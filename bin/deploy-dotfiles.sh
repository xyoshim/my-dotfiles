#!/bin/sh

# deploy dotfiles

usage() {
  echo '--targetdir[=dir] | -t [dir] ... The target directory.'
  echo '                                 If this option is omitted,'
  echo '                                 use "$HOME".'
  echo '--sourcedir[=dir] | -s [dir] ... The source directory.'
  echo '                                 If this option is omitted,'
  echo '                                 use "$HOME/dotfiles.cygwin64".'
  echo '--suffix-backup[=str] | -b [str] ... The suffix of backup file.'
  echo '                                     If this option is omitted,'
  echo '                                     use ".bak".'
  echo '--dry-run | -n               ... Do not actually change any files,'
  echo '                                 just print what would happen.'
  echo '--help | -h                  ... Print this message.'
}

# default values
dry_run=no
unset dirname_target dirname_source
dirname_target_default="$HOME"
dirname_source_default="$HOME/dotfiles.cygwin64"
suffix_backup=".bak"
regex_exclude_deploy='(/(\.jj|\.git|\.vscode)/|(\.bak|\.orig|\.rej|\.*history|\.lesshst|\.viminfo|\.gitattributes|\.gitignore|\.editorconfig|/~.*|\.~.*|0)(/|$))'

# exit with error message and error code.
#   $1 : error code
#   $2 : error message
exit_with_error() {
  echo "$2" >&2
  exit $1
}

# backup file with suffix.
#   $1 : file name
#   $2 : suffix for backup file name
backup_file_with_suffix() {
  mv "$1" "$1$2"
  return $?
}

# create directory if not exists.
#   $1 : directory name
mkdir_if_not_exists() {
  if [ -d "$1" ]; then
    return 0
  else
    mkdir -p "$1"
    return $?
  fi
}

# create symlink, when source realpath is not same as the target realpath.
#   $1 : link source directory
#   $2 : link source filenames
#   $3 : link target directory
deploy_dotfiles_link() {
  # backup original variables.
  dirname_source_original="${dirname_source-unset}"
  filename_source_original="${filename_source-unset}"
  fullpath_source_original="${fullpath_source-unset}"
  dirname_target_original="${dirname_target-unset}"
  filename_target_original="${filename_target-unset}"
  fullpath_target_original="${fullpath_target-unset}"
  for f in $2; do
    # Get the filename and directory name.
    dirname_f="$(dirname ${f})"
    dirname_source="$1/${dirname_f}"
    filename_source="$(basename ${f})"
    dirname_target="$3/${dirname_f}"
    filename_target="${filename_source}"
    # Get the realpath of the source and target files.
    fullpath_source="${dirname_source}/${filename_source}"
    fullpath_target="${dirname_target}/${filename_target}"
    fullpath_source_realpath="$(realpath -P "${fullpath_source}" 2>/dev/null)" || unset fullpath_source_realpath
    fullpath_target_realpath="$(realpath -P "${fullpath_target}" 2>/dev/null)" || unset fullpath_target_realpath
    # If realpath is same, already deployed.
    [ "$fullpath_source_realpath" = "$fullpath_target_realpath" ] && already_deployed=yes || already_deployed=no
    # check if target file exists.
    [ -f "${fullpath_target}" ] && exist_target=yes || exist_target=no
    # backup original target file.
    case "${dry_run}-${already_deployed}-${exist_target}" in
    "no-no-yes")
      ## backup original target file, when not symlink to source file.
      if backup_file_with_suffix "${fullpath_target}" "${suffix_backup}"; then
        echo "Rename : ${fullpath_target} -> ${fullpath_target}${suffix_backup}"
      else
        exit_with_error $? "Error: Failed to rename ${fullpath_target} -> ${fullpath_target}${suffix_backup}"
      fi
      ;;
    "yes-no-yes")
      ## show message 'Would rename', when dry-run.
      echo "Would rename : ${fullpath_target} -> ${fullpath_target}${suffix_backup}"
      ;;
    *) ;;
    esac
    # deploy dotfiles.
    case "${dry_run}-${already_deployed}" in
    ## do deploy, when not dry-run and not already-deployed.
    "no-no")
      ### Create the directory for symlink, if it does not exist.
      if mkdir_if_not_exists "$(dirname "${fullpath_target}")"; then
        :
      else
        exit_with_error $? "Error: Failed to create directory ${dirname_target_parent}."
      fi
      ### Create a symlink.
      if ln -s "${fullpath_source}" "${fullpath_target}"; then
        echo "Link : ${fullpath_source} -> ${fullpath_target}"
      else
        exit_with_error $? "Error: Failed to create symlink for ${fullpath_source} -> ${fullpath_target}"
      fi
      ;;
    ## show message 'Already-deployed', when not dry-run and already-deployed.
    "no-yes")
      echo "Already deployed : ${fullpath_source} -> ${fullpath_target}"
      ;;
    ## show message 'Would link', when dry-run and not already-deployed.
    "yes-no")
      echo "Would link : ${fullpath_source} -> ${fullpath_target}"
      ;;
    ## show message 'Would skip', when dry-run and already-deployed.
    "yes-yes")
      echo "Would skip : ${fullpath_source} -> ${fullpath_target}"
      ;;
    *) ;;
    esac
  done
  # restore original variables.
  [ "${dirname_source_original}" != "unset" ] && dirname_source="${dirname_source_original}" || unset dirname_source
  [ "${filename_source_original}" != "unset" ] && filename_source="${filename_source_original}" || unset filename_source
  [ "${fullpath_source_original}" != "unset" ] && fullpath_source="${fullpath_source_original}" || unset fullpath_source
  [ "${dirname_target_original}" != "unset" ] && dirname_target="${dirname_target_original}" || unset dirname_target
  [ "${filename_target_original}" != "unset" ] && filename_target="${filename_target_original}" || unset filename_target
  [ "${fullpath_target_original}" != "unset" ] && fullpath_target="${fullpath_target_original}" || unset fullpath_target
}

# parse arguments.
while [ $# != 0 ]; do
  option="$1"
  shift
  optarg=

  case $option in
  -h | --help)
    usage
    exit 0
    ;;
  -n | --dry-run)
    dry_run=yes
    ;;
  -t | --targetdir)
    if [ $# ] >0; then
      dirname_target="$1"
      shift
    fi
    ;;
  --targetdir=*)
    dirname_target="$(echo ${option} | sed 's|--targetdir=||')"
    ;;
  -s | --sourcedir)
    if [ $# ] >0; then
      dirname_source="$1"
      shift
    fi
    ;;
  --sourcedir=*)
    dirname_source="$(echo ${option} | sed 's|--sourcedir=||')"
    ;;
  --)
    break
    ;;
  *)
    echo "$0 unsupported option '${option}'"
    usage
    exit 1
    ;;
  esac
done
[ "${dirname_source}" = "" ] && unset dirname_source
[ "${dirname_target}" = "" ] && unset dirname_target

# Home directory
dir_source_base="${dirname_source:-$dirname_source_default}"
dir_target_base="${dirname_target:-$dirname_target_default}"
echo "Deploy dotfiles from ${dir_source_base} to ${dir_target_base}"
if [ -d "${dir_source_base}" ]; then
  files_source="$(cd $dir_source_base && find . -type f -print -o -type l -print | grep -Ev "(${regex_exclude_deploy}|/etc/profile\.d/)")"
  deploy_dotfiles_link "${dir_source_base}" "${files_source}" "${dir_target_base}"
else
  echo "Warning: Directory ${dir_source_base} does not exist."
fi

# /usr/local/etc
dir_source_base="${dirname_source:-$dirname_source_default}/etc"
if [ "$(realpath "${dirname_target}" 2>/dev/null)" = "$(realpath "${dirname_target_default}" 2>/dev/null)" ]; then
  dir_target_base="/usr/local/etc"
else
  dir_target_base="${dirname_target}/usr/local/etc"
fi
if [ -d "${dir_source_base}" ]; then
  files_source="$(cd $dir_source_base && find . -type f -print | grep -Ev "${regex_exclude_deploy}")"
  deploy_dotfiles_link "${dir_source_base}" "${files_source}" "${dir_target_base}"
else
  echo "Warning: Directory ${dir_source_base} does not exist."
fi

exit 0

#!/bin/sh

# deploy dotfiles

usage() {
  echo '--targetdir[=dir] | -t [dir] ... The target directory.'
  echo '                                 If this option is omitted,'
  echo '                                 use "$HOME".'
  echo '--sourcedir[=dir] | -s [dir] ... The source directory.'
  echo '                                 If this option is omitted,'
  echo '                                 use "$HOME/dotfiles.cygwin64".'
  echo '--dry-run | -n               ... Do not actually change any files,'
  echo '                                 just print what would happen.'
  echo '--help | -h                  ... Print this message.'
}

# default values
dry_run=no
unset dirname_target dirname_source
dirname_target_default="$HOME"
dirname_source_default="$HOME/dotfiles.gitbash"

# check if the source realpath is same as the target realpath.
#   $1 : path of source file
#   $2 : path of target file
is_same_realpath() {
  src_realpath="$(realpath -P "$1" 2> /dev/null)" || unset src_realpath
  tgt_realpath="$(realpath -P "$2" 2> /dev/null)" || unset tgt_realpath
  if [ -f "${tgt_realpath}" ] && [ "${src_realpath}" = "${tgt_realpath}" ]; then
    value_return=0
  else
    value_return=1
  fi
  unset src_realpath tgt_realpath
  return $value_return
}

# exit with error message and error code.
#   $1 : error code
#   $2 : error message
errot_exit() {
  echo "$2"
  exit $1
}

# create symlink, when source realpath is not same as the target realpath.
#   $1 : link source filenames
#   $2 : link source directory
#   $3 : link target directory
deply_dotfiles_link() {
  for f in $1; do
    # Get the filename and directory name.
    dirname_f="$(dirname ${f})"
    dirname_src="$(realpath $2/${dirname_f})"
    filename_src="$(basename ${f})"
    dirname_tgt="$3/${dirname_f}"
    [ -L "$dirname_tgt" ] && dirname_tgt="$(realpath -s $3/${dirname_f})"
    filename_tgt="${filename_src}"
    should_deploy=no
    fullpath_src_realpath="$(realpath -P ${dirname_src}/${filename_src} 2> /dev/null)" || unset fullpath_src_realpath
    fullpath_tgt_realpath="$(realpath -P ${dirname_tgt}/${filename_tgt} 2> /dev/null)" || unset fullpath_tgt_realpath
    # Check if the realpath is the same.
    if is_same_realpath "$fullpath_src_realpath" "$fullpath_tgt_realpath"; then
      should_deploy=no
    else
      should_deploy=yes
    fi
    # backup original target file.
    if [ -f "${dirname_tgt}/${filename_tgt}" ]; then
      if [ "${dry_run}" = "no" ]; then
        if [ "${should_deploy}" = "yes" ]; then
          if mv "${dirname_tgt}/${filename_tgt}" "${dirname_tgt}/${filename_tgt}.bak"; then
            echo "Rename : ${dirname_tgt}/${filename_tgt} -> ${dirname_tgt}/${filename_tgt}.bak"
          else
            errot_exit $? "Error: Failed to rename ${dirname_tgt}/${filename_tgt} -> ${dirname_tgt}/${filename_tgt}.bak"
          fi
        fi
      else
        [ "${should_deploy}" = "yes" ] && echo "Would rename : ${dirname_tgt}/${filename_tgt} -> ${dirname_tgt}/${filename_tgt}.bak"
      fi
    fi
    # deploy dotfiles.
    if [ "${dry_run}" = "no" ]; then
      if [ "${should_deploy}" = "yes" ]; then
        dirname_tgt_parent="$(dirname "${dirname_tgt}/${filename_tgt}")"
        # Create the directory if it does not exist.
        if [ ! -d "${dirname_tgt_parent}" ]; then
          if mkdir -p "${dirname_tgt_parent}"; then
            :
          else
            errot_exit $? "Error: Failed to create directory ${dirname_tgt_parent}."
          fi
        fi
        # Create a symlink.
        if ln -s "${dirname_src}/${filename_src}" "${dirname_tgt}/${filename_tgt}"; then
          echo "Link : ${dirname_src}/${filename_src} -> ${dirname_tgt}/${filename_tgt}"
        else
          errot_exit $? "Error: Failed to create symlink for ${dirname_src}/${filename_src} -> ${dirname_tgt}/${filename_tgt}"
        fi
      # already deployed.
      else
        echo "Already deployed : ${dirname_src}/${filename_src} -> ${dirname_tgt}/${filename_tgt}"
      fi
    # when dry run, show message(create symlink or skip).
    else
      if [ "${should_deploy}" = "yes" ]; then
        echo "Would link : ${dirname_src}/${filename_src} -> ${dirname_tgt}/${filename_tgt}"
      else
        echo "Would skip : ${dirname_src}/${filename_src} -> ${dirname_tgt}/${filename_tgt}"
      fi
    fi
  done
}

# parse arguments.
while [ $# != 0 ]; do
  option="$1"
  shift
  optarg=

  case $option in
    -h | --help)
      usage
      exit 0;;
    -n | --dry-run)
      dry_run=yes;;
    -t | --targetdir)
      if [ $# > 0 ]; then
        dirname_target="$1"
        shift
      fi
      ;;
    --targetdir=*)
      dirname_target="$(echo ${option} | sed 's|--targetdir=||')"
      ;;
    -s | --sourcedir)
      if [ $# > 0 ]; then
        dirname_source="$1"
        shift
      fi
      ;;
    --sourcedir=*)
      dirname_source="$(echo ${option} | sed 's|--sourcedir=||')"
      ;;
    --)
      break;;
    *)
      echo "$0 unsupported option '${option}'"
      usage
      exit 1;;
  esac
done
[ "${dirname_source}" = "" ] && unset dirname_source
[ "${dirname_target}" = "" ] && unset dirname_target

# Home directory
dir_src_base="${dirname_source:-$dirname_source_default}"
dir_tgt_base="${dirname_target:-$dirname_target_default}"
echo "Deploy dotfiles from ${dir_src_base} to ${dir_tgt_base}"
if [ -d "${dir_src_base}" ]; then
  files_src="$(cd $dir_src_base && find . -type f -print | grep -Ev '(^./(.jj|.git|.vscode)/|.(bak|orig|rej)$|.*history|.lesshst|.viminfo|.gitattributes|.gitignore|.editorconfig|/etc/profile.d/|/~|/.~|0)')"
  deply_dotfiles_link "${files_src}" "${dir_src_base}" "${dir_tgt_base}"
else
  echo "Warning: Directory ${dir_src_base} does not exist."
fi

# /usr/local/etc
dir_src_base="${dirname_source:-$dirname_source_default}/etc"
dir_tgt_base="${dirname_target:+$dirname_target}/usr/local/etc"
if [ -d "${dir_src_base}" ]; then
  files_src="$(cd $dir_src_base && find . -type f -print | grep -Ev '(^./(.jj|.git|.vscode)/|.(bak|orig|rej)$|.*history|.lesshst|.viminfo|.gitattributes|.gitignore|.editorconfig|/~|/.~)')"
  deply_dotfiles_link "${files_src}" "${dir_src_base}" "${dir_tgt_base}"
else
  echo "Warning: Directory ${dir_src_base} does not exist."
fi

exit 0

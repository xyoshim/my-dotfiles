#!/bin/sh

# deploy dotfiles

usage() {
  echo '--targetdir[=dir] | -d [dir] ... Add a prefix to the target directory,'
  echo '                                 if dir is omitted,'
  echo '                                 use "$HOME/test-deploy".'
  echo '--dry-run | -n               ... Do not actually change any files,'
  echo '                                 just print what would happen.'
  echo '--help | -h                  ... Print this message.'
}
# create symlink.
#   $0 : link source filenames
#   $1 : link source directory
#   $2 : link target directory
deply_dotfiles_link() {
  for f in $1; do
    dirname_f="$(dirname ${f})"
    dirname_src="$(realpath $2/${dirname_f})"
    filename_src="$(basename ${f})"
    dirname_tgt="$3/${dirname_f}"
    [ -L "$dirname_tgt" ] && dirname_tgt="$(realpath -s $3/${dirname_f})"
    filename_tgt="${filename_src}"
    deploy_flag=no
    fullpath_src_realpath="$(realpath -P ${dirname_src}/${filename_src} 2> /dev/null)" || unset fullpath_src_realpath
    fullpath_tgt_realpath="$(realpath -P ${dirname_tgt}/${filename_tgt} 2> /dev/null)" || unset fullpath_tgt_realpath
    if [ -f "${fullpath_tgt_realpath}" ]; then
      if [ "${fullpath_src_realpath}" == "${fullpath_tgt_realpath}" ]; then
        deploy_flag=no
      else
        if [ "${deploy_flag}" == "yes" ]; then
          echo "Move : ${dirname_tgt}/${filename_tgt} -> ${dirname_tgt}/${filename_tgt}.bak"
        else
          echo "Would move ${dirname_tgt}/${filename_tgt} -> ${dirname_tgt}/${filename_tgt}.bak"
        fi
        deploy_flag=yes
      fi
    else
      deploy_flag=yes
    fi
    if [ "${dry_run}" == "no" ]; then
      if [ "${deploy_flag}" == "yes" ]; then
        echo "Link : ${dirname_src}/${filename_src} -> ${dirname_tgt}/${filename_tgt}"
        dirname_tgt_parent="$(dirname "${dirname_tgt}/${filename_tgt}")"
        [ ! -d "${dirname_tgt_parent}" ] && mkdir -p "${dirname_tgt_parent}"
        ln -s "${dirname_src}/${filename_src}" "${dirname_tgt}/${filename_tgt}"
      else
        echo "Skip : ${dirname_src}/${filename_src} -> ${dirname_tgt}/${filename_tgt}"
      fi
    else
      if [ "${deploy_flag}" == "yes" ]; then
        echo "Would link : ${dirname_src}/${filename_src} -> ${dirname_tgt}/${filename_tgt}"
      else
        echo "Would skip : ${dirname_src}/${filename_src} -> ${dirname_tgt}/${filename_tgt}"
      fi
    fi
  done
}

# parse arguments
dry_run=no
unset dirname_prefix
dirname_prefix_default="$HOME/test-deploy"
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
    -d | --targetdir)
      if [ $# > 0 ]; then
        dirname_prefix="$1"
        shift
      fi
      dirname_prefix="${dirname_prefix:=${dirname_prefix_default}}"
      ;;
    --targetdir=*)
      dirname_prefix="$(echo ${option} | sed 's|--targetdir=||')"
      dirname_prefix="${dirname_prefix:=${dirname_prefix_default}}"
      ;;
    --)
      break;;
    *)
      echo "$0 unsupported option '${option}'"
      usage
      exit 1;;
  esac
done
[ "${dirname_prefix}" == "" ] && unset dirname_prefix

# Home directory
dir_src_base=$HOME/dotfiles.cygwin64
dir_tgt_base="${dirname_prefix-$HOME}"
files_src="$(cd $dir_src_base && find . -type f -print | grep -Ev '(/(.jj|.git|.vscode)/|.(bak|orig|rej)$|.*history|.lesshst|.viminfo|.gitattributes|.gitignore|.editorconfig|/etc/profile.d/|/~|/.~|0)')"
deply_dotfiles_link "${files_src}" "${dir_src_base}" "${dir_tgt_base}"

# /usr/local/etc
dir_src_base=$HOME/dotfiles.cygwin64/etc
dir_tgt_base="${dirname_prefix}/usr/local/etc"
files_src="$(cd $dir_src_base && find . -type f -print | grep -Ev '(^./(.jj|.git|.vscode)/|.(bak|orig|rej)$|.*history|.lesshst|.viminfo|.gitattributes|.gitignore|.editorconfig|/~|/.~)')"
deply_dotfiles_link "${files_src}" "${dir_src_base}" "${dir_tgt_base}"

exit 0

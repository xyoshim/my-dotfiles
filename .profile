# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide. This software is distributed without any warranty.
# You should have received a copy of the CC0 Public Domain Dedication along
# with this software.
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# base-files version 4.3-3

# ~/.profile: executed by the command interpreter for login shells.

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/skel/.profile

# Modifying /etc/skel/.profile directly will prevent
# setup from updating it.

# The copy in your home directory (~/.profile) is yours, please
# feel free to customize it to create a shell
# environment to your liking.  If you feel a change
# would be beneficial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .profile file

# Check for duplicate loading
[ "$LOADED_HOME_PROFILE" = "yes" ] && return
LOADED_HOME_PROFILE=yes

# Set user-defined locale
[ locale -uU > /dev/null 2>&1 ] && export LANG="$(locale -uU)"

# This file is not read by bash(1) if ~/.bash_profile or ~/.bash_login
# exists.

# Set PATH so it includes user's private bin if it exists
for TMP_PATH in /usr/local/bin "${HOME}/bin" "${HOME}/.local/bin" "${HOME}/.cargo/bin"
do
  if [ -d "${TMP_PATH}" ]; then
    case :"${PATH}": in
      *:"${TMP_PATH}":* )
        PATH="$(echo :${PATH}: | /usr/bin/sed -e "s|:${TMP_PATH}:|:|g")";;
      *) ;;
    esac
    PATH="${TMP_PATH}:${PATH}"
  fi
done
export PATH="$(echo :"${PATH}": | /usr/bin/sed -E 's|:+||' | /usr/bin/sed -e 's|^:|:|g' -e 's|:$||')"
unset TMP_PATH

# Add path
PREFIXS="/usr/local ${HOME}/.cargo ${HOME}/.local ${MSYSTEM_PREFIX}"
if [ x"${MSYSTEM_PREFIX}" != x"${MINGW_PREFIX}" ]; then
  PREFIXS="${PREFIXS} ${MINGW_PREFIX}"
fi
MANPATH="${MANPATH:-/usr/share/man:/usr/man}"
INFOPATH="${INFOPATH:-/usr/share/info:/usr/info}"
for TMP_PREFIX_PATH in ${PREFIXS}; do
  for TMP_SUFFIX_PATH in man share/man; do
    TMP_PATH="${TMP_PREFIX_PATH}/${TMP_SUFFIX_PATH}"
    if [ -d "${TMP_PATH}" ]; then
      case :"${MANPATH}": in
        *:"${TMP_PATH}":* )
          MANPATH="$(echo :${MANPATH}: | /usr/bin/sed -e "s|:${TMP_PATH}:|:|g")";;
        *) ;;
      esac
      MANPATH="${TMP_PATH}:${MANPATH}"
    fi
  done
  for TMP_SUFFIX_PATH in info share/info; do
    TMP_PATH="${TMP_PREFIX_PATH}/${TMP_SUFFIX_PATH}"
    if [ -d "${TMP_PATH}" ]; then
      case :"${INFOPATH}": in
        *:"${TMP_PATH}":* )
          INFOPATH="$(echo :${INFOPATH}: | /usr/bin/sed -e "s|:${TMP_PATH}:|:|g")";;
        *) ;;
      esac
      INFOPATH="${TMP_PATH}:${INFOPATH}"
    fi
  done
done
export MANPATH="$(echo :"${MANPATH}": | /usr/bin/sed -E 's|:+|:|g' | /usr/bin/sed -e 's|^:||' -e 's|:$||')"
export INFOPATH="$(echo :"${INFOPATH}": | /usr/bin/sed -E 's|:+|:|g' | /usr/bin/sed -e 's|^:||' -e 's|:$||')"
unset TMP_PATH TMP_PREFIX_PATH TMP_SUFFIX_PATH PREFIXS

# path of dotnet
## Check existing variable "DOTNET_ROOT"
if [ ! "${DOTNET_ROOT}" ] || [ ! -x "${DOTNET_ROOT}/dotnet" ]; then
  unset DOTNET_ROOT
fi
## Check dotnet directory under ${HOME}
if [ ! "${DOTNET_ROOT}" ] && [ -x "${HOME}/.dotnet/dotnet" ]; then
  export DOTNET_ROOT="${HOME}/.dotnet"
fi
## add DOTNET_ROOT to PATH
if [ "${DOTNET_ROOT}" ]; then
  case :"${PATH}": in
    *:"${DOTNET_ROOT}":*)
      PATH="$(echo :${PATH}: | /usr/bin/sed -e "s|:${DOTNET_ROOT}:|:|g")";;
    *) ;;
  esac
  export PATH="${DOTNET_ROOT}:${PATH}"
fi
## add DOTNET_TOOLS_PATH to PATH
if [ -z "${DOTNET_TOOLS_PATH}" ] && [ -n "${DOTNET_ROOT}" ]; then
  export DOTNET_TOOLS_PATH="${DOTNET_ROOT}/tools"
fi
if [ -n "$DOTNET_TOOLS_PATH" ]; then
  case :"${PATH}": in
    *:"${DOTNET_TOOLS_PATH}":* )
      PATH="$(echo :${PATH}: | /usr/bin/sed -e "s|:${DOTNET_TOOLS_PATH}:|:|g")";;
    *) ;;
  esac
  export PATH="${DOTNET_TOOLS_PATH}:${PATH}"
fi

# Load shell common functions
if [ -f "${XDG_CONFIG_HOME:-${HOME}/.config}/sh/.sh_functions" ]; then
  . "${XDG_CONFIG_HOME:-${HOME}/.config}/sh/.sh_functions"
elif [ -f "${HOME}/.sh_functions" ]; then
  . "${HOME}/.sh_functions"
fi

# set OSTYPE, when unset
export OSTYPE="${OSTYPE:-$(get_ostype)}"
export OSTYPE_LOWER="${OSTYPE_LOWER:-$(get_ostype_lower)}"

# if CYGWIN or MSYS, use Windows symbolic link
case "${OSTYPE_LOWER}" in
  cygwin*)
    export CYGWIN="${CYGWIN}${CYGWIN+ }winsymlinks:native"
    export EXEEXT=".exe"
    ;;
  msys*|mingw*)
    export MSYS="${MSYS}${MSYS+ }winsymlinks:native"
    export EXEEXT=".exe"
    ;;
  *)
    ;;
esac

# Set XDG Base Directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"

# If not running interactively, return here.
case "$-" in
  *i*) ;;
  *) return ;;
esac

# Get shell filename
SHELLFILENAME="$(get_shell_filename)"

# if running bash
if [ -n "${BASH_VERSION}" ]; then
  if [ -f "${XDG_CONFIG_HOME:-${HOME}/.config}/bash/.bashrc" ]; then
    source "${HOME}/.bashrc"
  elif [ -f "${HOME}/.bashrc" ]; then
    source "${HOME}/.bashrc"
  fi
fi

read_usr_local_etc_profile_d sh
[ "${XDG_STATE_HOME}" ] && [ ! -d "${XDG_STATE_HOME}" ] && mkdir -p "${XDG_STATE_HOME}"

# default editor and pager
if [ ! "x${TERM}" = "x" ]; then
  [ -x "/usr/bin/vim" ] && export EDITOR=${EDITOR:-/usr/bin/vim}
  [ -x "/usr/bin/less" ] && export PAGER=${PAGER:-/usr/bin/less}
fi

if [ "${BASH_VERSION}" ]; then
  read_usr_local_etc_profile_d bash
  case ":${SHELLOPTS}:_${POSIXLY_CORRECT+POSIXLY_CORRECT}_${SHELLFILENAME}" in
    *":posix:"* | *"_POSIXLY_CORRECT_"* | *"_sh")
      HISTFILE="${XDG_STATE_HOME+${XDG_STATE_HOME}/sh_history}"
      HISTFILE="${HISTFILE:-${HOME}/.sh_history}"
      ;;
    *"_bash")
      HISTFILE="${XDG_STATE_HOME+${XDG_STATE_HOME}/bash_history}"
      HISTFILE="${HISTFILE:-${HOME}/.bash_history}"
      ;;
    *) ;;
  esac
  PARENT_HISTFILE="$(dirname $HISTFILE 2> /dev/null)" || PARENT_HISTFILE="${HOME}"
  [ -d "${PARENT_HISTFILE}" ] || mkdir -p "${PARENT_HISTFILE}"
  unset PARENT_HISTFILE
elif [ "${KSH_VERSION}" ]; then
  read_usr_local_etc_profile_d ksh
  HISTFILE="${XDG_STATE_HOME+${XDG_STATE_HOME}/ksh_history}"
  HISTFILE="${HISTFILE:-${HOME}/.ksh_history}"
elif [ "${ZSH_VERSION}" ]; then
  # zsh is in shell compatibility mode here, so we probably shouldn't do this
  read_usr_local_etc_profile_d zsh
  HISTFILE="${XDG_STATE_HOME+${XDG_STATE_HOME}/zsh_history}"
  HISTFILE="${HISTFILE:-${HOME}/.zsh_history}"
else
  PS1="$ "
  PS2='> '
  PS4='+ '
fi

# history file of less
LESSHISTFILE="${XDG_STATE_HOME+${XDG_STATE_HOME}/lesshst}"
LESSHISTFILE="${LESSHISTFILE:-${HOME}/.lesshst}"

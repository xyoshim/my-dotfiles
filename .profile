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
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benificial to all, please feel free to send
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
export PATH="$(echo :"${PATH}": | /usr/bin/sed -E 's|:+|:|g' | sed -E 's|^:+||' | sed -E 's|:+$||')"
unset TMP_PATH

# Add path
if [ x"${SET_HOME_PROFILE_ENVVARS}" != x"yes" ]; then
  SET_HOME_PROFILE_ENVVARS="yes"
  PREFIXS="/usr/local $HOME/.cargo $HOME/.local ${MSYSTEM_PREFIX}"
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
  export MANPATH="$(echo :"${MANPATH}": | /usr/bin/sed -E 's|:+|:|g' | /usr/bin/sed -E 's|^:+||' | /usr/bin/sed -E 's|:+$||')"
  export INFOPATH="$(echo :"${INFOPATH}": | /usr/bin/sed -E 's|:+|:|g' | /usr/bin/sed -E 's|^:+||' | /usr/bin/sed -E 's|:+$||')"
  unset TMP_PREFIX_PATH TMP_SUFFIX_PATH PREFIXS
fi

# Set XDG Base Directories
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_STATE_HOME="${HOME}/.local/state"

# if running bash
if [ -n "${BASH_VERSION}" ]; then
  if [ -f "${HOME}/.bashrc" ]; then
    source "${HOME}/.bashrc"
  fi
fi

# default editor and pager
if [ ! "x${TERM}" = "x" ]; then
  [ -x "/usr/bin/vim" ] && export EDITOR=${EDITOR:=/usr/bin/vim}
  [ -x "/usr/bin/less" ] && export PAGER=${PAGER:=/usr/bin/less}
fi

# set OSTYPE, when not using bash
if OSTYPE="${OSTYPE:=$(uname -o 2> /dev/null)}"; then
  :
elif OSTYPE="$(uname -s 2> /dev/null)"; then
  :
else
  OSTYPE="${OS:-unknown}"
fi
# OSTYPE="$(echo ${OSTYPE} | tr [:upper:] [:lower:])" 2> /dev/null
export OSTYPE

# if CYGWIN or MSYS, use Windows symbolic link
case "${MSYSTEM:-${OSTYPE}}" in
  cygwin|Cygwin|CYGWIN_NT*)
    export CYGWIN="${CYGWIN}${CYGWIN+ }winsymlinks:native"
    export EXEEXT=".exe"
    ;;
  msys|Msys|MINGW*)
    export MSYS="${MSYS}${MSYS+ }winsymlinks:native"
    export EXEEXT=".exe"
    ;;
  *)
    ;;
esac

# Shell dependent settings from $1/*.$2
read_profile_d() {
  dir_profile_base="$1"
  shift
  _LC_ALL_SET_="${LC_ALL+set}"
  _LC_SAVE_="${LC_ALL-null}"
  LC_ALL=C
  if [ "${_LC_SAVE_}" = "null" ]; then
    for file in $dir_profile_base/*.$1; do
      [ -e "${file}" ] && . "${file}"
    done
    unset LC_ALL
  else
    for file in $dir_profile_base/*.$1; do
      [ -e "${file}" ] && LC_ALL="${_LC_SAVE_}" . "${file}"
    done
    LC_ALL="${_LC_SAVE_}"
  fi
  unset file _LC_ALL_SET_ _LC_SAVE_
}

# Shell dependent settings from /usr/local/etc/profile.d
local_profile_d() {
  read_profile_d /usr/local/etc/profile.d $1
}

local_profile_d sh
[ "${XDG_STATE_HOME}" ] && mkdir -p "${XDG_STATE_HOME}"
SHELLFILENAME=$(basename "$(ps -p $$ | tail -n 1 | awk '{print $8}')")
if [ "${BASH_VERSION}" ]; then
  local_profile_d bash
  case ":${SHELLOPTS}:_${POSIXLY_CORRECT+POSIXLY_CORRECT}_${SHELLFILENAME}" in
    *":posix:"* | *"_POSIXLY_CORRECT_"* | *"_sh")
      HISTFILE="${XDG_STATE_HOME+${XDG_STATE_HOME}/sh_history}"
      HISTFILE="${HISTFILE:=${HOME}/.sh_history}"
      ;;
    *)
      ;;
  esac
  PARENT_HISTFILE="$(dirname $HISTFILE)"
  [ -d "${PARENT_HISTFILE}" ] || mkdir -p "${PARENT_HISTFILE}"
  unset PARENT_HISTFILE
elif [ ! "x${KSH_VERSION}" = "x" ]; then
  local_profile_d ksh
  HISTFILE="${XDG_STATE_HOME+${XDG_STATE_HOME}/ksh_history}"
  HISTFILE="${HISTFILE:=${HOME}/.ksh_history}"
elif [ ! "x${ZSH_VERSION}" = "x" ]; then
  # zsh is in shell compatibility mode here, so we probably shouldn't do this
  local_profile_d zsh
  HISTFILE="${XDG_STATE_HOME+${XDG_STATE_HOME}/zsh_history}"
  HISTFILE="${HISTFILE:=${HOME}/.zsh_history}"
else
  PS1="$ "
  PS2='> '
  PS4='+ '
fi

# history file of less
LESSHISTFILE="${XDG_STATE_HOME+${XDG_STATE_HOME}/lesshst}"
LESSHISTFILE="${LESSHISTFILE:=${HOME}/.lesshst}"

# path of dotnet
## Check existing variable "DOTNET_ROOT"
if [ -z "$DOTNET_ROOT" ] || [ ! -x "${DOTNET_ROOT}/dotnet" ]; then
  unset DOTNET_ROOT
fi
## Check dotnet directory under $HOME
if [ -z "$DOTNET_ROOT" ] && [ -x "$HOME/.dotnet/dotnet" ]; then
  export DOTNET_ROOT="$HOME/.dotnet"
fi
## add DOTNET_ROOT to PATH
if [ -n  "$DOTNET_ROOT" ]; then
  case :"${PATH}": in
    *:"${DOTNET_ROOT}":* )
      PATH="$(echo :${PATH}: | /usr/bin/sed -e "s|:${DOTNET_ROOT}:|:|g")";;
    *) ;;
  esac
  export PATH="${DOTNET_ROOT}:${PATH}"
fi
## add DOTNET_TOOLS_PATH to PATH
if [ -z "$DOTNET_TOOLS_PATH" ] && [ -n "$DOTNET_ROOT" ]; then
  export DOTNET_TOOLS_PATH="$DOTNET_ROOT/tools"
fi
if [ -n "$DOTNET_TOOLS_PATH" ]; then
  case :"${PATH}": in
    *:"${DOTNET_TOOLS_PATH}":* )
      PATH="$(echo :${PATH}: | /usr/bin/sed -e "s|:${DOTNET_TOOLS_PATH}:|:|g")";;
    *) ;;
  esac
  export PATH="${DOTNET_TOOLS_PATH}:${PATH}"
fi

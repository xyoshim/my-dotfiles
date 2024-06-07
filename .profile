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

# Set user-defined locale
[ locale -uU > /dev/null 2> /dev/null ] && export LANG="$(locale -uU)"

# This file is not read by bash(1) if ~/.bash_profile or ~/.bash_login
# exists.

# Set PATH so it includes user's private bin if it exists
for TMP_PATH in /usr/local/bin "${HOME}/bin" "${HOME}/.local/bin"
do
  if [ -d "${TMP_PATH}" ]; then
    echo ":${PATH}:" | /usr/bin/fgrep ":${TMP_PATH}:" > /dev/null 2> /dev/null
    [ $? = 0 ] && PATH="$(echo :${PATH}: | /usr/bin/sed -e "s|:${TMP_PATH}:|:|g")"
    PATH="${TMP_PATH}:${PATH}"
  fi
done
PATH="$(echo ${PATH} | /usr/bin/sed -e 's|::*|:|g' -e 's|^:||g' -e 's|:$||g')"
export PATH
unset TMP_PATH

# Add path
if [ x"{SET_HOME_PROFILE_ENVVARS}" != x"yes" ]; then
  PREFIXS="/usr/local "$HOME/.cargo/env" ${MSYSTEM_PREFIX}"
  if [ x"${MSYSTEM_PREFIX}" != x"${MINGW_PREFIX}" ]; then
    PREFIXS="${PREFIXS} ${MINGW_PREFIX}"
  fi
  MANPATH="${MANPATH:=/usr/share/man:/usr/man}"
  INFOPATH="${INFOPATH:=/usr/share/info:/usr/info}"
  for TMP_PREFIX_PATH in ${PREFIXS}
  do
    echo ":${MANPATH}:" | /usr/bin/fgrep ":${TMP_PREFIX_PATH}/man:" > /dev/null 2> /dev/null
    [ $? != 0 ] && MANPATH="${TMP_PREFIX_PATH}/man:${MANPATH}"
    echo ":${MANPATH}:" | /usr/bin/fgrep ":${TMP_PREFIX_PATH}/share/man:" > /dev/null 2> /dev/null
    [ $? != 0 ] && MANPATH="${TMP_PREFIX_PATH}/share/man:${MANPATH}"
    echo ":${INFOPATH}:" | /usr/bin/fgrep ":${TMP_PREFIX_PATH}/info:" > /dev/null 2> /dev/null
    [ $? != 0 ] && INFOPATH="${TMP_PREFIX_PATH}/info:${INFOPATH}"
    echo ":${INFOPATH}:" | /usr/bin/fgrep ":${TMP_PREFIX_PATH}/share/info:" > /dev/null 2> /dev/null
    [ $? != 0 ] && INFOPATH="${TMP_PREFIX_PATH}/share/info:${INFOPATH}"
  done
  export MANPATH INFOPATH
  unset TMP_PREFIX_PATH PREFIXS
fi

# if running bash
if [ -n "${BASH_VERSION}" ]; then
  if [ -f "${HOME}/.bashrc" ]; then
    source "${HOME}/.bashrc"
  fi
fi

# default editor and pager
if [ ! "x${TERM}" = "x" ]; then
  [ -x "/usr/bin/vim" ] && EDITOR=${EDITOR:=/usr/bin/vim} && export EDITOR
  [ -x "/usr/bin/less" ] && PAGER=${PAGER:=/usr/bin/less} && export PAGER
fi

# if CYGWIN or MSYS, use Windows symbolic link
if [ "${OSTYPE}" = "cygwin" ]; then
  CYGWIN="${CYGWIN}${CYGWIN+ }winsymlinks:native" && export CYGWIN
  EXEEXT=".exe" && export EXEEXT
elif [ "${OSTYPE}" = "msys" ]; then
  MSYS="${MSYS}${MSYS+ }winsymlinks:native" && export MSYS
  EXEEXT=".exe" && export EXEEXT
fi

# Shell dependent settings from /usr/local/etc/profile.d
local_profile_d ()
{
  _LC_ALL_SET_="${LC_ALL+set}"
  _LC_SAVE_="${LC_ALL-null}"
  LC_ALL=C
  if [ "${_LC_SAVE_}" = "null" ]; then
    for file in /usr/local/etc/profile.d/*.$1; do
      [ -e "${file}" ] && . "${file}"
    done
    unset LC_ALL
  else
    for file in /usr/local/etc/profile.d/*.$1; do
      [ -e "${file}" ] && LC_ALL="${_LC_SAVE_}" . "${file}"
    done
    LC_ALL="${_LC_SAVE_}"
  fi
  unset file _LC_ALL_SET_ _LC_SAVE_
}

local_profile_d sh
if [ ! "x${BASH_VERSION}" = "x"  ]; then
  local_profile_d bash
  # : # HISTFILE=${HOME}/.bash_history
elif [ ! "x${KSH_VERSION}" = "x" ]; then
  local_profile_d ksh
  HISTFILE=${HOME}/.ksh_history && export HISTFILE
elif [ ! "x${ZSH_VERSION}" = "x" ]; then
  # zsh is in shell compatibility mode here, so we probably shouldn't do this
  local_profile_d zsh
  HISTFILE=${HOME}/.zsh_history && export HISTFILE
elif [ ! "x${POSH_VERSION}" = "x" ]; then
  local_profile_d posh
  HISTFILE=${HOME}/.posh_history && export HISTFILE
else
  PS1="$ "
fi

# dotnet
## DOTNET_ROOT
if [ -z "$DOTNET_ROOT" -o ! -x "${DOTNET_ROOT}/dotnet" ]; then
  unset DOTNET_ROOT
fi
if [ -z "$DOTNET_ROOT" -a -x "$HOME/.dotnet/dotnet" ]; then
  DOTNET_ROOT="$HOME/.dotnet" && export DOTNET_ROOT
fi
if [ -n  "$DOTNET_ROOT" ]; then
    echo ":${PATH}:" | /usr/bin/fgrep ":${DOTNET_ROOT}:" > /dev/null 2> /dev/null
    [ $? != 0 ] && PATH="${DOTNET_ROOT}:${PATH}"
fi
## DOTNET_TOOLS_PATH
if [ -z "$DOTNET_TOOLS_PATH" -a -n "$DOTNET_ROOT" ]; then
  DOTNET_TOOLS_PATH="$HOME/.dotnet/tools" && export DOTNET_TOOLS_PATH
fi
if [ -n  "$DOTNET_TOOLS_PATH" ]; then
    echo ":${PATH}:" | /usr/bin/fgrep ":${DOTNET_TOOLS_PATH}:" > /dev/null 2> /dev/null
    [ $? != 0 ] && PATH="${DOTNET_TOOLS_PATH}:${PATH}"
fi
export PATH

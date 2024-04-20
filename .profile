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
export LANG=$(locale -uU)

# This file is not read by bash(1) if ~/.bash_profile or ~/.bash_login
# exists.

# Set PATH so it includes user's private bin if it exists
for TMP_PATH in "${HOME}/bin ${HOME}/.local/bin"
do
  if [ -d "${TMP_PATH}" ] ; then
    PATH="${TMP_PATH}:${PATH}"
  fi
done
export PATH
unset TMP_PATH

# Add path
if [ x"{SET_HOME_PROFILE_ENVVARS}" != x"yes" ]; then
  PREFIXS="/usr/local ${MSYSTEM_PREFIX}"
  if [ x"${MSYSTEM_PREFIX}" != x"${MINGW_PREFIX}" ]; then
    PREFIXS="${PREFIXS} ${MINGW_PREFIX}"
  fi
  MANPATH="${MANPATH:=/usr/share/man:/usr/man}"
  INFOPATH="${INFOPATH:=/usr/share/info:/usr/info}"
  for TMP_PREFIX_PATH in ${PREFIXS}
  do
    MANPATH="${TMP_PREFIX_PATH}/share/man:${TMP_PREFIX_PATH}/man:${MANPATH}"
    INFOPATH="${TMP_PREFIX_PATH}/share/info:${TMP_PREFIX_PATH}/info:${INFOPATH}"
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
  EDITOR=${EDITOR:=/usr/bin/vim} && export EDITOR
  PAGER=${PAGER:=/usr/bin/less}  && export PAGER
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
  : # HISTFILE=${HOME}/.bash_history
  GIT_PS1_SHOWDIRTYSTATE=true && export GIT_PS1_SHOWDIRTYSTATE
  PS1='\[\e]0;\w\a\]\[\e[32m\]\u@\h \[\e[33m\]\w\[\033[31m\]$(__git_ps1)\[\e[0m\]\n\$ '
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
  : # [ "${PS1-null}" = "null" ] || PS1="$ "
fi

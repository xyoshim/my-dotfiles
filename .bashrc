# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide. This software is distributed without any warranty.
# You should have received a copy of the CC0 Public Domain Dedication along
# with this software.
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# base-files version 4.3-3

# ~/.bashrc: executed by bash(1) for interactive shells.

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/skel/.bashrc

# Modifying /etc/skel/.bashrc directly will prevent
# setup from updating it.

# The copy in your home directory (~/.bashrc) is yours, please
# feel free to customize it to create a shell
# environment to your liking.  If you feel a change
# would be beneficial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bashrc file

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# # Already loaded
# [ "${LOADED_HOME_BASHRC}" != "yes" ] && LOADED_HOME_BASHRC=yes

# Not bash
[ -z "${BASH_VERSION}" ] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
elif [ -f /etc/bash.bashrc ]; then
  . /etc/bash.bashrc
fi

# Functions
#
# Some people use a different file for functions
## Load bash functions
for d in "${XDG_CONFIG_HOME+${XDG_CONFIG_HOME}/bash}" "${XDG_CONFIG_HOME-${HOME}/.config/bash}" "${HOME}"; do
  if [ "${d}" ] && [ -f "${d}/.bash_functions" ]; then
    . "${d}/.bash_functions"
    break
  fi
done
## Load shell common functions
for d in "${XDG_CONFIG_HOME+${XDG_CONFIG_HOME}/sh}" "${XDG_CONFIG_HOME-${HOME}/.config/sh}" "${HOME}"; do
  if [ "${d}" ] && [ -f "${d}/.sh_functions" ]; then
    . "${d}/.sh_functions"
    break
  fi
done
## User specific aliases and functions
dir_loop="${HOME}/.config/bash/bashrc.d ${HOME}/.bashrc.d"
if [ "${XDG_CONFIG_HOME}" != "${HOME}/.config" ]; then
  dir_loop="${XDG_CONFIG_HOME}/bash/bashrc.d ${dir_loop}"
fi
for d in ${dir_loop}; do
  if [ "${d}" ] && [ -d ${d} ]; then
    read_profile_d "${d}" ""
  fi
done
unset d dir_loop

# set history file
if shopt -oq posix; then
  HISTFILE="${XDG_STATE_HOME:+${XDG_STATE_HOME}/sh_history}"
  HISTFILE="${HISTFILE:-${HOME}/.sh_history}"
else
  HISTFILE="${XDG_STATE_HOME:+${XDG_STATE_HOME}/bash_history}"
  HISTFILE="${HISTFILE:-${HOME}/.bash_history}"
fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
   xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# set prompt
export -n PS1
unset PS1
export OSTYPE="${OSTYPE:-$(get_ostype)}"
export OSTYPE_LOWER="${OSTYPE_LOWER:-$(get_ostype_lower)}"

# Setup safe prompts
if [ "$color_prompt" = yes ]; then
  if [ "${MSYSTEM:-${OSTYPE}}" ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\e]0;\w\a\]\[\e[32m\]\u@\h \[\033[35m\]${MSYSTEM:-${OSTYPE}} \[\e[33m\]\w\[\e[0m\]\n\$ '
  else
    PS1='${debian_chroot:+($debian_chroot)}\[\e]0;\w\a\]\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
  fi
else
  if [ "${MSYSTEM:-${OSTYPE}}" ]; then
    PS1='${debian_chroot:+($debian_chroot)}\u@\h ${MSYSTEM:-${OSTYPE}} \w\n\$ '
  else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h \w\n\$ '
  fi
fi

# Setup prompt for git
unset _have__git_ps1
if type __git_ps1 > /dev/null 2>&1; then
  _have__git_ps1=yes
else
  if [ -f "${XDG_CONFIG_HOME:-${HOME}/.config}/git/git-prompt.sh" ]; then
    . "${XDG_CONFIG_HOME:-${HOME}/.config}/git/git-prompt.sh"
  fi
  if type __git_ps1 > /dev/null 2>&1; then
    _have__git_ps1=yes
  fi
fi
if [ "${_have__git_ps1}" = "yes" ]; then
  case "${OSTYPE_LOWER}" in
    msys*|mingw*)
      if [ "$color_prompt" = yes ]; then
        PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]\[\033[32m\]\u@\h \[\033[35m\]'
        PS1="${PS1}"'${MSYSTEM:-${OSTYPE}} \[\033[33m\]\w\[\033[36m\]'
        PS1="${PS1}"'`__git_ps1`'
        PS1="${PS1}"'\[\033[0m\]\n$ '
      else
        PS1='$TITLEPREFIX:$PWD \u@\h '
        PS1="${PS1}"'${MSYSTEM:-${OSTYPE}} \w'
        PS1="${PS1}"'`__git_ps1`'
        PS1="${PS1}"'\n$ '
      fi
      ;;
    *)
      if [ "$color_prompt" = yes ]; then
        PS1='${debian_chroot:+($debian_chroot)}\[\e]0;\w\a\]\[\e[32m\]\u@\h'
        [ -n "${MSYSTEM:-${OSTYPE}}" ] && PS1="${PS1}"' \[\033[35m\]${MSYSTEM:-${OSTYPE}} '
        PS1="${PS1}"'\[\e[33m\]\w\[\033[31m\]$(__git_ps1)\[\e[0m\]\n\$ '
      else
        PS1='${debian_chroot:+($debian_chroot)}\u@\h'
        [ -n "${MSYSTEM:-${OSTYPE}}" ] && PS1="${PS1}"' ${MSYSTEM:-${OSTYPE}} '
        PS1="${PS1}"'\w$(__git_ps1)\n\$ '
      fi
    ;;
  esac
  GIT_PS1_SHOWDIRTYSTATE=true
  GIT_PS1_SHOWUNTRACKEDFILES=true
  GIT_PS1_SHOWSTASHSTATE=true
  GIT_PS1_SHOWUPSTREAM=auto
  GIT_PS1_SHOWCONFLICTSTATE=yes
  GIT_PS1_SHOWCOLORHINTS=""
fi

# git completion
if ! type ___git_complete > /dev/null 2>&1 ; then
  if [ -f "${XDG_CONFIG_HOME:-${HOME}/.config}/git/git-completion.bash" ]; then
    . "${XDG_CONFIG_HOME:-${HOME}/.config}/git/git-completion.bash"
  fi
fi

if [ "$HISTFILE" ]; then
  # [ -d "$(dirname $HISTFILE)" ] || mkdir -p "$(dirname $HISTFILE)"
  # [ -f "$HISTFILE" ] || touch $HISTFILE
  shopt -s histverify
  shopt -s histappend
  \history -r
fi

# History settings
case "$HISTCONTROL" in
  *ignoreboth*)
    ;;
  *)
    HISTCONTROL=${HISTCONTROL}${HISTCONTROL:+,}ignoreboth
  ;;
esac
export HISTCONTROL
HISTFILESIZE=10000
HISTIGNORE='[ \t]*:&:ls:ll:la:fg:bg:ps:top:df:du'
HISTSIZE=10000
# export HISTCONTROL=erasedups:ignoredups:ignorespace
# #export HISTCONTROL=ignoredups:ignorespace

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# alias ls='ls --color=auto'

#unset PAGER

# Shell Options
#
# See man bash for more options...
#
# Don't wait for job termination notification
# set -o notify
#
# Don't use ^D to exit
# set -o ignoreeof
#
# Use case-insensitive filename globbing
# shopt -s nocaseglob
#
# Make bash append rather than overwrite the history on disk
# shopt -s histappend
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell

# Programmable completion enhancements are enabled via
# /etc/profile.d/bash_completion.sh when the package bash_completion
# is installed.  Any completions you add in ~/.bash_completion are
# sourced last.

# History Options
#
# Don't put duplicate lines in the history.
# export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well
#
# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

# Aliases
#
# Some people use a different file for aliases
for d in "${XDG_CONFIG_HOME+${XDG_CONFIG_HOME}/bash}" "${HOME}"; do
  if [ -f "${d}/.bash_aliases" ]; then
    . "${d}/.bash_aliases"
  fi
done
#
# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#
# Interactive operation...
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
#
# Default to human readable figures
# alias df='df -h'
# alias du='du -h'
#
# Misc :)
# alias less='less -r'                          # raw control characters
# alias whence='type -a'                        # where, of a sort
# alias grep='grep --color'                     # show differences in colour
# alias egrep='egrep --color=auto'              # show differences in colour
# alias fgrep='fgrep --color=auto'              # show differences in colour
#
# Some shortcuts for different directory listings
# alias ls='ls -hF --color=tty'                 # classify files in colour
# alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'
# alias ll='ls -l'                              # long list
# alias la='ls -A'                              # all but . and ..
# alias l='ls -CF'                              #

# Umask
#
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077

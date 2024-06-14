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
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benifitial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bashrc file

# If not running interactively, don't do anything
#[[ "$-" != *i* ]] && return

# Not bash
[ -z "${BASH_VERSION}" ] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

OSTYPE="${OSTYPE:=$(uname -o)}" 2> /dev/null
if [ $? -a -n ${OSTYPE} ]; then
  export OSTYPE
else
  unset OSTYPE
fi

case "$-" in
  *i*)
    if [ -n "${MSYSTEM}" ]; then
      PS1='\[\e]0;\w\a\]\[\e[32m\]\u@\h \[\033[35m\]$MSYSTEM \[\e[33m\]\w\[\e[0m\]\n\$ '
    elif [ -n "${OSTYPE}" ]; then
      PS1='\[\e]0;\w\a\]\[\e[32m\]\u@\h \[\033[35m\]$OSTYPE \[\e[33m\]\w\[\e[0m\]\n\$ '
    else
      PS1='\[\e]0;\w\a\]\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
    fi
    case ":${SHELLOPTS}:" in
      *:posix:*)
        HISTFILE=${HOME}/.sh_history
        ;;
      *)
        if [ -f "${HOME}/.config/git/git-completion.bash" ]; then
          . "${HOME}/.config/git/git-completion.bash"
        fi
        HISTFILE=${HOME}/.bash_history
        _have__git_ps1=no
        type __git_ps1 2> /dev/null > /dev/null
        if [ $? = 0 ]; then
          _have__git_ps1=yes
        else
          if [ -f "${HOME}/.config/git/git-prompt.sh" ]; then
            . "${HOME}/.config/git/git-prompt.sh"
            type __git_ps1 2> /dev/null > /dev/null
            if [ $? = 0 ]; then
              _have__git_ps1=yes
            fi
          fi
        fi
        if [ "${_have__git_ps1}" = "yes" ]; then
          case "${OSTYPE}" in
            msys|Msys)
              PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]\[\033[32m\]\u@\h \[\033[35m\]'
              PS1="${PS1}"'${MSYSTEM:=$OSTYPE} \[\033[33m\]\w\[\033[36m\]'
              PS1="${PS1}"'`__git_ps1`'
              PS1="${PS1}"'\[\033[0m\]\n$ '
              ;;
            *)
              PS1='\[\e]0;\w\a\]\[\e[32m\]\u@\h '
              [ -n "${OSTYPE}" ] && PS1="${PS1}"'\[\033[35m\]$OSTYPE '
              PS1="${PS1}"'\[\e[33m\]\w\[\033[31m\]$(__git_ps1)\[\e[0m\]\n\$ '
            ;;
          esac
          GIT_PS1_SHOWDIRTYSTATE=true
          GIT_PS1_SHOWUNTRACKEDFILES=true
          GIT_PS1_SHOWSTASHSTATE=true
          GIT_PS1_SHOWUPSTREAM=auto
          GIT_PS1_SHOWCONFLICTSTATE=yes
          GIT_PS1_SHOWCOLORHINTS=""
        fi
        ;;
    esac
    unset _have__git_ps1
    ;;
  *)
    return
    ;;
esac

# History settings
[[ "$HISTCONTROL" != *ignoreboth* ]] && HISTCONTROL=${HISTCONTROL}${HISTCONTROL+,}ignoreboth
# HISTFILE=${HOME}/.bash_history
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
shopt -s histappend
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell

# Programmable completion enhancements are enabled via
# /etc/profile.d/bash_completion.sh when the package bash_completetion
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
if [ -f "${HOME}/.bash_aliases" ]; then
  source "${HOME}/.bash_aliases"
fi
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

# Functions
#
# Some people use a different file for functions
if [ -f "${HOME}/.bash_functions" ]; then
  source "${HOME}/.bash_functions"
fi

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi
unset rc

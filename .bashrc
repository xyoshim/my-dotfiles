# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
# if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
# then
#     PATH="$HOME/.local/bin:$HOME/bin:$PATH"
# fi
# export PATH

# Set PATH so it includes user's private bin if it exists
for TMP_PATH in ${HOME}/bin ${HOME}/.local/bin
do
  if [ -d "${TMP_PATH}" ]; then
    [[ ":${PATH}:" != *:${TMP_PATH}:* ]] && export PATH="${TMP_PATH}:${PATH}"
  fi
done
unset TMP_PATH

# export HISTCONTROL=erasedups:ignoredups:ignorespace
# #export HISTCONTROL=ignoredups:ignorespace

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# History settings
[[ "$HISTCONTROL" != *ignoreboth* ]] && export HISTCONTROL=${HISTCONTROL}${HISTCONTROL+,}ignoreboth
HISTFILESIZE=10000
HISTIGNORE='&:ls:ll:la:fg:bg:ps:top:df:du'
HISTSIZE=10000

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

# dotnet
export DOTNET_ROOT=$HOME/.dotnet
[[ ":${PATH}:" != *:${DOTNET_ROOT}:* ]] && export PATH="${PATH}:${DOTNET_ROOT}"
[[ ":${PATH}:" != *:${DOTNET_ROOT}/tools:* ]] && export PATH="${PATH}:${DOTNET_ROOT}/tools"

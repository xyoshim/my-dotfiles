# .cshrc

#unsetenv POSIXLY_CORRECT
# User specific aliases and functions

# Source global definitions
if ( -f /etc/csh.login ) then
	source /etc/csh.login
endif

# path setting
#setenv PATH ${PATH}:${HOME}/bin
setenv USERNAME ""

# Emacs style key binding
bindkey -e

# enable search on prompt
bindkey "^R" i-search-back
bindkey "^S" i-search-fwd

# unlimit stacksize for large aray in user mode
#limit stacksize unlimited

# set aliases
alias ls	'ls -F --color=auto'
alias ll	'ls -la --color=auto'
alias la	'ls -a --color=auto'
alias rm        'rm -i'
alias cp        'cp -i'
alias mv        'mv -i'
alias eng	'env LANG=C LANGUAGE=C LC_ALL=C'

unset autologout
set ignoreeof
set histdup = erase
set history = 1000
set savehist = (1024 merge)
#set savehist
#set histfile "$HOME/.csh_history"

alias pwd 'echo $cwd'

#alias vncs 'vncserver -geometry 1024x768'
#alias kernel.org 'w3m http://ftp.kernel.org/pub/linux/kernel/'
#alias mozilla.org 'w3m ftp://ftp.mozilla.org/pub/mozilla.org/'
#alias /. 'w3m http://slashdot.jp/'
#alias mymozilla '(cd /usr/local/mozilla ; env -u MOZILLA_FIVE_HOME ./mozilla \!*)'
#alias thunderbird   '(cd /usr/local/Mozilla/Thunderbird/thunderbird ; ./thunderbird \!* )'
alias cps 'ps -ef | grep csh'
#alias hg 'env PYTHONPATH=/usr/local/lib/python hg'

# dotnet
setenv DOTNET_ROOT "$HOME/.dotnet"
setenv PATH "$PATH":"$DOTNET_ROOT":"$DOTNET_ROOT/tools"


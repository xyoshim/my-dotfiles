# .bash_profile

# source the users bashrc if it exists
if [ -f ~/.profile ] ; then
	. ~/.profile
fi

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

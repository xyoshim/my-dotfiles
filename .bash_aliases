# bash aliases

# read common aliases
if [ -f "${HOME}/.sh_aliases" ]; then
  source "${HOME}/.sh_aliases"
fi

# bash specific aliases
alias where='\type -a'          # where
alias whence='\type'            # where, of a sort

# jujutsu complition
\type jj 2> /dev/null > /dev/null
[ $? = 0 ] && source <(jj util completion bash)

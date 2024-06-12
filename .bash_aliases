# bash aliases

# read common aliases
if [ -f "${HOME}/.sh_aliases" ]; then
  source "${HOME}/.sh_aliases"
fi

# bash specific aliases
alias where='\type -a'          # where
alias whence='\type'            # where, of a sort

# jujutsu complition
# $ jj util completion bash > "${HOME}/.config/jj/jj-completion.bash"
if [ -f "${HOME}/.config/jj/jj-completion.bash" ]; then
  source "${HOME}/.config/jj/jj-completion.bash"
fi

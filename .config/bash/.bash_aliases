# bash aliases

# read common aliases
for d in ${HOME} ${XDG_CONFIG_HOME+$XDG_CONFIG_HOME/sh}; do
  if [ -f "${d}/.sh_aliases" ]; then
    source "${d}/.sh_aliases"
  fi
done
unset d

# bash specific aliases
alias where='\type -a'          # where
alias whence='\type'            # where, of a sort

# jujutsu complition
# $ jj util completion bash > "${XDG_CONFIG_HOME:-$HOME/.config}/jj/jj-completion.bash"
d="${XDG_CONFIG_HOME:-$HOME/.config}"
if [ -f "${d}/jj/jj-completion.bash" ]; then
  source "${d}/jj/jj-completion.bash"
fi
unset d

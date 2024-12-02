# bash aliases

# read common aliases
for d in "${XDG_CONFIG_HOME+${XDG_CONFIG_HOME}/sh}" "${HOME}/.config/sh" "${HOME}"; do
  if [ "${d}" ] && [ -f "${d}/.sh_aliases" ]; then
    source "${d}/.sh_aliases"
    break
  fi
done
unset d

# bash specific aliases
alias where='\type -a'          # where
alias whence='\type'            # where, of a sort

# bash aliases

# read common functons
if [ -f "${HOME}/.sh_aliases" ]; then
  source "${HOME}/.sh_aliases"
fi

\type jj 2> /dev/null > /dev/null
[ $? = 0 ] && source <(jj util completion bash)

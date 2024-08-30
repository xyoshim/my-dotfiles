#
TMP_PATH=$(echo :${PATH}: | sed \
  -e 's|:/c/[Ww][Ii][Nn][Ds][Oo][Ww][Ss]/System32/OpenSSH:|:|g' \
  -e 's|:/c/Strawberry/perl/bin:|:|g' \
  -e 's|:/c/Strawberry/perl/site/bin:|:|g' \
  -e 's|:/c/Strawberry/c/bin:|:|g' \
  -e 's|:/c/Program Files/Git/cmd:|:|g' \
  -e 's|:+|:|g' -e 's|^:||' -e 's|:$||' \
)

PATH="${TMP_PATH}"; export PATH
unset TMP_PATH

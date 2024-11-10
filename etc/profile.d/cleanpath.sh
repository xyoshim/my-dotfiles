#
TMP_PATH=$(echo :"${PATH}": | sed \
  -e 's|:/c/[Ww][Ii][Nn][Ds][Oo][Ww][Ss]/System32/OpenSSH:|:|g' \
  -e 's|:/c/Strawberry/perl/bin:|:|g' \
  -e 's|:/c/Strawberry/perl/site/bin:|:|g' \
  -e 's|:/c/Strawberry/c/bin:|:|g' \
  -e 's|:/c/Program Files/Git/cmd:|:|g' \
)

export PATH="$(echo :"${TMP_PATH}": | sed -E 's|:+|:|g' | sed -E 's|^:+||' | sed -E 's|:+$||')"
unset TMP_PATH

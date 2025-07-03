#
# Remove Windows paths that interfere with Git Bash
#
# Surround PATH with colons to simplify sed patterns and combine all substitutions
# into a single sed call for efficiency.
TMP_PATH=$(echo ":${PATH}:" | sed \
  -e 's|:/c/[Ww][Ii][Nn][Ds][Oo][Ww][Ss]/System32/OpenSSH:|:|g' \
  -e 's|:/c/Strawberry/perl/bin:|:|g' \
  -e 's|:/c/Strawberry/perl/site/bin:|:|g' \
  -e 's|:/c/Strawberry/c/bin:|:|g' \
  -e 's|:/c/Program Files/Git/cmd:|:|g' \
)

# Clean up the PATH:
# 1. Replace multiple colons with a single one.
# 2. Remove leading/trailing colons.
export PATH="$(echo "${TMP_PATH}" | sed -E 's/:+/:/g; s/^:|:$//g')"
unset TMP_PATH

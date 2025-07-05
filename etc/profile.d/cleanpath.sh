#
# Remove Windows paths that interfere with Cygwin
#
# Surround PATH with colons to simplify sed patterns and combine all substitutions
# into a single sed call for efficiency.
TMP_PATH=$(echo ":${PATH}:" | sed \
  -e 's|:/cygdrive/c/[Ww][Ii][Nn][Ds][Oo][Ww][Ss]/System32/WindowsPowerShell/v1\.0:|:|g' \
  -e 's|:/cygdrive/c/[Ww][Ii][Nn][Ds][Oo][Ww][Ss]/System32/OpenSSH:|:|g' \
  -e 's|:/cygdrive/c/Program Files/PowerShell/7:|:|g' \
  -e 's|:/cygdrive/c/Program Files \(x86\)/dotnet:|:|g' \
  -e 's|:/cygdrive/c/Program Files \(x86\)/Windows Kits/10/Windows Performance Toolkit:|:|g' \
  -e 's|:/cygdrive/c/Program Files \(x86\)/NVIDIA Corporation/PhysX/Common:|:|g' \
  -e 's|:/cygdrive/c/Strawberry/perl/bin:|:|g' \
  -e 's|:/cygdrive/c/Strawberry/perl/site/bin:|:|g' \
  -e 's|:/cygdrive/c/Strawberry/c/bin:|:|g' \
  -e 's|:/cygdrive/c/Program Files/dotnet:|:|g' \
  -e 's|:/cygdrive/c/Program Files/LLVM/bin:|:|g' \
  -e 's|:/cygdrive/c/Program Files/Git/cmd:|:|g' \
  -e 's|:/cygdrive/c/Program Files/CMake/bin:|:|g' \
  -e "s|:/cygdrive/c/Users/${USERNAME:-${USER}}/AppData/Local/Microsoft/WindowsApps:|:|g" \
  -e "s|:/cygdrive/c/Users/${USERNAME:-${USER}}/AppData/Local/Android/Sdk/platform-tools:|:|g" \
  -e "s|:/cygdrive/c/Users/${USERNAME:-${USER}}/AppData/Local/Programs/Microsoft VS Code/bin:|:|g" \
  -e "s|:/cygdrive/c/Users/${USERNAME:-${USER}}/\.dotnet/tools:|:|g" \
)

# Remove python path
# WIP:  Can not delete the following path:
#        /cygdrive/c/Users/${USERNAME:-${USER}}/AppData/Local/Programs/Python/Python313
TMP_PATH=$(echo "${TMP_PATH}" | sed \
  -E "s|:/cygdrive/c/Users/${USERNAME:-${USER}}/AppData/Local/Programs/Python/[^:]+:|:|g" \
)

# Clean up the PATH:
# 1. Replace multiple colons with a single one.
# 2. Remove leading/trailing colons.
export PATH="$(echo "${TMP_PATH}" | sed -E 's/:+/:/g; s/^:|:$//g')"
unset TMP_PATH

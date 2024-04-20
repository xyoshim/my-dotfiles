# 
TMP_PATH=$(echo :${PATH}: | sed \
  -e 's|:/cygdrive/c/[Ww][Ii][Nn][Ds][Oo][Ww][Ss]/System32/WindowsPowerShell/v1.0|:|g' \
  -e 's|:/cygdrive/c/[Ww][Ii][Nn][Ds][Oo][Ww][Ss]/System32/OpenSSH:|:|g' \
  -e 's|:/cygdrive/c/Program Files/PowerShell/7:|:|g' \
  -e 's|:/cygdrive/c/Program Files/dotnet:|:|g' \
  -e 's|:/cygdrive/c/Program Files (x86)/dotnet:|:|g' \
  -e 's|:/cygdrive/c/Program Files (x86)/Windows Kits/10/Windows Performance Toolkit:|:|g' \
  -e 's|:/cygdrive/c/Program Files (x86)/NVIDIA Corporation/PhysX/Common:|:|g' \
  -e 's|:/cygdrive/c/Program Files/LLVM/bin:|:|g' \
  -e 's|:/cygdrive/c/Program Files/Git/cmd:|:|g' \
  -e 's|:/cygdrive/c/Program Files/CMake/bin:|:|g' \
  -e 's|:/cygdrive/c/Program Files/PowerShell/7:|:|g' \
  -e "s|:/cygdrive/c/Users/${USERNAME:-${USER}}/AppData/Local/Programs/Python/Python[0-9][0-9][0-9]/Scripts:|:|g" \
  -e "s|:/cygdrive/c/Users/${USERNAME:-${USER}}/AppData/Local/Programs/Python/Python[0-9][0-9][0-9]:|:|g" \
  -e "s|:/cygdrive/c/Users/${USERNAME:-${USER}}/AppData/Local/Microsoft/WindowsApps:|:|g" \
  -e "s|:/cygdrive/c/Users/${USERNAME:-${USER}}/AppData/Local/Android/Sdk/platform-tools:|:|g" \
  -e "s|:/cygdrive/c/Users/${USERNAME:-${USER}}/AppData/Local/Programs/Microsoft VS Code/bin:|:|g" \
  -e "s|:/cygdrive/c/Users/${USERNAME:-${USER}}/.dotnet/tools:|:|g" \
  -e 's|:+|:|g' -e 's|^:||' -e 's|:$||' \
)

PATH="${TMP_PATH}"; export PATH
unset TMP_PATH

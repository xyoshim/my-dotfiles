$IP = (wsl.exe -d Ubuntu-24.04 exec hostname -I).Trim()
# ssh localhost:10022 -> wsl:22
netsh.exe interface portproxy delete v4tov4 listenport=10022
netsh.exe interface portproxy add v4tov4 listenport=10022 connectaddress=$IP connectport=22

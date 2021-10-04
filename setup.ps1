$shell = New-Object -ComObject WScript.Shell
$curdir = Convert-Path .
$sysdir = [Environment]::GetFolderPath("System")

echo "@echo off" | Out-File -Encoding default .\ffdsm.cmd
echo "set DSM_HOME=$curdir" | Out-File -Append -Encoding default .\ffdsm.cmd
echo "set VAGRANT_HOME=%DSM_HOME%\vb" | Out-File -Append -Encoding default .\ffdsm.cmd
echo "set VAGRANT_PREFFER_SYSTEM_BIN=0" | Out-File -Append -Encoding default .\ffdsm.cmd
echo "cd %DSM_HOME%" | Out-File -Append -Encoding default .\ffdsm.cmd

$lnk = $shell.CreateShortcut("$curdir\ffdsm.lnk")
$lnk.TargetPath = "$sysdir\cmd.exe"
$lnk.Arguments = "/k $curdir\ffdsm.cmd"
$lnk.Save()

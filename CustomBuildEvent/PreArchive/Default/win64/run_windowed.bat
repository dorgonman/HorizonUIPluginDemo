@echo off
set SCRIPT_DIR=%~dp0
pushd "%SCRIPT_DIR%"
start HorizonUIPluginDemo.exe -windowed -ExecCmds="r.SetRes 1280x720w"
popd

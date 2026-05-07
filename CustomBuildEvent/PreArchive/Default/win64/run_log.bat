@echo off
set SCRIPT_DIR=%~dp0
pushd "%SCRIPT_DIR%"
start HorizonUIPluginDemo.exe -log
popd

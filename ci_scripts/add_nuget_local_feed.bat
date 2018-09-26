set SCRIPT_DIR=%~dp0
pushd %SCRIPT_DIR%
cd ..
ue_ci_scripts\bin\nuget\nuget sources remove -Name hsgame-local
ue_ci_scripts\bin\nuget\nuget sources Add -Name hsgame-local -Source \\hsgame\UE4-Packaged-build\nuget\hsgame-local
popd
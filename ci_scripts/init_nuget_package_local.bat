set SCRIPT_DIR=%~dp0
pushd %SCRIPT_DIR%
cd ..
ue_ci_scripts\bin\nuget\nuget init Intermediate\nuget\ \\hsgame\UE4-Packaged-build\nuget\hsgame-local\ -ForceEnglishOutput

popd
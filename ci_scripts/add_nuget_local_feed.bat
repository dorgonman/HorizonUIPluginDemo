set SCRIPT_DIR=%~dp0
pushd %SCRIPT_DIR%
cd ..
ue_ci_scripts\bin\nuget\nuget sources remove -Name %FEED_NAME%
ue_ci_scripts\bin\nuget\nuget sources Add -Name %FEED_NAME% -Source \\hsgame\UE4-Packaged-build\nuget\%FEED_NAME%
popd
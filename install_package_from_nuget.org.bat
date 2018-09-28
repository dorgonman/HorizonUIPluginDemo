
Set PACKAGE_NAME="UE4Editor-HorizonUIPluginDemo"
Set FEED_NAME="nuget.org"
set PROJECT_ROOT=%~dp0
set OUTPUT_DIRECTORY=%PROJECT_ROOT%\Intermediate\nuget\
: if exist %OUTPUT_DIRECTORY% rmdir /Q /S %OUTPUT_DIRECTORY%
mkdir %OUTPUT_DIRECTORY%

nuget install %PACKAGE_NAME% -OutputDirectory %OUTPUT_DIRECTORY% -Source %FEED_NAME% -ExcludeVersion -ForceEnglishOutput -NoCache

xcopy  %OUTPUT_DIRECTORY%\%PACKAGE_NAME%\* %PROJECT_ROOT% /s /e /Y
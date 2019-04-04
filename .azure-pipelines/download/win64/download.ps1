$projectRoot=$(Resolve-Path -Path "../../../")

. "$projectRoot\ue_ci_scripts\function\ps1\az\devops.ps1"


$cmd="DownloadArtifact " +
    "-Organization https://hsgame.visualstudio.com/ " +
    "-Project UE4HorizonPlugin " +
    "-DefinitionIds 24 " +
    "-ArtifactName drop_standalone_win64_shipping " +
    "-DownloadToPath " + $projectRoot + "\Intermediate\PipelineArtifact\"

echo $cmd
iex $cmd


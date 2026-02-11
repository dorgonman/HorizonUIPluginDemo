$projectRoot = Resolve-Path -Path "$PSScriptRoot\..\..\.."
$organization = "https://hsgame.visualstudio.com/"
$project = "UE4HorizonPlugin"
$definitionId = "24"
$artifactName = "drop_standalone_win64_shipping"
$downloadToPath = Join-Path $projectRoot "Intermediate\PipelineArtifact"

if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    throw "Azure CLI (az) is required to download pipeline artifacts."
}

New-Item -ItemType Directory -Force -Path $downloadToPath | Out-Null
$buildId = az pipelines build list --organization $organization --project $project --definition-ids $definitionId --result succeeded --status completed --top 1 --query "[0].id" -o tsv
if (-not $buildId) {
    throw "Could not resolve latest successful build for definition $definitionId."
}

$cmd = "az pipelines runs artifact download " +
    "--organization $organization " +
    "--project $project " +
    "--run-id $buildId " +
    "--artifact-name $artifactName " +
    "--path `"$downloadToPath`""

echo $cmd
iex $cmd

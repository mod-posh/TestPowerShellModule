param (
 [string]$ModuleName,
 [string]$Source = "",
 [string]$Output = "",
 [string]$Debug = 'false'
)
try
{
 Write-Host "::group::Starting the Test PowerShell Module task..."
 Write-Host "::group::Setting up variables"

 $Debug = [System.Convert]::ToBoolean($Debug)

 $sourcePath = if ([string]::IsNullOrEmpty($Source)) { $env:GITHUB_WORKSPACE } else { Join-Path $env:GITHUB_WORKSPACE $Source }
 $outputPath = if ([string]::IsNullOrEmpty($Output)) { Join-Path $env:GITHUB_WORKSPACE "output" } else { Join-Path $env:GITHUB_WORKSPACE $Output }

 $Module = Get-ChildItem -Path $sourcePath -Filter "$ModuleName.psd1" -Recurse
 $ModuleRoot = $Module.Directory.FullName
 $Destination = Join-Path $outputPath $ModuleName
 $modulePath = Join-Path $Destination "$ModuleName.psm1"
 $ManifestPath = Join-Path $Destination "$ModuleName.psd1"

 if ($Debug)
 {
  Write-Host "ModuleName   : $ModuleName"
  Write-Host "SourcePath   : $sourcePath"
  Write-Host "OutputPath   : $outputPath"
  Write-Host "ModuleRoot   : $ModuleRoot"
  Write-Host "modulePath   : $modulePath"
  Write-Host "ManifestPath : $ManifestPath"
  Write-Host "Destination  : $Destination"
 }

 Test-ModuleManifest -Path $ManifestPath -Verbose
 Import-Module $Destination -Verbose
 Get-Module -Name $ModuleName
}
catch
{
 Write-Host "##[error]An error occurred: $($_.Exception.Message)"
 exit 1
}
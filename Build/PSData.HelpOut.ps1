$PSDataLoaded = Get-Module PSData
Push-Location ($PSScriptRoot | Split-Path)
if (-not $PSDataLoaded) {
    $PSDataLoaded = Get-ChildItem -Recurse -Filter "*.psd1" | 
        Where-Object Name -eq 'PSData.psd1' | 
        Import-Module -Name { $_.FullName } -Force -PassThru
}
if ($PSDataLoaded) {
    "::notice title=ModuleLoaded::PSData Loaded" | Out-Host
} else {
    "::error:: PSData not loaded" |Out-Host
}
if ($PSDataLoaded) {
    Save-MarkdownHelp -Module $PSDataLoaded.Name -PassThru -SkipCommandType Alias
}
Pop-Location
#requires -Module PSDevOps
Import-BuildStep -SourcePath (
    Join-Path $PSScriptRoot 'GitHub'
) -BuildSystem GitHubWorkflow

Push-Location ($PSScriptRoot | Split-Path)
New-GitHubWorkflow -Name "Analyze, Test, Tag, and Publish" -On Push,
    PullRequest, 
    Demand -Job TestPowerShellOnLinux, 
    TagReleaseAndPublish, 
    BuildPSData -OutputPath .\.github\workflows\BuildPSData.yml -Environment ([Ordered]@{
        REGISTRY = 'ghcr.io'
        IMAGE_NAME = '${{ github.repository }}'
    })

Pop-Location
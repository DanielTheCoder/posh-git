if (Get-Module posh-git) { return }

Push-Location $psScriptRoot
.\CheckVersion.ps1 > $null

. .\Utils.ps1
. .\Utils.modules.ps1
. .\GitUtils.ps1
. .\GitPrompt.ps1
. .\GitTabExpansion.ps1
#. .\modules\TortoiseGit.ps1

#MODULES Import - Start
    # global Paths
    $global:poshgit_moduleDbg = $false
    $global:poshgit_modules_global = (Join-Path $PSScriptRoot "modules")
    $global:poshgit_modules_user =  (Join-Path $(Split-Path -parent $profile) "posh-git\modules")
    
    #write-host $global:poshgit_modules_user
    if($global:poshgit_moduleDbg) {write-host ("> MODULES Import - Start")}

    # create Userprofile folder
    if(!(Test-Path $global:poshgit_modules_user)) {
        New-Item -ItemType Directory -Force -Path $global:poshgit_modules_user
    }

    # Module Imports
    Import-Modules "Global" $global:poshgit_modules_global
    Import-Modules "User" $global:poshgit_modules_user
    #write-host $global:functionList

    $scriptRunResult += Run-Scripts "Global" $global:poshgit_modules_global "GetFunctionExports"
    $scriptRunResult += Run-Scripts "User" $global:poshgit_modules_user "GetFunctionExports"
    # Force Array with ,
    $global:functionList += ,$scriptRunResult
    if($global:poshgit_moduleDbg) {write-host ("> MODULES Import - End")}
#MODULES Import - End

Pop-Location

if (!$Env:HOME) { $Env:HOME = "$Env:HOMEDRIVE$Env:HOMEPATH" }
if (!$Env:HOME) { $Env:HOME = "$Env:USERPROFILE" }

Get-TempEnv 'SSH_AGENT_PID'
Get-TempEnv 'SSH_AUTH_SOCK'

$global:functionList += @(
        'Invoke-NullCoalescing',
        'Write-GitStatus',
        'Write-Prompt',
        'Get-GitStatus', 
        'Enable-GitColors', 
        'Get-GitDirectory',
        'TabExpansion',
        'Get-AliasPattern',
        'Get-SshAgent',
        'Start-SshAgent',
        'Stop-SshAgent',
        'Add-SshKey',
        'Get-SshPath',
        'Update-AllBranches')

#write-host $global:functionList

Export-ModuleMember `
    -Alias @(
        '??') `
    -Function $global:functionList



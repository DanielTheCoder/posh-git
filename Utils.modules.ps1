function Get-ModuleScripts([string] $displayText, [System.IO.FileInfo]$importPath){
    if($global:poshgit_moduleDbg) {write-host ("> " + $displayText)}
    #write-host $("> Importpath:" + $importPath)
    
    if (!(Test-Path $importPath)) {
        write-warning $("Importpath (" + $importPath + ") does not exist!")
        return
    }

    $scriptsFolder = Join-Path $importPath  "*.*"
    $scriptFiles = Get-ChildItem $scriptsFolder -include *.ps1,*.psm1
    
    return $scriptFiles
}


function Import-Modules([string] $displayText, [System.IO.FileInfo]$importPath)
{
    $scriptFiles = Get-ModuleScripts $("Importing (" + $displayText + ")") $importPath
    foreach ($file in $scriptFiles)
    {
        if($global:poshgit_moduleDbg) {write-host (" - " + $file.Name)}
        . $file
    }
    return $scriptFiles
}

function Run-Scripts([string] $displayText, [System.IO.FileInfo]$importPath, [string]$baseCommandName, $arguments)
{
    $scriptFiles = Get-ModuleScripts $("Run-Scripts (" + $displayText + ") with command: " + $baseCommandName) $importPath
    foreach ($file in $scriptFiles)
    {
        $commandName = ($file.BaseName + "_" + $baseCommandName)
        
        if($global:poshgit_moduleDbg) {write-host (" - command: " + $commandName)}

        . $file
        $result = &$commandName $arguments

        if($global:poshgit_moduleDbg) {write-host (" - result: " + $result)}        
        
        return $result
    }
}

Param(
    [string] $srcDirectory, # the path that contains your mod's .XCOM_sln
    [string] $sdkPath, # the path to your SDK installation ending in "XCOM 2 War of the Chosen SDK"
    [string] $gamePath, # the path to your XCOM 2 installation ending in "XCOM2-WaroftheChosen"
    [string] $config # build configuration
)

$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
$common = Join-Path -Path $ScriptDirectory "X2ModBuildCommon\build_common.ps1"
Write-Host "Sourcing $common"
. ($common)

$builder = [BuildProject]::new("MeristPerkPack", $srcDirectory, $sdkPath, $gamePath)

# $builder.IncludeSrc("D:\SteamLibrary\steamapps\workshop\content\268500\1796402257\Src")

switch ($config)
{
    "debug" {
        $builder.EnableDebug()
    }
    "default" {
        # Nothing special
    }
    "" { ThrowFailure "Missing build configuration" }
    default { ThrowFailure "Unknown build configuration $config" }
}

$builder.AddToClean("MeristBuffMe")
$builder.AddToClean("MeristEnhancedShieldEffects")

# Uncomment this line to enable cooking.
# $builder.SetContentOptionsJsonFilename("ContentOptions.json")
$builder.InvokeBuild()

if ($null -ne (Get-Command "X2ProjectGenerator.exe" -ErrorAction SilentlyContinue))
{
    Write-Host "Verifying project file..."
    &"X2ProjectGenerator.exe" "$srcDirectory\MeristPerkPack" "--exclude-contents" "--verify-only"
    if ($LASTEXITCODE -ne 0)
    {
        ThrowFailure "Errors in project file."
    }
}
else
{
    Write-Host "Skipping verification of project file."
}
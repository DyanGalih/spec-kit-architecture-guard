<#
.SYNOPSIS
    Locate the active Spec Kit feature directory and output artifact paths.

.DESCRIPTION
    Used by architecture-verify.md as the {SCRIPT} source to find the active
    FEATURE_DIR and derive absolute paths for spec.md, plan.md, and tasks.md.

    Discovery order:
      1. -FeaturePath argument if provided.
      2. Most recently modified directory under specs/ in the working tree.
      3. specs/ root itself (fallback when no subdirectory is found).

.PARAMETER FeaturePath
    Optional. Explicit feature directory path (absolute or relative to repo root).

.PARAMETER Json
    Output in JSON format (for machine consumption).

.PARAMETER PathsOnly
    Suppress status/warning lines; output paths only.

.PARAMETER Help
    Show help message and exit.

.EXAMPLE
    .\check-prerequisites.ps1
    # Text output of feature dir and artifact paths

.EXAMPLE
    .\check-prerequisites.ps1 -Json -PathsOnly
    # JSON output without status messages

.EXAMPLE
    .\check-prerequisites.ps1 -FeaturePath specs/001-auth -Json
    # Use explicit feature directory

.NOTES
    EXIT CODES:
      0  Feature directory found; artifact paths derived
      1  Error (specs/ missing, bad arguments)
      2  Feature directory found but one or more artifact files are missing
#>

[CmdletBinding()]
param(
    [string]$FeaturePath = "",
    [switch]$Json,
    [switch]$PathsOnly,
    [Alias("h")]
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

if ($Help) {
    Write-Host @"
Usage: check-prerequisites.ps1 [OPTIONS]

Locate the active Spec Kit feature directory and derive artifact paths.

OPTIONS:
  -FeaturePath <path>   Explicit feature directory (absolute or relative)
  -Json                 Output in JSON format
  -PathsOnly            Suppress status/warning lines; output paths only
  -Help, -h             Show this help message

EXIT CODES:
  0  Feature directory found; artifact paths derived
  1  Error (specs/ missing, bad arguments)
  2  Feature directory found but one or more artifact files are missing
"@
    exit 0
}

# --- Locate repo root ---
try {
    $repoRoot = (git rev-parse --show-toplevel 2>$null)
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrEmpty($repoRoot)) {
        $repoRoot = (Get-Location).Path
    }
} catch {
    $repoRoot = (Get-Location).Path
}
$repoRoot = $repoRoot.Trim()

# --- Locate specs/ ---
$specsDir = Join-Path $repoRoot "specs"
if (-not (Test-Path $specsDir -PathType Container)) {
    if (-not $PathsOnly -and -not $Json) {
        Write-Error "ERROR: specs/ directory not found in $repoRoot"
    }
    exit 1
}

# --- Resolve feature directory ---
if (-not [string]::IsNullOrEmpty($FeaturePath)) {
    if ([System.IO.Path]::IsPathRooted($FeaturePath)) {
        $featureDir = $FeaturePath
    } else {
        $featureDir = Join-Path $repoRoot $FeaturePath
    }
    if (-not (Test-Path $featureDir -PathType Container)) {
        Write-Error "ERROR: Feature directory not found: $featureDir"
        exit 1
    }
} else {
    # Find most recently modified specs subdirectory
    $subDirs = Get-ChildItem -Path $specsDir -Directory -ErrorAction SilentlyContinue |
               Sort-Object LastWriteTime -Descending |
               Select-Object -First 1

    if ($null -ne $subDirs) {
        $featureDir = $subDirs.FullName
    } else {
        $featureDir = $specsDir
    }
}

# --- Derive artifact paths ---
$specMd            = Join-Path $featureDir "spec.md"
$planMd            = Join-Path $featureDir "plan.md"
$tasksMd           = Join-Path $featureDir "tasks.md"
$memorySynthesis   = Join-Path $featureDir "memory-synthesis.md"
$securityConstraints = Join-Path $featureDir "security-constraints.md"

# --- Check file existence ---
$missingFiles = @()
if (-not (Test-Path $specMd  -PathType Leaf)) { $missingFiles += "spec.md" }
if (-not (Test-Path $planMd  -PathType Leaf)) { $missingFiles += "plan.md" }
if (-not (Test-Path $tasksMd -PathType Leaf)) { $missingFiles += "tasks.md" }

$exitCode = if ($missingFiles.Count -gt 0) { 2 } else { 0 }

# --- Output ---
if ($Json) {
    $missingJson = $missingFiles | ConvertTo-Json -Compress
    if ($missingFiles.Count -eq 0) { $missingJson = "[]" }
    $output = [ordered]@{
        feature_dir           = $featureDir
        spec_md               = $specMd
        plan_md               = $planMd
        tasks_md              = $tasksMd
        memory_synthesis      = $memorySynthesis
        security_constraints  = $securityConstraints
        missing_files         = $missingFiles
    }
    $output | ConvertTo-Json -Compress
} elseif ($PathsOnly) {
    Write-Host "FEATURE_DIR: $featureDir"
    Write-Host "SPEC_MD: $specMd"
    Write-Host "PLAN_MD: $planMd"
    Write-Host "TASKS_MD: $tasksMd"
    Write-Host "MEMORY_SYNTHESIS: $memorySynthesis"
    Write-Host "SECURITY_CONSTRAINTS: $securityConstraints"
} else {
    Write-Host "FEATURE_DIR: $featureDir"
    Write-Host ""
    Write-Host "Artifact Paths:"
    Write-Host "  spec.md:               $specMd"
    Write-Host "  plan.md:               $planMd"
    Write-Host "  tasks.md:              $tasksMd"
    Write-Host "  memory-synthesis.md:   $memorySynthesis"
    Write-Host "  security-constraints:  $securityConstraints"
    if ($missingFiles.Count -gt 0) {
        Write-Host ""
        Write-Host "Missing files: $($missingFiles -join ', ')"
    }
}

exit $exitCode

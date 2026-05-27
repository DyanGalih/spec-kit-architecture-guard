<#
.SYNOPSIS
    Verify all Architecture Guard prerequisites before running governed workflows.

.DESCRIPTION
    Checks constitution files, Spec Kit structure, optional extensions, source
    directories, and prints a summary with pass/warn/fail indicators.

.PARAMETER ProjectRoot
    Optional. Path to the project root. Defaults to the current directory.

.EXAMPLE
    .\validate-setup.ps1
    # Validate current directory

.EXAMPLE
    .\validate-setup.ps1 -ProjectRoot C:\Projects\my-app
    # Validate a specific project

.NOTES
    EXIT CODES:
      0  No blocking errors — Architecture Guard can run
      N  Number of blocking errors found
#>

[CmdletBinding()]
param(
    [string]$ProjectRoot = "."
)

$ErrorActionPreference = 'Continue'

$errors   = 0
$warnings = 0

# Colour helpers
function Pass   ([string]$msg) { Write-Host "  " -NoNewline; Write-Host "√" -ForegroundColor Green -NoNewline; Write-Host " $msg" }
function Warn   ([string]$msg, [string]$hint = "") {
    Write-Host "  " -NoNewline; Write-Host "!" -ForegroundColor Yellow -NoNewline; Write-Host " $msg"
    if ($hint) { Write-Host "    $hint" -ForegroundColor Gray }
    $script:warnings++
}
function Fail   ([string]$msg, [string]$hint = "") {
    Write-Host "  " -NoNewline; Write-Host "X" -ForegroundColor Red -NoNewline; Write-Host " $msg"
    if ($hint) { Write-Host "    $hint" -ForegroundColor Gray }
    $script:errors++
}
function Section([string]$title) { Write-Host "`n$title" -ForegroundColor Cyan }

$root = Resolve-Path $ProjectRoot | Select-Object -ExpandProperty Path

Write-Host "Architecture Guard - Setup Validator" -ForegroundColor White
Write-Host "Project root: $root"

# ─── 1. Constitution Files ────────────────────────────────────────────────────
Section "1. Constitution Files"

if (Test-Path (Join-Path $root ".specify/memory/constitution.md")) {
    Pass "Governance constitution found (.specify/memory/constitution.md)"
} else {
    Fail "Governance constitution missing (.specify/memory/constitution.md)" `
         "Run /speckit.architecture-guard.init to create it."
}

if (Test-Path (Join-Path $root ".specify/memory/architecture_constitution.md")) {
    Pass "Architecture constitution found (.specify/memory/architecture_constitution.md)"
} else {
    Fail "Architecture constitution missing - this is the primary validation source." `
         "Run /speckit.architecture-guard.init to create it."
}

if (Test-Path (Join-Path $root ".specify/memory/security_constitution.md")) {
    Pass "Security constitution found (.specify/memory/security_constitution.md)"
} else {
    Warn "Security constitution not found (.specify/memory/security_constitution.md)" `
         "Optional but recommended when using governed-plan or security-review."
}

# ─── 2. Spec Kit Structure ────────────────────────────────────────────────────
Section "2. Spec Kit Structure"

if (Test-Path (Join-Path $root "specs") -PathType Container) {
    Pass "specs/ directory found"
    $specCount = (Get-ChildItem (Join-Path $root "specs") -Directory -ErrorAction SilentlyContinue | Measure-Object).Count
    if ($specCount -gt 0) {
        Pass "Found $specCount feature spec director$(if ($specCount -eq 1) {'y'} else {'ies'}) in specs/"
    } else {
        Warn "specs/ is empty - no feature directories found yet"
    }
} else {
    Warn "No specs/ directory - Architecture Guard expects Spec Kit workflow directories here"
}

if (Test-Path (Join-Path $root ".specify") -PathType Container) {
    Pass ".specify/ directory found"
} else {
    Fail ".specify/ directory missing - run 'specify init' to bootstrap Spec Kit"
}

# ─── 3. Optional Extension: flash-mem ───────────────────────────────────────
Section "3. Optional Extension: flash-mem"

$memoryFound = $false
$extensionsYml = Join-Path $root ".specify/extensions.yml"
if (Test-Path $extensionsYml) {
    $ymlContent = Get-Content $extensionsYml -Raw
    if ($ymlContent -match 'memory-md') {
    Pass "flash-mem extension declared in .specify/extensions.yml"
        $memoryFound = $true
    }
}
if (-not $memoryFound -and (Test-Path (Join-Path $root ".specify/extensions/memory-md") -PathType Container)) {
    Pass "flash-mem extension directory found (.specify/extensions/memory-md)"
    $memoryFound = $true
}
if (-not $memoryFound) {
    Warn "flash-mem not installed - governed workflows will skip memory synthesis" `
         "Install with: specify integration add memory-md"
}

if ($memoryFound) {
    $configPath = Join-Path $root ".specify/extensions/memory-md/config.yml"
    if (Test-Path $configPath) {
        Pass "flash-mem config found (.specify/extensions/memory-md/config.yml)"
        $configContent = Get-Content $configPath -Raw
        if ($configContent -match 'enabled:\s*true') {
            Pass "flash-mem optimizer is enabled - SQLite acceleration active"
        } else {
            Warn "flash-mem optimizer is disabled - running in markdown-only mode (higher token usage)" `
                 "Set 'optimizer.enabled: true' in config.yml to enable SQLite acceleration"
        }
    } else {
        Warn "flash-mem config not found - using defaults (markdown-only, no optimizer)"
    }

    $indexPath = Join-Path $root "docs/memory/INDEX.md"
    if (Test-Path $indexPath) {
        $entryCount = (Select-String -Path $indexPath -Pattern "^\|" | Measure-Object).Count
        Pass "docs/memory/INDEX.md found ($entryCount table row(s))"
    } else {
        Warn "docs/memory/INDEX.md not found" `
             "Run the memory initialization alias to initialize memory files"
    }
}

# ─── 4. Optional Extension: Security Review ──────────────────────────────────
Section "4. Optional Extension: Security Review"

$securityFound = $false
if (Test-Path $extensionsYml) {
    $ymlContent = Get-Content $extensionsYml -Raw -ErrorAction SilentlyContinue
    if ($ymlContent -match 'security-review') { $securityFound = $true }
}
if (-not $securityFound -and (Test-Path (Join-Path $root ".specify/extensions/security-review") -PathType Container)) {
    $securityFound = $true
}

if ($securityFound) {
    Pass "security-review extension found - governed-plan will include security validation"
} else {
    Warn "Security Review not installed - governed workflows will skip security boundary checks" `
         "Install with: specify integration add security-review"
}

# ─── 5. Source Structure ─────────────────────────────────────────────────────
Section "5. Source Structure"

$sourceFound = $false
foreach ($dir in @("src","app","modules","lib")) {
    if (Test-Path (Join-Path $root $dir) -PathType Container) {
        Pass "Source directory found: $dir/"
        $sourceFound = $true
        break
    }
}
if (-not $sourceFound) {
    Warn "No standard source directory found (src/, app/, modules/, lib/)" `
         "Ensure your architecture_constitution.md defines custom boundaries explicitly"
}

# ─── 6. Execution Model ──────────────────────────────────────────────────────
Section "6. Execution Model"

Write-Host "  " -NoNewline
Write-Host "i" -ForegroundColor Cyan -NoNewline
Write-Host "  Architecture Guard is a prompt governance layer."
Write-Host "     Validation quality depends on the AI agent following the command instructions."
Write-Host "     It does not perform static analysis or AST inspection."
Write-Host "     For stronger guarantees, pair it with SonarLint or a dedicated linter."

# ─── Summary ─────────────────────────────────────────────────────────────────
Write-Host "`n" + ("─" * 54) -ForegroundColor White
if ($errors -gt 0) {
    Write-Host "  X $errors error(s) found - fix before running governed workflows" -ForegroundColor Red
}
if ($warnings -gt 0) {
    Write-Host "  ! $warnings warning(s) - optional but recommended to address" -ForegroundColor Yellow
}
if ($errors -eq 0 -and $warnings -eq 0) {
    Write-Host "  √ All checks passed - Architecture Guard is ready" -ForegroundColor Green
} elseif ($errors -eq 0) {
    Write-Host "  √ No blocking errors - Architecture Guard can run" -ForegroundColor Green
}

exit $errors

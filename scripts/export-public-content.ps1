$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$outputRoot = Join-Path $repoRoot "quartz\content"

$excludeDirs = @(
  ".git",
  ".github",
  ".obsidian",
  ".smart-env",
  "notebooklm-py",
  "quartz",
  "scripts",
  "node_modules",
  "public",
  "content",
  "repo-meta"
)

$excludeFiles = @(
  ".gitignore",
  ".git.broken",
  "package.json",
  "package-lock.json"
)

New-Item -ItemType Directory -Force -Path $outputRoot | Out-Null

$null = & robocopy $repoRoot $outputRoot /MIR /R:1 /W:1 /NFL /NDL /NJH /NJS /NP /XD $excludeDirs /XF $excludeFiles

if ($LASTEXITCODE -gt 7) {
  throw "robocopy failed with exit code $LASTEXITCODE"
}

Get-ChildItem -Path $outputRoot -File -Recurse |
  Where-Object { $_.Name -like "*Codex*" -or $_.Name -like "*NotebookLM*" } |
  Remove-Item -Force

Write-Host "Exported public content to $outputRoot"

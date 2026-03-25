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

if (Test-Path -LiteralPath $outputRoot) {
  Get-ChildItem -LiteralPath $outputRoot -Force | Remove-Item -Recurse -Force
} else {
  New-Item -ItemType Directory -Force -Path $outputRoot | Out-Null
}

$repoRootWithSeparator = $repoRoot.TrimEnd("\", "/") + [System.IO.Path]::DirectorySeparatorChar

$filesToCopy = Get-ChildItem -Path $repoRoot -Recurse -File | Where-Object {
  $relativePath = $_.FullName.Substring($repoRootWithSeparator.Length)
  $segments = $relativePath -split "[/\\]"

  if ($_.FullName.StartsWith($outputRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    return $false
  }

  if ($segments | Where-Object { $excludeDirs -contains $_ }) {
    return $false
  }

  if ($excludeFiles -contains $_.Name) {
    return $false
  }

  if ($_.Name -like "*Codex*" -or $_.Name -like "*NotebookLM*") {
    return $false
  }

  return $true
}

foreach ($file in $filesToCopy) {
  $relativePath = $file.FullName.Substring($repoRootWithSeparator.Length)
  $destinationPath = Join-Path $outputRoot $relativePath
  $destinationDir = Split-Path -Parent $destinationPath

  New-Item -ItemType Directory -Force -Path $destinationDir | Out-Null
  Copy-Item -LiteralPath $file.FullName -Destination $destinationPath -Force
}

Write-Host "Exported public content to $outputRoot"

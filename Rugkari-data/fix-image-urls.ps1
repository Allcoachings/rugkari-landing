# =============================================================================
# Fix fake CDN image URLs across all HTML pages using real URLs from the
# Shopify product CSV export.
# =============================================================================

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$csvPath     = Join-Path $PSScriptRoot 'all_products_rugkari.com.csv'
$utf8NoBom   = New-Object System.Text.UTF8Encoding($false)

if (-not (Test-Path $csvPath)) { throw "CSV not found: $csvPath" }
$csv = Import-Csv $csvPath

# Build map: short-slug (e.g. "elysian-abstract") -> ordered list of image URLs
$imageMap = @{}
$titleMap = @{}
foreach ($row in $csv) {
  if (-not $row.Handle) { continue }
  $handle = $row.Handle.Trim()
  $shortSlug = $handle -replace '-pure-new-zealand-wool-rug',''
  if (-not $titleMap.ContainsKey($shortSlug) -and $row.Title) {
    $titleMap[$shortSlug] = $row.Title
  }
  if ($row.'Image Src') {
    if (-not $imageMap.ContainsKey($shortSlug)) { $imageMap[$shortSlug] = @() }
    if ($imageMap[$shortSlug] -notcontains $row.'Image Src') {
      $imageMap[$shortSlug] += $row.'Image Src'
    }
  }
}

Write-Output ("Loaded " + $imageMap.Count + " products from CSV with images.")
Write-Output ""

# Gather every HTML/XML file under project
$htmlFiles = @()
$htmlFiles += Get-ChildItem "$projectRoot\*.html"
$htmlFiles += Get-ChildItem "$projectRoot\*.xml"
$htmlFiles += Get-ChildItem "$projectRoot\blog\*.html"
$htmlFiles += Get-ChildItem "$projectRoot\collections\*.html"
$htmlFiles += Get-ChildItem "$projectRoot\products\*.html"

# For each fake URL pattern, replace globally with real URL (preserving index N)
# Pattern: https://rugkari.com/cdn/shop/files/<shortSlug>-<N>.jpg
$totalReplacements = 0

foreach ($f in $htmlFiles) {
  $text = [System.IO.File]::ReadAllText($f.FullName, $utf8NoBom)
  $original = $text
  $fileChanges = 0

  foreach ($shortSlug in $imageMap.Keys) {
    $images = $imageMap[$shortSlug]
    if (-not $images -or $images.Count -eq 0) { continue }

    # Match all fake URLs like https://rugkari.com/cdn/shop/files/<shortSlug>-N.<ext>
    $pattern = 'https://rugkari\.com/cdn/shop/files/' + [regex]::Escape($shortSlug) + '-(\d+)\.(jpg|jpeg|png|webp)(?:\?[^"'']*)?'

    $matches = [regex]::Matches($text, $pattern)
    foreach ($m in $matches) {
      $idx = ([int]$m.Groups[1].Value) - 1   # 1-based -> 0-based
      if ($idx -lt 0) { $idx = 0 }
      if ($idx -ge $images.Count) { $idx = ($images.Count - 1) }
      $replacement = $images[$idx]
      $text = $text.Replace($m.Value, $replacement)
      $fileChanges++
    }
  }

  if ($text -ne $original) {
    [System.IO.File]::WriteAllText($f.FullName, $text, $utf8NoBom)
    Write-Output ("  updated: " + $f.Name + " :: " + $fileChanges + " URLs swapped")
    $totalReplacements += $fileChanges
  }
}

Write-Output ""
Write-Output ("Total replacements: " + $totalReplacements)

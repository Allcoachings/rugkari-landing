# =============================================================================
# Replace all external rugkari.com footer/policy links with local pages.
# Idempotent.
# =============================================================================

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$utf8NoBom   = New-Object System.Text.UTF8Encoding($false)

# Map: external URL pattern -> local URL
$linkMap = @{
  'https://rugkari.com/pages/contact?vid=suvals'           = '/pages/contact.html'
  'https://rugkari.com/pages/contact'                      = '/pages/contact.html'
  'https://rugkari.com/pages/the-founder?vid=suvals'       = '/pages/the-founder.html'
  'https://rugkari.com/pages/the-founder'                  = '/pages/the-founder.html'
  'https://rugkari.com/pages/the-carpet-city?vid=suvals'   = '/pages/the-carpet-city.html'
  'https://rugkari.com/pages/the-carpet-city'              = '/pages/the-carpet-city.html'
  'https://rugkari.com/pages/the-art?vid=suvals'           = '/pages/the-art.html'
  'https://rugkari.com/pages/the-art'                      = '/pages/the-art.html'
  'https://rugkari.com/pages/stain-repellent?vid=suvals'   = '/pages/stain-repellent.html'
  'https://rugkari.com/pages/stain-repellent'              = '/pages/stain-repellent.html'
  'https://rugkari.com/pages/rug-warranty?vid=suvals'      = '/pages/rug-warranty.html'
  'https://rugkari.com/pages/rug-warranty'                 = '/pages/rug-warranty.html'
  'https://rugkari.com/pages/track-your-order?vid=suvals'  = '/pages/track-your-order.html'
  'https://rugkari.com/pages/track-your-order'             = '/pages/track-your-order.html'
  'https://rugkari.com/policies/privacy-policy?vid=suvals' = '/pages/privacy-policy.html'
  'https://rugkari.com/policies/privacy-policy'            = '/pages/privacy-policy.html'
  'https://rugkari.com/policies/refund-policy?vid=suvals'  = '/pages/refund-policy.html'
  'https://rugkari.com/policies/refund-policy'             = '/pages/refund-policy.html'
  'https://rugkari.com/policies/terms-of-service?vid=suvals' = '/pages/terms-of-service.html'
  'https://rugkari.com/policies/terms-of-service'          = '/pages/terms-of-service.html'
  'https://rugkari.com/policies/shipping-policy?vid=suvals' = '/pages/shipping-policy.html'
  'https://rugkari.com/policies/shipping-policy'           = '/pages/shipping-policy.html'
  'https://rugkari.com/policies/contact-information?vid=suvals' = '/pages/contact.html'
  'https://rugkari.com/policies/contact-information'       = '/pages/contact.html'
}

# Order keys longest-first to avoid prefix-replacement collisions (vid=suvals
# variants must be replaced before plain ones).
$orderedKeys = $linkMap.Keys | Sort-Object -Property Length -Descending

# Gather all HTML files
$files = @()
$files += Get-ChildItem "$projectRoot\*.html"
$files += Get-ChildItem "$projectRoot\blog\*.html"
$files += Get-ChildItem "$projectRoot\collections\*.html"
$files += Get-ChildItem "$projectRoot\products\*.html"
$files += Get-ChildItem "$projectRoot\pages\*.html"

Write-Output ("Scanning " + $files.Count + " HTML files...")

$totalReplacements = 0
$filesChanged = 0

foreach ($f in $files) {
  $text = [System.IO.File]::ReadAllText($f.FullName, $utf8NoBom)
  $original = $text
  $changes = 0

  foreach ($k in $orderedKeys) {
    # Match only when used inside href attribute or text reference
    # Simple .Replace handles all occurrences
    while ($text.Contains($k)) {
      $idx = $text.IndexOf($k)
      $text = $text.Substring(0, $idx) + $linkMap[$k] + $text.Substring($idx + $k.Length)
      $changes++
    }
  }

  if ($text -ne $original) {
    [System.IO.File]::WriteAllText($f.FullName, $text, $utf8NoBom)
    $filesChanged++
    $totalReplacements += $changes
  }
}

Write-Output ("Files changed: " + $filesChanged)
Write-Output ("Total replacements: " + $totalReplacements)

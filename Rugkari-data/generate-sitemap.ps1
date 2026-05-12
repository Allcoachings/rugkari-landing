# =============================================================================
# Production sitemap generator for rugs.rugkari.com.
# Builds sitemap.xml from CSV (products) + static page list.
# Uses real file mtime for <lastmod> so Google sees genuine freshness signals.
# =============================================================================

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$csvPath     = Join-Path $PSScriptRoot 'all_products_rugkari.com.csv'
$outPath     = Join-Path $projectRoot 'sitemap.xml'
$utf8NoBom   = New-Object System.Text.UTF8Encoding($false)
$today       = Get-Date -Format 'yyyy-MM-dd'
$base        = 'https://rugs.rugkari.com'
$EN          = [char]0x2013   # en-dash

function Get-Lastmod([string]$relPath) {
  # Real file mtime if the page exists; fall back to today.
  $full = Join-Path $projectRoot ($relPath -replace '/','\')
  if (Test-Path $full -PathType Leaf) { return (Get-Item $full).LastWriteTime.ToString('yyyy-MM-dd') }
  return $today
}

function Xml-Escape([string]$s) {
  if (-not $s) { return '' }
  return ($s -replace '&','&amp;' -replace '<','&lt;' -replace '>','&gt;' -replace '"','&quot;' -replace "'",'&apos;')
}

# Parse CSV: get first image per handle and title
$csv = Import-Csv $csvPath
$prodMap = @{}
foreach ($r in $csv) {
  $h = $r.Handle.Trim()
  if (-not $h) { continue }
  if (-not $prodMap.ContainsKey($h)) {
    $prodMap[$h] = @{ title=''; image='' }
  }
  if (-not $prodMap[$h].title  -and $r.Title)      { $prodMap[$h].title  = $r.Title.Trim() }
  if (-not $prodMap[$h].image  -and $r.'Image Src') { $prodMap[$h].image = $r.'Image Src'.Trim() }
}

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('<?xml version="1.0" encoding="UTF-8"?>')
[void]$sb.AppendLine('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"')
[void]$sb.AppendLine('        xmlns:xhtml="http://www.w3.org/1999/xhtml">')
[void]$sb.AppendLine('')

function Add-Url($locPath, $priority, $changefreq, $imgUrl, $imgTitle, $imgCaption) {
  $loc = if ($locPath.StartsWith('http')) { $locPath } else { $base + $locPath }
  # Pick a sensible lastmod source path
  $relForMtime = if ($locPath -eq '/') { 'index.html' } else { $locPath.TrimStart('/') }
  $lm = Get-Lastmod $relForMtime
  [void]$sb.AppendLine('  <url>')
  [void]$sb.AppendLine('    <loc>' + (Xml-Escape $loc) + '</loc>')
  [void]$sb.AppendLine('    <lastmod>' + $lm + '</lastmod>')
  [void]$sb.AppendLine('    <changefreq>' + $changefreq + '</changefreq>')
  [void]$sb.AppendLine('    <priority>' + $priority + '</priority>')
  [void]$sb.AppendLine('    <xhtml:link rel="alternate" hreflang="en-IN" href="' + (Xml-Escape $loc) + '" />')
  [void]$sb.AppendLine('    <xhtml:link rel="alternate" hreflang="x-default" href="' + (Xml-Escape $loc) + '" />')
  # Google deprecated the image sitemap extension (sitemap-image/0.9) — images are
  # now discovered via HTML crawling, so we emit no <image:*> tags. $imgUrl and the
  # remaining image parameters are intentionally unused.
  [void]$sb.AppendLine('  </url>')
  [void]$sb.AppendLine('')
}

# Homepage
[void]$sb.AppendLine('  <!-- Homepage -->')
Add-Url '/' '1.0' 'weekly' 'https://rugs.rugkari.com/assets/RUGKARI-LOGO.webp' "Rugkari $EN The Rug Guide" 'Handcrafted pure New Zealand wool rugs from Bhadohi, India'

# Brand / About
[void]$sb.AppendLine('  <!-- Brand / About -->')
Add-Url '/heritage' '0.9' 'monthly' '' '' ''
Add-Url '/rug-care' '0.9' 'monthly' '' '' ''

# Collections
[void]$sb.AppendLine('  <!-- Collections -->')
Add-Url '/collections/abstract-rugs.html'    '0.9' 'weekly' 'https://rugkari.com/cdn/shop/collections/7_91faef0e-6131-4c60-b908-ee6d896b3ba8.jpg' 'Abstract Rugs Collection' 'Premium abstract pure New Zealand wool rugs, hand-tufted in Bhadohi'
Add-Url '/collections/floral-rugs.html'      '0.9' 'weekly' 'https://rugkari.com/cdn/shop/collections/ry.jpg' 'Floral Rugs Collection' 'Vintage floral hand-tufted pure wool rugs for Indian homes'
Add-Url '/collections/hand-knotted-rugs.html' '0.9' 'weekly' 'https://cdn.shopify.com/s/files/1/0659/8649/4558/files/1_12805eb4-fa71-41d5-87fc-285d8ead17a6.jpg?v=1777702789' 'Hand-Knotted Rugs Collection' 'Heirloom hand-knotted traditional wool rugs from Bhadohi'
Add-Url '/collections/hand-tufted-rugs.html'  '0.9' 'weekly' 'https://cdn.shopify.com/s/files/1/0659/8649/4558/files/5_9ce644f2-a560-4fa7-97b3-243df12f5f26.jpg?v=1777702689' 'Hand-Tufted Rugs Collection' 'Hand-tufted 20mm pile pure New Zealand wool rugs by Rugkari'

# Footer / Utility pages
[void]$sb.AppendLine('  <!-- Footer / Utility pages -->')
$footerPages = @(
  @{ slug='contact';          priority='0.8'; cf='monthly' }
  @{ slug='the-founder';      priority='0.7'; cf='yearly'  }
  @{ slug='the-carpet-city';  priority='0.7'; cf='yearly'  }
  @{ slug='the-art';          priority='0.7'; cf='yearly'  }
  @{ slug='stain-repellent';  priority='0.6'; cf='yearly'  }
  @{ slug='rug-warranty';     priority='0.6'; cf='yearly'  }
  @{ slug='track-your-order'; priority='0.6'; cf='monthly' }
  @{ slug='shipping-policy';  priority='0.5'; cf='yearly'  }
  @{ slug='refund-policy';    priority='0.5'; cf='yearly'  }
  @{ slug='terms-of-service'; priority='0.4'; cf='yearly'  }
  @{ slug='privacy-policy';   priority='0.4'; cf='yearly'  }
)
foreach ($fp in $footerPages) {
  Add-Url ('/pages/' + $fp.slug + '.html') $fp.priority $fp.cf '' '' ''
}

# Blog Articles
[void]$sb.AppendLine('  <!-- Blog Articles (cornerstone editorial) -->')
$blogs = @(
  @{ slug='best-hand-tufted-rugs-for-living-room';        title='8 Best Hand-Tufted Rugs for Living Rooms';  cap='Editor-curated best hand-tufted rugs for Indian living rooms (2026)' }
  @{ slug='hand-tufted-vs-machine-made-rugs';             title='Hand-Tufted vs Machine-Made Rugs';          cap='Definitive comparison of manufacturing, durability, and lifetime cost' }
  @{ slug='how-to-remove-coffee-stains-from-wool-rugs';   title='How to Remove Coffee Stains from Wool Rugs'; cap='Safe 5-step method for removing coffee stains from pure wool' }
  @{ slug='how-to-choose-rug-size-for-living-room-india'; title='How to Choose Rug Size for Living Room';     cap='India-specific rug sizing for 3-seater, 5-seater, and L-shape layouts' }
  @{ slug='hand-knotted-vs-hand-tufted-rugs-difference';  title='Hand-Knotted vs Hand-Tufted Rugs';           cap='Construction, durability, and price comparison' }
  @{ slug='best-rugs-for-bedroom-india-guide';            title='Best Rugs for Bedroom India';                cap='Bedroom rug sizing, materials and placement guide' }
  @{ slug='how-to-care-for-pure-new-zealand-wool-rugs';   title='How to Care for Pure New Zealand Wool Rugs'; cap='Complete wool rug care, vacuum, rotation, stains' }
  @{ slug='custom-rugs-india-everything-to-know';         title='Custom Rugs in India';                       cap='Custom rug sizing, design, and lead-time guide' }
)
foreach ($b in $blogs) {
  Add-Url ('/blog/' + $b.slug + '.html') '0.9' 'monthly' '' $b.title $b.cap
}

# Product Pages
[void]$sb.AppendLine('  <!-- Product Pages (' + $prodMap.Count + ' total) -->')
foreach ($h in ($prodMap.Keys | Sort-Object)) {
  $p = $prodMap[$h]
  if (-not $p.title) { continue }
  $caption = $p.title + " $EN pure New Zealand wool rug, hand-crafted in Bhadohi by Rugkari"
  Add-Url ('/products/' + $h + '.html') '0.8' 'weekly' $p.image $p.title $caption
}

[void]$sb.AppendLine('</urlset>')

[System.IO.File]::WriteAllText($outPath, $sb.ToString(), $utf8NoBom)

$urlCount = ([regex]::Matches($sb.ToString(), '<url>')).Count
Write-Output ('Sitemap written: ' + $outPath)
Write-Output ('Total URLs: ' + $urlCount + ' (' + $prodMap.Count + ' products + 4 collections + 8 blog + ' + $footerPages.Count + ' utility + 3 brand/home)')

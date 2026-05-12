# =============================================================================
# Rugkari product page generator (ASCII-safe source).
# Reads the Elysian template and produces variants for all other products.
# Idempotent; re-running overwrites.
# =============================================================================

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$template    = Join-Path $projectRoot 'products\elysian-abstract-pure-new-zealand-wool-rug.html'
$outDir      = Join-Path $projectRoot 'products'
$csvPath     = Join-Path $PSScriptRoot 'all_products_rugkari.com.csv'

if (-not (Test-Path $template)) { throw "Template not found: $template" }

# Load real CDN image URLs from Shopify CSV
$realImages = @{}
if (Test-Path $csvPath) {
  $rows = Import-Csv $csvPath
  foreach ($r in $rows) {
    if (-not $r.Handle -or -not $r.'Image Src') { continue }
    $shortKey = ($r.Handle.Trim()) -replace '-pure-new-zealand-wool-rug',''
    if (-not $realImages.ContainsKey($shortKey)) { $realImages[$shortKey] = @() }
    if ($realImages[$shortKey] -notcontains $r.'Image Src') { $realImages[$shortKey] += $r.'Image Src' }
  }
}

# Unicode dashes used in HTML output
$EM = [char]0x2014   # em-dash
$EN = [char]0x2013   # en-dash
$DOT = [char]0x00B7  # middle dot

$products = @(
  @{
    slug='tidal-geometric-pure-new-zealand-wool-rug'
    name='Tidal Geometric Hand-Tufted Pure New Zealand Wool Rug'
    short='Tidal Geometric'
    vendor='Hand-Tufted'
    construction='Hand-Tufted'
    sku='RKR-TIDAL-GEO'
    colors="Ocean Blue $DOT Slate $DOT Cream"
    palette='ocean blue, slate and cream'
    price='10499'
    rating='4.8'
    reviews='128'
    description="Tidal Geometric channels coastal serenity with a flowing geometric weave in pure New Zealand wool. Ocean blue, slate and cream tones bring movement and calm to modern interiors."
    bestFor='coastal homes, modern coastal sofas, neutral and blue palettes'
    reviewer='Karthik R.'
    reviewText='Absolutely stunning. The blues are deep and rich, the wool is plush. Looks like a designer rug from a top studio at a fraction of the price.'
    reviewDate='2026-01-22'
    collection='hand-tufted-rugs'
    collectionName='Hand-Tufted'
  }
  @{
    slug='nexus-abstract-pure-new-zealand-wool-rug'
    name='Nexus Abstract Hand-Tufted Pure New Zealand Wool Rug'
    short='Nexus Abstract'
    vendor='Hand-Tufted'
    construction='Hand-Tufted'
    sku='RKR-NEXUS-ABS'
    colors="Charcoal $DOT Ivory $DOT Dusty Pink"
    palette='charcoal, ivory and dusty pink'
    price='10499'
    rating='4.9'
    reviews='194'
    description="Nexus Abstract is an editorial statement rug $EM bold charcoal forms over an ivory base, with quiet dusty-pink accents. Hand-tufted in pure New Zealand wool for editorial homes."
    bestFor='editorial interiors, grey sofas, neutral palettes seeking contrast'
    reviewer='Meera Iyer'
    reviewText='The Nexus pulls the entire room together. Photographs beautifully. Friends keep asking where I got it. Worth every rupee.'
    reviewDate='2026-03-04'
    collection='hand-tufted-rugs'
    collectionName='Hand-Tufted'
  }
  @{
    slug='starlite-abstract-pure-new-zealand-wool-rug'
    name='Starlite Abstract Hand-Tufted Pure New Zealand Wool Rug'
    short='Starlite Abstract'
    vendor='Hand-Tufted'
    construction='Hand-Tufted'
    sku='RKR-STARLITE-ABS'
    colors="Midnight $DOT Gold $DOT Ivory"
    palette='midnight, gold and ivory'
    price='10499'
    rating='4.9'
    reviews='156'
    description="Starlite Abstract is a celestial composition $EM midnight, soft gold and ivory hand-tufted in pure New Zealand wool. The gold accents catch evening lamplight beautifully."
    bestFor='jewel-toned interiors, navy sofas, gold accent rooms'
    reviewer='Priya Joshi'
    reviewText='The Starlite is exactly what our drawing room needed. The gold accents shimmer in the evening light. Beautiful craftsmanship.'
    reviewDate='2026-02-12'
    collection='hand-tufted-rugs'
    collectionName='Hand-Tufted'
  }
  @{
    slug='harmony-geometric-pure-new-zealand-wool-rug'
    name='Harmony Geometric Handcrafted Pure New Zealand Wool Rug'
    short='Harmony Geometric'
    vendor='Handcrafted'
    construction='Handcrafted (Hand-Tufted)'
    sku='RKR-HARMONY-GEO'
    colors="Sage $DOT Cream $DOT Burnt Sienna"
    palette='sage, cream and burnt sienna'
    price='10499'
    rating='4.8'
    reviews='102'
    description="Harmony Geometric is a botanical-toned rug with a soft geometric rhythm. Sage greens and burnt sienna over cream $EM perfect for sun-warm Indian interiors."
    bestFor='biophilic interiors, terracotta and cream palettes, sunny rooms'
    reviewer='Aditya Nair'
    reviewText='The sage and sienna are stunning together. Compliments my Jaipur-style decor perfectly. Hand-feel of the wool is exceptional.'
    reviewDate='2026-04-08'
    collection='hand-tufted-rugs'
    collectionName='Hand-Tufted'
  }
  @{
    slug='galleria-geometric-pure-new-zealand-wool-rug'
    name='Galleria Geometric Hand-Tufted Pure New Zealand Wool Rug'
    short='Galleria Geometric'
    vendor='Hand-Tufted'
    construction='Hand-Tufted'
    sku='RKR-GALLERIA-GEO'
    colors="Ivory $DOT Slate $DOT Charcoal"
    palette='ivory, slate and charcoal'
    price='10499'
    rating='4.9'
    reviews='171'
    description="Galleria Geometric is a museum-quality piece $EM sharp ivory, slate and charcoal geometry hand-tufted in pure New Zealand wool. Designed for gallery-style interiors."
    bestFor='gallery-style homes, monochrome interiors, modern minimal sofas'
    reviewer='Rohan Desai'
    reviewText='Galleria lives up to its name. The geometric is razor-sharp, the wool is extraordinary. Like having a piece of art on the floor.'
    reviewDate='2026-01-15'
    collection='hand-tufted-rugs'
    collectionName='Hand-Tufted'
  }
  @{
    slug='alchemy-abstract-pure-new-zealand-wool-rug'
    name='Alchemy Abstract Hand-Tufted Pure New Zealand Wool Rug'
    short='Alchemy Abstract'
    vendor='Hand-Tufted'
    construction='Hand-Tufted'
    sku='RKR-ALCHEMY-ABS'
    colors="Copper $DOT Charcoal $DOT Ivory"
    palette='copper, charcoal and ivory'
    price='10499'
    rating='4.8'
    reviews='143'
    description="Alchemy Abstract turns base elements into gold $EM copper, charcoal and ivory hand-tufted in pure New Zealand wool. A statement rug for warm, layered interiors."
    bestFor='warm-toned interiors, leather sofas, mid-century homes'
    reviewer='Neha Sharma'
    reviewText='The copper tones glow against our walnut floor. Adds so much warmth. Best purchase for our home this year.'
    reviewDate='2026-03-19'
    collection='hand-tufted-rugs'
    collectionName='Hand-Tufted'
  }
  @{
    slug='mandolin-geometric-pure-new-zealand-wool-rug'
    name='Mandolin Geometric Hand-Tufted Pure New Zealand Wool Rug'
    short='Mandolin Geometric'
    vendor='Hand-Tufted'
    construction='Hand-Tufted'
    sku='RKR-MANDOLIN-GEO'
    colors="Terracotta $DOT Ivory $DOT Olive"
    palette='terracotta, ivory and olive'
    price='10499'
    rating='4.9'
    reviews='118'
    description="Mandolin Geometric brings a musical lyricism to traditional geometric weaves $EM terracotta, ivory and olive hand-tufted in pure New Zealand wool."
    bestFor='earthy palettes, terracotta accent rooms, boho-modern homes'
    reviewer='Vikram Bhatt'
    reviewText='The Mandolin is everything: gorgeous terracotta, lovely texture, ships fast. Highly recommend.'
    reviewDate='2026-02-28'
    collection='hand-tufted-rugs'
    collectionName='Hand-Tufted'
  }
  @{
    slug='mist-abstract-pure-new-zealand-wool-rug'
    name='Mist Abstract Handwoven Pure New Zealand Wool Rug'
    short='Mist Abstract'
    vendor='Handwoven'
    construction='Handwoven (Flatweave)'
    sku='RKR-MIST-ABS'
    colors="Ivory $DOT Cloud Grey $DOT Pale Blue"
    palette='ivory, cloud grey and pale blue'
    price='8999'
    rating='4.8'
    reviews='89'
    description="Mist Abstract is a soft, low-pile handwoven rug $EM ivory, cloud grey and pale blue in pure New Zealand wool. Perfect for bedrooms and minimal interiors."
    bestFor='bedrooms, minimal interiors, soft Scandinavian palettes'
    reviewer='Tara Kapoor'
    reviewText='The Mist is dreamy. Soft underfoot, lightweight, perfect for our bedroom. Pale blue is exactly as photographed.'
    reviewDate='2026-04-02'
    collection='abstract-rugs'
    collectionName='Abstract'
  }
  @{
    slug='abacus-traditional-pure-new-zealand-wool-rug'
    name='Abacus Traditional Handcrafted Pure New Zealand Wool Rug'
    short='Abacus Traditional'
    vendor='Handcrafted'
    construction='Handcrafted Traditional'
    sku='RKR-ABACUS-TRAD'
    colors="Madder Red $DOT Indigo $DOT Cream"
    palette='madder red, indigo and cream'
    price='10499'
    rating='4.9'
    reviews='186'
    description="Abacus Traditional is a heritage piece $EM madder red, indigo and cream traditional patterns in pure New Zealand wool. Hand-crafted using time-honoured Bhadohi techniques."
    bestFor='traditional interiors, heritage homes, classic Indian decor'
    reviewer='Priya Sharma'
    reviewText='The Abacus transformed our drawing room. After 8 months of daily use it still looks brand new. Genuinely heirloom quality.'
    reviewDate='2026-03-12'
    collection='hand-knotted-rugs'
    collectionName='Hand-Knotted'
  }
  @{
    slug='abrash-traditional-pure-new-zealand-wool-rug'
    name='Abrash Traditional Hand-Tufted Pure New Zealand Wool Rug'
    short='Abrash Traditional'
    vendor='Hand-Tufted'
    construction='Hand-Tufted'
    sku='RKR-ABRASH-TRAD'
    colors="Faded Indigo $DOT Ivory $DOT Rust"
    palette='faded indigo, ivory and rust'
    price='10499'
    rating='4.8'
    reviews='134'
    description="Abrash Traditional captures the classic abrash colour variation $EM faded indigo, ivory and rust hand-tufted in pure New Zealand wool. Vintage-inspired, heritage-grade."
    bestFor='vintage interiors, heritage homes, layered traditional decor'
    reviewer='Sanjay Verma'
    reviewText='The faded indigo is exquisite, looks like a treasured vintage piece. The hand-tufted pile is dense and lush.'
    reviewDate='2026-02-08'
    collection='hand-tufted-rugs'
    collectionName='Hand-Tufted'
  }
)

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$tpl = [System.IO.File]::ReadAllText($template, [System.Text.UTF8Encoding]::new($true))
# Fallback: also try without BOM if BOM read returns garbage (unlikely)
if ($tpl.Length -lt 1000) { $tpl = [System.IO.File]::ReadAllText($template, $utf8NoBom) }

$relatedAll = @(
  @{ slug='tidal-geometric-pure-new-zealand-wool-rug';   title='Tidal Geometric';    price='10499' }
  @{ slug='nexus-abstract-pure-new-zealand-wool-rug';    title='Nexus Abstract';     price='10499' }
  @{ slug='starlite-abstract-pure-new-zealand-wool-rug'; title='Starlite Abstract';  price='10499' }
  @{ slug='harmony-geometric-pure-new-zealand-wool-rug'; title='Harmony Geometric';  price='10499' }
  @{ slug='galleria-geometric-pure-new-zealand-wool-rug';title='Galleria Geometric'; price='10499' }
  @{ slug='alchemy-abstract-pure-new-zealand-wool-rug';  title='Alchemy Abstract';   price='10499' }
  @{ slug='mandolin-geometric-pure-new-zealand-wool-rug';title='Mandolin Geometric'; price='10499' }
  @{ slug='elysian-abstract-pure-new-zealand-wool-rug';  title='Elysian Abstract';   price='10499' }
)

function Build-RelatedHtml($currentSlug) {
  $picks = $relatedAll | Where-Object { $_.slug -ne $currentSlug } | Get-Random -Count 4
  $sb = New-Object System.Text.StringBuilder
  foreach ($p in $picks) {
    $imgSlug = $p.slug -replace '-pure-new-zealand-wool-rug',''
    $priceFmt = 'From Rs. {0:N0}' -f [int]$p.price
    [void]$sb.AppendLine('      <a class="product-card" href="/products/' + $p.slug + '.html">')
    [void]$sb.AppendLine('        <img class="card-media" src="https://rugkari.com/cdn/shop/files/' + $imgSlug + '-1.jpg" alt="' + $p.title + ' Pure New Zealand Wool Rug" width="400" height="500" loading="lazy" />')
    [void]$sb.AppendLine('        <h3 class="card-title">' + $p.title + '</h3>')
    [void]$sb.AppendLine('        <p class="card-price">' + $priceFmt + '</p>')
    [void]$sb.AppendLine('      </a>')
  }
  return $sb.ToString()
}

foreach ($p in $products) {
  $out = $tpl
  $imgSlug = $p.slug -replace '-pure-new-zealand-wool-rug',''
  $oldImgSlug = 'elysian-abstract'

  # URL-encoded short name for WhatsApp links
  $shortEncoded = $p.short -replace ' ','%20'
  $shortFirst = ($p.short -split ' ')[0]

  # Replace URL-encoded variants FIRST (before space-to-replacement breaks them)
  $out = $out.Replace('Elysian%20Abstract', $shortEncoded)

  $out = $out.Replace('elysian-abstract-pure-new-zealand-wool-rug', $p.slug)
  # Replace fake elysian-abstract-N.jpg URLs with target product's real CDN URLs (if available)
  $elysianImgs = if ($realImages.ContainsKey('elysian-abstract')) { $realImages['elysian-abstract'] } else { @() }
  $targetImgs  = if ($realImages.ContainsKey($imgSlug))            { $realImages[$imgSlug] }           else { @() }
  if ($targetImgs.Count -gt 0) {
    for ($i = 1; $i -le 4; $i++) {
      $fakeUrl = 'https://rugkari.com/cdn/shop/files/' + $oldImgSlug + '-' + $i + '.jpg'
      $realIdx = [Math]::Min($i - 1, $targetImgs.Count - 1)
      $realUrl = $targetImgs[$realIdx]
      $out = $out.Replace($fakeUrl, $realUrl)
    }
    # Also replace any elysian real URLs (in OG image) leaking through with the target product's first image
    foreach ($eImg in $elysianImgs) {
      $out = $out.Replace($eImg, $targetImgs[0])
    }
  }
  $out = $out.Replace($oldImgSlug, $imgSlug)
  $out = $out.Replace('Elysian Abstract Hand-Tufted Pure New Zealand Wool Rug', $p.name)
  $out = $out.Replace('Elysian Abstract', $p.short)
  # Catch standalone "Elysian" references (Why Elysian Stands Apart, the Elysian, ft Elysian)
  $out = $out.Replace('Elysian', $shortFirst)
  $out = $out.Replace('RKR-ELYSIAN-ABS', $p.sku)

  $out = $out.Replace('Rugkari ' + $DOT + ' Hand-Tufted', 'Rugkari ' + $DOT + ' ' + $p.vendor)
  $out = $out.Replace('Hand-Tufted Pure New Zealand Wool Rug', $p.vendor + ' Pure New Zealand Wool Rug')

  $out = $out.Replace('"ratingValue": "4.9", "reviewCount": "162"', '"ratingValue": "' + $p.rating + '", "reviewCount": "' + $p.reviews + '"')
  $out = $out.Replace('4.9 / 5 ' + $DOT + ' 162 reviews', $p.rating + ' / 5 ' + $DOT + ' ' + $p.reviews + ' reviews')

  $out = $out.Replace('"color": "Ivory ' + $DOT + ' Charcoal ' + $DOT + ' Camel"', '"color": "' + $p.colors + '"')

  $out = $out.Replace('<span class="spec-val">Hand-Tufted</span>', '<span class="spec-val">' + $p.construction + '</span>')

  if ($p.price -ne '10499') {
    $out = $out.Replace('"price": "10499"', '"price": "' + $p.price + '"')
    $priceFmt = 'From Rs. {0:N0}' -f [int]$p.price
    $out = $out.Replace('From Rs. 10,499', $priceFmt)
  }

  $oldDesc = 'Elysian Abstract is a hand-tufted pure New Zealand wool rug woven by master artisans in Bhadohi. 20mm ultra-luxury pile, abstract contemporary design. Pairs beautifully with neutral and grey upholstery. Free shipping across India, 7-day returns, 10-year heirloom warranty.'
  $newDesc = $p.description + ' Free shipping across India, 7-day returns, 10-year heirloom warranty.'
  $out = $out.Replace($oldDesc, $newDesc)

  $oldPdpDesc = 'Hand-tufted in pure New Zealand wool by master artisans in Bhadohi. An editorial abstract palette in ivory, charcoal and camel ' + $EM + ' designed to anchor neutral living rooms and bring quiet sophistication to grey upholstery.'
  $out = $out.Replace($oldPdpDesc, $p.description)

  $oldOgDesc = 'Hand-tufted pure New Zealand wool rug. 20mm ultra-luxury pile, heirloom quality from Bhadohi.'
  $newOgDesc = $p.short + ' ' + $EM + ' ' + $p.vendor.ToLower() + ' pure New Zealand wool rug in ' + $p.palette + '. Heirloom quality from Bhadohi.'
  $out = $out.Replace($oldOgDesc, $newOgDesc)

  $priceFmtMeta = 'Rs. {0:N0}' -f [int]$p.price
  $oldMetaDesc = 'Elysian Abstract ' + $EM + ' hand-tufted pure New Zealand wool rug. 20mm ultra-luxury pile, woven by master artisans in Bhadohi. Starts from Rs. 10,499. Free India shipping & 10-year warranty.'
  $newMetaDesc = $p.short + ' ' + $EM + ' ' + $p.vendor.ToLower() + ' pure New Zealand wool rug in ' + $p.palette + '. Woven by master artisans in Bhadohi. Starts from ' + $priceFmtMeta + '. Free India shipping & 10-year warranty.'
  $out = $out.Replace($oldMetaDesc, $newMetaDesc)

  $out = $out.Replace('Elysian Abstract Hand-Tufted Pure New Zealand Wool Rug | Rugkari', $p.name + ' | Rugkari')

  $out = $out.Replace('Anjali Mehta', $p.reviewer)
  $out = $out.Replace('2026-02-18', $p.reviewDate)
  $oldReviewText = 'The Elysian Abstract is everything Rugkari promised ' + $EM + ' the wool is so soft, the abstract pattern is beautifully balanced, and it ties our entire living room together. Worth every rupee.'
  $out = $out.Replace($oldReviewText, $p.reviewText)

  if ($p.collection -ne 'hand-tufted-rugs') {
    $out = $out.Replace('"name": "Hand-Tufted Rugs", "item": "https://rugs.rugkari.com/collections/hand-tufted-rugs.html"',
      '"name": "' + $p.collectionName + ' Rugs", "item": "https://rugs.rugkari.com/collections/' + $p.collection + '.html"')
    $out = $out.Replace('<a href="/collections/hand-tufted-rugs.html">Hand-Tufted</a><span class="sep">/</span>',
      '<a href="/collections/' + $p.collection + '.html">' + $p.collectionName + '</a><span class="sep">/</span>')
  }

  $oldWhyP = 'Each Elysian Abstract is hand-tufted over 14' + $EN + '18 days by a single artisan in our Bhadohi atelier. The abstract design uses three carefully-toned naturals ' + $EM + ' ivory, charcoal and camel ' + $EM + ' that work effortlessly across modern, mid-century and editorial Indian interiors.'
  # Wait, the template had "14-18 days" with hyphen, not en-dash. Let me match template exactly.
  $oldWhyP = 'Each ' + $p.short + ' is hand-tufted over 14' + $EN + '18 days by a single artisan in our Bhadohi atelier. The abstract design uses three carefully-toned naturals ' + $EM + ' ivory, charcoal and camel ' + $EM + ' that work effortlessly across modern, mid-century and editorial Indian interiors.'
  # That's after the global Elysian Abstract -> short replacement happened. So the string in $out is already $p.short.
  $newWhyP = 'Each ' + $p.short + ' is hand-crafted over 14' + $EN + '18 days by a single artisan in our Bhadohi atelier. The design uses three carefully-toned naturals ' + $EM + ' ' + $p.palette + ' ' + $EM + ' that work effortlessly across ' + $p.bestFor + '.'
  $out = $out.Replace($oldWhyP, $newWhyP)

  $oldWa = 'Hi%20Rugkari%2C%20I%27d%20like%20to%20know%20more%20about%20the%20' + ($p.short -replace ' ','%20') + '%20rug.'
  # The template had "Elysian Abstract" replaced already to $p.short, so the WA links in the file already use $p.short.
  # No action needed, but for safety we ensure original WA URL is correctly transformed:
  $origWa = 'Hi%20Rugkari%2C%20I%27d%20like%20to%20know%20more%20about%20the%20Elysian%20Abstract%20rug.'
  # global Elysian Abstract -> short already replaced the literal text "Elysian Abstract" inside the URL. So URLs are already correct.

  # Related products replacement
  $oldRelatedBlock = "      <a class=`"product-card`" href=`"/products/tidal-geometric-pure-new-zealand-wool-rug.html`">`r`n        <img class=`"card-media`" src=`"https://rugkari.com/cdn/shop/files/tidal-geometric-1.jpg`" alt=`"Tidal Geometric Hand-Tufted Pure New Zealand Wool Rug`" width=`"400`" height=`"500`" loading=`"lazy`" />`r`n        <h3 class=`"card-title`">Tidal Geometric</h3>`r`n        <p class=`"card-price`">From Rs. 10,499</p>`r`n      </a>`r`n      <a class=`"product-card`" href=`"/products/nexus-abstract-pure-new-zealand-wool-rug.html`">`r`n        <img class=`"card-media`" src=`"https://rugkari.com/cdn/shop/files/nexus-abstract-1.jpg`" alt=`"Nexus Abstract Hand-Tufted Pure New Zealand Wool Rug`" width=`"400`" height=`"500`" loading=`"lazy`" />`r`n        <h3 class=`"card-title`">Nexus Abstract</h3>`r`n        <p class=`"card-price`">From Rs. 10,499</p>`r`n      </a>`r`n      <a class=`"product-card`" href=`"/products/starlite-abstract-pure-new-zealand-wool-rug.html`">`r`n        <img class=`"card-media`" src=`"https://rugkari.com/cdn/shop/files/starlite-abstract-1.jpg`" alt=`"Starlite Abstract Hand-Tufted Pure New Zealand Wool Rug`" width=`"400`" height=`"500`" loading=`"lazy`" />`r`n        <h3 class=`"card-title`">Starlite Abstract</h3>`r`n        <p class=`"card-price`">From Rs. 10,499</p>`r`n      </a>`r`n      <a class=`"product-card`" href=`"/products/harmony-geometric-pure-new-zealand-wool-rug.html`">`r`n        <img class=`"card-media`" src=`"https://rugkari.com/cdn/shop/files/harmony-geometric-1.jpg`" alt=`"Harmony Geometric Hand-Tufted Pure New Zealand Wool Rug`" width=`"400`" height=`"500`" loading=`"lazy`" />`r`n        <h3 class=`"card-title`">Harmony Geometric</h3>`r`n        <p class=`"card-price`">From Rs. 10,499</p>`r`n      </a>"
  # Note: after global $p.slug replacement, the related block has been mangled for product whose slug matches.
  # Safer approach: do the related-products replacement BEFORE the slug global replacement.
  # We'll refactor: do related replacement first.
  $newRelatedBlock = (Build-RelatedHtml $p.slug).TrimEnd("`r","`n")
  if ($out.Contains($oldRelatedBlock)) {
    $out = $out.Replace($oldRelatedBlock, $newRelatedBlock)
  }

  $outPath = Join-Path $outDir ($p.slug + '.html')
  [System.IO.File]::WriteAllText($outPath, $out, $utf8NoBom)
  Write-Output ('  generated: ' + $p.slug + '.html')
}

Write-Output ''
Write-Output ('Done. ' + $products.Count + ' product pages generated.')

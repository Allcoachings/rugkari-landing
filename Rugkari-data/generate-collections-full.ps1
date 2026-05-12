# =============================================================================
# Rugkari collection landing pages generator (CSV-driven).
# Pulls full catalog from CSV; auto-assigns products to collections by tags.
# =============================================================================

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$csvPath     = Join-Path $PSScriptRoot 'all_products_rugkari.com.csv'
$outDir      = Join-Path $projectRoot 'collections'
$utf8NoBom   = New-Object System.Text.UTF8Encoding($false)

$EM = [char]0x2014
$DOT = [char]0x00B7
$RUPEE = [char]0x20B9

if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

# Parse CSV into products
$csv = Import-Csv $csvPath
$products = @{}
foreach ($row in $csv) {
  $h = $row.Handle.Trim()
  if (-not $h) { continue }
  if (-not $products.ContainsKey($h)) {
    $products[$h] = @{ handle=$h; title=''; tags=@(); minPrice=$null; image=''; vendor='' }
  }
  $p = $products[$h]
  if (-not $p.title -and $row.Title) { $p.title = $row.Title.Trim() }
  if ((-not $p.tags -or $p.tags.Count -eq 0) -and $row.Tags) {
    $p.tags = ($row.Tags -split ',') | ForEach-Object { $_.Trim() } | Where-Object { $_ }
  }
  if ($row.'Variant Price') {
    $price = [decimal]$row.'Variant Price'
    if (-not $p.minPrice -or $price -lt $p.minPrice) { $p.minPrice = $price }
  }
  if (-not $p.image -and $row.'Image Src') { $p.image = $row.'Image Src'.Trim() }
}

# Derive vendor for each
foreach ($h in $products.Keys) {
  $tags = $products[$h].tags
  $v = 'Handcrafted'
  if ($tags -match 'Hand Knotted' -or $tags -match 'Hand-Knotted')  { $v = 'Hand-Knotted' }
  elseif ($tags -match 'Hand Tufted' -or $tags -match 'Hand-Tufted')  { $v = 'Hand-Tufted' }
  elseif ($tags -match 'Hand Woven' -or $tags -match 'Handwoven')    { $v = 'Handwoven' }
  elseif ($tags -match 'Hand Loom' -or $tags -match 'Handloom')      { $v = 'Handloom' }
  elseif ($tags -match 'Flatweave')  { $v = 'Flatweave' }
  $products[$h].vendor = $v
}

Write-Output ("Parsed " + $products.Count + " products.")

function Short-Name([string]$title) {
  $words = $title -split '\s+'
  if ($words.Count -le 2) { return $title }
  return ($words[0..1] -join ' ')
}

function Format-Rupees([decimal]$amount) { return ($RUPEE + ' ' + ('{0:N0}' -f $amount)) }

# Filters for each collection
$filters = @{
  'abstract-rugs'    = { param($p) $p.tags -match 'Abstract' -or $p.title -match 'Abstract' }
  'floral-rugs'      = { param($p) $p.tags -match 'Floral' -or $p.title -match 'Floral' -or $p.title -match 'Botanical' }
  'hand-knotted-rugs' = { param($p) $p.vendor -eq 'Hand-Knotted' -or $p.tags -match 'Traditional' }
  'hand-tufted-rugs' = { param($p) $p.vendor -eq 'Hand-Tufted' }
}

$collections = @(
  @{
    slug='abstract-rugs'
    title='Abstract Rugs'
    longTitle='Abstract Rugs Collection'
    metaTitle='Abstract Rugs Collection | Pure New Zealand Wool | Rugkari'
    metaDesc='Modern abstract pure New Zealand wool rugs by Rugkari, hand-tufted in Bhadohi. Free India shipping, 10-year warranty. Browse the full abstract collection.'
    eyebrow='Editorial Designs'
    intro='Abstract rugs that read as art. Each piece is hand-crafted in pure New Zealand wool, designed to anchor contemporary and editorial Indian interiors.'
    image='https://rugkari.com/cdn/shop/collections/7_91faef0e-6131-4c60-b908-ee6d896b3ba8.jpg'
    intro2='Abstract design in a rug is a balancing act. Too loud and it competes with the furniture; too muted and it disappears. Rugkari abstract rugs are tuned for Indian living rooms where seating volumes are large, light is warm, and the rug needs to ground without overpowering.'
    intro3='Each Rugkari abstract piece is hand-crafted in pure New Zealand wool with a 20mm ultra-luxury pile. No synthetic dyes, no shortcuts. Backed by our 10-year heirloom warranty.'
  }
  @{
    slug='floral-rugs'
    title='Floral Rugs'
    longTitle='Floral Rugs Collection'
    metaTitle='Floral Rugs Collection | Pure New Zealand Wool | Rugkari'
    metaDesc='Botanical and floral pure New Zealand wool rugs by Rugkari, handcrafted in Bhadohi. Free India shipping, 10-year warranty.'
    eyebrow='Botanical Designs'
    intro='Floral and botanical rugs in pure New Zealand wool. Hand-tufted softly, with botanical motifs scaled for modern Indian rooms.'
    image='https://rugkari.com/cdn/shop/collections/ry.jpg'
    intro2='Floral design in rugs has come a long way from the heavy Victorian carpets of the 20th century. Rugkari floral rugs use softer, larger botanical motifs that complement contemporary furniture rather than overwhelm it.'
    intro3='Each floral rug is hand-crafted in pure New Zealand wool, with botanical patterns inspired by Indian gardens and traditional Mughal motifs reinterpreted for modern interiors.'
  }
  @{
    slug='hand-knotted-rugs'
    title='Hand-Knotted Rugs'
    longTitle='Hand-Knotted Rugs Collection'
    metaTitle='Hand-Knotted Rugs Collection | Pure New Zealand Wool | Rugkari Bhadohi'
    metaDesc='Heritage hand-knotted pure New Zealand wool rugs by Rugkari, up to 300 KPSI density. Woven by master artisans in Bhadohi. Free India shipping.'
    eyebrow='Heritage Craft'
    intro='The art of hand-knotting reaches its peak in Bhadohi. Each Rugkari hand-knotted rug is tied knot-by-knot over months, achieving up to 300 KPSI density in pure New Zealand wool.'
    image='https://cdn.shopify.com/s/files/1/0659/8649/4558/files/1_12805eb4-fa71-41d5-87fc-285d8ead17a6.jpg?v=1777702789'
    intro2='Hand-knotted rugs are the highest expression of rug-making art. Unlike hand-tufted rugs, hand-knotted rugs have each knot individually tied by hand. The result is a fully reversible rug that lasts generations.'
    intro3='Rugkari hand-knotted rugs are made in Bhadohi, the Carpet City of the World, by master artisans who learned this craft from their grandparents. Knot densities reach 300 KPSI for our finest pieces.'
  }
  @{
    slug='hand-tufted-rugs'
    title='Hand-Tufted Rugs'
    longTitle='Hand-Tufted Rugs Collection'
    metaTitle='Hand-Tufted Rugs Collection | Pure New Zealand Wool | Rugkari'
    metaDesc='Hand-tufted pure New Zealand wool rugs by Rugkari. 20mm ultra-luxury pile, Bhadohi craftsmanship. Free India shipping, 10-year warranty.'
    eyebrow='Modern Craft'
    intro='Hand-tufted rugs combine the best of artisan craft and accessible luxury. 20mm pile pure New Zealand wool, hand-pushed through a canvas backing by a single artisan over 14-18 days.'
    image='https://cdn.shopify.com/s/files/1/0659/8649/4558/files/5_9ce644f2-a560-4fa7-97b3-243df12f5f26.jpg?v=1777702689'
    intro2='Hand-tufted rugs are the most popular choice for modern Indian homes. They have the genuine handmade character of hand-knotted rugs at a fraction of the cost, with a denser, plusher pile that feels luxurious underfoot.'
    intro3='Every Rugkari hand-tufted rug uses 100% pure New Zealand wool with a 20mm ultra-luxury pile depth, cotton canvas backing, and is woven by a single artisan over 14-18 days in Bhadohi.'
  }
)

function Build-ProductCards($matches) {
  $sb = New-Object System.Text.StringBuilder
  foreach ($p in $matches) {
    $short = Short-Name $p.title
    $price = if ($p.minPrice) { 'From ' + (Format-Rupees $p.minPrice) } else { '' }
    $img = if ($p.image) { $p.image } else { '/assets/RUGKARI-LOGO.webp' }
    [void]$sb.AppendLine('      <a class="product-card" href="/products/' + $p.handle + '.html">')
    [void]$sb.AppendLine('        <img class="card-media" src="' + $img + '" alt="' + $p.title + '" width="400" height="500" loading="lazy" />')
    [void]$sb.AppendLine('        <h3 class="card-title">' + $short + '</h3>')
    [void]$sb.AppendLine('        <p class="card-price">' + $price + '</p>')
    [void]$sb.AppendLine('      </a>')
  }
  return $sb.ToString()
}

function Build-ItemListJson($matches, $collectionUrl) {
  $items = @()
  $i = 1
  foreach ($p in $matches) {
    $items += ('          { "@type": "ListItem", "position": ' + $i + ', "name": "' + ($p.title -replace '"','\"') + '", "url": "https://rugs.rugkari.com/products/' + $p.handle + '.html", "image": "' + $p.image + '" }')
    $i++
  }
  return ($items -join ",`r`n")
}

foreach ($c in $collections) {
  $url = 'https://rugs.rugkari.com/collections/' + $c.slug + '.html'
  $filter = $filters[$c.slug]

  $matches = @()
  foreach ($h in $products.Keys) {
    $p = $products[$h]
    if (-not $p.title -or -not $p.image) { continue }
    if (& $filter $p) { $matches += $p }
  }
  $matches = $matches | Sort-Object { $_.title }

  $productsHtml = Build-ProductCards $matches
  $itemListJson = Build-ItemListJson $matches $url

  Write-Output ('  ' + $c.slug + ' : ' + $matches.Count + ' products')

  $jsonLd = @"
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "Organization",
      "@id": "https://rugkari.com/#organization",
      "name": "Rugkari",
      "url": "https://rugkari.com/",
      "logo": { "@type": "ImageObject", "url": "/assets/RUGKARI-LOGO.webp" }
    },
    {
      "@type": "WebSite",
      "@id": "https://rugs.rugkari.com/#website",
      "url": "https://rugs.rugkari.com/",
      "name": "Rugkari $EM The Rug Guide",
      "publisher": { "@id": "https://rugkari.com/#organization" },
      "inLanguage": "en-IN"
    },
    {
      "@type": "CollectionPage",
      "@id": "$url#webpage",
      "url": "$url",
      "name": "$($c.metaTitle)",
      "isPartOf": { "@id": "https://rugs.rugkari.com/#website" },
      "description": "$($c.metaDesc)",
      "inLanguage": "en-IN",
      "isAccessibleForFree": true,
      "breadcrumb": { "@id": "$url#breadcrumb" }
    },
    {
      "@type": "BreadcrumbList",
      "@id": "$url#breadcrumb",
      "itemListElement": [
        { "@type": "ListItem", "position": 1, "name": "Rugkari", "item": "https://rugs.rugkari.com/" },
        { "@type": "ListItem", "position": 2, "name": "Collections", "item": "https://rugs.rugkari.com/" },
        { "@type": "ListItem", "position": 3, "name": "$($c.title)", "item": "$url" }
      ]
    },
    {
      "@type": "ItemList",
      "@id": "$url#products",
      "name": "$($c.longTitle)",
      "description": "$($c.metaDesc)",
      "numberOfItems": $($matches.Count),
      "itemListElement": [
$itemListJson
      ]
    }
  ]
}
</script>
"@

  $page = @"
<!doctype html>
<html lang="en" prefix="og: https://ogp.me/ns#">
<head>
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','GTM-5L4Z9CSQ');</script>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="icon" type="image/webp" href="/assets/FEVICON.webp" />
<link rel="apple-touch-icon" href="/assets/FEVICON.webp" />
<title>$($c.metaTitle)</title>
<meta name="description" content="$($c.metaDesc)" />
<meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1" />
<link rel="canonical" href="$url" />
<meta property="og:type" content="website" />
<meta property="og:site_name" content="Rugkari" />
<meta property="og:url" content="$url" />
<meta property="og:title" content="$($c.metaTitle)" />
<meta property="og:description" content="$($c.metaDesc)" />
<meta property="og:image" content="$($c.image)" />
<meta name="twitter:card" content="summary_large_image" />
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet" />
<link rel="stylesheet" href="/assets/styles.css" />
$jsonLd
</head>

<body>

<header class="site-header" role="banner">
  <div class="store-note tracking-wider-2">Free Pan-India Shipping $DOT Up to 25-Year Heirloom Warranty</div>
  <div class="mobile-drawer-overlay" id="drawerOverlay" aria-hidden="true"></div>
  <div class="mobile-drawer" id="mobileDrawer" role="dialog" aria-label="Navigation" aria-modal="true">
    <div class="mobile-drawer-header"><span class="mobile-drawer-title">Menu</span><button class="drawer-close-btn" id="drawerClose" aria-label="Close"><svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" fill="none"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg></button></div>
    <nav class="mobile-drawer-nav"><a href="/collections/abstract-rugs.html">Abstract</a><a href="/collections/floral-rugs.html">Floral</a><a href="/collections/hand-knotted-rugs.html">Hand-Knotted</a><a href="/collections/hand-tufted-rugs.html">Hand-Tufted</a><a href="/rug-care">Rug Care</a><a href="/heritage">Heritage</a></nav>
  </div>
  <div class="container header-row">
    <button class="mobile-summary mobile-menu" id="drawerOpen" aria-label="Open menu" aria-expanded="false"><svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" fill="none"><path d="M4 12h16"/><path d="M4 6h16"/><path d="M4 18h16"/></svg></button>
    <a href="/" aria-label="Rugkari" class="logo"><img src="/assets/RUGKARI-LOGO.webp" alt="Rugkari" width="140" height="36" /></a>
    <nav class="desktop-nav"><a href="/collections/abstract-rugs.html">Abstract</a><a href="/collections/floral-rugs.html">Floral</a><a href="/collections/hand-knotted-rugs.html">Hand-Knotted</a><a href="/collections/hand-tufted-rugs.html">Hand-Tufted</a><a href="/rug-care">Rug Care</a><a href="/heritage">Heritage</a></nav>
    <div class="icon-actions">
      <a class="icon-button" href="https://rugkari.com/search" aria-label="Search" rel="noopener"><svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg></a>
      <a class="login-text-btn" href="https://rugkari.com/account" rel="noopener">Log in</a>
      <a class="icon-button" href="https://rugkari.com/cart" aria-label="Cart" rel="noopener"><svg viewBox="0 0 24 24"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4Z"/><path d="M3 6h18"/><path d="M16 10a4 4 0 0 1-8 0"/></svg></a>
    </div>
  </div>
</header>

<main id="main-content">

<div class="container">
  <nav class="crumbs" aria-label="Breadcrumb">
    <a href="/">Rugkari</a><span class="sep">/</span>
    <span>$($c.title)</span>
  </nav>
</div>

<section class="page-hero with-image">
  <img src="$($c.image)" alt="$($c.title) collection by Rugkari" loading="eager" />
  <div class="container">
    <p class="eyebrow tracking-luxury">$($c.eyebrow)</p>
    <h1>$($c.longTitle)</h1>
    <p class="lead" style="max-width: 640px; margin: 24px auto 0; color: rgba(255,255,255,0.85);">$($c.intro)</p>
    <p style="margin-top: 16px; font-size: 13px; letter-spacing: .08em; text-transform: uppercase; color: rgba(255,255,255,0.7);">$($matches.Count) Rugs $DOT From $RUPEE 7,099</p>
  </div>
</section>

<section class="section">
  <div class="container">
    <p class="eyebrow" style="text-align:center;">The Collection</p>
    <h2 class="section-title">Shop the $($c.title)</h2>
    <div class="product-grid">
$productsHtml    </div>
    <p style="text-align:center; margin-top: 56px;">
      <a href="/#collections" class="btn btn-ghost">
        <span>Explore Other Collections</span>
      </a>
    </p>
  </div>
</section>

<section class="section" style="background: var(--secondary);">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">About the Collection</p>
    <h2 style="text-align:center;">Why Rugkari $($c.title)</h2>
    <p style="font-size: 17px; line-height: 1.8;">$($c.intro2)</p>
    <p style="font-size: 17px; line-height: 1.8;">$($c.intro3)</p>
  </div>
</section>

<section class="section">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">Read Next</p>
    <h2 class="section-title">From the Rug Guide</h2>
    <div class="product-grid three">
      <a class="product-card" href="/best-hand-tufted-rugs-for-living-room">
        <img class="card-media" src="https://cdn.shopify.com/s/files/1/0659/8649/4558/files/4695-kellywearstler-districtspruce-rug-1200x1800-roomset__38058.jpg?v=1777702455" alt="Best hand-tufted rugs for Indian living rooms" width="400" height="500" loading="lazy" />
        <h3 class="card-title">8 Best Hand-Tufted Rugs</h3>
        <p class="card-price">Buying Guide</p>
      </a>
      <a class="product-card" href="/hand-tufted-vs-machine-made-rugs">
        <img class="card-media" src="https://cdn.shopify.com/s/files/1/0659/8649/4558/files/1200x1800---cc_plexa_r_c9edf421-09e9-4752-be04-8e0b82194cc0.jpg?v=1777702445" alt="Hand-Tufted vs Machine-Made Rugs" width="400" height="500" loading="lazy" />
        <h3 class="card-title">Hand-Tufted vs Machine-Made</h3>
        <p class="card-price">Comparison Guide</p>
      </a>
      <a class="product-card" href="/how-to-choose-rug-size-for-living-room-india">
        <img class="card-media" src="https://cdn.shopify.com/s/files/1/0659/8649/4558/files/designer-rugs-bernabeifreeman-contour-lo-wr-1.jpg?v=1777702443" alt="How to choose rug size" width="400" height="500" loading="lazy" />
        <h3 class="card-title">Choose the Right Rug Size</h3>
        <p class="card-price">Size Guide</p>
      </a>
    </div>
  </div>
</section>

</main>

<footer class="site-footer" role="contentinfo">
  <div class="container footer-main">
    <div>
      <img class="footer-brand" src="/assets/RUGKARI-LOGO.webp" alt="Rugkari" width="140" height="36" loading="lazy" />
      <p class="footer-since tracking-luxury">Since 1980</p>
      <p class="footer-copy">Handcrafted pure New Zealand wool rugs woven by master artisans in Bhadohi, India.</p>
    </div>
    <nav aria-label="Guides">
      <h4 class="footer-title">The Rug Guide</h4>
      <ul class="footer-list">
        <li><a href="/rug-care">Rug Care &amp; Guides</a></li>
        <li><a href="/heritage">Heritage</a></li>
        <li><a href="/best-hand-tufted-rugs-for-living-room">Best Living Room Rugs</a></li>
      </ul>
    </nav>
    <nav aria-label="Shop">
      <h4 class="footer-title">Shop</h4>
      <ul class="footer-list">
        <li><a href="/collections/abstract-rugs.html">Abstract</a></li>
        <li><a href="/collections/floral-rugs.html">Floral</a></li>
        <li><a href="/collections/hand-knotted-rugs.html">Hand-Knotted</a></li>
        <li><a href="/collections/hand-tufted-rugs.html">Hand-Tufted</a></li>
        <li><a href="/collections/hand-tufted-rugs.html">Hand-Tufted</a></li>
      </ul>
    </nav>
    <div>
      <h4 class="footer-title">Stay Connected</h4>
      <p class="newsletter-text">New arrivals and design inspiration.</p>
      <form class="newsletter-form" onsubmit="handleNewsletterSubmit(event)" novalidate>
        <label for="newsletter-email" class="sr-only">Email</label>
        <input type="email" id="newsletter-email" name="email" placeholder="Your email" required autocomplete="email" />
        <button type="submit">Join</button>
      </form>
    </div>
  </div>
  <div class="footer-bottom">
    <div class="container footer-bottom-row">
      <p>&copy; <span id="footer-year"></span> <a href="/">Rugkari</a>. Handwoven in India. Loved worldwide.</p>
      <ul class="legal-links" role="list">
        <li><a href="https://rugkari.com/policies/privacy-policy" rel="noopener">Privacy</a></li>
        <li><a href="https://rugkari.com/policies/refund-policy" rel="noopener">Refund</a></li>
        <li><a href="https://rugkari.com/policies/terms-of-service" rel="noopener">Terms</a></li>
        <li><a href="https://rugkari.com/policies/shipping-policy" rel="noopener">Shipping</a></li>
      </ul>
    </div>
  </div>
</footer>

<div class="whatsapp" role="complementary"><a class="whatsapp-button" href="https://wa.me/917348515188?text=Hi%20Rugkari%2C%20I%27d%20like%20to%20know%20more%20about%20your%20rugs." target="_blank" rel="noopener noreferrer" aria-label="WhatsApp"><svg viewBox="0 0 175.216 175.552" aria-hidden="true"><path d="M87.184 0C39.04 0 .002 39.038 0 87.184c0 15.363 4.03 30.37 11.688 43.549L.336 175.552l46.033-11.304c12.683 6.983 26.975 10.663 41.549 10.663 48.142 0 87.184-39.038 87.298-87.184C175.33 39.152 135.33 0 87.184 0zm0 159.893c-13.363 0-26.44-3.594-37.782-10.38l-2.714-1.61-28.138 6.913 7.138-25.883-1.765-2.827C16.83 114.466 13.11 101.059 13.11 87.184 13.11 46.23 46.23 13.11 87.184 13.11c40.13 0 72.781 32.65 72.781 72.782 0 40.953-32.65 74.001-72.781 74.001zm40.009-55.37c-2.196-1.097-12.978-6.394-14.99-7.124-2.012-.73-3.476-1.097-4.94 1.097-1.463 2.194-5.671 7.124-6.952 8.587-1.28 1.462-2.561 1.645-4.757.548-2.196-1.097-9.27-3.41-17.65-10.88-6.524-5.818-10.929-13.004-12.21-15.198-1.28-2.194-.136-3.379 .962-4.472.986-.979 2.196-2.559 3.293-3.838 1.097-1.28 1.463-2.194 2.195-3.657.73-1.462.365-2.742-.183-3.838-.548-1.097-4.94-11.887-6.77-16.28-1.78-4.28-3.592-3.7-4.94-3.762-1.28-.061-2.744-.074-4.208-.074-1.463 0-3.842.548-5.854 2.742-2.012 2.194-7.684 7.49-7.684 18.28 0 10.789 7.867 21.214 8.964 22.676 1.097 1.462 15.479 23.625 37.503 33.146 5.242 2.266 9.333 3.619 12.52 4.633 5.262 1.677 10.053 1.44 13.838.873 4.222-.632 12.978-5.305 14.807-10.425 1.83-5.12 1.83-9.512 1.28-10.425-.548-.913-2.012-1.462-4.208-2.559z" fill="#fff"/></svg></a></div>

<script>
  document.getElementById('footer-year').textContent = new Date().getFullYear();
  (function() {
    var header  = document.querySelector('.site-header');
    var openBtn = document.getElementById('drawerOpen');
    var closeBtn = document.getElementById('drawerClose');
    var overlay = document.getElementById('drawerOverlay');
    function openDrawer()  { header.classList.add('drawer-open');  openBtn.setAttribute('aria-expanded','true');  document.body.style.overflow = 'hidden'; }
    function closeDrawer() { header.classList.remove('drawer-open'); openBtn.setAttribute('aria-expanded','false'); document.body.style.overflow = ''; }
    if (openBtn)  openBtn.addEventListener('click', openDrawer);
    if (closeBtn) closeBtn.addEventListener('click', closeDrawer);
    if (overlay)  overlay.addEventListener('click', closeDrawer);
    document.addEventListener('keydown', function(e) { if (e.key === 'Escape') closeDrawer(); });
  })();
  function handleNewsletterSubmit(e) { e.preventDefault(); var i = e.target.querySelector('input[type=email]'); var b = e.target.querySelector('button'); if (!i.value) return; b.textContent='Joined'; b.disabled=true; i.disabled=true; }
</script>

</body>
</html>
"@

  $outPath = Join-Path $outDir ($c.slug + '.html')
  [System.IO.File]::WriteAllText($outPath, $page, $utf8NoBom)
}

Write-Output ''
Write-Output 'Done.'

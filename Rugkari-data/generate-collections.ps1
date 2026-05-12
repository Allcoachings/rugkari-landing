# =============================================================================
# Rugkari collection landing page generator (ASCII-safe).
# =============================================================================

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$outDir      = Join-Path $projectRoot 'collections'
$csvPath     = Join-Path $PSScriptRoot 'all_products_rugkari.com.csv'
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

$EM = [char]0x2014
$DOT = [char]0x00B7
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# Load CSV: real CDN URLs (first image), titles, lowest variant price,
# construction (Hand-Knotted / Hand-Tufted / Handwoven / Handcrafted) per handle.
$realFirstImage = @{}
$csvTitle       = @{}
$csvLowPrice    = @{}
$csvHandles     = @()
if (Test-Path $csvPath) {
  $csvRows = Import-Csv $csvPath
  foreach ($r in $csvRows) {
    if (-not $r.Handle) { continue }
    $shortKey = ($r.Handle.Trim()) -replace '-pure-new-zealand-wool-rug',''
    if ($r.'Image Src' -and -not $realFirstImage.ContainsKey($shortKey)) {
      $realFirstImage[$shortKey] = $r.'Image Src'
    }
    if ($r.Title -and -not $csvTitle.ContainsKey($shortKey)) {
      $csvTitle[$shortKey] = $r.Title
      $csvHandles += $shortKey
    }
    if ($r.'Variant Price') {
      $p = 0
      if ([double]::TryParse($r.'Variant Price', [ref]$p)) {
        $cents = [int][math]::Round($p)
        if (-not $csvLowPrice.ContainsKey($shortKey) -or $cents -lt $csvLowPrice[$shortKey]) {
          $csvLowPrice[$shortKey] = $cents
        }
      }
    }
  }
}

function Get-Construction($title) {
  if ($title -match 'Hand-Knotted') { return 'Hand-Knotted' }
  if ($title -match 'Hand-Tufted')  { return 'Hand-Tufted' }
  if ($title -match 'Handwoven')    { return 'Handwoven' }
  if ($title -match 'Handcrafted')  { return 'Handcrafted' }
  return 'Handcrafted'
}

function Get-ShortName($title) {
  $t = $title
  $t = $t -replace '\s+(Hand-Knotted|Hand-Tufted|Handwoven|Handcrafted)\s+Pure New Zealand Wool Rug.*',''
  $t = $t -replace '\s+Pure New Zealand Wool Rug.*',''
  return $t.Trim()
}

# Header / footer building blocks shared by all collections
$gtmAndMeta = @'
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','GTM-5L4Z9CSQ');</script>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="icon" type="image/webp" href="/assets/FEVICON.webp" />
<link rel="apple-touch-icon" href="/assets/FEVICON.webp" />
'@

$sharedHead = @'
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet" />
<link rel="stylesheet" href="/assets/styles.css" />
'@

$sharedHeader = @'
<header class="site-header" role="banner">
  <div class="store-note tracking-wider-2">Free Pan-India Shipping {{DOT}} Up to 25-Year Heirloom Warranty</div>
  <div class="mobile-drawer-overlay" id="drawerOverlay" aria-hidden="true"></div>
  <div class="mobile-drawer" id="mobileDrawer" role="dialog" aria-label="Navigation" aria-modal="true">
    <div class="mobile-drawer-header">
      <span class="mobile-drawer-title">Menu</span>
      <button class="drawer-close-btn" id="drawerClose" aria-label="Close navigation menu"><svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" fill="none"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg></button>
    </div>
    <nav class="mobile-drawer-nav" role="navigation" aria-label="Mobile navigation">
      <div class="drawer-section">
        <h5 class="drawer-section-title">Shop by Style</h5>
        <a href="/collections/abstract-rugs.html">Abstract Rugs</a>
        <a href="/collections/floral-rugs.html">Floral Rugs</a>
        <a href="/collections/geometric-rugs.html">Geometric Rugs</a>
        <a href="/collections/modern-rugs.html">Modern Rugs</a>
        <a href="/collections/solid-rugs.html">Solid Rugs</a>
        <a href="/collections/unshaped-rugs.html">Unshaped Rugs</a>
      </div>
      <div class="drawer-section">
        <h5 class="drawer-section-title">Shop by Craft</h5>
        <a href="/collections/hand-knotted-rugs.html">Hand-Knotted</a>
        <a href="/collections/hand-tufted-rugs.html">Hand-Tufted</a>
        <a href="/collections/hand-loom.html">Hand-Loom</a>
      </div>
      <div class="drawer-section">
        <h5 class="drawer-section-title">Shop by Room</h5>
        <a href="/collections/living-room-rugs.html">Living Room</a>
        <a href="/collections/bedroom-rugs.html">Bedroom</a>
        <a href="/collections/dining-room-rugs.html">Dining Room</a>
      </div>
      <div class="drawer-section">
        <h5 class="drawer-section-title">More</h5>
        <a href="/rug-care">Rug Care</a>
        <a href="/heritage">Our Story</a>
      </div>
    </nav>
  </div>
  <div class="container header-row">
    <button class="mobile-summary mobile-menu" id="drawerOpen" aria-label="Open navigation menu" aria-expanded="false"><svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" fill="none"><path d="M4 12h16"/><path d="M4 6h16"/><path d="M4 18h16"/></svg></button>
    <a href="/" aria-label="Rugkari" class="logo"><img src="/assets/RUGKARI-LOGO.webp" alt="Rugkari" width="140" height="36" /></a>
    <nav class="desktop-nav" role="navigation" aria-label="Primary navigation">
      <a href="/collections/abstract-rugs.html">Abstract</a>
      <a href="/collections/floral-rugs.html">Floral</a>
      <a href="/collections/hand-knotted-rugs.html">Hand-Knotted</a>
      <a href="/collections/hand-tufted-rugs.html">Hand-Tufted</a>
      <a href="/rug-care">Rug Care</a>
      <a href="/heritage">Heritage</a>
    </nav>
    <div class="icon-actions">
      <a class="icon-button" href="https://rugkari.com/search" aria-label="Search" rel="noopener"><svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg></a>
      <a class="login-text-btn" href="https://rugkari.com/account" rel="noopener">Log in</a>
      <a class="icon-button" href="https://rugkari.com/cart" aria-label="Cart" rel="noopener"><svg viewBox="0 0 24 24"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4Z"/><path d="M3 6h18"/><path d="M16 10a4 4 0 0 1-8 0"/></svg></a>
    </div>
  </div>
</header>
'@

$sharedFooter = @'
<footer class="site-footer" role="contentinfo">
  <div class="container footer-main">
    <div>
      <img class="footer-brand" src="/assets/RUGKARI-LOGO.webp" alt="Rugkari" width="140" height="36" loading="lazy" />
      <p class="footer-since tracking-luxury">Since 1980</p>
      <p class="footer-copy">Handcrafted pure New Zealand wool rugs woven by master artisans in Bhadohi, India. Heirloom quality, 10-year warranty.</p>
      <div class="socials" role="list">
        <a href="https://www.instagram.com/rugkaari" target="_blank" rel="noopener noreferrer" aria-label="Instagram"><svg viewBox="0 0 24 24"><path d="M7.8 2h8.4A5.8 5.8 0 0 1 22 7.8v8.4a5.8 5.8 0 0 1-5.8 5.8H7.8A5.8 5.8 0 0 1 2 16.2V7.8A5.8 5.8 0 0 1 7.8 2Zm-.2 2A3.6 3.6 0 0 0 4 7.6v8.8A3.6 3.6 0 0 0 7.6 20h8.8a3.6 3.6 0 0 0 3.6-3.6V7.6A3.6 3.6 0 0 0 16.4 4H7.6Zm9.65 1.5a1.25 1.25 0 1 1 0 2.5 1.25 1.25 0 0 1 0-2.5ZM12 7a5 5 0 1 1 0 10 5 5 0 0 1 0-10Zm0 2a3 3 0 1 0 0 6 3 3 0 0 0 0-6Z"/></svg></a>
        <a href="https://www.facebook.com/profile.php?id=61583826735546" target="_blank" rel="noopener noreferrer" aria-label="Facebook"><svg viewBox="0 0 24 24"><path d="M13.5 22v-8h2.7l.4-3h-3.1V9.1c0-.9.25-1.5 1.55-1.5h1.65V4.9c-.8-.08-1.6-.13-2.4-.13-2.4 0-4.05 1.47-4.05 4.17V11H8v3h2.75v8h2.75Z"/></svg></a>
        <a href="https://www.youtube.com/@rugkari" target="_blank" rel="noopener noreferrer" aria-label="YouTube"><svg viewBox="0 0 24 24"><path d="M23 7.2a3 3 0 0 0-2.1-2.1C19 4.6 12 4.6 12 4.6s-7 0-8.9.5A3 3 0 0 0 1 7.2 31 31 0 0 0 .5 12 31 31 0 0 0 1 16.8a3 3 0 0 0 2.1 2.1c1.9.5 8.9.5 8.9.5s7 0 8.9-.5a3 3 0 0 0 2.1-2.1 31 31 0 0 0 .5-4.8 31 31 0 0 0-.5-4.8ZM9.8 15.4V8.6L15.6 12l-5.8 3.4Z"/></svg></a>
      </div>
    </div>
    <nav aria-label="Guides">
      <h4 class="footer-title">The Rug Guide</h4>
      <ul class="footer-list">
        <li><a href="/rug-care">Rug Care &amp; Guides</a></li>
        <li><a href="/heritage">Heritage &amp; Story</a></li>
        <li><a href="/best-hand-tufted-rugs-for-living-room">Best Living Room Rugs</a></li>
        <li><a href="/hand-tufted-vs-machine-made-rugs">Hand-Tufted vs Machine-Made</a></li>
      </ul>
    </nav>
    <nav aria-label="Shop Rug Collections">
      <h4 class="footer-title">Shop Rugs</h4>
      <ul class="footer-list">
        <li><a href="/collections/abstract-rugs.html">Abstract</a></li>
        <li><a href="/collections/floral-rugs.html">Floral</a></li>
        <li><a href="/collections/geometric-rugs.html">Geometric</a></li>
        <li><a href="/collections/solid-rugs.html">Solid</a></li>
        <li><a href="/collections/modern-rugs.html">Modern</a></li>
        <li><a href="/collections/unshaped-rugs.html">Unshaped</a></li>
        <li><a href="/collections/hand-knotted-rugs.html">Hand-Knotted</a></li>
        <li><a href="/collections/hand-tufted-rugs.html">Hand-Tufted</a></li>
        <li><a href="/collections/hand-loom.html">Hand-Loom</a></li>
        <li><a href="/collections/living-room-rugs.html">Living Room</a></li>
        <li><a href="/collections/bedroom-rugs.html">Bedroom</a></li>
        <li><a href="/collections/dining-room-rugs.html">Dining Room</a></li>
      </ul>
    </nav>
    <div>
      <h4 class="footer-title">Stay Connected</h4>
      <p class="newsletter-text">New arrivals, exclusive offers, and design inspiration.</p>
      <form class="newsletter-form" onsubmit="handleNewsletterSubmit(event)" novalidate>
        <label for="newsletter-email" class="sr-only">Email address</label>
        <input type="email" id="newsletter-email" name="email" placeholder="Your email" required autocomplete="email" />
        <button type="submit">Join</button>
      </form>
    </div>
  </div>
  <div class="footer-bottom">
    <div class="container footer-bottom-row">
      <p>(c) <span id="footer-year"></span> <a href="/">Rugkari</a>. Handwoven in India. Loved worldwide.</p>
      <ul class="legal-links" role="list">
        <li><a href="https://rugkari.com/policies/privacy-policy" rel="noopener">Privacy</a></li>
        <li><a href="https://rugkari.com/policies/refund-policy" rel="noopener">Refund</a></li>
        <li><a href="https://rugkari.com/policies/terms-of-service" rel="noopener">Terms</a></li>
        <li><a href="https://rugkari.com/policies/shipping-policy" rel="noopener">Shipping</a></li>
      </ul>
    </div>
  </div>
</footer>

<div class="whatsapp" role="complementary">
  <a class="whatsapp-button" href="https://wa.me/917348515188?text=Hi%20Rugkari%2C%20I%27d%20like%20to%20know%20more%20about%20your%20rugs." target="_blank" rel="noopener noreferrer" aria-label="Chat on WhatsApp">
    <svg viewBox="0 0 175.216 175.552" aria-hidden="true"><path d="M87.184 0C39.04 0 .002 39.038 0 87.184c0 15.363 4.03 30.37 11.688 43.549L.336 175.552l46.033-11.304c12.683 6.983 26.975 10.663 41.549 10.663 48.142 0 87.184-39.038 87.298-87.184C175.33 39.152 135.33 0 87.184 0zm0 159.893c-13.363 0-26.44-3.594-37.782-10.38l-2.714-1.61-28.138 6.913 7.138-25.883-1.765-2.827C16.83 114.466 13.11 101.059 13.11 87.184 13.11 46.23 46.23 13.11 87.184 13.11c40.13 0 72.781 32.65 72.781 72.782 0 40.953-32.65 74.001-72.781 74.001zm40.009-55.37c-2.196-1.097-12.978-6.394-14.99-7.124-2.012-.73-3.476-1.097-4.94 1.097-1.463 2.194-5.671 7.124-6.952 8.587-1.28 1.462-2.561 1.645-4.757.548-2.196-1.097-9.27-3.41-17.65-10.88-6.524-5.818-10.929-13.004-12.21-15.198-1.28-2.194-.136-3.379 .962-4.472.986-.979 2.196-2.559 3.293-3.838 1.097-1.28 1.463-2.194 2.195-3.657.73-1.462.365-2.742-.183-3.838-.548-1.097-4.94-11.887-6.77-16.28-1.78-4.28-3.592-3.7-4.94-3.762-1.28-.061-2.744-.074-4.208-.074-1.463 0-3.842.548-5.854 2.742-2.012 2.194-7.684 7.49-7.684 18.28 0 10.789 7.867 21.214 8.964 22.676 1.097 1.462 15.479 23.625 37.503 33.146 5.242 2.266 9.333 3.619 12.52 4.633 5.262 1.677 10.053 1.44 13.838.873 4.222-.632 12.978-5.305 14.807-10.425 1.83-5.12 1.83-9.512 1.28-10.425-.548-.913-2.012-1.462-4.208-2.559z" fill="#fff"/></svg>
  </a>
</div>

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
  function handleNewsletterSubmit(e) {
    e.preventDefault();
    const input = e.target.querySelector('input[type="email"]');
    const btn   = e.target.querySelector('button');
    if (!input.value) return;
    btn.textContent = '(checkmark) Joined'; btn.disabled = true; input.disabled = true;
  }
</script>
'@
$sharedHeader = $sharedHeader -replace '\(c\)','&copy;'
$sharedFooter = $sharedFooter -replace '\(c\)','&copy;'
$sharedFooter = $sharedFooter -replace '\(checkmark\)','&#10003;'

$sharedHeader = $sharedHeader -replace '\{\{DOT\}\}', $DOT

$collections = @(
  @{
    slug='abstract-rugs'
    title='Abstract Rugs'
    longTitle='Abstract Rugs Collection'
    metaTitle='Abstract Rugs Collection | Pure New Zealand Wool | Rugkari'
    metaDesc='Modern abstract pure New Zealand wool rugs by Rugkari. Handcrafted in Bhadohi, free India shipping, heirloom warranty. Browse the full abstract collection.'
    eyebrow='Editorial Designs'
    intro='Abstract rugs that read as art. Each piece is handcrafted in pure New Zealand wool, designed to anchor contemporary and editorial Indian interiors.'
    image='https://rugkari.com/cdn/shop/collections/7_91faef0e-6131-4c60-b908-ee6d896b3ba8.jpg'
    intro2='Abstract design in a rug is a balancing act. Too loud and it competes with the furniture; too muted and it disappears. Rugkari abstract rugs are tuned for Indian living rooms where seating volumes are large, light is warm, and the rug needs to ground without overpowering.'
    intro3='Each Rugkari abstract piece is handcrafted in pure New Zealand wool with a 20mm ultra-luxury pile. Three natural shades per design, no synthetic dyes. Backed by our heirloom warranty.'
    match = { param($h,$t) $h -match '-abstract$' }
  }
  @{
    slug='floral-rugs'
    title='Floral Rugs'
    longTitle='Floral Rugs Collection'
    metaTitle='Floral Rugs Collection | Pure New Zealand Wool | Rugkari'
    metaDesc='Botanical and floral pure New Zealand wool rugs by Rugkari, handcrafted in Bhadohi. Free India shipping, heirloom warranty. Soft florals for living rooms and bedrooms.'
    eyebrow='Botanical Designs'
    intro='Floral and botanical rugs in pure New Zealand wool. Handcrafted softly, with botanical motifs scaled for modern Indian rooms.'
    image='https://rugkari.com/cdn/shop/collections/ry.jpg'
    intro2='Floral design in rugs has come a long way from the heavy Victorian carpets of the 20th century. Rugkari floral rugs use softer, larger botanical motifs that complement contemporary furniture rather than overwhelm it.'
    intro3='Each floral rug is handcrafted in pure New Zealand wool, with botanical patterns inspired by Indian gardens and traditional Mughal motifs reinterpreted for modern interiors.'
    match = { param($h,$t) $h -match '-floral$' }
  }
  @{
    slug='hand-knotted-rugs'
    title='Hand-Knotted Rugs'
    longTitle='Hand-Knotted Rugs Collection'
    metaTitle='Hand-Knotted Rugs Collection | Pure New Zealand Wool | Rugkari Bhadohi'
    metaDesc='Heritage hand-knotted pure New Zealand wool rugs by Rugkari, up to 300 KPSI density. Woven by master artisans in Bhadohi. Free India shipping, 25-year warranty.'
    eyebrow='Heritage Craft'
    intro='The art of hand-knotting reaches its peak in Bhadohi. Each Rugkari hand-knotted rug is tied knot-by-knot over months, achieving up to 300 KPSI density in pure New Zealand wool.'
    image='https://rugkari.com/cdn/shop/files/1_12805eb4-fa71-41d5-87fc-285d8ead17a6.jpg?v=1777702789'
    intro2='Hand-knotted rugs are the highest expression of rug-making art. Unlike hand-tufted rugs (where yarn is pushed through a backing with a tufting gun), hand-knotted rugs have each knot individually tied by hand. The result: a fully reversible rug that lasts generations.'
    intro3='Rugkari hand-knotted rugs are made in Bhadohi, the Carpet City of the World, by master artisans who learned this craft from their grandparents. Knot densities reach 300 KPSI for our finest pieces, backed by a 25-year heirloom warranty.'
    match = { param($h,$t) $t -match 'Hand-Knotted' }
  }
  @{
    slug='hand-tufted-rugs'
    title='Hand-Tufted Rugs'
    longTitle='Hand-Tufted Rugs Collection'
    metaTitle='Hand-Tufted Rugs Collection | Pure New Zealand Wool | Rugkari'
    metaDesc='Hand-tufted pure New Zealand wool rugs by Rugkari. 20mm ultra-luxury pile, Bhadohi craftsmanship. Free India shipping, 10-year warranty. Browse our full hand-tufted range.'
    eyebrow='Modern Craft'
    intro='Hand-tufted rugs combine the best of artisan craft and accessible luxury. 20mm pile pure New Zealand wool, hand-pushed through a canvas backing by a single artisan over 14-18 days.'
    image='https://rugkari.com/cdn/shop/files/5_9ce644f2-a560-4fa7-97b3-243df12f5f26.jpg?v=1777702689'
    intro2='Hand-tufted rugs are the most popular choice for modern Indian homes. They have the genuine handmade character of hand-knotted rugs at a fraction of the cost, with a denser, plusher pile that feels luxurious underfoot.'
    intro3='Every Rugkari hand-tufted rug uses 100% pure New Zealand wool with a 20mm ultra-luxury pile depth, cotton canvas backing, and is woven by a single artisan over 14-18 days in Bhadohi. Backed by our 10-year heirloom warranty.'
    match = { param($h,$t) $t -match 'Hand-Tufted' }
  }
  @{
    slug='modern-rugs'
    title='Modern Rugs'
    longTitle='Modern Rugs Collection'
    metaTitle='Modern Rugs Collection | Pure New Zealand Wool | Rugkari'
    metaDesc='Modern pure New Zealand wool rugs by Rugkari. Abstract, geometric, designer and solid pieces handcrafted in Bhadohi. Free India shipping, heirloom warranty.'
    eyebrow='Contemporary Edit'
    intro='Modern rugs for contemporary Indian interiors. Abstract, geometric, designer and solid designs in pure New Zealand wool, handcrafted in Bhadohi.'
    image='https://rugkari.com/cdn/shop/collections/1_2112c79b-fb1d-40ed-a00e-3909b79b6305.jpg?v=1777703693'
    intro2='Modern design in a rug means restraint. Clean lines, considered colour, scale that respects the room. Rugkari modern rugs span abstract editorial pieces, structured geometrics, designer silhouettes and quiet solids for serene interiors.'
    intro3='Each modern rug is handcrafted in pure New Zealand wool with a 20mm ultra-luxury pile. Three natural shades per design, no synthetic dyes. Backed by our heirloom warranty.'
    match = { param($h,$t) $h -match '-(abstract|geometric|designer|solid)$' }
  }
  @{
    slug='solid-rugs'
    title='Solid Rugs'
    longTitle='Solid Rugs Collection'
    metaTitle='Solid Rugs Collection | Pure New Zealand Wool | Rugkari'
    metaDesc='Solid colour pure New Zealand wool rugs by Rugkari. Tonal, minimal, handcrafted in Bhadohi. Free India shipping, heirloom warranty.'
    eyebrow='Quiet Luxury'
    intro='Solid rugs let the wool do the talking. Tonal, minimal, plush. Each piece is handcrafted in pure New Zealand wool for interiors that prefer calm to pattern.'
    image='https://rugkari.com/cdn/shop/collections/15_dba6835d-9a09-487b-a880-dba3672d4cf8.jpg?v=1777704121'
    intro2='Solid rugs are the foundation of layered interiors. They ground furniture without competing, and the unbroken surface lets the texture of pure New Zealand wool become the visual story.'
    intro3='Rugkari solid rugs use single-tone or close-tonal palettes with no synthetic dye contrast. 20mm pile depth, hand-pushed through cotton canvas, woven over 14-18 days in Bhadohi.'
    match = { param($h,$t) $h -match '-solid$' }
  }
  @{
    slug='geometric-rugs'
    title='Geometric Rugs'
    longTitle='Geometric Rugs Collection'
    metaTitle='Geometric Rugs Collection | Pure New Zealand Wool | Rugkari'
    metaDesc='Geometric pure New Zealand wool rugs by Rugkari. Grid, chevron, chronicle and contemporary patterns handcrafted in Bhadohi. Free India shipping, heirloom warranty.'
    eyebrow='Structured Pattern'
    intro='Geometric rugs bring rhythm and architecture to a room. Grids, chevrons, diamonds and contemporary repeats handcrafted in pure New Zealand wool.'
    image='https://rugkari.com/cdn/shop/collections/1_d915f6f3-7df1-49b0-976d-6dddeac823c7.jpg?v=1777703543'
    intro2='Geometric design is the most flexible pattern language in rugs. It works under modern furniture, traditional furniture and everything in between. Scale is the variable that decides the mood: tight repeats for energy, large blocks for calm.'
    intro3='Each Rugkari geometric rug is handcrafted in pure New Zealand wool with a 20mm pile. Patterns are carved with hand-finishing for clean edges and tonal depth.'
    match = { param($h,$t) $h -match '-geometric$' }
  }
  @{
    slug='unshaped-rugs'
    title='Unshaped Rugs'
    longTitle='Unshaped Designer Rugs Collection'
    metaTitle='Unshaped Designer Rugs | Pure New Zealand Wool | Rugkari'
    metaDesc='Unshaped and designer-form pure New Zealand wool rugs by Rugkari. Sculptural silhouettes handcrafted in Bhadohi. Free India shipping, heirloom warranty.'
    eyebrow='Sculptural Forms'
    intro='Unshaped and designer rugs break from the rectangle. Sculptural silhouettes and signature forms in pure New Zealand wool, hand-finished for clean edges.'
    image='https://rugkari.com/cdn/shop/collections/1_482b297d-3954-42f9-9f62-33d2eca3eaf3.jpg?v=1777704523'
    intro2='Unshaped rugs ask a room to make space for them. They sit best as a focal piece, paired with restrained furniture and clean surrounding flooring so the silhouette can read.'
    intro3='Rugkari designer rugs are hand-finished to the outline by master artisans, with pile carving at the perimeter to keep the form crisp. Pure New Zealand wool, heirloom warranty.'
    match = { param($h,$t) $h -match '-designer$' }
  }
  @{
    slug='hand-loom'
    title='Hand-Loom Rugs'
    longTitle='Hand-Loom Rugs Collection'
    metaTitle='Hand-Loom Rugs Collection | Pure New Zealand Wool | Rugkari'
    metaDesc='Handwoven hand-loom pure New Zealand wool rugs by Rugkari. Flatweave and low-pile, handcrafted in Bhadohi. Free India shipping, 10-year warranty.'
    eyebrow='Flatweave Craft'
    intro='Hand-loom rugs are woven, not tufted. Lighter, lower-pile, and naturally reversible $EM ideal for rooms that need a softer footprint with full wool character.'
    image='https://rugkari.com/cdn/shop/collections/Image.png?v=1777704813'
    intro2='Hand-loom (handwoven) construction interlocks warp and weft on a frame loom. The result is a flatter, denser surface than tufted rugs $EM closer in feel to a dhurrie but with the warmth of pure New Zealand wool.'
    intro3='Rugkari hand-loom rugs work well in bedrooms, study areas, and under low-profile furniture where pile depth would interfere. Backed by our 10-year heirloom warranty.'
    match = { param($h,$t) $t -match 'Handwoven' }
  }
  @{
    slug='dining-room-rugs'
    cap=40
    title='Dining Room Rugs'
    longTitle='Dining Room Rugs Collection'
    metaTitle='Dining Room Rugs | Pure New Zealand Wool | Rugkari'
    metaDesc='Dining room pure New Zealand wool rugs by Rugkari. Structured patterns that sit elegantly under a dining table. Free India shipping, heirloom warranty.'
    eyebrow='Under the Table'
    intro='Dining room rugs need to hold a table, six chairs and the foot traffic of every evening. Rugkari dining rugs are handcrafted in pure New Zealand wool with patterns that read at full chair-pull-out width.'
    image='https://rugkari.com/cdn/shop/collections/IMG_5439_JPEG.jpg?v=1777705303'
    intro2='A dining rug is sized to the table, not the room. The rule of thumb: 60cm of rug clearance on every side beyond the table edge so chairs stay on the rug when pulled out. Pattern should read top-down, not just side-on.'
    intro3='Rugkari dining rugs are handcrafted in pure New Zealand wool with 20mm pile, structured pattern language, and edges hand-finished for daily traffic. Spill-cleaning is straightforward with our care kit.'
    match = { param($h,$t) $h -match '-(traditional|geometric)$' }
  }
  @{
    slug='living-room-rugs'
    cap=40
    title='Living Room Rugs'
    longTitle='Living Room Rugs Collection'
    metaTitle='Living Room Rugs | Pure New Zealand Wool | Rugkari'
    metaDesc='Living room pure New Zealand wool rugs by Rugkari. Abstract, geometric, designer and traditional pieces handcrafted in Bhadohi. Free India shipping, heirloom warranty.'
    eyebrow='Anchor the Room'
    intro='The living room rug is the single piece that sets the temperature of the whole room. Rugkari living room rugs are handcrafted in pure New Zealand wool, sized and scaled for Indian sofas and seating.'
    image='https://rugkari.com/cdn/shop/collections/3_31bca7c4-8c7f-4dd2-ab4a-612919a6cfde.jpg?v=1777704931'
    intro2='A living room rug should fit under at least the front legs of the main sofa, with breathing space at the centre table. In Indian homes that often means 8x10 or 9x12; oversized for studios and larger for open-plan layouts.'
    intro3='Rugkari living room rugs use 20mm pile pure New Zealand wool, hand-tufted or hand-knotted in Bhadohi. Pattern language spans abstract, geometric, designer and traditional. Backed by our heirloom warranty.'
    match = { param($h,$t) $h -match '-(abstract|geometric|designer|traditional)$' }
  }
  @{
    slug='bedroom-rugs'
    cap=40
    title='Bedroom Rugs'
    longTitle='Bedroom Rugs Collection'
    metaTitle='Bedroom Rugs | Pure New Zealand Wool | Rugkari'
    metaDesc='Bedroom pure New Zealand wool rugs by Rugkari. Soft solids, abstracts and florals handcrafted in Bhadohi. Free India shipping, heirloom warranty.'
    eyebrow='Quiet Mornings'
    intro='Bedroom rugs are the first thing your feet meet. Rugkari bedroom rugs are handcrafted in pure New Zealand wool with soft solids, abstracts and florals tuned for calm.'
    image='https://rugkari.com/cdn/shop/collections/Emanate_Rug_1.jpg?v=1777705155'
    intro2='A bedroom rug is sized to extend at least 60cm past the sides and foot of the bed so you step onto wool, not bare floor. Calmer pattern languages $EM solids, soft abstracts, gentle florals $EM keep the room restful.'
    intro3='Rugkari bedroom rugs use 20mm pile pure New Zealand wool, hand-tufted in Bhadohi. The pile compresses gently underfoot and rebounds. Backed by our heirloom warranty.'
    match = { param($h,$t) $h -match '-(solid|abstract|floral)$' }
  }
)

# Build productCatalog dynamically from CSV
$productCatalog = @{}
foreach ($k in $csvHandles) {
  $title = $csvTitle[$k]
  $construction = Get-Construction $title
  $shortName = Get-ShortName $title
  $price = if ($csvLowPrice.ContainsKey($k)) { [string]$csvLowPrice[$k] } else { '0' }
  $image = if ($realFirstImage.ContainsKey($k)) { $realFirstImage[$k] } else { '' }
  $productCatalog[$k] = @{
    title  = $shortName
    price  = $price
    vendor = $construction
    slug   = $k + '-pure-new-zealand-wool-rug'
    image  = $image
  }
}

# Populate each collection's product list from CSV via its match script-block.
# Optional .cap limits the number of products shown on heavy room-based pages.
foreach ($c in $collections) {
  $matched = @()
  foreach ($k in $csvHandles) {
    $title = $csvTitle[$k]
    if (& $c.match $k $title) { $matched += $k }
  }
  if ($c.ContainsKey('cap') -and $c.cap -gt 0 -and $matched.Count -gt $c.cap) {
    $matched = $matched | Select-Object -First $c.cap
  }
  $c.products = $matched
}

# Relevant local collections to suggest at the bottom of each page (3 per page).
$relatedMap = @{
  'abstract-rugs'    = @('modern-rugs','geometric-rugs','unshaped-rugs')
  'floral-rugs'      = @('bedroom-rugs','abstract-rugs','solid-rugs')
  'hand-knotted-rugs'= @('hand-tufted-rugs','living-room-rugs','hand-loom')
  'hand-tufted-rugs' = @('hand-knotted-rugs','modern-rugs','living-room-rugs')
  'modern-rugs'      = @('abstract-rugs','geometric-rugs','solid-rugs')
  'solid-rugs'       = @('bedroom-rugs','modern-rugs','hand-loom')
  'geometric-rugs'   = @('modern-rugs','dining-room-rugs','hand-tufted-rugs')
  'unshaped-rugs'    = @('modern-rugs','abstract-rugs','hand-tufted-rugs')
  'hand-loom'        = @('hand-tufted-rugs','solid-rugs','bedroom-rugs')
  'dining-room-rugs' = @('geometric-rugs','hand-knotted-rugs','hand-tufted-rugs')
  'living-room-rugs' = @('hand-tufted-rugs','modern-rugs','geometric-rugs')
  'bedroom-rugs'     = @('solid-rugs','floral-rugs','hand-loom')
}
# Title lookup for related buttons
$titleBySlug = @{}
foreach ($cc in $collections) { $titleBySlug[$cc.slug] = $cc.title }

function Build-RelatedButtonsHtml($slugs) {
  $sb = New-Object System.Text.StringBuilder
  foreach ($s in $slugs) {
    if (-not $titleBySlug.ContainsKey($s)) { continue }
    [void]$sb.AppendLine('      <a href="/collections/' + $s + '.html" class="btn btn-ghost"><span>Explore ' + $titleBySlug[$s] + '</span></a>')
  }
  return $sb.ToString()
}

function Build-ProductCardsHtml($keys) {
  $sb = New-Object System.Text.StringBuilder
  foreach ($k in $keys) {
    $p = $productCatalog[$k]
    if (-not $p) { continue }
    $priceFmt = 'From Rs. {0:N0}' -f [int]$p.price
    [void]$sb.AppendLine('      <a class="product-card" href="/products/' + $p.slug + '.html">')
    [void]$sb.AppendLine('        <img class="card-media" src="' + $p.image + '" alt="' + $p.title + ' ' + $p.vendor + ' Pure New Zealand Wool Rug" width="400" height="500" loading="lazy" />')
    [void]$sb.AppendLine('        <h3 class="card-title">' + $p.title + '</h3>')
    [void]$sb.AppendLine('        <p class="card-price">' + $priceFmt + '</p>')
    [void]$sb.AppendLine('      </a>')
  }
  return $sb.ToString()
}

function Build-ItemListJson($keys, $collectionUrl) {
  $items = @()
  $i = 1
  foreach ($k in $keys) {
    $p = $productCatalog[$k]
    if (-not $p) { continue }
    $items += ('          { "@type": "ListItem", "position": ' + $i + ', "name": "' + $p.title + ' ' + $p.vendor + ' Pure New Zealand Wool Rug", "url": "https://rugs.rugkari.com/products/' + $p.slug + '.html", "image": "' + $p.image + '" }')
    $i++
  }
  return ($items -join ",`r`n")
}

foreach ($c in $collections) {
  $url = 'https://rugs.rugkari.com/collections/' + $c.slug + '.html'
  $productsHtml = Build-ProductCardsHtml $c.products
  $itemListJson = Build-ItemListJson $c.products $url
  $relatedSlugs = if ($relatedMap.ContainsKey($c.slug)) { $relatedMap[$c.slug] } else { @() }
  $relatedHtml = Build-RelatedButtonsHtml $relatedSlugs

  $jsonLd = @'
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
      "name": "Rugkari - The Rug Guide",
      "publisher": { "@id": "https://rugkari.com/#organization" },
      "inLanguage": "en-IN"
    },
    {
      "@type": "CollectionPage",
      "@id": "{{URL}}#webpage",
      "url": "{{URL}}",
      "name": "{{META_TITLE}}",
      "isPartOf": { "@id": "https://rugs.rugkari.com/#website" },
      "description": "{{META_DESC}}",
      "inLanguage": "en-IN",
      "isAccessibleForFree": true,
      "breadcrumb": { "@id": "{{URL}}#breadcrumb" }
    },
    {
      "@type": "BreadcrumbList",
      "@id": "{{URL}}#breadcrumb",
      "itemListElement": [
        { "@type": "ListItem", "position": 1, "name": "Rugkari", "item": "https://rugs.rugkari.com/" },
        { "@type": "ListItem", "position": 2, "name": "Collections", "item": "https://rugs.rugkari.com/" },
        { "@type": "ListItem", "position": 3, "name": "{{TITLE}}", "item": "{{URL}}" }
      ]
    },
    {
      "@type": "ItemList",
      "@id": "{{URL}}#products",
      "name": "{{LONG_TITLE}}",
      "description": "{{META_DESC}}",
      "numberOfItems": {{NUM_ITEMS}},
      "itemListElement": [
{{ITEM_LIST}}
      ]
    }
  ]
}
</script>
'@

  $jsonLd = $jsonLd.Replace('{{URL}}', $url)
  $jsonLd = $jsonLd.Replace('{{META_TITLE}}', $c.metaTitle)
  $jsonLd = $jsonLd.Replace('{{META_DESC}}', $c.metaDesc)
  $jsonLd = $jsonLd.Replace('{{TITLE}}', $c.title)
  $jsonLd = $jsonLd.Replace('{{LONG_TITLE}}', $c.longTitle)
  $jsonLd = $jsonLd.Replace('{{NUM_ITEMS}}', [string]$c.products.Count)
  $jsonLd = $jsonLd.Replace('{{ITEM_LIST}}', $itemListJson)

  $page = @"
<!doctype html>
<html lang="en" prefix="og: https://ogp.me/ns#">
<head>
$gtmAndMeta
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
$sharedHead
$jsonLd
</head>

<body>
$sharedHeader
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
  </div>
</section>

<section class="section">
  <div class="container">
    <p class="eyebrow" style="text-align:center;">The Collection</p>
    <h2 class="section-title">Shop the $($c.title)</h2>
    <div class="product-grid">
$productsHtml    </div>
    <div style="margin-top: 56px; text-align: center;">
      <p class="eyebrow" style="margin-bottom: 18px;">You May Also Like</p>
      <div style="display:flex; flex-wrap:wrap; gap:12px; justify-content:center;">
$relatedHtml      </div>
    </div>
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
        <h3 class="card-title">8 Best Hand-Tufted Rugs for Living Rooms</h3>
        <p class="card-price">Buying Guide</p>
      </a>
      <a class="product-card" href="/hand-tufted-vs-machine-made-rugs">
        <img class="card-media" src="https://cdn.shopify.com/s/files/1/0659/8649/4558/files/1200x1800---cc_plexa_r_c9edf421-09e9-4752-be04-8e0b82194cc0.jpg?v=1777702445" alt="Hand-Tufted vs Machine-Made Rugs" width="400" height="500" loading="lazy" />
        <h3 class="card-title">Hand-Tufted vs Machine-Made Rugs</h3>
        <p class="card-price">Comparison Guide</p>
      </a>
      <a class="product-card" href="/how-to-remove-coffee-stains-from-wool-rugs">
        <img class="card-media" src="https://cdn.shopify.com/s/files/1/0659/8649/4558/files/designer-rugs-bernabeifreeman-contour-lo-wr-1.jpg?v=1777702443" alt="How to remove coffee stains from wool rugs" width="400" height="500" loading="lazy" />
        <h3 class="card-title">Remove Coffee Stains from Wool Rugs</h3>
        <p class="card-price">Care Guide</p>
      </a>
    </div>
  </div>
</section>

</main>
$sharedFooter
</body>
</html>
"@

  $outPath = Join-Path $outDir ($c.slug + '.html')
  [System.IO.File]::WriteAllText($outPath, $page, $utf8NoBom)
  Write-Output ('  generated: ' + $c.slug + '.html')
}

Write-Output ''
Write-Output ('Done. ' + $collections.Count + ' collection pages generated.')

# =============================================================================
# Rugkari footer/utility pages generator.
# Creates 11 local pages with content from rugkari.com, styled to match
# rugs.rugkari.com brand (clean B&W editorial).
# =============================================================================

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$outDir      = Join-Path $projectRoot 'pages'
$utf8NoBom   = New-Object System.Text.UTF8Encoding($false)

$EM = [char]0x2014
$EN = [char]0x2013
$DOT = [char]0x00B7
$RUPEE = [char]0x20B9

if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

# -----------------------------------------------------------------------------
# Shared header/footer markup
# -----------------------------------------------------------------------------
$sharedHeader = @"
<header class="site-header" role="banner">
  <div class="store-note tracking-wider-2">Free Pan-India Shipping $DOT Up to 25-Year Heirloom Warranty</div>
  <div class="mobile-drawer-overlay" id="drawerOverlay" aria-hidden="true"></div>
  <div class="mobile-drawer" id="mobileDrawer" role="dialog" aria-label="Navigation" aria-modal="true">
    <div class="mobile-drawer-header"><span class="mobile-drawer-title">Menu</span><button class="drawer-close-btn" id="drawerClose" aria-label="Close"><svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" fill="none"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg></button></div>
    <nav class="mobile-drawer-nav"><div class="drawer-section"><h5 class="drawer-section-title">Shop by Style</h5><a href="/collections/abstract-rugs.html">Abstract Rugs</a><a href="/collections/floral-rugs.html">Floral Rugs</a><a href="/collections/geometric-rugs.html">Geometric Rugs</a><a href="/collections/modern-rugs.html">Modern Rugs</a><a href="/collections/solid-rugs.html">Solid Rugs</a><a href="/collections/unshaped-rugs.html">Unshaped Rugs</a></div><div class="drawer-section"><h5 class="drawer-section-title">Shop by Craft</h5><a href="/collections/hand-knotted-rugs.html">Hand-Knotted</a><a href="/collections/hand-tufted-rugs.html">Hand-Tufted</a><a href="/collections/hand-loom.html">Hand-Loom</a></div><div class="drawer-section"><h5 class="drawer-section-title">Shop by Room</h5><a href="/collections/living-room-rugs.html">Living Room</a><a href="/collections/bedroom-rugs.html">Bedroom</a><a href="/collections/dining-room-rugs.html">Dining Room</a></div><div class="drawer-section"><h5 class="drawer-section-title">More</h5><a href="/rug-care">Rug Care</a><a href="/heritage">Heritage</a><a href="/pages/contact.html">Contact</a></div></nav>
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
"@

$sharedFooter = @"
<footer class="site-footer" role="contentinfo">
  <div class="container footer-main">
    <div>
      <img class="footer-brand" src="/assets/RUGKARI-LOGO.webp" alt="Rugkari" width="140" height="36" loading="lazy" />
      <p class="footer-since tracking-luxury">Since 1980</p>
      <p class="footer-copy">Handcrafted pure New Zealand wool rugs woven by master artisans in Bhadohi, India.</p>
    </div>
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
    <nav aria-label="Help &amp; Company">
      <h4 class="footer-title">Help &amp; Company</h4>
      <ul class="footer-list">
        <li><a href="/rug-care">Rug Care &amp; Guides</a></li>
        <li><a href="/heritage">Heritage &amp; Story</a></li>
        <li><a href="/pages/rug-warranty.html">Rug Warranty</a></li>
        <li><a href="/pages/track-your-order.html">Track Your Order</a></li>
        <li><a href="/pages/contact.html">Contact</a></li>
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
        <li><a href="/pages/privacy-policy.html">Privacy</a></li>
        <li><a href="/pages/refund-policy.html">Refund</a></li>
        <li><a href="/pages/terms-of-service.html">Terms</a></li>
        <li><a href="/pages/shipping-policy.html">Shipping</a></li>
        <li><a href="/pages/contact.html">Contact</a></li>
      </ul>
    </div>
  </div>
</footer>

<div class="whatsapp" role="complementary"><a class="whatsapp-button" href="https://wa.me/917348515188?text=Hi%20Rugkari" target="_blank" rel="noopener noreferrer" aria-label="WhatsApp"><svg viewBox="0 0 175.216 175.552" aria-hidden="true"><path d="M87.184 0C39.04 0 .002 39.038 0 87.184c0 15.363 4.03 30.37 11.688 43.549L.336 175.552l46.033-11.304c12.683 6.983 26.975 10.663 41.549 10.663 48.142 0 87.184-39.038 87.298-87.184C175.33 39.152 135.33 0 87.184 0zm0 159.893c-13.363 0-26.44-3.594-37.782-10.38l-2.714-1.61-28.138 6.913 7.138-25.883-1.765-2.827C16.83 114.466 13.11 101.059 13.11 87.184 13.11 46.23 46.23 13.11 87.184 13.11c40.13 0 72.781 32.65 72.781 72.782 0 40.953-32.65 74.001-72.781 74.001zm40.009-55.37c-2.196-1.097-12.978-6.394-14.99-7.124-2.012-.73-3.476-1.097-4.94 1.097-1.463 2.194-5.671 7.124-6.952 8.587-1.28 1.462-2.561 1.645-4.757.548-2.196-1.097-9.27-3.41-17.65-10.88-6.524-5.818-10.929-13.004-12.21-15.198-1.28-2.194-.136-3.379 .962-4.472.986-.979 2.196-2.559 3.293-3.838 1.097-1.28 1.463-2.194 2.195-3.657.73-1.462.365-2.742-.183-3.838-.548-1.097-4.94-11.887-6.77-16.28-1.78-4.28-3.592-3.7-4.94-3.762-1.28-.061-2.744-.074-4.208-.074-1.463 0-3.842.548-5.854 2.742-2.012 2.194-7.684 7.49-7.684 18.28 0 10.789 7.867 21.214 8.964 22.676 1.097 1.462 15.479 23.625 37.503 33.146 5.242 2.266 9.333 3.619 12.52 4.633 5.262 1.677 10.053 1.44 13.838.873 4.222-.632 12.978-5.305 14.807-10.425 1.83-5.12 1.83-9.512 1.28-10.425-.548-.913-2.012-1.462-4.208-2.559z" fill="#fff"/></svg></a></div>

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
"@

# -----------------------------------------------------------------------------
# Build-page helper
# -----------------------------------------------------------------------------
function Build-Page {
  param(
    [string]$slug,
    [string]$title,
    [string]$metaDesc,
    [string]$eyebrow,
    [string]$h1,
    [string]$lede,
    [string]$body,
    [string]$breadcrumbName,
    [string]$pageType = 'WebPage',
    [string]$ogImage = '/assets/RUGKARI-LOGO.webp'
  )

  $url = "https://rugs.rugkari.com/pages/$slug.html"

  $jsonLd = @"
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": ["Organization","LocalBusiness"],
      "@id": "https://rugkari.com/#organization",
      "name": "Rugkari",
      "url": "https://rugkari.com/",
      "logo": { "@type": "ImageObject", "@id": "https://rugkari.com/#logo", "url": "/assets/RUGKARI-LOGO.webp" },
      "telephone": "+91-73485-15188",
      "email": "care@rugkari.com",
      "address": { "@type": "PostalAddress", "streetAddress": "Carpet Lane", "addressLocality": "Bhadohi", "addressRegion": "Uttar Pradesh", "postalCode": "221401", "addressCountry": "IN" },
      "sameAs": ["https://www.instagram.com/rugkaari", "https://www.facebook.com/profile.php?id=61583826735546", "https://www.youtube.com/@rugkari", "https://twitter.com/rugkari"]
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
      "@type": "$pageType",
      "@id": "$url#webpage",
      "url": "$url",
      "name": "$title",
      "isPartOf": { "@id": "https://rugs.rugkari.com/#website" },
      "about": { "@id": "https://rugkari.com/#organization" },
      "description": "$metaDesc",
      "inLanguage": "en-IN",
      "isAccessibleForFree": true,
      "breadcrumb": { "@id": "$url#breadcrumb" }
    },
    {
      "@type": "BreadcrumbList",
      "@id": "$url#breadcrumb",
      "itemListElement": [
        { "@type": "ListItem", "position": 1, "name": "Rugkari", "item": "https://rugs.rugkari.com/" },
        { "@type": "ListItem", "position": 2, "name": "$breadcrumbName", "item": "$url" }
      ]
    }
  ]
}
</script>
"@

  return @"
<!doctype html>
<html lang="en" prefix="og: https://ogp.me/ns#">
<head>
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','GTM-5L4Z9CSQ');</script>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="icon" type="image/webp" href="/assets/FEVICON.webp" />
<link rel="apple-touch-icon" href="/assets/FEVICON.webp" />
<title>$title | Rugkari</title>
<meta name="description" content="$metaDesc" />
<meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1" />
<link rel="canonical" href="$url" />
<meta property="og:type" content="website" />
<meta property="og:site_name" content="Rugkari" />
<meta property="og:url" content="$url" />
<meta property="og:title" content="$title $EM Rugkari" />
<meta property="og:description" content="$metaDesc" />
<meta property="og:image" content="$ogImage" />
<meta name="twitter:card" content="summary_large_image" />
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet" />
<link rel="stylesheet" href="/assets/styles.css" />
$jsonLd
</head>
<body>

$sharedHeader

<main id="main-content">

<div class="container">
  <nav class="crumbs" aria-label="Breadcrumb">
    <a href="/">Rugkari</a><span class="sep">/</span>
    <span>$breadcrumbName</span>
  </nav>
</div>

<section class="page-hero">
  <div class="container-narrow">
    <p class="eyebrow tracking-luxury">$eyebrow</p>
    <h1>$h1</h1>
    <p class="lead" style="margin-top: 24px;">$lede</p>
  </div>
</section>

$body

</main>

$sharedFooter

</body>
</html>
"@
}

# -----------------------------------------------------------------------------
# 1. Contact
# -----------------------------------------------------------------------------
$contactBody = @"
<section class="section">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">Every Rug Begins With A Conversation</p>
    <h2 style="text-align:center;">We'd Love to Hear Yours</h2>
    <p style="font-size:17px; line-height:1.8;">Whether you need help with sizing, want to start a commission, are pursuing a trade enquiry, or have a press request $EM the atelier responds within two working days.</p>
  </div>
</section>

<section class="section" style="background: var(--secondary);">
  <div class="container">
    <div style="display:grid; grid-template-columns: repeat(2, 1fr); gap: 48px; max-width: 920px; margin: 0 auto;">

      <div>
        <p class="eyebrow">Atelier</p>
        <h3 style="margin-top: 12px;">The Bhadohi Atelier</h3>
        <p style="font-size:15px; line-height:1.7; color: var(--muted-foreground);">
          Carpet Lane,<br/>
          Bhadohi, Uttar Pradesh<br/>
          221401, India
        </p>
      </div>

      <div>
        <p class="eyebrow">Reach the team</p>
        <h3 style="margin-top: 12px;">Direct contact</h3>
        <p style="font-size:15px; line-height:1.8;">
          <strong>Email:</strong> <a href="mailto:care@rugkari.com" style="text-decoration: underline;">care@rugkari.com</a><br/>
          <strong>Phone:</strong> <a href="tel:+917348515188" style="text-decoration: underline;">+91 73485 15188</a><br/>
          <strong>WhatsApp:</strong> <a href="https://wa.me/917348515188" target="_blank" rel="noopener" style="text-decoration: underline;">+91 73485 15188</a>
        </p>
      </div>

      <div>
        <p class="eyebrow">Atelier hours</p>
        <h3 style="margin-top: 12px;">Open six days</h3>
        <p style="font-size:15px; line-height:1.8;">
          Monday $EN Friday: 10:00 $EN 19:00<br/>
          Saturday: 11:00 $EN 18:00<br/>
          Sunday: By appointment<br/>
          <span style="color: var(--muted-foreground);">(IST, India Standard Time)</span>
        </p>
      </div>

      <div>
        <p class="eyebrow">Social</p>
        <h3 style="margin-top: 12px;">Follow the craft</h3>
        <p style="font-size:15px; line-height:1.8;">
          <a href="https://www.instagram.com/rugkaari" target="_blank" rel="noopener" style="text-decoration: underline;">Instagram</a> $DOT
          <a href="https://www.facebook.com/profile.php?id=61583826735546" target="_blank" rel="noopener" style="text-decoration: underline;">Facebook</a> $DOT
          <a href="https://www.youtube.com/@rugkari" target="_blank" rel="noopener" style="text-decoration: underline;">YouTube</a>
        </p>
      </div>

    </div>
  </div>
</section>

<section class="section">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">Write to the atelier</p>
    <h2 style="text-align:center;">Send a message</h2>
    <p style="text-align:center; color: var(--muted-foreground); margin-bottom: 32px;">For fastest response, please contact us directly on WhatsApp or email.</p>

    <form onsubmit="handleContactSubmit(event)" novalidate style="max-width: 640px; margin: 0 auto; display: grid; gap: 16px;">
      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
        <label style="display: block;">
          <span style="font-size:12px; letter-spacing:.08em; text-transform: uppercase; color: var(--muted-foreground); display: block; margin-bottom: 6px;">Your name</span>
          <input type="text" name="name" required style="width:100%; padding: 12px 14px; border: 1px solid var(--border); font-size: 14px;" />
        </label>
        <label style="display: block;">
          <span style="font-size:12px; letter-spacing:.08em; text-transform: uppercase; color: var(--muted-foreground); display: block; margin-bottom: 6px;">Email</span>
          <input type="email" name="email" required style="width:100%; padding: 12px 14px; border: 1px solid var(--border); font-size: 14px;" />
        </label>
      </div>
      <label style="display: block;">
        <span style="font-size:12px; letter-spacing:.08em; text-transform: uppercase; color: var(--muted-foreground); display: block; margin-bottom: 6px;">Phone (optional)</span>
        <input type="tel" name="phone" style="width:100%; padding: 12px 14px; border: 1px solid var(--border); font-size: 14px;" />
      </label>
      <label style="display: block;">
        <span style="font-size:12px; letter-spacing:.08em; text-transform: uppercase; color: var(--muted-foreground); display: block; margin-bottom: 6px;">Subject</span>
        <select name="subject" required style="width:100%; padding: 12px 14px; border: 1px solid var(--border); font-size: 14px; background:#fff;">
          <option value="">Choose a category</option>
          <option>General enquiry</option>
          <option>Commission</option>
          <option>Trade</option>
          <option>Press</option>
          <option>Other</option>
        </select>
      </label>
      <label style="display: block;">
        <span style="font-size:12px; letter-spacing:.08em; text-transform: uppercase; color: var(--muted-foreground); display: block; margin-bottom: 6px;">Message</span>
        <textarea name="message" rows="5" required style="width:100%; padding: 12px 14px; border: 1px solid var(--border); font-size: 14px; font-family: inherit; resize: vertical;"></textarea>
      </label>
      <button type="submit" class="btn" style="justify-self: start;"><span>Send message</span></button>
    </form>
  </div>
</section>

<script>
  function handleContactSubmit(e) {
    e.preventDefault();
    var form = e.target;
    var name = form.elements['name'].value;
    var subject = form.elements['subject'].value;
    var msg = form.elements['message'].value;
    var waText = encodeURIComponent('Hi Rugkari! ' + name + ' here. Subject: ' + subject + '. ' + msg);
    window.open('https://wa.me/917348515188?text=' + waText, '_blank');
  }
</script>
"@

# -----------------------------------------------------------------------------
# 2. The Founder
# -----------------------------------------------------------------------------
$founderBody = @"
<section class="section">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">The Person</p>
    <h2 style="text-align:center;">Amit Kumar</h2>
    <p style="font-size:17px; line-height:1.8;">Amit Kumar founded Rugkari with one conviction: that a rug should be made the way it was always meant to be made $EM by patient hands, from natural fibres, designed to outlive seasons. His expertise stems from manufacturing experience rather than sales alone. His understanding of materials, proportions, and surface quality reflects years of practical training in the craft of rug-making at the loom.</p>
  </div>
</section>

<section class="section" style="background: var(--secondary);">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">The Lineage</p>
    <h2 style="text-align:center;">Third generation craft</h2>
    <p style="font-size:17px; line-height:1.8;">Amit carries forward inherited knowledge refined through three generations of family involvement in the Bhadohi$EN Mirzapur carpet region. The brand's tagline says it simply: <em>Legacy in craft. Since 1980. Exported worldwide. Now in India.</em></p>
  </div>
</section>

<section class="section">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">Four Pillars of Origin</p>
    <h2 style="text-align:center;">What Rugkari stands on</h2>

    <div style="margin-top: 40px; display:grid; gap: 24px;">
      <div style="display: grid; grid-template-columns: 48px 1fr; gap: 20px;">
        <span style="font-family: 'Cormorant Garamond', Georgia, serif; font-size: 36px; line-height: 1; color: var(--muted-foreground);">01</span>
        <div><h3 style="margin: 0 0 8px;">Born from the carpet city belt</h3><p>Bhadohi and Mirzapur represent India's handmade rug heritage, shaped by Persian influence and refined by generations of skill.</p></div>
      </div>
      <div style="display: grid; grid-template-columns: 48px 1fr; gap: 20px;">
        <span style="font-family: 'Cormorant Garamond', Georgia, serif; font-size: 36px; line-height: 1; color: var(--muted-foreground);">02</span>
        <div><h3 style="margin: 0 0 8px;">From manufacturing to brand</h3><p>Rugkari transitions maker-side expertise directly to Indian consumers, without the markups of intermediaries.</p></div>
      </div>
      <div style="display: grid; grid-template-columns: 48px 1fr; gap: 20px;">
        <span style="font-family: 'Cormorant Garamond', Georgia, serif; font-size: 36px; line-height: 1; color: var(--muted-foreground);">03</span>
        <div><h3 style="margin: 0 0 8px;">Craft with modern restraint</h3><p>The brand balances traditional techniques with contemporary design $EM abstract, geometric, floral, and traditional all within one editorial language.</p></div>
      </div>
      <div style="display: grid; grid-template-columns: 48px 1fr; gap: 20px;">
        <span style="font-family: 'Cormorant Garamond', Georgia, serif; font-size: 36px; line-height: 1; color: var(--muted-foreground);">04</span>
        <div><h3 style="margin: 0 0 8px;">Built for Indian homes</h3><p>Every product addresses specific Indian interior contexts: marble floors, apartment proportions, and the rhythms of family living.</p></div>
      </div>
    </div>
  </div>
</section>

<section class="section" style="background: var(--secondary);">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">Core Values</p>
    <h2 style="text-align:center;">What we will not compromise on</h2>
    <ul style="margin-top: 32px; font-size: 16px; line-height: 1.8; list-style: none; padding: 0;">
      <li style="padding: 16px 0; border-bottom: 1px solid var(--border);"><strong>Material honesty</strong> $EM Premium pure New Zealand wool. No blends, no shortcuts, no synthetic substitutes.</li>
      <li style="padding: 16px 0; border-bottom: 1px solid var(--border);"><strong>Artisan respect</strong> $EM Every rug hand-crafted using traditional techniques. Fair wages. No mass production.</li>
      <li style="padding: 16px 0; border-bottom: 1px solid var(--border);"><strong>Maker-direct trust</strong> $EM Direct accountability from the loom to your living room. No layers of middlemen.</li>
      <li style="padding: 16px 0;"><strong>Custom capability</strong> $EM Bespoke rugs to your specifications, at the same per-square-foot rate as standard catalog.</li>
    </ul>
  </div>
</section>

<section class="section" style="background: var(--foreground); color: #fff;">
  <div class="container-narrow" style="text-align:center;">
    <p class="eyebrow" style="color: rgba(255,255,255,0.65);">Founding Philosophy</p>
    <h2 style="color: #fff; max-width: 600px; margin: 16px auto 0;">"Rugkari is not just a rug store. It is a way to bring the maker's eye back into the home."</h2>
    <p style="color: rgba(255,255,255,0.85); margin-top: 32px; font-size: 13px; letter-spacing: 0.18em; text-transform: uppercase;">$EM Amit Kumar, Founder</p>
  </div>
</section>
"@

# -----------------------------------------------------------------------------
# 3. The Carpet City
# -----------------------------------------------------------------------------
$carpetCityBody = @"
<section class="section">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">Bhadohi, Uttar Pradesh, India</p>
    <h2 style="text-align:center;">The carpet city of the world</h2>
    <p style="font-size:17px; line-height:1.8;">Where every knot holds a century of memory, and every thread is woven by hands that carry forward a living tradition. Bhadohi is not only a place. It is one of India's most important carpet identities.</p>
  </div>
</section>

<section class="section" style="background: var(--secondary);">
  <div class="container">
    <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 32px; max-width: 920px; margin: 0 auto; text-align: center;">
      <div>
        <p style="font-family: 'Cormorant Garamond', Georgia, serif; font-size: 56px; line-height: 1; margin: 0;">400+</p>
        <p style="font-size: 11px; letter-spacing: .18em; text-transform: uppercase; color: var(--muted-foreground); margin-top: 12px;">Years of legacy</p>
      </div>
      <div>
        <p style="font-family: 'Cormorant Garamond', Georgia, serif; font-size: 56px; line-height: 1; margin: 0;">22 L</p>
        <p style="font-size: 11px; letter-spacing: .18em; text-transform: uppercase; color: var(--muted-foreground); margin-top: 12px;">Artisans employed</p>
      </div>
      <div>
        <p style="font-family: 'Cormorant Garamond', Georgia, serif; font-size: 56px; line-height: 1; margin: 0;">75%</p>
        <p style="font-size: 11px; letter-spacing: .18em; text-transform: uppercase; color: var(--muted-foreground); margin-top: 12px;">India's carpet exports</p>
      </div>
      <div>
        <p style="font-family: 'Cormorant Garamond', Georgia, serif; font-size: 56px; line-height: 1; margin: 0;">GI</p>
        <p style="font-size: 11px; letter-spacing: .18em; text-transform: uppercase; color: var(--muted-foreground); margin-top: 12px;">Certified 2010</p>
      </div>
    </div>
  </div>
</section>

<section class="section">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">Historical Foundation</p>
    <h2 style="text-align:center;">A craft that arrived in the 16th century</h2>
    <p style="font-size:17px; line-height:1.8;">Bhadohi's carpet tradition began under Emperor Akbar's patronage in the 16th century, when Persian master weavers travelled to India and established looms in the region. Over centuries, they blended Persian techniques with Indian motifs and dyes to create a style distinctively Bhadohi $EM neither purely Persian nor purely Mughal, but something refined and original.</p>
  </div>
</section>

<section class="section" style="background: var(--secondary);">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">Three Pillars</p>
    <h2 style="text-align:center;">What Bhadohi stands for</h2>
    <div style="margin-top: 40px; display:grid; gap: 32px;">
      <div>
        <h3>Hand-knotted mastery</h3>
        <p>Thousands of knots per square foot, each tied by hand. A premium hand-knotted Bhadohi rug can reach 300 knots per square inch (KPSI), achieving heirloom-grade density.</p>
      </div>
      <div>
        <h3>Generational knowledge</h3>
        <p>Techniques are taught grandparent to grandchild. There are no industrial training programmes for this craft $EM only families who have passed it down for generations.</p>
      </div>
      <div>
        <h3>A fusion of worlds</h3>
        <p>Persian geometry meets Indian mythology, Mughal florals meet contemporary editorial design. Bhadohi is where these traditions live together on one loom.</p>
      </div>
    </div>
  </div>
</section>

<section class="section">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">National Recognition</p>
    <h2 style="text-align:center;">From Bhadohi to India's Parliament</h2>
    <p style="font-size:17px; line-height:1.8;">Over 900 Bhadohi artisans created the carpets that line India's Parliament building $EM more than 35,000 square feet of hand-woven craft. In 2010, Bhadohi received Geographical Indication (GI) certification, formally recognising the region's unique role in India's textile heritage.</p>
  </div>
</section>

<section class="section" style="background: var(--foreground); color: #fff;">
  <div class="container-narrow" style="text-align:center;">
    <p class="eyebrow" style="color: rgba(255,255,255,0.65);">Rugkari Roots</p>
    <h2 style="color: #fff;">Born here. Made here. Always.</h2>
    <p style="color: rgba(255,255,255,0.85); font-size:17px; line-height:1.8; margin-top: 24px;">Rugkari is from Bhadohi. Founded in 1980 within this living tradition, we don't outsource. Our weavers learned from their parents and their parents before that. Every rug you receive is made entirely here, by hands that carry centuries of skill.</p>
  </div>
</section>
"@

# -----------------------------------------------------------------------------
# 4. The Art
# -----------------------------------------------------------------------------
$artBody = @"
<section class="section">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">The Art of Making</p>
    <h2 style="text-align:center;">A Rugkari carpet is not manufactured. It is created.</h2>
    <p style="font-size:17px; line-height:1.8;">From raw fibre to finished piece, every Rugkari rug passes through six stages in our Bhadohi atelier $EM each one shaped by techniques refined over centuries. The process is slow on purpose. It is what separates a rug that lasts decades from one that lasts seasons.</p>
  </div>
</section>

<section class="section" style="background: var(--secondary);">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">Every stage matters</p>
    <h2 style="text-align:center;">Six steps from fibre to floor</h2>

    <div style="margin-top: 40px; display:grid; gap: 40px;">

      <div style="display: grid; grid-template-columns: 60px 1fr; gap: 20px;">
        <span style="font-family: 'Cormorant Garamond', Georgia, serif; font-size: 42px; line-height: 1; color: var(--muted-foreground);">01</span>
        <div>
          <h3 style="margin: 0 0 12px;">Design &amp; Pattern Making</h3>
          <p>Designers sketch each pattern on graph paper $EM what artisans call the <em>Talim</em>. Every square on the Talim represents one knot. A complex hand-knotted design can take days of drafting before a single thread is dyed.</p>
        </div>
      </div>

      <div style="display: grid; grid-template-columns: 60px 1fr; gap: 20px;">
        <span style="font-family: 'Cormorant Garamond', Georgia, serif; font-size: 42px; line-height: 1; color: var(--muted-foreground);">02</span>
        <div>
          <h3 style="margin: 0 0 12px;">Material Selection</h3>
          <p>Premium natural fibres only: pure New Zealand wool for warmth and resilience, cotton for structural foundation, silk for surface lustre, and jute for low-pile texture. Every fibre is hand-selected against our quality benchmarks.</p>
        </div>
      </div>

      <div style="display: grid; grid-template-columns: 60px 1fr; gap: 20px;">
        <span style="font-family: 'Cormorant Garamond', Georgia, serif; font-size: 42px; line-height: 1; color: var(--muted-foreground);">03</span>
        <div>
          <h3 style="margin: 0 0 12px;">Dyeing &amp; Colour</h3>
          <p>Fibres are dyed in controlled batches using natural and azo-free reactive dyes. Each colour batch is tested for colourfastness against fading, light and gentle washing before it ever reaches the loom.</p>
        </div>
      </div>

      <div style="display: grid; grid-template-columns: 60px 1fr; gap: 20px;">
        <span style="font-family: 'Cormorant Garamond', Georgia, serif; font-size: 42px; line-height: 1; color: var(--muted-foreground);">04</span>
        <div>
          <h3 style="margin: 0 0 12px;">Weaving &amp; Knotting</h3>
          <p>Three weaving methods, depending on the rug:</p>
          <ul style="margin-top: 12px;">
            <li><strong>Hand-knotted</strong> $EN 100$EN 500+ knots per square foot, each tied individually by hand.</li>
            <li><strong>Hand-tufted</strong> $EN yarn pushed through canvas using a tufting gun, secured with latex.</li>
            <li><strong>Hand-loom</strong> $EN flat-weave techniques on traditional pit looms.</li>
          </ul>
        </div>
      </div>

      <div style="display: grid; grid-template-columns: 60px 1fr; gap: 20px;">
        <span style="font-family: 'Cormorant Garamond', Georgia, serif; font-size: 42px; line-height: 1; color: var(--muted-foreground);">05</span>
        <div>
          <h3 style="margin: 0 0 12px;">Washing &amp; Finishing</h3>
          <p>Rugs are washed, stretched, dried in shade, then clipped by hand to achieve even pile height. Edges are bound by hand $EN no mechanical edge finishing.</p>
        </div>
      </div>

      <div style="display: grid; grid-template-columns: 60px 1fr; gap: 20px;">
        <span style="font-family: 'Cormorant Garamond', Georgia, serif; font-size: 42px; line-height: 1; color: var(--muted-foreground);">06</span>
        <div>
          <h3 style="margin: 0 0 12px;">Quality Check &amp; Dispatch</h3>
          <p>Each finished rug passes a final inspection $EN pile consistency, pattern accuracy, colour uniformity, structural integrity. Only then is it rolled, wrapped, and shipped to your home.</p>
        </div>
      </div>

    </div>
  </div>
</section>

<section class="section" style="background: var(--foreground); color: #fff;">
  <div class="container-narrow" style="text-align:center;">
    <p class="eyebrow" style="color: rgba(255,255,255,0.65);">What arrives at your door</p>
    <h2 style="color: #fff;">Weeks of skilled labour. Generations of knowledge. One rug.</h2>
    <p style="color: rgba(255,255,255,0.85); margin-top: 24px; font-size: 17px; line-height: 1.8;">A 6$DOT 9 ft hand-tufted Rugkari rug takes 14$EN 18 days of continuous work by a single artisan. A 200 KPSI hand-knotted rug takes 6$EN 8 months. What arrives at your door is the result of weeks of skilled labour, generations of knowledge, and an unwavering commitment to <em>craft</em>.</p>
  </div>
</section>
"@

# -----------------------------------------------------------------------------
# 5. Stain Repellent
# -----------------------------------------------------------------------------
$stainBody = @"
<section class="section">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">Optional Treatment</p>
    <h2 style="text-align:center;">Protection that stays quiet</h2>
    <p style="font-size:17px; line-height:1.8;">Spilled chai. Muddy shoes. Pet paws. The Rugkari stain repellent is a professional-grade treatment applied after weaving $EN an invisible shield that gives you extra time to clean up before a spill becomes a permanent mark. The coating does not change the look, feel, or breathability of your rug.</p>
  </div>
</section>

<section class="section" style="background: var(--secondary);">
  <div class="container">
    <div style="display:grid; grid-template-columns: repeat(3, 1fr); gap: 32px; max-width: 920px; margin: 0 auto;">
      <div style="text-align:center;">
        <p style="font-family: 'Cormorant Garamond', Georgia, serif; font-size: 56px; line-height: 1; margin: 0;">1$EN 2</p>
        <p style="font-size: 11px; letter-spacing: .18em; text-transform: uppercase; color: var(--muted-foreground); margin-top: 12px;">Years of protection</p>
      </div>
      <div style="text-align:center;">
        <p style="font-family: 'Cormorant Garamond', Georgia, serif; font-size: 56px; line-height: 1; margin: 0;">100%</p>
        <p style="font-size: 11px; letter-spacing: .18em; text-transform: uppercase; color: var(--muted-foreground); margin-top: 12px;">Non-toxic, pet-safe</p>
      </div>
      <div style="text-align:center;">
        <p style="font-family: 'Cormorant Garamond', Georgia, serif; font-size: 56px; line-height: 1; margin: 0;">$EM</p>
        <p style="font-size: 11px; letter-spacing: .18em; text-transform: uppercase; color: var(--muted-foreground); margin-top: 12px;">Invisible, no texture change</p>
      </div>
    </div>
  </div>
</section>

<section class="section">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">Covered Against</p>
    <h2 style="text-align:center;">What the shield handles</h2>
    <ul style="margin-top: 32px; font-size: 16px; line-height: 1.8; list-style: none; padding: 0; max-width: 480px; margin-left: auto; margin-right: auto;">
      <li style="padding: 14px 0; border-bottom: 1px solid var(--border);">Tea, coffee and juice</li>
      <li style="padding: 14px 0; border-bottom: 1px solid var(--border);">Food stains and oil splatters</li>
      <li style="padding: 14px 0; border-bottom: 1px solid var(--border);">Muddy footprints</li>
      <li style="padding: 14px 0; border-bottom: 1px solid var(--border);">Pet accidents</li>
      <li style="padding: 14px 0;">Everyday dirt and grime</li>
    </ul>
  </div>
</section>

<section class="section" style="background: var(--secondary);">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">If A Spill Happens</p>
    <h2 style="text-align:center;">The 5-step response</h2>
    <ol style="margin-top: 32px; font-size: 16px; line-height: 1.8; padding-left: 24px;">
      <li style="margin: 12px 0;"><strong>Act quickly</strong> $EN blot immediately with a clean white cloth.</li>
      <li style="margin: 12px 0;"><strong>Work inward</strong> $EN from outer edges toward the centre to prevent spreading.</li>
      <li style="margin: 12px 0;"><strong>Absorb first</strong> $EN soak the spill with a dry cloth before adding any liquid.</li>
      <li style="margin: 12px 0;"><strong>Gentle clean</strong> $EN if needed, use mild wool-safe soap with cold water.</li>
      <li style="margin: 12px 0;"><strong>Air dry</strong> $EN never use a hairdryer or steam.</li>
    </ol>
  </div>
</section>

<section class="section">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">What To Avoid</p>
    <h2 style="text-align:center;">Even with the shield, please don't</h2>
    <ul style="margin-top: 32px; font-size: 16px; line-height: 1.8; list-style: none; padding: 0;">
      <li style="padding: 14px 0; border-bottom: 1px solid var(--border);">Scrub or aggressively rub the rug surface.</li>
      <li style="padding: 14px 0; border-bottom: 1px solid var(--border);">Use bleach, hydrogen peroxide, enzyme cleaners or harsh chemicals.</li>
      <li style="padding: 14px 0; border-bottom: 1px solid var(--border);">Skip professional cleaning. A wool-safe deep clean every 12$EN 18 months is recommended.</li>
      <li style="padding: 14px 0;">Treat it as fully stain-proof. The shield buys time $EM prompt action remains essential.</li>
    </ul>
  </div>
</section>

<section class="section" style="background: var(--foreground); color: #fff;">
  <div class="container-narrow" style="text-align:center;">
    <p class="eyebrow" style="color: rgba(255,255,255,0.65);">Availability</p>
    <h2 style="color: #fff;">Beauty that's truly built to last</h2>
    <p style="color: rgba(255,255,255,0.85); font-size:17px; line-height:1.8; margin-top: 24px;">The stain repellent treatment is available as an optional add-on at purchase for most Rugkari rugs. Look for the <em>Stain Repellent</em> badge on eligible products. To enquire for a custom rug, message us on WhatsApp.</p>
    <p style="margin-top: 32px;"><a class="btn btn-ghost" style="border-color: #fff; color: #fff;" href="https://wa.me/917348515188?text=Hi%20Rugkari%2C%20I%27d%20like%20to%20add%20stain%20repellent%20treatment%20to%20my%20order." target="_blank" rel="noopener"><span>Ask on WhatsApp</span></a></p>
  </div>
</section>
"@

# -----------------------------------------------------------------------------
# 6. Rug Warranty
# -----------------------------------------------------------------------------
$warrantyBody = @"
<section class="section">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">Our Promise</p>
    <h2 style="text-align:center;">We stand behind every rug</h2>
    <p style="font-size:17px; line-height:1.8;">Every Rugkari rug is hand-crafted by master artisans in Bhadohi and inspected before dispatch. If something goes wrong because of how it was made, we will repair or replace it $EM at no cost to you. Made with care. Backed by our word.</p>
  </div>
</section>

<section class="section" style="background: var(--secondary);">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">Warranty Coverage</p>
    <h2 style="text-align:center;">By rug type</h2>
    <table style="width:100%; border-collapse:collapse; margin-top:32px; font-size:15px;">
      <thead>
        <tr style="border-bottom: 2px solid var(--foreground);">
          <th style="text-align:left; padding:14px 12px;">Rug type</th>
          <th style="text-align:right; padding:14px 12px;">Warranty</th>
        </tr>
      </thead>
      <tbody>
        <tr><td style="padding:14px 12px; border-bottom:1px solid var(--border);">Hand-Knotted Rugs</td><td style="padding:14px 12px; border-bottom:1px solid var(--border); text-align:right;">25 Years</td></tr>
        <tr><td style="padding:14px 12px; border-bottom:1px solid var(--border);">Hand-Tufted Rugs</td><td style="padding:14px 12px; border-bottom:1px solid var(--border); text-align:right;">10 Years</td></tr>
        <tr><td style="padding:14px 12px; border-bottom:1px solid var(--border);">Hand-Loom and Dhurrie Rugs</td><td style="padding:14px 12px; border-bottom:1px solid var(--border); text-align:right;">10 Years</td></tr>
        <tr><td style="padding:14px 12px;">Custom Orders</td><td style="padding:14px 12px; text-align:right;">Same as equivalent rug type</td></tr>
      </tbody>
    </table>
  </div>
</section>

<section class="section">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">What Is Covered</p>
    <h2 style="text-align:center;">Manufacturing defects only</h2>

    <div style="margin-top: 40px; display:grid; gap: 24px;">
      <div>
        <h3>01 $DOT Structural Defects $EM Weaving Integrity</h3>
        <p>Loose weaving, unravelling edges, or knots coming apart under normal use are covered.</p>
      </div>
      <div>
        <h3>02 $DOT Colour Defects $EM Colour Stability</h3>
        <p>Significant fading or bleeding without exposure to sunlight or chemicals is covered.</p>
      </div>
      <div>
        <h3>03 $DOT Size Discrepancy $EM Measured Accuracy</h3>
        <p>Rug dimensions varying more than 2% from the stated size are covered.</p>
      </div>
      <div>
        <h3>04 $DOT Pattern Defects $EM Production Accuracy</h3>
        <p>Noticeable deviation from the product image caused during production is covered.</p>
      </div>
    </div>
  </div>
</section>

<section class="section" style="background: var(--secondary);">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">What Is Not Covered</p>
    <h2 style="text-align:center;">Outside the warranty</h2>
    <ul style="margin-top: 32px; font-size: 16px; line-height: 1.8; list-style: none; padding: 0;">
      <li style="padding: 14px 0; border-bottom: 1px solid var(--border);"><strong>Normal wear and tear</strong> from everyday use over time.</li>
      <li style="padding: 14px 0; border-bottom: 1px solid var(--border);"><strong>Improper cleaning</strong> or use of harsh chemicals.</li>
      <li style="padding: 14px 0; border-bottom: 1px solid var(--border);"><strong>Colour changes</strong> caused by prolonged direct sunlight exposure.</li>
      <li style="padding: 14px 0; border-bottom: 1px solid var(--border);"><strong>Physical damage</strong> $EM cuts, burns, pet damage, water damage.</li>
      <li style="padding: 14px 0; border-bottom: 1px solid var(--border);"><strong>Care instruction failure</strong> $EM damage caused by not following Rugkari care guidance.</li>
      <li style="padding: 14px 0;"><strong>Commercial or heavy-traffic use</strong> beyond the rug's intended residential use.</li>
    </ul>
  </div>
</section>

<section class="section">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">Claim Process</p>
    <h2 style="text-align:center;">Four steps. Reviewed within 48 hours.</h2>

    <div style="margin-top: 40px; display:grid; gap: 24px;">
      <div style="display: grid; grid-template-columns: 48px 1fr; gap: 20px;">
        <span style="font-family: 'Cormorant Garamond', Georgia, serif; font-size: 36px; line-height: 1; color: var(--muted-foreground);">01</span>
        <div><h3 style="margin: 0 0 8px;">Contact Rugkari</h3><p>Email <a href="mailto:care@rugkari.com" style="text-decoration: underline;">care@rugkari.com</a> or call <a href="tel:+917348515188" style="text-decoration: underline;">+91 73485 15188</a> within the warranty period.</p></div>
      </div>
      <div style="display: grid; grid-template-columns: 48px 1fr; gap: 20px;">
        <span style="font-family: 'Cormorant Garamond', Georgia, serif; font-size: 36px; line-height: 1; color: var(--muted-foreground);">02</span>
        <div><h3 style="margin: 0 0 8px;">Share details</h3><p>Send your order number and 2$EN 3 clear photographs of the defect so our team can verify the issue properly.</p></div>
      </div>
      <div style="display: grid; grid-template-columns: 48px 1fr; gap: 20px;">
        <span style="font-family: 'Cormorant Garamond', Georgia, serif; font-size: 36px; line-height: 1; color: var(--muted-foreground);">03</span>
        <div><h3 style="margin: 0 0 8px;">Review within 48 hours</h3><p>Our team will review your claim within 48 hours and confirm the next step.</p></div>
      </div>
      <div style="display: grid; grid-template-columns: 48px 1fr; gap: 20px;">
        <span style="font-family: 'Cormorant Garamond', Georgia, serif; font-size: 36px; line-height: 1; color: var(--muted-foreground);">04</span>
        <div><h3 style="margin: 0 0 8px;">Repair or replacement</h3><p>If approved, Rugkari will arrange pickup and either repair or replace the rug at no additional cost to you.</p></div>
      </div>
    </div>
  </div>
</section>

<section class="section" style="background: var(--foreground); color: #fff;">
  <div class="container-narrow" style="text-align:center;">
    <p class="eyebrow" style="color: rgba(255,255,255,0.65);">Our Commitment</p>
    <h2 style="color: #fff;">Buy with confidence</h2>
    <p style="color: rgba(255,255,255,0.85); font-size:17px; line-height:1.8; margin-top: 24px;">A Rugkari rug is an heirloom investment. The warranty covers manufacturing $EM but our reputation covers everything else. If you ever have a concern about any Rugkari rug, we want to hear about it.</p>
    <p style="margin-top: 32px;"><a class="btn btn-ghost" style="border-color: #fff; color: #fff;" href="/pages/contact.html"><span>File a warranty claim</span></a></p>
  </div>
</section>
"@

# -----------------------------------------------------------------------------
# 7. Track Your Order
# -----------------------------------------------------------------------------
$trackBody = @"
<section class="section">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">Order Care</p>
    <h2 style="text-align:center;">Know where your rug is</h2>
    <p style="font-size:17px; line-height:1.8;">Once your order ships, a tracking link is sent to you via WhatsApp and email. If you can't find it, you can also check your order status by contacting our team directly $EM we respond within working hours.</p>
  </div>
</section>

<section class="section" style="background: var(--secondary);">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">Three Ways To Track</p>
    <h2 style="text-align:center;">Pick what's easiest</h2>

    <div style="margin-top: 40px; display:grid; gap: 24px;">
      <div style="background:#fff; padding: 28px; border: 1px solid var(--border);">
        <h3 style="margin: 0 0 12px;">01 $DOT Check WhatsApp / Email</h3>
        <p>Your order confirmation and tracking ID are sent via WhatsApp and email the moment your rug ships. Search your inbox for "Rugkari" or check your WhatsApp message thread with our team.</p>
      </div>
      <div style="background:#fff; padding: 28px; border: 1px solid var(--border);">
        <h3 style="margin: 0 0 12px;">02 $DOT WhatsApp the atelier</h3>
        <p>Send us your order number on WhatsApp and we will reply with the latest tracking status within working hours.</p>
        <p style="margin-top: 16px;"><a class="btn btn-ghost" href="https://wa.me/917348515188?text=Hi%20Rugkari%2C%20I%27d%20like%20to%20track%20my%20order.%20Order%20number%3A%20" target="_blank" rel="noopener"><span>Open WhatsApp</span></a></p>
      </div>
      <div style="background:#fff; padding: 28px; border: 1px solid var(--border);">
        <h3 style="margin: 0 0 12px;">03 $DOT Email customer care</h3>
        <p>Email <a href="mailto:care@rugkari.com" style="text-decoration:underline;">care@rugkari.com</a> with your order number and we will share the latest status.</p>
      </div>
    </div>
  </div>
</section>

<section class="section">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">Production &amp; Delivery Times</p>
    <h2 style="text-align:center;">What's typical</h2>

    <table style="width:100%; border-collapse:collapse; margin-top:32px; font-size:15px;">
      <thead>
        <tr style="border-bottom: 2px solid var(--foreground);">
          <th style="text-align:left; padding:14px 12px;">Stage</th>
          <th style="text-align:right; padding:14px 12px;">Timeline</th>
        </tr>
      </thead>
      <tbody>
        <tr><td style="padding:14px 12px; border-bottom:1px solid var(--border);">Hand-tufted production</td><td style="padding:14px 12px; border-bottom:1px solid var(--border); text-align:right;">10$EN 12 working days</td></tr>
        <tr><td style="padding:14px 12px; border-bottom:1px solid var(--border);">Hand-knotted production</td><td style="padding:14px 12px; border-bottom:1px solid var(--border); text-align:right;">30$EN 35 working days</td></tr>
        <tr><td style="padding:14px 12px; border-bottom:1px solid var(--border);">Dhurrie / Flat-weave production</td><td style="padding:14px 12px; border-bottom:1px solid var(--border); text-align:right;">15$EN 20 working days</td></tr>
        <tr><td style="padding:14px 12px; border-bottom:1px solid var(--border);">Standard delivery (post-dispatch)</td><td style="padding:14px 12px; border-bottom:1px solid var(--border); text-align:right;">5$EN 7 working days</td></tr>
        <tr><td style="padding:14px 12px;">Express delivery (post-dispatch)</td><td style="padding:14px 12px; text-align:right;">2$EN 4 working days</td></tr>
      </tbody>
    </table>

    <p style="margin-top:24px; color: var(--muted-foreground); font-size:14px; text-align:center;">In-stock rugs typically dispatch within 1$EN 2 working days. Custom and made-to-order pieces follow the production timeline above.</p>
  </div>
</section>

<section class="section" style="background: var(--secondary);">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">Common Questions</p>
    <h2 style="text-align:center;">Quick answers</h2>
    <div class="faq-list" style="margin-top: 32px;">
      <details>
        <summary class="faq-question">My order hasn't shipped yet $EM what should I do?</summary>
        <div class="faq-answer">In-stock orders typically dispatch within 1$EN 2 working days. Custom and made-to-order rugs follow the production timeline (10$EN 35 working days depending on construction). If it has been longer than expected, WhatsApp our team with your order number and we'll check on it.</div>
      </details>
      <details>
        <summary class="faq-question">My package looks tampered with $EM what do I do?</summary>
        <div class="faq-answer">Do not accept delivery. Refuse the package at the door and immediately WhatsApp or email us with photographs. We will arrange a replacement at no cost.</div>
      </details>
      <details>
        <summary class="faq-question">I need urgent help with my order. How do I reach you?</summary>
        <div class="faq-answer">WhatsApp <a href="https://wa.me/917348515188" target="_blank" rel="noopener" style="text-decoration:underline;">+91 73485 15188</a> for fastest response (Mon$EN Sat, 10:00$EN 18:00 IST). For non-urgent matters, email <a href="mailto:care@rugkari.com" style="text-decoration:underline;">care@rugkari.com</a>.</div>
      </details>
    </div>
  </div>
</section>
"@

# -----------------------------------------------------------------------------
# 8. Privacy Policy
# -----------------------------------------------------------------------------
$privacyBody = @"
<section class="section">
  <div class="container-narrow article-body" style="max-width:760px;">
    <p style="color: var(--muted-foreground); font-size: 14px; text-transform: uppercase; letter-spacing: 0.08em;">Last updated: 2 May 2026</p>

    <p style="font-size: 16px; line-height: 1.8; margin-top: 16px;">Rugkari ("we", "us", "our") operates this store and website, including all related information, content, features, tools, products and services (collectively, the "Services"), in order to provide you, the customer, with a curated shopping experience. Our Services are powered by Shopify.</p>

    <p style="font-size: 16px; line-height: 1.8;">By accessing the Services, you acknowledge that you have read and understood the information collection and disclosure practices outlined in this Privacy Policy.</p>

    <h2>Information We Collect</h2>
    <p>We may collect the following categories of information:</p>
    <ul>
      <li><strong>Contact details</strong> $EM name, address, phone, email.</li>
      <li><strong>Financial information</strong> $EM payment card details, transaction data.</li>
      <li><strong>Account information</strong> $EM username, password, preferences.</li>
      <li><strong>Transaction information</strong> $EM items viewed, purchased, returned.</li>
      <li><strong>Communications</strong> $EM messages exchanged with customer support.</li>
      <li><strong>Device information</strong> $EM IP address, browser data, device identifiers.</li>
      <li><strong>Usage information</strong> $EM how you interact with the Services.</li>
    </ul>

    <h2>How We Collect Information</h2>
    <p>Information is collected through: direct user provision, automatic collection through the Services and cookies, our service providers, and business partners or third parties.</p>

    <h2>How We Use Your Information</h2>
    <p>We use collected information to:</p>
    <ul>
      <li>Provide and personalise our Services.</li>
      <li>Process payments and fulfil orders.</li>
      <li>Send marketing communications via email and postal mail (where permitted).</li>
      <li>Detect and prevent fraudulent activity.</li>
      <li>Provide customer support.</li>
      <li>Comply with legal obligations.</li>
    </ul>

    <h2>Third-Party Disclosures</h2>
    <p>We may share information with Shopify vendors, marketing partners, affiliates, and in connection with business transactions or legal compliance needs.</p>

    <h2>Shopify Relationship</h2>
    <p>Information you submit to the Services will be transmitted to and shared with Shopify as well as third parties that may be located in countries other than where you reside. You may review Shopify's consumer privacy policy and privacy portal for additional details about how Shopify processes your information.</p>

    <h2>Children's Data</h2>
    <p>The Services are not intended to be used by children, and we do not knowingly collect any personal information about children under the age of majority in your jurisdiction.</p>

    <h2>Your Rights</h2>
    <p>Depending on your jurisdiction, you may have the right to:</p>
    <ul>
      <li>Access the personal information we hold about you.</li>
      <li>Request deletion of your information.</li>
      <li>Correct inaccuracies.</li>
      <li>Receive a portable copy of your data.</li>
      <li>Manage marketing communication preferences (use unsubscribe links in our emails).</li>
    </ul>

    <h2>Security</h2>
    <p>Please be aware that no security measures are perfect or impenetrable, and we cannot guarantee "perfect security".</p>

    <h2>International Data Transfers</h2>
    <p>Information may be transferred internationally. For European Economic Area and United Kingdom transfers, we rely on Standard Contractual Clauses or equivalent mechanisms unless adequate protection exists.</p>

    <h2>Contact Us</h2>
    <p>For privacy enquiries or to exercise your rights:</p>
    <ul>
      <li><strong>Email:</strong> <a href="mailto:care@rugkari.com" style="text-decoration:underline;">care@rugkari.com</a></li>
      <li><strong>Phone:</strong> <a href="tel:+917348515188" style="text-decoration:underline;">+91 73485 15188</a></li>
      <li><strong>Address:</strong> The Bhadohi Atelier, Carpet Lane, Bhadohi, Uttar Pradesh 221401, India</li>
    </ul>
  </div>
</section>
"@

# -----------------------------------------------------------------------------
# 9. Refund Policy
# -----------------------------------------------------------------------------
$refundBody = @"
<section class="section">
  <div class="container-narrow article-body" style="max-width:760px;">

    <h2>Return Eligibility</h2>
    <ul>
      <li><strong>Manufacturing defects only.</strong> Returns are accepted only for verifiable production defects.</li>
      <li><strong>Request within 48 hours of receipt.</strong> Contact us within 48 hours of delivery with photographs.</li>
      <li><strong>Unused, unwashed, unsoiled condition.</strong> The rug must be in the condition it was delivered.</li>
      <li><strong>Original packing and tags intact.</strong></li>
    </ul>

    <h2>Non-Returnable Items</h2>
    <ul>
      <li><strong>Custom and made-to-order rugs</strong> are non-returnable except for verified manufacturing defects covered under our warranty.</li>
      <li><strong>Promotional or clearance sale items</strong> are sold as final.</li>
    </ul>

    <h2>Return Process</h2>
    <ol>
      <li>Submit high-quality images of the defect from multiple angles within 48 hours.</li>
      <li>Once approved, we coordinate a free pickup. Buyer covers return shipping costs only if the return is not due to a manufacturing defect.</li>
      <li>Replacement is offered for the same design first. Different designs may be considered in exceptional cases, subject to stock availability.</li>
      <li>Refunds are processed within 48 hours after our team has inspected the returned rug.</li>
    </ol>

    <h2>Refund Details</h2>
    <ul>
      <li><strong>Administrative deduction.</strong> A 5% administrative deduction applies on standard returns.</li>
      <li><strong>Cancelled orders (post-production).</strong> Once production has started, cancelled orders receive a 50% refund.</li>
      <li><strong>Stain coatings.</strong> Optional stain repellent treatment is non-refundable and non-transferable.</li>
    </ul>

    <h2>How to Initiate a Refund</h2>
    <p>Contact us within 48 hours of receiving your order:</p>
    <ul>
      <li><strong>WhatsApp / Phone:</strong> <a href="https://wa.me/917348515188" target="_blank" rel="noopener" style="text-decoration:underline;">+91 73485 15188</a></li>
      <li><strong>Email:</strong> <a href="mailto:care@rugkari.com" style="text-decoration:underline;">care@rugkari.com</a></li>
      <li><strong>Address:</strong> The Bhadohi Atelier, Carpet Lane, Bhadohi, Uttar Pradesh 221401, India</li>
    </ul>

    <p style="margin-top: 32px; padding: 24px; background: var(--secondary); font-size: 15px;">
      <strong>Note on warranty vs. refund:</strong> If your rug has a defect outside the 48-hour return window, please refer to our <a href="/pages/rug-warranty.html" style="text-decoration:underline;">Rug Warranty</a>, which covers structural, colour, size and pattern defects for up to 25 years on hand-knotted rugs and up to 10 years on hand-tufted and dhurrie rugs.
    </p>
  </div>
</section>
"@

# -----------------------------------------------------------------------------
# 10. Terms of Service
# -----------------------------------------------------------------------------
$termsBody = @"
<section class="section">
  <div class="container-narrow article-body" style="max-width:760px;">

    <p style="font-size: 16px; line-height: 1.8;">Welcome to Rugkari. The terms "we", "us" and "our" refer to Rugkari. By using this website you agree to the following terms of service.</p>

    <h2>1. Access and Account</h2>
    <p>Users must be of legal age in their jurisdiction and provide accurate information when creating an account or placing an order.</p>

    <h2>2. Products</h2>
    <p>Rugs are hand-crafted natural-fibre products. Colours may differ slightly from on-screen renderings due to monitor settings, lighting, and the natural variation inherent in hand-woven goods. Product descriptions are subject to change.</p>

    <h2>3. Orders</h2>
    <p>Rugkari reserves the right to accept or decline any order. Refunds are governed by our <a href="/pages/refund-policy.html" style="text-decoration:underline;">Refund Policy</a>.</p>

    <h2>4. Prices and Billing</h2>
    <p>Prices are subject to change without notice. Domestic prices are inclusive of GST. International prices exclude duties and customs, which are the buyer's responsibility.</p>

    <h2>5. Shipping and Delivery</h2>
    <p>We are not liable for shipping and delivery delays caused by courier partners, weather, customs, or other circumstances beyond our control. See our <a href="/pages/shipping-policy.html" style="text-decoration:underline;">Shipping Policy</a> for details.</p>

    <h2>6. Intellectual Property</h2>
    <p>All Rugkari trademarks, designs, images, copy, and content are owned by Rugkari. No reuse, reproduction, or modification is permitted without written permission.</p>

    <h2>7. Optional Tools and Third-Party Links</h2>
    <p>Some optional tools are provided by third parties on an "as-is" basis. Rugkari is not responsible for the content, accuracy, or practices of external websites that we link to.</p>

    <h2>8. Shopify Relationship</h2>
    <p>The Rugkari store is powered by Shopify. Shopify is not responsible for any aspect of any sales transactions on the Rugkari store.</p>

    <h2>9. Privacy</h2>
    <p>Use of the Services is also governed by our <a href="/pages/privacy-policy.html" style="text-decoration:underline;">Privacy Policy</a>.</p>

    <h2>10. Feedback</h2>
    <p>Any feedback you provide to Rugkari (suggestions, reviews, ideas) grants Rugkari a perpetual, royalty-free, world-wide licence to use that feedback.</p>

    <h2>11. Errors and Omissions</h2>
    <p>Rugkari reserves the right to correct information, update prices, and cancel orders that result from material errors or omissions.</p>

    <h2>12. Prohibited Uses</h2>
    <p>You may not use the Services in ways that are unlawful, harmful, fraudulent, or that interfere with the operation of the site. Specifically prohibited: spam, malware, scraping for commercial use, impersonation of other persons or entities.</p>

    <h2>13. Software Agents</h2>
    <p>Autonomous software (bots, scrapers, AI agents) accessing the Services must identify themselves clearly in HTTP requests and respect our robots.txt directives.</p>

    <h2>14. Termination</h2>
    <p>Rugkari may suspend or terminate access to the Services at its sole discretion for violation of these terms.</p>

    <h2>15. Warranties, Liability, Indemnification</h2>
    <p>The Services are provided "as is". To the maximum extent permitted by law, Rugkari disclaims all implied warranties. Rugkari's total liability for any claim shall not exceed the amount paid by you for the rug giving rise to the claim. You agree to indemnify Rugkari against any claims arising from your misuse of the Services.</p>

    <h2>16. Governing Law</h2>
    <p>These terms are governed by the laws of India, with exclusive jurisdiction of the courts in Uttar Pradesh.</p>

    <h2>17. Contact</h2>
    <p>For any question on these terms, contact us at <a href="mailto:care@rugkari.com" style="text-decoration:underline;">care@rugkari.com</a> or visit <a href="/pages/contact.html" style="text-decoration:underline;">The Bhadohi Atelier</a>, Carpet Lane, Bhadohi, Uttar Pradesh 221401, India.</p>
  </div>
</section>
"@

# -----------------------------------------------------------------------------
# 11. Shipping Policy
# -----------------------------------------------------------------------------
$shippingBody = @"
<section class="section">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">Free Across India</p>
    <h2 style="text-align:center;">Pan-India shipping at no cost</h2>
    <p style="font-size:17px; line-height:1.8;">All domestic orders ship free of charge across India. Prices are all-inclusive (GST included). International shipping is available with the buyer responsible for import duties and customs charges.</p>
  </div>
</section>

<section class="section" style="background: var(--secondary);">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">Production Timelines</p>
    <h2 style="text-align:center;">How long the craft takes</h2>
    <table style="width:100%; border-collapse:collapse; margin-top:32px; font-size:15px;">
      <thead>
        <tr style="border-bottom: 2px solid var(--foreground);">
          <th style="text-align:left; padding:14px 12px;">Rug type</th>
          <th style="text-align:right; padding:14px 12px;">Production time</th>
        </tr>
      </thead>
      <tbody>
        <tr><td style="padding:14px 12px; border-bottom:1px solid var(--border);">Hand-Tufted Rugs</td><td style="padding:14px 12px; border-bottom:1px solid var(--border); text-align:right;">10$EN 12 working days</td></tr>
        <tr><td style="padding:14px 12px; border-bottom:1px solid var(--border);">Hand-Knotted Rugs</td><td style="padding:14px 12px; border-bottom:1px solid var(--border); text-align:right;">30$EN 35 working days</td></tr>
        <tr><td style="padding:14px 12px;">Dhurrie / Flat-weave</td><td style="padding:14px 12px; text-align:right;">15$EN 20 working days</td></tr>
      </tbody>
    </table>
    <p style="margin-top:16px; color: var(--muted-foreground); font-size:14px; text-align:center;">In-stock rugs dispatch within 1$EN 2 working days.</p>
  </div>
</section>

<section class="section">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">Delivery After Dispatch</p>
    <h2 style="text-align:center;">From our atelier to your door</h2>
    <table style="width:100%; border-collapse:collapse; margin-top:32px; font-size:15px;">
      <thead>
        <tr style="border-bottom: 2px solid var(--foreground);">
          <th style="text-align:left; padding:14px 12px;">Service</th>
          <th style="text-align:right; padding:14px 12px;">Transit time</th>
        </tr>
      </thead>
      <tbody>
        <tr><td style="padding:14px 12px; border-bottom:1px solid var(--border);">Standard Delivery (free across India)</td><td style="padding:14px 12px; border-bottom:1px solid var(--border); text-align:right;">5$EN 7 working days</td></tr>
        <tr><td style="padding:14px 12px;">Express Delivery (where available)</td><td style="padding:14px 12px; text-align:right;">2$EN 4 working days</td></tr>
      </tbody>
    </table>
  </div>
</section>

<section class="section" style="background: var(--secondary);">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">Order Updates</p>
    <h2 style="text-align:center;">Stay informed</h2>
    <ul style="margin-top: 32px; font-size: 16px; line-height: 1.8; list-style: none; padding: 0; max-width: 540px; margin-left: auto; margin-right: auto;">
      <li style="padding: 14px 0; border-bottom: 1px solid var(--border);">Order confirmation sent via email and WhatsApp.</li>
      <li style="padding: 14px 0; border-bottom: 1px solid var(--border);">Tracking ID sent the moment your rug ships.</li>
      <li style="padding: 14px 0; border-bottom: 1px solid var(--border);">Quality-assured before dispatch by our team.</li>
      <li style="padding: 14px 0;">Free pickup and replacement if package arrives tampered.</li>
    </ul>
  </div>
</section>

<section class="section">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">International Orders</p>
    <h2 style="text-align:center;">We ship worldwide</h2>
    <p style="font-size:17px; line-height:1.8;">Rugkari ships to most countries internationally. For international shipments:</p>
    <ul style="margin-top: 16px; font-size: 16px; line-height: 1.8;">
      <li>Shipping is charged at actual courier rates.</li>
      <li>Import duties, customs charges, and local taxes are the buyer's responsibility.</li>
      <li>WhatsApp our team for a custom shipping quote based on size and destination.</li>
    </ul>
    <p style="margin-top: 24px;"><a class="btn btn-ghost" href="https://wa.me/917348515188?text=Hi%20Rugkari%2C%20I%27d%20like%20a%20shipping%20quote%20for%20an%20international%20order." target="_blank" rel="noopener"><span>Get an international quote</span></a></p>
  </div>
</section>

<section class="section" style="background: var(--foreground); color: #fff;">
  <div class="container-narrow" style="text-align:center;">
    <p class="eyebrow" style="color: rgba(255,255,255,0.65);">Need Help?</p>
    <h2 style="color: #fff;">Contact customer care</h2>
    <p style="color: rgba(255,255,255,0.85); font-size:16px; line-height:1.8; margin-top:24px;">
      <strong>WhatsApp / Phone:</strong> <a href="https://wa.me/917348515188" target="_blank" rel="noopener" style="color:#fff; text-decoration:underline;">+91 73485 15188</a><br/>
      <strong>Email:</strong> <a href="mailto:care@rugkari.com" style="color:#fff; text-decoration:underline;">care@rugkari.com</a><br/>
      <strong>Hours:</strong> Monday$EN Saturday, 10:00$EN 18:00 IST (closed on national holidays)
    </p>
  </div>
</section>
"@

# -----------------------------------------------------------------------------
# Pages definition
# -----------------------------------------------------------------------------
$pages = @(
  @{ slug='contact';          title='Contact';                 metaDesc="Talk to the Rugkari atelier in Bhadohi. Email care@rugkari.com or WhatsApp +91 73485 15188. Open Monday-Saturday, 10:00-19:00 IST."; eyebrow="Carpet Lane $DOT Bhadohi $DOT India"; h1="Talk to the Atelier"; lede="Every rug begins with a conversation. We'd love to hear yours."; breadcrumb='Contact'; body=$contactBody; type='ContactPage' }
  @{ slug='the-founder';      title='The Founder';             metaDesc='Amit Kumar, founder of Rugkari, on third-generation craft from the Bhadohi-Mirzapur carpet belt and what makes a rug truly heirloom-grade.'; eyebrow='Third Generation Craft'; h1='The Founder'; lede="Legacy in craft. Since 1980. Exported worldwide. Now in India."; breadcrumb='The Founder'; body=$founderBody; type='AboutPage' }
  @{ slug='the-carpet-city';  title='The Carpet City';         metaDesc="Bhadohi, India's Carpet City, has hand-woven rugs for over 400 years. The history, the craft, and Rugkari's place in this living tradition."; eyebrow='Bhadohi, Uttar Pradesh'; h1='The Carpet City'; lede="Where every knot holds a century of memory."; breadcrumb='The Carpet City'; body=$carpetCityBody; type='AboutPage' }
  @{ slug='the-art';          title='The Art of Making';       metaDesc='How a Rugkari carpet is made: six stages from design to dispatch, by master artisans in Bhadohi.'; eyebrow='Craft Process'; h1='The Art of Making'; lede="A Rugkari carpet is not manufactured. It is created."; breadcrumb='The Art'; body=$artBody; type='AboutPage' }
  @{ slug='stain-repellent';  title='Stain Repellent';         metaDesc='Optional professional stain repellent treatment for Rugkari rugs. Invisible, non-toxic, pet-safe, 1-2 year protection. How it works and how to maintain it.'; eyebrow='Optional Treatment'; h1='Stain Repellent'; lede="An invisible shield for your rug, that stays quiet."; breadcrumb='Stain Repellent'; body=$stainBody; type='WebPage' }
  @{ slug='rug-warranty';     title='Rug Warranty';            metaDesc='Rugkari rug warranty: 25 years on hand-knotted, 10 years on hand-tufted and dhurrie. What is covered, what is not, and how to file a claim.'; eyebrow='Our Promise'; h1='Rug Warranty'; lede="Every Rugkari rug is backed by our word. Manufacturing defects, repaired or replaced at no cost."; breadcrumb='Rug Warranty'; body=$warrantyBody; type='WebPage' }
  @{ slug='track-your-order'; title='Track Your Order';        metaDesc='Track your Rugkari order. Production timelines, delivery transit, and three ways to get the latest status from our team in Bhadohi.'; eyebrow='Order Care'; h1='Track Your Order'; lede="Know where your rug is at every stage of the journey from our looms to your home."; breadcrumb='Track Your Order'; body=$trackBody; type='WebPage' }
  @{ slug='privacy-policy';   title='Privacy Policy';          metaDesc='How Rugkari collects, uses, and protects your information. Your rights, our practices, and how to contact us.'; eyebrow='Last updated May 2026'; h1='Privacy Policy'; lede="How we collect, use, and protect your information $EM and the rights you have over it."; breadcrumb='Privacy Policy'; body=$privacyBody; type='WebPage' }
  @{ slug='refund-policy';    title='Refund Policy';           metaDesc='Rugkari refund policy. Return eligibility, process, timeline, and what is and is not refundable. Custom rugs covered by warranty.'; eyebrow='Returns &amp; Refunds'; h1='Refund Policy'; lede="Returns are accepted for manufacturing defects within 48 hours of delivery. Here is exactly how it works."; breadcrumb='Refund Policy'; body=$refundBody; type='WebPage' }
  @{ slug='terms-of-service'; title='Terms of Service';        metaDesc='Rugkari terms of service. The rules that govern using rugs.rugkari.com and ordering Rugkari products. India jurisdiction.'; eyebrow='The Terms'; h1='Terms of Service'; lede="The rules that govern using this website and ordering from Rugkari."; breadcrumb='Terms of Service'; body=$termsBody; type='WebPage' }
  @{ slug='shipping-policy';  title='Shipping Policy';         metaDesc='Rugkari ships free across India and worldwide. Production timelines, delivery times, and details on customs for international orders.'; eyebrow='Free Across India'; h1='Shipping Policy'; lede="Free pan-India shipping. Quality assured before dispatch. International shipping on request."; breadcrumb='Shipping Policy'; body=$shippingBody; type='WebPage' }
)

# -----------------------------------------------------------------------------
# Emit pages
# -----------------------------------------------------------------------------
$count = 0
foreach ($p in $pages) {
  $html = Build-Page -slug $p.slug -title $p.title -metaDesc $p.metaDesc -eyebrow $p.eyebrow -h1 $p.h1 -lede $p.lede -body $p.body -breadcrumbName $p.breadcrumb -pageType $p.type
  $outPath = Join-Path $outDir ($p.slug + '.html')
  [System.IO.File]::WriteAllText($outPath, $html, $utf8NoBom)
  Write-Output ('  generated: pages/' + $p.slug + '.html')
  $count++
}

Write-Output ''
Write-Output ('Done. ' + $count + ' pages generated.')

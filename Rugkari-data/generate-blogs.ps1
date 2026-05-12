# =============================================================================
# Rugkari SEO blog generator (ASCII source).
# Produces 5 keyword-targeted blog articles.
# =============================================================================

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$outDir      = Join-Path $projectRoot 'blog'
$utf8NoBom   = New-Object System.Text.UTF8Encoding($false)

$EM = [char]0x2014
$EN = [char]0x2013
$DOT = [char]0x00B7

# Common HTML chunks
$sharedHeader = @"
<header class="site-header" role="banner">
  <div class="store-note tracking-wider-2">Free Pan-India Shipping $DOT Up to 25-Year Heirloom Warranty</div>
  <div class="mobile-drawer-overlay" id="drawerOverlay" aria-hidden="true"></div>
  <div class="mobile-drawer" id="mobileDrawer" role="dialog" aria-label="Navigation" aria-modal="true">
    <div class="mobile-drawer-header"><span class="mobile-drawer-title">Menu</span><button class="drawer-close-btn" id="drawerClose" aria-label="Close"><svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" fill="none"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg></button></div>
    <nav class="mobile-drawer-nav"><a href="/collections/abstract-rugs.html">Abstract</a><a href="/collections/floral-rugs.html">Floral</a><a href="/collections/hand-knotted-rugs.html">Hand-Knotted</a><a href="/collections/hand-tufted-rugs.html">Hand-Tufted</a><a href="/rug-care">Rug Care</a><a href="/heritage">Heritage</a><a href="https://rugkari.com/collections/all" rel="noopener">Shop Catalog</a></nav>
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
      </ul>
    </nav>
    <div>
      <h4 class="footer-title">Stay Connected</h4>
      <p class="newsletter-text">New arrivals and design inspiration.</p>
      <form class="newsletter-form" onsubmit="handleNewsletterSubmit(event)" novalidate>
        <label for="newsletter-email" class="sr-only">Email address</label>
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
<div class="whatsapp"><a class="whatsapp-button" href="https://wa.me/917348515188?text=Hi%20Rugkari" target="_blank" rel="noopener noreferrer" aria-label="WhatsApp"><svg viewBox="0 0 175.216 175.552" aria-hidden="true"><path d="M87.184 0C39.04 0 .002 39.038 0 87.184c0 15.363 4.03 30.37 11.688 43.549L.336 175.552l46.033-11.304c12.683 6.983 26.975 10.663 41.549 10.663 48.142 0 87.184-39.038 87.298-87.184C175.33 39.152 135.33 0 87.184 0zm0 159.893c-13.363 0-26.44-3.594-37.782-10.38l-2.714-1.61-28.138 6.913 7.138-25.883-1.765-2.827C16.83 114.466 13.11 101.059 13.11 87.184 13.11 46.23 46.23 13.11 87.184 13.11c40.13 0 72.781 32.65 72.781 72.782 0 40.953-32.65 74.001-72.781 74.001zm40.009-55.37c-2.196-1.097-12.978-6.394-14.99-7.124-2.012-.73-3.476-1.097-4.94 1.097-1.463 2.194-5.671 7.124-6.952 8.587-1.28 1.462-2.561 1.645-4.757.548-2.196-1.097-9.27-3.41-17.65-10.88-6.524-5.818-10.929-13.004-12.21-15.198-1.28-2.194-.136-3.379 .962-4.472.986-.979 2.196-2.559 3.293-3.838 1.097-1.28 1.463-2.194 2.195-3.657.73-1.462.365-2.742-.183-3.838-.548-1.097-4.94-11.887-6.77-16.28-1.78-4.28-3.592-3.7-4.94-3.762-1.28-.061-2.744-.074-4.208-.074-1.463 0-3.842.548-5.854 2.742-2.012 2.194-7.684 7.49-7.684 18.28 0 10.789 7.867 21.214 8.964 22.676 1.097 1.462 15.479 23.625 37.503 33.146 5.242 2.266 9.333 3.619 12.52 4.633 5.262 1.677 10.053 1.44 13.838.873 4.222-.632 12.978-5.305 14.807-10.425 1.83-5.12 1.83-9.512 1.28-10.425-.548-.913-2.012-1.462-4.208-2.559z" fill="#fff"/></svg></a></div>
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

# Blog data
$blogs = @(
  @{
    slug = 'how-to-choose-rug-size-for-living-room-india'
    title = 'How to Choose the Right Rug Size for Your Living Room (India 2026 Guide)'
    metaDesc = 'A complete guide to choosing the perfect rug size for Indian living rooms. Size charts for 3-seater, 5-seater and L-shaped sofas, plus expert placement tips.'
    headline = 'How to Choose the Right Rug Size for Your Living Room (India 2026)'
    description = 'A complete sizing guide for Indian living rooms, with charts for every sofa configuration and placement style.'
    keywords = 'rug size for living room India, what size rug for living room, rug size guide, how to choose rug size, living room rug dimensions'
    section = 'Size Guide'
    image = 'https://cdn.shopify.com/s/files/1/0659/8649/4558/files/4695-kellywearstler-districtspruce-rug-1200x1800-roomset__38058.jpg?v=1777702455'
    datePublished = '2026-05-10'
    lede = 'The single biggest mistake we see Indian customers make: buying a rug that is too small. A 5x7 ft rug under a 3-seater sofa floats like an island. Here is exactly how to size your rug for the way Indian living rooms are actually furnished.'
    sections = @(
      @{ heading='Three placement styles for Indian living rooms'; body='<p>There are three accepted ways to place a rug under a sofa:</p><ol><li><strong>All-furniture-on-rug</strong> (most grounded): every leg of every piece sits on the rug. Requires the largest size. Best for 12x15 ft+ living rooms.</li><li><strong>Front-legs-on-rug</strong> (most popular in India): the front legs of the sofa, side chairs and accent chairs sit on the rug. Back legs sit on bare floor. Middle ground between cost and impact.</li><li><strong>Floating</strong> (smallest): the rug sits between the seating, with all furniture legs on bare floor. Coffee table sits centered on the rug. Best for small living rooms or rugs that are themselves the visual focal point.</li></ol>' }
      @{ heading='Sizing chart by sofa configuration'; body="<p>The most common Indian living room layouts and their ideal rug sizes:</p><table style='width:100%; border-collapse:collapse; margin: 24px 0;'><thead><tr style='border-bottom:1px solid #ccc;'><th style='text-align:left; padding:12px 8px;'>Sofa configuration</th><th style='text-align:left; padding:12px 8px;'>Floating</th><th style='text-align:left; padding:12px 8px;'>Front legs on</th><th style='text-align:left; padding:12px 8px;'>All on</th></tr></thead><tbody><tr style='border-bottom:1px solid #eee;'><td style='padding:12px 8px;'>3-seater only</td><td style='padding:12px 8px;'>5x7 ft</td><td style='padding:12px 8px;'>6x9 ft</td><td style='padding:12px 8px;'>8x10 ft</td></tr><tr style='border-bottom:1px solid #eee;'><td style='padding:12px 8px;'>3+2 seater</td><td style='padding:12px 8px;'>6x9 ft</td><td style='padding:12px 8px;'>8x10 ft</td><td style='padding:12px 8px;'>9x12 ft</td></tr><tr style='border-bottom:1px solid #eee;'><td style='padding:12px 8px;'>L-shaped sectional</td><td style='padding:12px 8px;'>6x9 ft</td><td style='padding:12px 8px;'>8x10 ft</td><td style='padding:12px 8px;'>9x12 ft</td></tr><tr style='border-bottom:1px solid #eee;'><td style='padding:12px 8px;'>3+2+1 + 2 chairs</td><td style='padding:12px 8px;'>8x10 ft</td><td style='padding:12px 8px;'>9x12 ft</td><td style='padding:12px 8px;'>10x14 ft</td></tr></tbody></table>" }
      @{ heading='How much bare floor to leave'; body='<p>The rule that designers actually use: leave 18 to 24 inches of bare floor between the rug edge and the wall. Less than 18 inches and the rug looks wedged in. More than 24 inches and the rug looks too small for the room.</p><p>For a 12x15 ft living room: a 9x12 ft rug leaves exactly 18 inches on all sides. For a 14x18 ft room: a 10x14 ft rug works perfectly with front-legs-on placement.</p>' }
      @{ heading='Common Indian mistakes'; body="<p><strong>Mistake 1: Buying a 5x7 ft rug for a 3-seater sofa.</strong> Looks like an island. Always go up at least one size from what feels intuitive.</p><p><strong>Mistake 2: Choosing a runner instead of an area rug.</strong> Runners belong in hallways and beside beds. They never anchor a living room.</p><p><strong>Mistake 3: Buying based on floor space available rather than furniture configuration.</strong> Start with where your sofa is, then size the rug around it.</p><p><strong>Mistake 4: Forgetting the coffee table.</strong> The coffee table must fully sit on the rug in the front-legs-on style, and at least 18 inches of rug should be visible around it.</p>" }
      @{ heading='Custom sizes for unusually shaped rooms'; body='<p>For long narrow drawing rooms, large duplex living rooms, or rooms with bay windows that constrain placement, custom-sized rugs are essential. Rugkari offers custom sizing on every hand-tufted and hand-knotted rug in our catalog at no extra charge for changes within 12 inches in either dimension.</p><p>Standard sizes we keep in stock: 5x7, 6x9, 8x10, 9x12, 10x14 ft. Round rugs available in 6 ft and 8 ft diameters.</p>' }
    )
    faq = @(
      @{ q='What is the most popular rug size for Indian living rooms?'; a='The 6x9 ft and 8x10 ft sizes are the most popular for Indian living rooms. 6x9 ft works for 3-seater sofas in front-legs-on placement, while 8x10 ft fits the typical 3+2 sofa configuration in most Indian apartments.' }
      @{ q='Can I use a rug that is bigger than the room?'; a='No. A rug should leave at least 18 inches of bare floor between its edge and any wall. A rug that runs wall-to-wall is technically a fitted carpet, not a rug, and loses the visual benefits that a defined rug provides.' }
      @{ q='What size rug do I need for a 12x15 ft living room?'; a='For a 12x15 ft living room, an 8x10 ft rug works with front-legs-on placement and a 9x12 ft rug works for all-furniture-on placement. A 5x7 ft will look too small.' }
      @{ q='Are custom rug sizes more expensive?'; a='At Rugkari, custom sizing within 12 inches of a standard size is included at no extra cost. For larger size variations, the price scales with square footage. Custom rugs typically take 30 to 45 days to weave.' }
      @{ q='Should the coffee table sit on the rug?'; a='Yes, in almost every layout. The coffee table should sit entirely on the rug with at least 18 inches of visible rug around it. The only exception is the floating placement style for very small living rooms.' }
    )
  }
  @{
    slug = 'hand-knotted-vs-hand-tufted-rugs-difference'
    title = "Hand-Knotted vs Hand-Tufted Rugs: What's the Real Difference?"
    metaDesc = 'Hand-knotted vs hand-tufted rugs: the complete comparison. Manufacturing process, durability, cost, lifespan, and how to choose between them for your home.'
    headline = "Hand-Knotted vs Hand-Tufted Rugs: What's the Real Difference?"
    description = 'A definitive comparison of hand-knotted and hand-tufted rugs, the two most common forms of handmade rugs.'
    keywords = 'hand knotted vs hand tufted, hand knotted rug, hand tufted rug, difference between hand knotted and tufted, KPSI rug'
    section = 'Buying Guide'
    image = 'https://cdn.shopify.com/s/files/1/0659/8649/4558/files/1200x1800---cc_plexa_r_c9edf421-09e9-4752-be04-8e0b82194cc0.jpg?v=1777702445'
    datePublished = '2026-05-08'
    lede = 'When you start shopping for handmade rugs, two terms come up constantly: hand-knotted and hand-tufted. They are NOT the same thing, and the difference matters for cost, lifespan, and the kind of rug you actually want.'
    sections = @(
      @{ heading='Hand-knotted rugs: knot-by-knot, by hand'; body='<p>A hand-knotted rug is exactly what it sounds like: each individual knot is tied by hand, one at a time, by an artisan working at a vertical loom. The rug is built up row by row, with each knot tied around the warp threads and locked in by the next row of weft.</p><p>The metric that matters for hand-knotted rugs is KPSI (Knots Per Square Inch). A basic hand-knotted rug starts around 80 KPSI. Premium hand-knotted rugs reach 200 to 300 KPSI. Museum-grade Persian silk rugs can exceed 1,000 KPSI.</p><p>Rugkari hand-knotted rugs are made in Bhadohi at 80 to 300 KPSI in pure New Zealand wool. A 6x9 ft hand-knotted rug at 200 KPSI takes 6 to 8 months to complete.</p>' }
      @{ heading='Hand-tufted rugs: tufting gun and canvas'; body='<p>A hand-tufted rug is made by pushing yarn loops through a stretched canvas backing using a tufting gun. The artisan works from the back of the canvas, following a design that has been pre-drawn on the canvas. The front shows the pile as it develops.</p><p>Once the entire surface is tufted, a layer of latex is applied to the back to hold the loops in place, and a secondary canvas backing is glued over the latex.</p><p>Rugkari hand-tufted rugs use a 20mm ultra-luxury pile of pure New Zealand wool with cotton canvas backing. A 6x9 ft hand-tufted rug takes 14 to 18 days to complete.</p>' }
      @{ heading='The key differences side by side'; body='<p>The visible differences:</p><ul><li><strong>Reversibility:</strong> Hand-knotted rugs are fully reversible (the back shows the pattern as well). Hand-tufted rugs have a solid canvas backing.</li><li><strong>Lifespan:</strong> Hand-knotted rugs last 30 to 100+ years. Hand-tufted rugs last 15 to 25 years with the latex backing as the limiting factor.</li><li><strong>Cost:</strong> Hand-knotted rugs cost 4 to 10 times more than hand-tufted at the same size and material quality.</li><li><strong>Production time:</strong> Hand-knotted takes 4 to 12 months. Hand-tufted takes 2 to 3 weeks.</li><li><strong>Pile feel:</strong> Hand-tufted has a denser, plusher pile. Hand-knotted has a more variable, organic pile that feels more "handmade".</li></ul>' }
      @{ heading='How to tell them apart by looking'; body='<p>Flip the rug over. A hand-knotted rug shows the design clearly on the back (you can see each knot row). A hand-tufted rug shows a solid canvas or cotton backing.</p><p>Look at the edges. Hand-knotted rugs have visible warp ends as fringes that are part of the rug structure. Hand-tufted rugs have fringes glued or sewn on as a decorative finish.</p><p>Feel the pile. Hand-knotted pile feels slightly variable in height across the surface, with subtle texture from each individual knot. Hand-tufted pile feels uniformly dense and even.</p>' }
      @{ heading='Which should you buy?'; body='<p><strong>Choose hand-knotted if:</strong> You want a heirloom piece that will be passed down. Budget is flexible (Rs. 60,000+). You appreciate the most authentic, traditional craft. You want a fully reversible rug.</p><p><strong>Choose hand-tufted if:</strong> You want genuine handmade character at an accessible price (Rs. 8,000 to Rs. 25,000). You want a plush, modern pile feel. Production time matters (2 to 3 weeks vs. 6 months). You want a wider range of contemporary designs.</p><p>For most Indian homes, hand-tufted is the sweet spot: genuinely handcrafted, premium New Zealand wool, accessible price, and a lifespan that easily covers two decades of daily use.</p>' }
    )
    faq = @(
      @{ q='Is a hand-knotted rug worth the extra cost?'; a='For an investment piece in a primary living space, yes. A Rs. 80,000 hand-knotted rug that lasts 50 years costs Rs. 1,600 per year. A Rs. 12,000 hand-tufted rug that lasts 20 years costs Rs. 600 per year. The hand-knotted has higher annual cost but lower per-decade depreciation and significant heirloom value.' }
      @{ q='Are hand-tufted rugs considered fake or low quality?'; a='No. Hand-tufted is a legitimate handmade construction method that produces genuinely handcrafted rugs. The misconception comes from cheap polyester hand-tufted rugs sold in mass-market stores. A Rugkari hand-tufted rug in pure New Zealand wool with a 20mm pile is a premium handmade piece.' }
      @{ q='How do I tell if a rug is hand-knotted or hand-tufted?'; a='Flip it over. A hand-knotted rug shows the design pattern on the back with visible rows of individual knots. A hand-tufted rug shows a solid canvas backing covering everything.' }
      @{ q='Why are hand-knotted rugs so expensive?'; a='A 6x9 ft hand-knotted rug at 200 KPSI contains roughly 1.5 million individual knots, each tied by hand over 6 to 8 months. The labor cost alone is substantial, then add the cost of pure New Zealand wool, dyeing, washing, finishing and quality control.' }
      @{ q='Can hand-tufted rugs be repaired?'; a='Yes for surface repairs (pile shed, minor pulls) but the latex backing eventually breaks down (15 to 25 years) and that is not economically repairable. Hand-knotted rugs have no backing to fail and can be repaired indefinitely.' }
    )
  }
  @{
    slug = 'best-rugs-for-bedroom-india-guide'
    title = 'Best Rugs for Bedrooms in India: Buyer Guide 2026'
    metaDesc = 'The best rugs for bedrooms in Indian homes. Size, material, placement and the top hand-tufted picks for queen and king bedrooms. Expert buying guide.'
    headline = 'The Best Rugs for Bedrooms in India (2026 Buyer Guide)'
    description = 'How to choose the perfect bedroom rug for Indian homes, with size charts and our editor picks.'
    keywords = 'best rug for bedroom India, bedroom rug size, rugs under bed, queen bed rug size, king bed rug size'
    section = 'Buying Guide'
    image = 'https://cdn.shopify.com/s/files/1/0659/8649/4558/files/esduotfgcdfsuycfgh.jpg?v=1777702456'
    datePublished = '2026-05-11'
    lede = 'A bedroom rug does three things: it warms the floor (especially in cool months), it absorbs sound (making the bedroom quieter), and it adds the soft visual contrast a bedroom needs. Here is exactly how to choose one.'
    sections = @(
      @{ heading='Three ways to place a bedroom rug'; body='<p>The standard placement options:</p><ol><li><strong>Full under bed:</strong> the rug extends 18 to 24 inches beyond all three sides (left, right, foot of bed). The headboard sits on bare floor or against the wall. Requires the largest rug.</li><li><strong>Two-thirds under bed:</strong> the rug starts roughly under the pillows and extends past the foot of the bed. Bedside tables sit on bare floor. Mid-cost option.</li><li><strong>Runners on each side:</strong> two long narrow rugs (2x6 ft each) flank the bed. No rug under the bed itself. Most affordable, works in small bedrooms.</li></ol>' }
      @{ heading='Sizing for queen, king and king-size beds'; body="<table style='width:100%; border-collapse:collapse; margin:24px 0;'><thead><tr style='border-bottom:1px solid #ccc;'><th style='text-align:left; padding:12px 8px;'>Bed size</th><th style='text-align:left; padding:12px 8px;'>Full under bed</th><th style='text-align:left; padding:12px 8px;'>Two-thirds under</th><th style='text-align:left; padding:12px 8px;'>Side runners</th></tr></thead><tbody><tr style='border-bottom:1px solid #eee;'><td style='padding:12px 8px;'>Queen (5x6.5 ft)</td><td style='padding:12px 8px;'>8x10 ft</td><td style='padding:12px 8px;'>6x9 ft</td><td style='padding:12px 8px;'>2x6 ft (x2)</td></tr><tr style='border-bottom:1px solid #eee;'><td style='padding:12px 8px;'>King (6x6.5 ft)</td><td style='padding:12px 8px;'>9x12 ft</td><td style='padding:12px 8px;'>8x10 ft</td><td style='padding:12px 8px;'>2.5x6 ft (x2)</td></tr><tr style='border-bottom:1px solid #eee;'><td style='padding:12px 8px;'>King-size (6x7 ft)</td><td style='padding:12px 8px;'>10x14 ft</td><td style='padding:12px 8px;'>9x12 ft</td><td style='padding:12px 8px;'>3x6 ft (x2)</td></tr></tbody></table>" }
      @{ heading='Material: low-pile or high-pile for bedrooms?'; body='<p>Bedroom traffic is light (you walk on the rug only when getting in and out of bed), so pile depth is a comfort choice, not a durability one.</p><p><strong>Low-pile (8 to 12mm)</strong> like the Rugkari Mist Abstract is best for bedrooms with cool flooring (marble, vitrified tiles) where you want softness underfoot but easy vacuuming.</p><p><strong>High-pile (20mm hand-tufted)</strong> like the Rugkari Elysian Abstract is best for bedrooms with wooden or warm flooring where you want plush, foot-sinking softness on bare feet in the morning.</p>' }
      @{ heading='Bedroom rug color and pattern'; body='<p>Bedrooms need calm. Two design principles:</p><p>1. The rug should be lighter or softer in color than the most dominant element in the room. If you have a strong headboard, a busy duvet, or bold curtains, the rug should be the quietest element.</p><p>2. If your bedroom uses muted neutrals, the rug can be the visual interest. Abstract patterns and subtle geometrics work well here. Avoid loud florals or strong stripes which can feel restless at night.</p>' }
      @{ heading='Top three Rugkari picks for bedrooms'; body='<p>Our most-loved bedroom rugs:</p><p><strong>1. <a href="/products/mist-abstract-pure-new-zealand-wool-rug.html">Mist Abstract</a></strong> (Handwoven, 8mm pile, Rs. 8,999+) - the ultimate quiet bedroom rug. Ivory, cloud grey and pale blue in a subtle abstract weave.</p><p><strong>2. <a href="/products/starlite-abstract-pure-new-zealand-wool-rug.html">Starlite Abstract</a></strong> (Hand-tufted, 20mm pile, Rs. 10,499+) - for bedrooms with deeper, warmer tones. Midnight, gold and ivory.</p><p><strong>3. <a href="/products/harmony-geometric-pure-new-zealand-wool-rug.html">Harmony Geometric</a></strong> (Hand-tufted, 20mm pile, Rs. 10,499+) - for guest bedrooms and biophilic interiors. Sage, cream and burnt sienna.</p>' }
    )
    faq = @(
      @{ q='What size rug for a queen bed?'; a='For a queen bed (5x6.5 ft), an 8x10 ft rug works for full-under-bed placement, 6x9 ft for two-thirds placement, or two 2x6 ft side runners.' }
      @{ q='What size rug for a king bed?'; a='For a king bed (6x6.5 ft), use a 9x12 ft rug for full-under-bed placement, 8x10 ft for two-thirds, or two 2.5x6 ft side runners.' }
      @{ q='Should the bedside tables sit on the rug?'; a='In full-under-bed placement, yes (the rug should extend at least 18 inches beyond the bedside tables). In two-thirds placement, the bedside tables sit on bare floor.' }
      @{ q='Are wool rugs good for bedrooms?'; a='Yes, especially pure New Zealand wool. Wool is naturally hypoallergenic, has built-in stain resistance from lanolin, is flame-retardant, and feels luxurious on bare feet. For Indian climate, wool rugs feel cool in summer and warm in winter.' }
      @{ q='What is the most popular bedroom rug size in India?'; a='6x9 ft for queen beds and 8x10 ft for king beds, both in two-thirds-under-bed placement, are the most popular configurations for Indian master bedrooms.' }
    )
  }
  @{
    slug = 'how-to-care-for-pure-new-zealand-wool-rugs'
    title = 'How to Care for Pure New Zealand Wool Rugs (Complete 2026 Guide)'
    metaDesc = 'Complete care guide for pure New Zealand wool rugs: vacuuming, rotation, stain removal, professional cleaning, and what to avoid. Make your rug last 20+ years.'
    headline = 'How to Care for Pure New Zealand Wool Rugs (Complete Guide)'
    description = 'Master the care of pure New Zealand wool rugs, from weekly vacuuming to professional cleaning. Make your rug last decades.'
    keywords = 'how to care for wool rug, wool rug care, New Zealand wool rug care, clean wool rug, wool rug maintenance'
    section = 'Care Guide'
    image = 'https://cdn.shopify.com/s/files/1/0659/8649/4558/files/designer-rugs-bernabeifreeman-contour-lo-wr-1.jpg?v=1777702443'
    datePublished = '2026-05-09'
    lede = 'A pure New Zealand wool rug, treated correctly, will outlive most of the furniture in your home. Treated incorrectly, it can be ruined in a single year. Here is exactly how to care for one, week by week, year by year.'
    sections = @(
      @{ heading='Weekly: vacuuming the right way'; body='<p>Vacuum your wool rug at least once a week (more often in high-traffic areas). Two critical rules:</p><p><strong>1. Use suction only, not a beater bar.</strong> The beater bar (the rotating brush on most vacuums) is designed for wall-to-wall carpets, not for area rugs. It pulls fibers loose from a wool rug over time. Most modern vacuums let you turn off the beater bar; use only suction.</p><p><strong>2. Vacuum in the direction of the pile.</strong> Wool pile has a natural lay (the direction the fibers point). Vacuuming against the pile direction stresses the fibers. Look at your rug under light: the side that appears lighter is the pile direction. Vacuum from that side toward the darker side.</p><p>For very high-pile rugs (20mm+), vacuum slowly and let suction do the work. Do not press down hard or move the vacuum quickly.</p>' }
      @{ heading='Every 3 to 6 months: rotation'; body='<p>Rotate the rug 180 degrees every 6 months (every 3 months in heavy-traffic rooms). Sunlight fades the side of the rug that faces a window. Foot traffic compresses certain areas. Rotation evens out both kinds of wear.</p><p>For a hand-tufted rug, rotation is easy: just turn it. For hand-knotted, also turn it. Some people are tempted to flip the rug entirely once a year; hand-knotted rugs can be used reversed (the pattern shows through), but hand-tufted rugs should never be reversed (the canvas backing is not the wear surface).</p>' }
      @{ heading='Spill protocol: the 30-second response'; body='<p>The single most important rule for wool rugs: act in the first 30 seconds.</p><p><strong>Step 1:</strong> Grab a clean white cloth or paper towels. White only - colored cloths can transfer dye.</p><p><strong>Step 2:</strong> Blot the spill from the outside edge toward the center, never rub. Pressing inward prevents the stain from spreading outward.</p><p><strong>Step 3:</strong> Use cold water only. Hot water sets protein-based stains (coffee, wine, food) into wool permanently.</p><p><strong>Step 4:</strong> For most stains, the blot-and-cold-water step is enough. For tougher stains, mix 1 teaspoon of wool-safe detergent in 250ml of cold water. Apply with a clean cloth, blot in, then rinse with clean cold water.</p>' }
      @{ heading='What NOT to use on a wool rug'; body='<p>Common cleaning products that destroy wool:</p><ul><li><strong>Bleach</strong> - strips color permanently.</li><li><strong>Enzyme cleaners</strong> (Vanish, OxiClean, BIZ) - the enzymes break down the protein in wool fibers.</li><li><strong>Hydrogen peroxide</strong> - bleaches wool.</li><li><strong>Ammonia-based cleaners</strong> (some glass cleaners) - cause wool to felt and harden.</li><li><strong>Steam cleaners</strong> - introduce hot water which sets stains and breaks down the latex backing.</li><li><strong>Hair dryers on hot</strong> - dries wool unevenly and can shrink fibers.</li></ul>' }
      @{ heading='Annual: professional cleaning'; body='<p>Every 18 to 24 months, get your wool rug professionally cleaned. Specify "wool-only" or "natural fiber" cleaning. Standard carpet cleaning uses hot water extraction with detergents that are too aggressive for wool.</p><p>Best practice: have the rug rolled up and taken offsite by a specialist wool cleaner who hand-washes it with wool-safe products, then air-dries it flat. This is more expensive (Rs. 8 to Rs. 15 per square foot) but extends the rug life by years.</p><p>Avoid: dry cleaning with chemical solvents, machine-washing, putting wool rugs in tumble dryers.</p>' }
      @{ heading='Storage: when not in use'; body='<p>If you need to store a wool rug for more than a month:</p><ol><li>Vacuum thoroughly first. Then have it professionally cleaned if it has been used heavily.</li><li>Roll (do not fold) the rug, pile-side in. Folding creates permanent creases.</li><li>Wrap in cotton sheeting or natural-fiber breathable cloth. Never use plastic - it traps moisture and creates conditions for moths and mildew.</li><li>Store in a cool, dry, dark place. Cedar blocks or moth-repellent sachets (lavender, neem) prevent moth damage.</li><li>Unroll and air the rug for 24 hours every 6 months of storage.</li></ol>' }
    )
    faq = @(
      @{ q='How often should I vacuum a wool rug?'; a='At least once a week in normal use. Twice weekly in high-traffic rooms. Always with suction only - never with a beater bar, which damages wool over time.' }
      @{ q='Can I steam clean a wool rug?'; a='No. Steam cleaning uses hot water which sets stains, breaks down the latex backing on hand-tufted rugs, and can shrink wool fibers. Use cold water only for cleaning.' }
      @{ q='How long should a pure New Zealand wool rug last?'; a='With basic care: 20 to 25 years for hand-tufted (the latex backing is the limiting factor), and 30 to 100+ years for hand-knotted (no backing to fail). Rugkari rugs are backed by a tiered heirloom warranty: 25 years on hand-knotted, 10 years on hand-tufted and dhurrie.' }
      @{ q='Is it normal for a new wool rug to shed?'; a='Yes. Light shedding is normal for the first 3 to 6 months on new wool rugs. The loose fibers from the manufacturing process work their way out. Vacuum regularly and shedding will reduce significantly within a few months.' }
      @{ q='Can pets ruin a wool rug?'; a='Wool is surprisingly pet-friendly. The natural lanolin in wool creates mild stain resistance and pet urine wipes off if blotted immediately. The bigger risk is claw damage - trim pulled fibers flush with scissors, never pull them out. Cat claws and large dog nails should be regularly trimmed.' }
    )
  }
  @{
    slug = 'custom-rugs-india-everything-to-know'
    title = 'Custom Rugs in India: A Complete Buyer Guide (2026)'
    metaDesc = 'Custom rugs in India - sizes, materials, designs, pricing, lead times. Everything you need to know before ordering a bespoke handcrafted rug. Rugkari guide.'
    headline = 'Custom Rugs in India: Everything You Need to Know (2026)'
    description = 'A complete guide to ordering custom-made rugs in India - sizing, design, materials, lead times and pricing.'
    keywords = 'custom rugs India, made to order rugs, bespoke rug, custom size rug, custom design rug, made to measure rugs India'
    section = 'Buying Guide'
    image = 'https://cdn.shopify.com/s/files/1/0659/8649/4558/files/4.jpg?v=1777702439'
    datePublished = '2026-05-12'
    lede = 'Standard rug sizes do not work for many Indian homes. Modern apartments have unusual proportions, duplex living rooms need oversized rugs, and built-in furniture creates non-rectangular spaces. The solution: a custom-made rug. Here is exactly how the process works at Rugkari.'
    sections = @(
      @{ heading='What can be customized'; body='<p>Three dimensions of customization:</p><ol><li><strong>Size:</strong> any rectangular size from 3x5 ft up to 14x20 ft. Round rugs from 4 to 12 ft diameter. Runners from 2x4 ft up to 3x16 ft.</li><li><strong>Material:</strong> 100% pure New Zealand wool (standard), pure silk (premium, for hand-knotted only), wool-silk blend (premium hand-knotted).</li><li><strong>Design:</strong> customize any existing Rugkari design with your choice of colors, OR commission a fully custom design from your interior designer or mood board.</li></ol>' }
      @{ heading='The custom design process at Rugkari'; body="<p>The end-to-end process:</p><p><strong>Step 1: Brief us</strong> (week 1). Send dimensions, photos of the room, and references for design and color. WhatsApp our team or fill the custom enquiry form.</p><p><strong>Step 2: Design proposal</strong> (week 2). Our in-house designer creates two to three color and pattern options. You receive renders showing the rug in your room and material swatches.</p><p><strong>Step 3: Approval</strong> (week 2 to 3). Refinements as needed until you approve the final design.</p><p><strong>Step 4: Production</strong> (weeks 3 to 12). Hand-tufted custom: 2 to 4 weeks. Hand-knotted custom: 8 to 14 weeks depending on KPSI and size.</p><p><strong>Step 5: Quality check and shipping</strong> (final week). Rug is washed, sheared, finished, inspected, and shipped." }
      @{ heading='Pricing - how custom rug pricing works'; body='<p>Custom rugs are priced by square foot, not by the piece. The base rate depends on construction and material:</p><table style="width:100%; border-collapse:collapse; margin:24px 0;"><thead><tr style="border-bottom:1px solid #ccc;"><th style="text-align:left; padding:12px 8px;">Construction</th><th style="text-align:left; padding:12px 8px;">Material</th><th style="text-align:left; padding:12px 8px;">Approx. rate per sq ft</th></tr></thead><tbody><tr style="border-bottom:1px solid #eee;"><td style="padding:12px 8px;">Hand-tufted (20mm pile)</td><td style="padding:12px 8px;">Pure NZ wool</td><td style="padding:12px 8px;">Rs. 145 - Rs. 220</td></tr><tr style="border-bottom:1px solid #eee;"><td style="padding:12px 8px;">Hand-knotted (80 KPSI)</td><td style="padding:12px 8px;">Pure NZ wool</td><td style="padding:12px 8px;">Rs. 750 - Rs. 950</td></tr><tr style="border-bottom:1px solid #eee;"><td style="padding:12px 8px;">Hand-knotted (200 KPSI)</td><td style="padding:12px 8px;">Pure NZ wool</td><td style="padding:12px 8px;">Rs. 1,500 - Rs. 2,200</td></tr><tr style="border-bottom:1px solid #eee;"><td style="padding:12px 8px;">Hand-knotted (300 KPSI)</td><td style="padding:12px 8px;">Wool-silk blend</td><td style="padding:12px 8px;">Rs. 4,500 - Rs. 8,000</td></tr></tbody></table><p>A 9x12 ft custom hand-tufted rug at Rs. 180 per sq ft = Rs. 19,440. A 9x12 ft custom hand-knotted at 200 KPSI in pure NZ wool = Rs. 1,89,000 to Rs. 2,38,000.</p>' }
      @{ heading='When custom is worth it'; body='<p>Custom makes sense when:</p><ul><li>Your room dimensions do not match standard sizes (most common reason).</li><li>You want a specific color palette that matches your decor exactly.</li><li>You are working with an interior designer who has created a custom design.</li><li>You want a non-rectangular shape (round, oval, irregular).</li><li>The room is large enough that an oversized rug is needed (10x14 ft+).</li></ul><p>Standard sizes work fine if your room is 12x15, 14x18, or another common proportion. Buy standard.</p>' }
      @{ heading='What to send Rugkari when ordering custom'; body='<p>For the fastest, most accurate quote, send:</p><ol><li><strong>Floor plan or sketch</strong> showing rug placement relative to furniture, with all measurements.</li><li><strong>Photos of the room</strong> from at least 3 angles, ideally in daylight.</li><li><strong>Reference photos</strong> of rugs or designs you like (Pinterest links, magazine clippings, photos of friends rugs).</li><li><strong>Color palette</strong> from your existing decor - photos of sofa, curtains, walls, art.</li><li><strong>Timeline</strong> - when do you need the rug delivered?</li><li><strong>Budget range</strong> - lets us suggest the right construction and material.</li></ol><p>WhatsApp +91 73485 15188 with this information to start.</p>' }
    )
    faq = @(
      @{ q='How long does a custom rug take to make?'; a='Hand-tufted custom rugs: 2 to 4 weeks production + design phase (1 to 2 weeks) + shipping (5 to 10 days). Total: 4 to 8 weeks. Hand-knotted custom rugs: 8 to 14 weeks production + design + shipping. Total: 10 to 18 weeks depending on size and KPSI.' }
      @{ q='Are custom rugs more expensive than standard?'; a='Slightly. Custom rugs are priced by square foot at the same per-square-foot rate as standard rugs of the same construction. The premium is small (5 to 15%) due to one-off setup costs for the design, not a markup on labor or material.' }
      @{ q='Can I customize just the color of an existing Rugkari design?'; a='Yes. Color customization on existing designs is the easiest and fastest custom option - typically 3 to 4 weeks total. Send us color swatches or RAL codes.' }
      @{ q='Do you ship custom rugs across India?'; a='Yes, free shipping anywhere in India on all custom orders. Internationally we ship to most countries at actual courier rates.' }
      @{ q='Can custom rugs be returned?'; a='Custom-made rugs are non-returnable except for manufacturing defects, which remain covered by our heirloom warranty (25 years on hand-knotted, 10 years on hand-tufted and dhurrie). Before production starts you receive renders and approve the design, so the final rug should match expectations.' }
    )
  }
)

# Schema.org BlogPosting + WebPage + FAQ for a blog
function Build-JsonLd($blog) {
  $url = "https://rugs.rugkari.com/$($blog.slug)"
  $faqJson = ($blog.faq | ForEach-Object {
    $qEsc = $_.q.Replace('"','\"')
    $aEsc = $_.a.Replace('"','\"')
    '          { "@type": "Question", "name": "' + $qEsc + '", "acceptedAnswer": { "@type": "Answer", "text": "' + $aEsc + '" } }'
  }) -join ",`r`n"

  $sch = @"
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "Organization",
      "@id": "https://rugkari.com/#organization",
      "name": "Rugkari",
      "url": "https://rugkari.com/",
      "logo": { "@type": "ImageObject", "@id": "https://rugkari.com/#logo", "url": "/assets/RUGKARI-LOGO.webp" },
      "knowsAbout": ["Hand-tufted rugs", "Hand-knotted rugs", "Pure New Zealand wool rugs", "Rug care", "Bhadohi carpet weaving"],
      "areaServed": { "@type": "Country", "name": "India" }
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
      "@type": "WebPage",
      "@id": "$url#webpage",
      "url": "$url",
      "name": "$($blog.title)",
      "isPartOf": { "@id": "https://rugs.rugkari.com/#website" },
      "primaryImageOfPage": { "@type": "ImageObject", "url": "$($blog.image)" },
      "datePublished": "$($blog.datePublished)T09:00:00+05:30",
      "dateModified": "$($blog.datePublished)T09:00:00+05:30",
      "inLanguage": "en-IN",
      "isAccessibleForFree": true,
      "breadcrumb": { "@id": "$url#breadcrumb" },
      "speakable": { "@type": "SpeakableSpecification", "cssSelector": ["h1", ".article-lede", ".faq-question"] }
    },
    {
      "@type": "BreadcrumbList",
      "@id": "$url#breadcrumb",
      "itemListElement": [
        { "@type": "ListItem", "position": 1, "name": "Rugkari", "item": "https://rugs.rugkari.com/" },
        { "@type": "ListItem", "position": 2, "name": "Rug Care & Guides", "item": "https://rugs.rugkari.com/rug-care" },
        { "@type": "ListItem", "position": 3, "name": "$($blog.headline.Replace('"','\\"'))", "item": "$url" }
      ]
    },
    {
      "@type": "BlogPosting",
      "@id": "$url#article",
      "isPartOf": { "@id": "$url#webpage" },
      "mainEntityOfPage": { "@id": "$url#webpage" },
      "headline": "$($blog.headline.Replace('"','\\"'))",
      "description": "$($blog.description.Replace('"','\\"'))",
      "image": { "@type": "ImageObject", "url": "$($blog.image)" },
      "datePublished": "$($blog.datePublished)T09:00:00+05:30",
      "dateModified": "$($blog.datePublished)T09:00:00+05:30",
      "author": { "@type": "Organization", "name": "Rugkari Editorial Team", "url": "https://rugkari.com/" },
      "publisher": { "@id": "https://rugkari.com/#organization" },
      "reviewedBy": { "@id": "https://rugkari.com/#organization" },
      "keywords": "$($blog.keywords)",
      "articleSection": "$($blog.section)",
      "inLanguage": "en-IN",
      "isAccessibleForFree": true
    },
    {
      "@type": "FAQPage",
      "@id": "$url#faq",
      "inLanguage": "en-IN",
      "mainEntity": [
$faqJson
      ]
    }
  ]
}
</script>
"@
  return $sch
}

function Build-ArticleSectionsHtml($sections) {
  $sb = New-Object System.Text.StringBuilder
  foreach ($s in $sections) {
    [void]$sb.AppendLine('  <h2>' + $s.heading + '</h2>')
    [void]$sb.AppendLine('  ' + $s.body)
  }
  return $sb.ToString()
}

function Build-FaqHtml($faq) {
  $sb = New-Object System.Text.StringBuilder
  foreach ($f in $faq) {
    [void]$sb.AppendLine('    <details>')
    [void]$sb.AppendLine('      <summary class="faq-question">' + $f.q + '</summary>')
    [void]$sb.AppendLine('      <div class="faq-answer">' + $f.a + '</div>')
    [void]$sb.AppendLine('    </details>')
  }
  return $sb.ToString()
}

foreach ($b in $blogs) {
  $url = "https://rugs.rugkari.com/$($b.slug)"
  $jsonLd = Build-JsonLd $b
  $sectionsHtml = Build-ArticleSectionsHtml $b.sections
  $faqHtml = Build-FaqHtml $b.faq

  $page = @"
<!doctype html>
<html lang="en" prefix="og: https://ogp.me/ns#">
<head>
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','GTM-5L4Z9CSQ');</script>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="icon" type="image/webp" href="/assets/FEVICON.webp" />
<link rel="apple-touch-icon" href="/assets/FEVICON.webp" />
<title>$($b.title) | Rugkari</title>
<meta name="description" content="$($b.metaDesc)" />
<meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1" />
<link rel="canonical" href="$url" />
<meta property="og:type" content="article" />
<meta property="og:site_name" content="Rugkari" />
<meta property="og:url" content="$url" />
<meta property="og:title" content="$($b.title)" />
<meta property="og:description" content="$($b.metaDesc)" />
<meta property="og:image" content="$($b.image)" />
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
    <a href="/rug-care">Rug Care &amp; Guides</a><span class="sep">/</span>
    <span>$($b.section)</span>
  </nav>
</div>

<header class="page-hero">
  <div class="container-narrow">
    <p class="eyebrow tracking-luxury">$($b.section)</p>
    <h1>$($b.headline)</h1>
    <p class="article-meta"><span>By Rugkari Editorial Team</span><span>$($b.datePublished)</span><span>$($b.section)</span></p>
    <figure style="margin: 32px 0 0;">
      <img src="$($b.image)" alt="$($b.headline)" width="1200" height="700" loading="eager" style="width: 100%; aspect-ratio: 16/9; object-fit: cover;" />
    </figure>
  </div>
</header>

<article class="article-body">
  <p class="article-lede">$($b.lede)</p>
$sectionsHtml
</article>

<section class="section" style="background: var(--secondary);">
  <div class="container-narrow">
    <p class="eyebrow" style="text-align:center;">Frequently Asked</p>
    <h2 class="section-title" style="margin-bottom: 32px;">Common Questions</h2>
    <div class="faq-list">
$faqHtml
    </div>
  </div>
</section>

<section class="section">
  <div class="container">
    <p class="eyebrow" style="text-align:center;">Continue Reading</p>
    <h2 class="section-title">More from the Rug Guide</h2>
    <div class="product-grid three">
      <a class="product-card" href="/best-hand-tufted-rugs-for-living-room">
        <img class="card-media" src="https://cdn.shopify.com/s/files/1/0659/8649/4558/files/4695-kellywearstler-districtspruce-rug-1200x1800-roomset__38058.jpg?v=1777702455" alt="8 best hand-tufted rugs" width="400" height="500" loading="lazy" />
        <h3 class="card-title">8 Best Hand-Tufted Rugs for Indian Living Rooms</h3>
        <p class="card-price">Editor's Picks</p>
      </a>
      <a class="product-card" href="/hand-tufted-vs-machine-made-rugs">
        <img class="card-media" src="https://cdn.shopify.com/s/files/1/0659/8649/4558/files/1200x1800---cc_plexa_r_c9edf421-09e9-4752-be04-8e0b82194cc0.jpg?v=1777702445" alt="Hand-Tufted vs Machine-Made Rugs" width="400" height="500" loading="lazy" />
        <h3 class="card-title">Hand-Tufted vs Machine-Made Rugs</h3>
        <p class="card-price">Comparison Guide</p>
      </a>
      <a class="product-card" href="/rug-care">
        <img class="card-media" src="https://cdn.shopify.com/s/files/1/0659/8649/4558/files/designer-rugs-bernabeifreeman-contour-lo-wr-1.jpg?v=1777702443" alt="All Rugkari rug care guides" width="400" height="500" loading="lazy" />
        <h3 class="card-title">All Rugkari Care &amp; Buying Guides</h3>
        <p class="card-price">Guide Hub</p>
      </a>
    </div>
  </div>
</section>

</main>

$sharedFooter

</body>
</html>
"@

  $outPath = Join-Path $outDir ($b.slug + '.html')
  [System.IO.File]::WriteAllText($outPath, $page, $utf8NoBom)
  Write-Output ('  generated: ' + $b.slug + '.html')
}

Write-Output ''
Write-Output ('Done. ' + $blogs.Count + ' blog articles generated.')

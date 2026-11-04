# Rugkari Shopify store: status and next steps

## Done on 4 Nov 2026 (with the Shopify connector)

1. **Sold out fixed.** Rug variants already had "Continue selling" and no stock tracking.
   The storefront showed them sold out to visitors in the "Rest of World" market, which has
   no shipping, and to requests without an `Accept-Language` header (Googlebot), which
   Shopify placed in that market. The owner chose **India only**, so the United States,
   United Kingdom and Rest of World markets were set to **Draft** (not deleted).
   Result: 1,862 / 1,862 variants available, product pages report `InStock` to Google.
   The US/UK shipping zones were left in place; checkout only opens for active markets.
2. **New product page installed on an unpublished copy** of the live theme:
   "RUGKARI Live + New Product Page (Nov 2026)", theme id 189479125086.
   Files uploaded from this repo by pinned commit: `sections/main-product-rugkari.liquid`,
   `sections/rug-experience.liquid`, `templates/product.json` (old `main-product.liquid` kept
   for rollback). Tested on the store preview: no Liquid errors, real Shopify cart gets the
   rug and the per-size coating, Buy it now present, one Product JSON-LD with InStock,
   Shopify emits product_viewed and product_added_to_cart exactly as on the live theme.
3. **Store facts made consistent** (owner confirmed): 10-year warranty against
   manufacturing defects; returns for manufacturing defects only, within 15 days;
   phone +91 90222 66877.
   - Theme copy: header announcements, trust text (locale), homepage promise and story,
     product page panel and WhatsApp link. Edited files are in `theme-edits/`.
   - Live product descriptions: Cantus, Caesar, Alkaya ("1-year" → "10-year") and Aurora,
     Nexus, Starlite ("14-day inspection window" → "15-day returns"). No wrong numbers
     remain in any of the 249 descriptions.

## Waiting on the owner

1. **Publish the theme copy** after checking its preview:
   https://rugkari.com/?preview_theme_id=189479125086 (the connector cannot publish).
2. **Policies** (the connector lacks `write_legal_policies`), Settings › Policies:
   - Refund: "within 30 days" → "within 15 days" (3 places; "of receipt" → "of delivery");
     "Custom/made-to-order rugs" → "Custom-size or custom-colour rugs, except for
     manufacturing defects"; phone → +91 90222 66877.
   - Shipping: remove "International Orders …", add "Delivery: Across India only";
     phone → +91 90222 66877.
   - Refund policy says both "free pickup" and "buyer covers return shipping costs"; decide one.
   - Legal notice uses myrugkari@gmail.com; other pages use care@rugkari.com.
3. **Tracking**: Facebook & Instagram app › customer data sharing → Maximum (match quality
   4.4/10). Google Ads AW-18135638202 loads twice; it is not in the theme, so check the
   Google & YouTube app and Settings › Customer events for a second Google tag.
   After publishing, place one test order and confirm Purchase in Meta Events Manager.

# Next steps for the Rugkari Shopify store (rugkari.com)

Work list for the next session with the Shopify connector. Confirm each change with the
owner before running it, and work only on an unpublished copy of the live theme.

## 1. Fix "Sold out" on every rug (do this first)

- Checked 3 Nov 2026 from the public storefront: all 249 rug products, 1,862 variants, show
  `available: false`. Rugs are made to order.
- First read a few variants: `inventoryPolicy`, `inventoryItem.tracked`, inventory levels per location.
- Fix: set every rug variant to `inventoryPolicy: CONTINUE` ("Continue selling when out of stock"),
  or stop tracking quantity, whichever matches how the owner wants to run stock.
  Skip the "Partial Payment" product. Also check `stain-resistant-coating` (the add-on product)
  can be bought.
- With 249 products, use one bulk operation (`bulkOperationRunMutation` with
  `productVariantsBulkUpdate`) instead of 249 separate calls.
- Verify afterwards: `https://rugkari.com/products/<handle>.js` shows `"available": true`.

## 2. Install the new product page on a theme copy

- Live theme: "RUGKARI Atelier - No Hijack Checkout" (theme id 188522463326, assets under `/t/16/`).
- Duplicate it. On the copy:
  - add `sections/main-product-rugkari.liquid` and `sections/rug-experience.liquid` from this repo
  - in `templates/product.json` replace the old main product section with
    `main-product-rugkari` (use the preset blocks), then `rug-experience`, then keep the
    existing recommendations and recently viewed sections
  - set the advisor button link (WhatsApp, the footer shows +91 90222 66877; confirm with the owner)
- Run the test list in `PRODUCT-PAGE-ROLLOUT.md` on the copy's preview link.
- The owner publishes the copy. Publishing is blocked for the connector.

## 3. Make store facts match everywhere

Owner-confirmed on 3 Nov 2026: **10-year warranty** against manufacturing defects,
**15-day returns**, pile height **15–20 mm**.

Still showing older numbers on the live store:
- "Why you can buy with confidence" (product page): "Lifetime Warranty", "30-Night Trial"
- trust bar and footer: "7-day returns"
- "The Rugkari Difference" in product descriptions: "1-year manufacturing warranty"
- Settings › Policies › Refund policy: must say 15 days. Show the owner the current text and
  the proposed change before saving; it is a legal page.
- "How your rug is made" describes hand-knotting (Talim, graph paper, loom) on hand-tufted rugs.
  The new section uses hand-tufting steps; confirm with the owner.

## 4. Tracking

- Meta dataset 2829473034074642: no Purchase in 28 days (because of item 1). After item 1,
  place one real test order and confirm Purchase arrives in Events Manager.
- Facebook & Instagram app: set customer data sharing to Maximum (match quality is 4.4/10).
- Google Ads tag AW-18135638202 loads twice per page. Find both sources (theme code and the
  Google & YouTube app) and keep one.

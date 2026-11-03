# Product page rollout: checkout and tracking safety

Rules for changing the product page of the live Rugkari theme without breaking
checkout or Meta / Google tracking.

## What must not change

| Part | Keep exactly as it is | Why |
|---|---|---|
| Product form | `{% form 'product' %}` with `name="id"` (variant id) and `name="quantity"` | Shopify's cart, checkout and standard events read these fields |
| Size picker | Radios `name="options[Size]"` with the size as `value` | The theme's variant script and the Rug Experience section both listen to them |
| Add to cart | The theme's existing cart script (`/cart/add.js`) and cart drawer | Shopify emits `product_added_to_cart` from it, which Meta receives as AddToCart |
| Buy it now | `{{ form \| payment_button }}`: restyle only through CSS | Shopify accelerated checkout; replacing it breaks Shop Pay, UPI wallets and events |
| Stain coating add-on | The existing `data-addon-toggle` logic | Changing it can change the cart price |
| Pixels | Meta and Google stay in Shopify > Settings > Customer events (apps) | Never paste `fbq()` or `gtag()` into the theme: it double counts |

## Tracking (checked 3 Nov 2026)

Meta dataset `2829473034074642`, last 28 days (browser + server / Conversions API both arrive):

| Event | Server events |
|---|---|
| PageView | 2,886 |
| ViewContent | 1,672 |
| Search | 66 |
| AddToCart | 50 |
| InitiateCheckout | 19 |
| AddPaymentInfo | 1 |
| Purchase | **0** |

- No Purchase in 28 days: every variant is unavailable ("Sold out"), so nobody can buy. Fix
  inventory first (Products > select all > Bulk edit > "Continue selling when out of stock"),
  then place one real test order to confirm Purchase arrives in Meta Events Manager.
- Event Match Quality is 4.4/10: only IP, user agent and external id are sent. In the
  Facebook & Instagram app, set Customer data sharing to **Maximum** so checkout sends
  hashed email / phone (better match, better ad optimisation).
- Google: the Google Ads tag `AW-18135638202` loads twice on every page (theme code and an
  app). Keep one source only, or conversions are counted twice.

## Rug Experience section events

The section publishes one Shopify custom event per tab, once per page view:

```
Shopify.analytics.publish('rug_experience_open', { tab: 'size' | 'zoom' | 'room' | '3d', product })
```

It sends nothing to Meta on its own. To report it, add a custom pixel in
Settings > Customer events that subscribes to `rug_experience_open` and calls
`fbq('trackCustom', 'RugExperienceOpen', ...)`.

Tab order: Size guide (default), Texture, Room, 3D. three.js loads only when the 3D tab is opened.

## Installing the new product section

Files:
- `sections/main-product-rugkari.liquid`: the product page (gallery, buy box, description, steps).
- `sections/rug-experience.liquid`: size guide, texture, room view, 3D (in that order).

The section uses the live theme's own `global.js` hooks (`data-product-form`,
`data-variant-picker`, `data-addons`, `.product__media-list`, `.sticky-atc`, `.lightbox`),
so the cart, cart drawer, add-on, variant URL and sticky bar run on code that already works today.

Steps, on a duplicate of the live theme:
1. Edit code › Sections › add `main-product-rugkari` and `rug-experience` with these contents.
2. Customize › Products › Default product: hide the old product section, add
   "Product (Rugkari)" at the top and "Rug Experience" below it. Keep
   Recommendations and Recently viewed after them.
3. In "Product (Rugkari)" set the advisor button link (WhatsApp) and check the add-on handle
   is `stain-resistant-coating` (its variant names must equal the size names).
4. Run the test list above, then publish.

Checked before release (3 Nov 2026):
- Shopify Theme Check: 0 errors, 0 warnings on both sections.
- Rendered with the real Cantus data and the live `global.js`: size switch updates variant id,
  price, URL and size row; add-on shows the per-size price (Rs. 1,350 to Rs. 16,200) and is
  added as its own line; quantity, cart drawer, cart count, sticky bar, hover zoom, lightbox
  and mobile dots all work; no console errors; no sideways scroll on a 390 px phone.

## Release steps

1. Duplicate the live theme. Work only on the copy.
2. Change the product template and CSS on the copy.
3. Test on the copy's preview link, desktop and phone:
   - every size updates price, variant id and URL `?variant=`
   - stain coating adds the right amount in the cart
   - Add to cart opens the drawer; Buy it now reaches checkout
   - Meta Pixel Helper shows ViewContent on load and AddToCart on add, once each
   - Google Tag Assistant shows one AW tag, not two
   - products with 1 photo, and the product with 0 photos, still lay out correctly
4. Publish at a low-traffic hour. Keep the old theme in the library for one-click rollback.
5. Watch Events Manager and orders for 48 hours.

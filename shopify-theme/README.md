# Rugkari Shopify theme add-ons

These files are for the Shopify store (rugkari.com). They are not part of the
rugs.rugkari.com landing site and are excluded from its deploy via `.deployignore`.

## sections/main-product-rugkari.liquid

The redesigned product page. It reuses the live theme's cart and variant JavaScript, so checkout and tracking keep working. Install steps are in `PRODUCT-PAGE-ROLLOUT.md`.

## sections/rug-experience.liquid

See `PRODUCT-PAGE-ROLLOUT.md` for checkout and tracking rules before changing the product page.

An interactive section for product pages with four tabs:

1. **Size guide** (opens first): a top-down floor plan in feet (living room, bedroom, dining) with fit advice.
2. **Feel the texture**: a magnifier (3x / 5x / 8x) over the flat rug photo.
3. **In your room**: upload a room photo, use the live phone camera, or use the sample
   room. Drag the rug and its 4 corner dots to fit the floor, match the lighting, and save a photo.
4. **3D rug** (last): the rug at its real proportions with a wool pile texture and a pile
   close-up. "Flip corner" curls a corner to show the backing. three.js loads only when this tab opens.

The size chips stay in sync with the product form's Size option (in both directions).

### Install

1. Shopify admin > Online Store > Themes > on the live theme click **...** > **Duplicate**.
2. On the copy: **...** > **Edit code** > Sections > **Add a new section** named
   `rug-experience`, then paste this file's contents and save.
3. **Customize** > open a product page > **Add section** > **Rug Experience**.
   Place it below the main product block.
4. Preview it, then publish the copy.

### Optional

- Product metafield `custom.flat_image` (type: File, image) to choose the flat
  top-down photo exactly. Without it the section picks the non-square photo, and the
  shopper can switch photos with the small thumbnails.
- Section settings: sample room photo (an empty floor works best), pile depth, backing
  colour, accent colour, and the three texture facts.

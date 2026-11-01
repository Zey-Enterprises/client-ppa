# Chase Popp reconstruction report

Completed for local review on October 31, 2026. No commits, pushes, deployments, domain changes, or repository-setting changes were made. The existing CNAME remains byte-for-byte unchanged: `chasepopp.com`.

## Architecture

Custom GitHub Pages-compatible Jekyll 3.10 project, with no theme, frontend framework, or custom plugin. `_layouts/default.html` and `_layouts/post.html` share header, footer, metadata, and contact-form includes. Four native posts retain explicit original permalinks and publication dates. Custom CSS handles desktop/mobile layouts; JavaScript handles the mobile menu, video controls, and email handoff. All runtime images, fonts, and video are local.

`_config.yml` uses `https://chasepopp.com` and an empty baseurl. Development materials, the immutable reference archive, documentation, scripts, and browser artifacts are excluded from `_site/`. SEO includes descriptions, canonical URLs, Open Graph metadata, article structured data, robots.txt, and sitemap.xml. Nokogiri is a development-only validation dependency.

## URL mapping

| Original | Reconstruction |
| --- | --- |
| `/` | `/` |
| `/home` | Static redirect to `/`, with a fallback link and root canonical |
| `/about` | `/about` |
| `/lessons` | `/lessons` |
| `/blog` | `/blog` |
| `/blog/black-pearl-couloir` | Same slug; February 3, 2024 |
| `/blog/my-first-trip-to-ouray` | Same slug; January 30, 2024 |
| `/blog/why-do-i-climb` | Same slug; January 30, 2024 |
| `/blog/willow-lake-ice-wi5` | Same slug; February 23, 2024 |

The live `/home` and `/` have the same content. Extensionless routes are emitted as HTML files and work with Jekyll's preview server. Prints and product routes are excluded. The future storefront setting is empty and produces no navigation link.

## Evidence and assets

The initial implementation inspected all nine live routes at desktop and mobile sizes, including the mobile menu. It used Playwright original/rendered HTML, metadata, desktop/mobile captures, manual screenshots, manually saved HTML source, and the independent Wget copy. Existing evidence summaries are retained under excluded `output/`.

Manual-source content agreed with the Playwright copies for all seven manually saved in-scope pages. Desktop/mobile source and rendered text agreed across all nine captures. Wget supplied an independent content cross-check. No substantive live-versus-archive wording discrepancy was identified. Squarespace's delayed image animations sometimes produced temporary blank areas; its narrow-screen homepage heading overlapped the introduction. The reconstruction displays content directly and avoids that overlap.

`docs/asset-map.json` records selected original image URLs and archive paths. Only selected photography, logo, and AMGA badge were copied. Photographs were optimized as WebP, with 750px variants for responsive inline images. Original article image order and captions are retained. The original Quicksand Latin WOFF2 is hosted locally with an OFL license file. No Squarespace CSS or JavaScript framework is shipped.

The archive lacked the homepage video's media segments. The original 35-second clip was retrieved during implementation and converted to a local, silent H.264 MP4 with a local poster. Playback has a pause control and respects reduced-motion preferences by avoiding automatic playback when requested.

## Visual choices

Preserved pale gray backgrounds, Quicksand typography, muted red buttons, the logo, AMGA badge, climbing video, two-column guiding/biography sections, large photographic banners, alternating blog cards, narrow article text, caption placement, and social/contact footer. Mobile layouts stack content and provide an accessible menu. Desktop/mobile Lessons layouts retain the two original offerings, original descriptions, prices, photography, and external Explore Origin reservation destinations.

## Validation

The resumed validation preserved all existing implementation changes and performed one fresh Jekyll build to replace output left by interrupted preview/watch work. No generated file was manually edited.

- `bundle exec jekyll build`: passed.
- `bundle exec ruby scripts/validate.rb`: passed; nine routes and ten HTML files, local links/resources, image alt text, duplicate IDs, archive/development exclusions, and CNAME preservation.
- All four complete article texts, captions, and image counts match the reference using the existing validator; image sequences were verified during initial implementation.
- Generated CSS, JavaScript, and video match their current source files; production canonical URLs use chasepopp.com.
- Outstanding Lessons browser checks completed at 1440×1000 and 390×844: desktop columns and mobile stacking render; mobile document has no horizontal overflow; custom-adventure image/heading share a row above the form.
- Video browser check: local MP4 has readyState 4, duration 35.001633 seconds, advances during playback, and reports no media error. Pause changes the control to “Play video”; resume changes it back to “Pause video”.

The final browser work was limited to Lessons and homepage video; earlier site-wide screenshot comparisons were not repeated.

## Remaining limitations

The Lessons contact form uses an explicit email-app handoff rather than a hosted submission endpoint. Visitors review and send through their email app; no submission or delivery was tested. The original newsletter opt-in was omitted because no mailing-list integration is configured. A future form provider remains a separate integration decision.

Squarespace commenting and comment submission are not reproduced; existing comments remain in the archive. Reservation links retain the original external provider URLs, but no booking or transaction was initiated. Prints are intentionally absent. This is a faithful first reconstruction for review, not a claim of pixel-identical rendering across every browser or device. Live hosting and GitHub Pages deployment remain untested and unauthorized.

## Local commands

From the repository root:

```sh
bundle install
bundle exec jekyll build
bundle exec ruby scripts/validate.rb
bundle exec jekyll serve --host 127.0.0.1 --port 4017 --force_polling
```

Preview at http://127.0.0.1:4017/. Polling is recommended here because the initial event-based watcher missed some source changes in the Dropbox checkout. For later edits, first inspect the user's existing watch output and generated-file freshness; do not automatically start another server or rebuild when their watcher is current.

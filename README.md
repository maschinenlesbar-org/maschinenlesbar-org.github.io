# maschinenlesbar-org.github.io

The website of **maschinenlesbar.org**, served at <https://maschinenlesbar.org/>
(English) and <https://maschinenlesbar.org/de/> (Deutsch). It presents the two halves of
maschinenlesbar.org: the **search index** over around 12,000 public sources (*where is it?*)
and the **API wrappers** around the official APIs (*what does the source say right now?*),
the surfaces they reach people and agents through (web, command line, MCP), what is open
source and what is a service, and the blog. The individual tools are listed on the
[plugin marketplace site](https://maschinenlesbar.org/plugins/), not here.

It uses the same stack as the plugin marketplace site and every CLI's website:
[Jekyll](https://jekyllrb.com/), [banira](https://sebs.github.io/banira/) web components and
[Fylgja](https://fylgja.dev/) CSS.

## Layout

```
site/_data/i18n/{en,de}.yml all interface text, in both languages (same keys, or the build fails)
site/_data/nav.yml          the main menu: page refs, in order (each must exist in every language)
site/_plugins/i18n.rb       the check that en.yml and de.yml have the same keys
site/_plugins/nav.rb        the check that every menu entry has a page in every language
site/_layouts/              default.html (shell, menu, language switch, hreflang), home.html,
                            page.html (a content page), blog.html (the post list), post.html
site/_includes/             lang.html (t, home, blog_home, feed, plugins_home for the page's
                            language), card.html, status.html (the "Available" / "In the
                            making" badge), copy.html, post-list.html, feed.xml (Atom)
site/index.html, site/de/   the two home pages (front matter only; copy in _data/i18n)
site/search.md              the search index        (German: site/de/search.md)
site/wrappers.md            the API wrappers        (German: site/de/wrappers.md)
site/open-source.md         open source and service (German: site/de/open-source.md)
site/blog/, site/de/blog/   the two blog indexes (front matter only)
site/_posts/                English posts
site/de/_posts/             German posts
site/feed.xml, site/de/     the two Atom feeds (front matter only)
site/sitemap.xml            this site's sitemap: every page and every post
site/robots.txt             robots.txt for all of maschinenlesbar.org, with every site's sitemap
site/_data/sites.yml        the other sites under the domain (plugins, every CLI): a new CLI gets a line
site/components/*.ts        banira web components: <copy-command>
site/assets/css/site.css    site styles on top of Fylgja
site/scripts/vendor-css.mjs copies the pinned Fylgja stylesheets into assets/vendor/
.github/workflows/pages.yml builds site/ and deploys it to GitHub Pages
```

## Adding a page

A content page is Markdown with `layout: page`, once per language, linked by a shared `ref`:
`site/<slug>.md` and `site/de/<slug>.md` (served at `/<slug>/` and `/de/<slug>/`).

```markdown
---
layout: page
lang: en
ref: pricing
title: Pricing            # <title>, and the menu label unless `nav` is set
nav: Pricing              # optional, a shorter menu label
eyebrow: Service          # optional, above the heading
heading: What it costs    # optional, the h1 (else the title)
intro: One sentence.      # optional, under the heading and the meta description
status: making            # optional, a badge: available | making
---

## A section

- **An item**: its text. {% include status.html status="available" %}
```

To put it in the menu, add its `ref` to `site/_data/nav.yml`. The build fails if either
language lacks the page. A new status is a new key under `status` in both i18n files.

## Writing a post

An English post is `site/_posts/YYYY-MM-DD-slug.md`, its German translation
`site/de/_posts/YYYY-MM-DD-slug.md` (the slug may differ). Front matter is a `title` and a
`ref` shared by both versions, which links them through the language switch and `hreflang`:

```markdown
---
title: Hello, world
ref: hello-world
---

The first paragraph is the excerpt on the blog index, the home page and in the feed.
```

Layout, language and permalink (`/blog/YYYY/MM/slug/`, `/de/blog/YYYY/MM/slug/`) come from
the defaults in `site/_config.yml`. A post without a translation simply has no language
switch. Pushing it to `main` publishes it.

The home page's copy is in `site/_data/i18n/en.yml` and `de.yml`; the content pages carry
their own.

## Build and preview locally

Needs Node.js ≥ 22.12, Ruby 3.4 and Bundler.

```bash
cd site
npm ci && bundle install
npm run serve        # http://127.0.0.1:4000/
npm run build        # into site/_site/
npm test             # banira test + lint for the components
```

## Publishing

Pushes to `main` that touch `site/` deploy automatically. One-time repo setting:
**Settings → Pages → Build and deployment → Source → "GitHub Actions"**.

## License

Dual-licensed **AGPL-3.0-or-later OR commercial** — see [LICENSING.md](LICENSING.md). No
external code contributions are accepted ([CONTRIBUTING.md](CONTRIBUTING.md)).

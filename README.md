# maschinenlesbar-org.github.io

The website of **maschinenlesbar.org**, served at <https://maschinenlesbar-org.github.io/>
(English) and <https://maschinenlesbar-org.github.io/de/> (Deutsch): the blog of the
command-line tools, TypeScript clients and Claude Code skills for open German public-sector
APIs, with links to where they live — the
[plugin marketplace site](https://maschinenlesbar-org.github.io/plugins/) (every tool and its
website), GitHub and npm. The site doesn't describe the tools itself.

It uses the same stack as the plugin marketplace site and every CLI's website:
[Jekyll](https://jekyllrb.com/), [banira](https://sebs.github.io/banira/) web components and
[Fylgja](https://fylgja.dev/) CSS.

## Layout

```
site/_data/i18n/{en,de}.yml all interface text, in both languages (same keys, or the build fails)
site/_plugins/i18n.rb       the check that en.yml and de.yml have the same keys
site/_layouts/              default.html (shell, language switch, hreflang), home.html,
                            blog.html (the post list), post.html (one post)
site/_includes/             copy.html, post-list.html, feed.xml (the Atom feed)
site/index.html, site/de/   the two home pages (front matter only)
site/blog/, site/de/blog/   the two blog indexes (front matter only)
site/_posts/                English posts
site/de/_posts/             German posts
site/feed.xml, site/de/     the two Atom feeds (front matter only)
site/components/*.ts        banira web components: <copy-command>
site/assets/css/site.css    site styles on top of Fylgja
site/scripts/vendor-css.mjs copies the pinned Fylgja stylesheets into assets/vendor/
.github/workflows/pages.yml builds site/ and deploys it to GitHub Pages
```

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

The rest of the copy — the intro and the link descriptions on the home page — is in
`site/_data/i18n/en.yml` and `de.yml`.

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

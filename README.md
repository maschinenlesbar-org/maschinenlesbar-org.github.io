# maschinenlesbar-org.github.io

The landing page of **maschinenlesbar.org**, served at <https://maschinenlesbar-org.github.io/>
(English) and <https://maschinenlesbar-org.github.io/de/> (Deutsch): command-line tools,
TypeScript clients and Claude Code skills for open German public-sector APIs.

It uses the same stack as the [plugin marketplace site](https://maschinenlesbar-org.github.io/plugins/)
and every CLI's website: [Jekyll](https://jekyllrb.com/),
[banira](https://sebs.github.io/banira/) web components and [Fylgja](https://fylgja.dev/) CSS.

## Layout

```
site/_plugins/catalog.rb    builds the tool catalogue (see "Content" below)
site/_data/i18n/{en,de}.yml all interface text, in both languages (same keys, or the build fails)
site/_layouts/              default.html (shell, language switch, hreflang), home.html (the page)
site/index.html, site/de/   the two home pages (front matter only)
site/components/*.ts        banira web components: <copy-command>, <plugin-filter>
site/assets/css/site.css    site styles on top of Fylgja
site/scripts/vendor-css.mjs copies the pinned Fylgja stylesheets into assets/vendor/
.github/workflows/pages.yml builds site/ and deploys it to GitHub Pages
```

## Content

Nothing about the individual tools is written by hand. `catalog.rb` treats the
[plugin marketplace](https://github.com/maschinenlesbar-org/plugins) as the list of tools:

- **From the marketplace repo:** the tools, their categories and English descriptions
  (`.claude-plugin/marketplace.json`), and the German descriptions and category names
  (`site/_data/i18n/de.yml`).
- **From each CLI repo at `main`:** npm package, command name and version (`package.json`),
  whether the API needs a key or account (`site/_data/project.yml`), and the number of
  skills.

A new CLI therefore shows up here once it is in the marketplace. Because that content lives
in other repositories, `pages.yml` also rebuilds the site every Monday; run it manually
(Actions → Pages → Run workflow) to publish a change right away.

The general copy — the hero, "One design, every tool", licensing — is in
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

Every build refreshes the clones of the marketplace and CLI repositories in `site/.cache/`.

## Publishing

Pushes to `main` that touch `site/` deploy automatically. One-time repo setting:
**Settings → Pages → Build and deployment → Source → "GitHub Actions"**.

## License

Dual-licensed **AGPL-3.0-or-later OR commercial** — see [LICENSING.md](LICENSING.md). No
external code contributions are accepted ([CONTRIBUTING.md](CONTRIBUTING.md)).

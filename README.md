# maschinenlesbar-org.github.io

The organisation landing page for **maschinenlesbar.org**, served at
<https://maschinenlesbar-org.github.io/>.

It's a tiny [Jekyll](https://jekyllrb.com/) site: you write Markdown, GitHub
Pages renders the HTML. There is **no build workflow** — GitHub builds it
natively from the default branch.

## Editing

- Edit [`index.md`](index.md) — it's plain Markdown with a small YAML front
  matter block at the top.
- The look comes from the `jekyll-theme-cayman` theme set in
  [`_config.yml`](_config.yml).

The tool table in `index.md` was generated from the CLIs' `package.json` files;
update it by hand, or regenerate it if you script that.

## Preview locally (optional)

```bash
bundle install
bundle exec jekyll serve   # http://127.0.0.1:4000
```

## Publishing

Push to the default branch, then once: **Settings → Pages → Build and
deployment → Source → "Deploy from a branch" → `main` / `/ (root)`**. Every
later push rebuilds the site automatically.

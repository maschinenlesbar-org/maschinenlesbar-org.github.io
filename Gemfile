source "https://rubygems.org"

# Mirrors GitHub Pages' own build environment (pins Jekyll + the supported
# themes/plugins to the exact versions GitHub uses), so a local `bundle exec
# jekyll serve` matches what gets published.
gem "github-pages", group: :jekyll_plugins

# Ruby 3.3+/3.4 dropped these from the default gems, but the GitHub-Pages-pinned
# Jekyll still expects them. Only needed for local preview.
gem "webrick", "~> 1.8"
gem "csv"
gem "base64"
gem "bigdecimal"
gem "logger"

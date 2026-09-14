# Builds the tool catalogue of the maschinenlesbar.org landing page.
#
# The list of tools is the Claude Code plugin marketplace: it shallow-clones the
# marketplace repository (catalog.marketplace_repo) and reads
# .claude-plugin/marketplace.json for the tools, categories and English
# descriptions, and site/_data/i18n/<lang>.yml for their translations. It then
# shallow-clones every CLI repository at catalog.cli_ref and reads package.json
# (npm package, command, version), site/_data/project.yml (how the API is accessed)
# and skills/*/SKILL.md (skill count). Clones are cached under catalog.cache and
# refreshed on every build.
#
# The result is site.data["catalog"]. Interface strings live in _data/i18n/<lang>.yml
# and must have the same keys in every language listed under `languages`.

require "fileutils"
require "json"
require "open3"
require "yaml"

module Catalog
  class Generator < Jekyll::Generator
    safe true
    priority :highest

    def generate(site)
      config = site.config.fetch("catalog")
      languages = site.config.fetch("languages")
      default_lang = site.config.fetch("default_lang")
      check_translations(site.data.fetch("i18n"), languages, default_lang)

      cache = File.expand_path(config.fetch("cache", ".cache/repos"), site.source)
      git_base = ENV.fetch("GIT_URL_BASE", "https://github.com")
      org = config.fetch("org")
      pages = "https://#{org}.github.io"

      marketplace_repo = config.fetch("marketplace_repo")
      marketplace_dir = fetch_repo(git_base, marketplace_repo, config.fetch("marketplace_ref", "main"), cache)
      marketplace = JSON.parse(File.read(File.join(marketplace_dir, ".claude-plugin", "marketplace.json")))
      translations = languages.to_h do |lang|
        file = File.join(marketplace_dir, "site", "_data", "i18n", "#{lang}.yml")
        [lang, File.exist?(file) ? YAML.safe_load(File.read(file)) : {}]
      end

      tools = marketplace.fetch("plugins").map do |entry|
        repo = entry.dig("source", "repo") or raise fatal("#{entry["name"]}: marketplace entry without a github repo")
        dir = fetch_repo(git_base, repo, config.fetch("cli_ref", "main"), cache)
        package = JSON.parse(File.read(File.join(dir, "package.json")))
        project_file = File.join(dir, "site", "_data", "project.yml")
        project = File.exist?(project_file) ? YAML.safe_load(File.read(project_file)) : {}
        name = repo.split("/").last

        tool = {
          "name" => name,
          "repository" => repo,
          "plugin" => entry["name"],
          "category" => entry["category"],
          "package" => package.fetch("name"),
          "bin" => package["bin"].is_a?(Hash) ? package["bin"].keys.first : name,
          "version" => package["version"],
          "access" => project.dig("access", "type") || "open",
          "skills" => Dir.glob(File.join(dir, "skills", "*", "SKILL.md")).size,
          "website_url" => "#{pages}/#{name}/",
          "github_url" => "https://github.com/#{repo}",
          "npm_url" => "https://www.npmjs.com/package/#{package.fetch("name")}",
          "plugin_url" => "#{pages}/#{marketplace_repo.split("/").last}/#{entry["name"]}/",
        }
        tool.merge("i18n" => languages.to_h { |lang| [lang, localize(tool, entry, translations[lang], lang, default_lang)] })
      end

      site.data["catalog"] = {
        "tools" => tools,
        "tool_count" => tools.size,
        "skill_count" => tools.sum { |t| t["skills"] },
        "keyed_count" => tools.count { |t| t["access"] != "open" },
        "marketplace" => marketplace.fetch("name"),
        "marketplace_repo" => marketplace_repo,
        "plugins_url" => "#{pages}/#{marketplace_repo.split("/").last}/",
      }
    end

    private

    def fatal(message)
      Jekyll::Errors::FatalException.new(message)
    end

    # Clones the repository on the first build and refreshes it on later ones.
    def fetch_repo(git_base, repo, ref, cache)
      dir = File.join(cache, "#{repo.tr("/", "__")}@#{ref}")
      if File.directory?(File.join(dir, ".git"))
        run("git", "-C", dir, "fetch", "--quiet", "--depth", "1", "origin", ref)
        run("git", "-C", dir, "reset", "--quiet", "--hard", "FETCH_HEAD")
      else
        FileUtils.mkdir_p(cache)
        Jekyll.logger.info "Catalog:", "cloning #{repo} at #{ref}"
        run("git", "clone", "--quiet", "--depth", "1", "--branch", ref, "#{git_base}/#{repo}.git", dir)
      end
      dir
    end

    def run(*command)
      _, err, status = Open3.capture3(*command)
      raise fatal("#{command.join(" ")} failed: #{err}") unless status.success?
    end

    # Descriptions and category names come from the marketplace site's translations;
    # a missing one falls back to English (marked with its language) and warns.
    def localize(tool, entry, strings, lang, default_lang)
      description = lang == default_lang ? nil : strings.dig("plugins", entry["name"]).to_s.strip
      category = lang == default_lang ? nil : strings.dig("categories", entry["category"])
      if lang != default_lang
        Jekyll.logger.warn "Catalog:", "no #{lang} description for #{entry["name"]}, using English" if description.empty?
        Jekyll.logger.warn "Catalog:", "no #{lang} name for category #{entry["category"]}" unless category
      end
      description = nil if description.to_s.empty?
      {
        "description" => description || entry["description"],
        "description_lang" => (description || lang == default_lang) ? nil : default_lang,
        "category" => category || entry["category"],
        "search" => [tool["name"], tool["bin"], entry["description"], description, entry["category"], category,
                     *entry["keywords"]].compact.join(" ").downcase,
      }
    end

    def check_translations(i18n, languages, default_lang)
      reference = flat_keys(i18n.fetch(default_lang))
      languages.each do |lang|
        strings = i18n[lang] or raise fatal("_data/i18n/#{lang}.yml is missing")
        keys = flat_keys(strings)
        next if keys == reference

        raise fatal("_data/i18n/#{lang}.yml differs from #{default_lang}.yml: " \
                    "missing #{(reference - keys).inspect}, extra #{(keys - reference).inspect}")
      end
    end

    def flat_keys(hash, prefix = nil)
      hash.flat_map do |key, value|
        path = [prefix, key].compact.join(".")
        value.is_a?(Hash) ? flat_keys(value, path) : [path]
      end.sort
    end
  end
end

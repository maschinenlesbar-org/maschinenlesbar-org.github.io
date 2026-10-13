# Checks the interface strings of the maschinenlesbar.org website: every language
# listed under `languages` must have a _data/i18n/<lang>.yml with exactly the keys
# of the default language's file, or the build fails.

module I18n
  class Check < Jekyll::Generator
    safe true
    priority :highest

    def generate(site)
      i18n = site.data.fetch("i18n")
      default_lang = site.config.fetch("default_lang")
      reference = flat_keys(i18n.fetch(default_lang))
      site.config.fetch("languages").each do |lang|
        strings = i18n[lang] or raise fatal("_data/i18n/#{lang}.yml is missing")
        keys = flat_keys(strings)
        next if keys == reference

        raise fatal("_data/i18n/#{lang}.yml differs from #{default_lang}.yml: " \
                    "missing #{(reference - keys).inspect}, extra #{(keys - reference).inspect}")
      end
    end

    private

    def fatal(message)
      Jekyll::Errors::FatalException.new(message)
    end

    def flat_keys(hash, prefix = nil)
      hash.flat_map do |key, value|
        path = [prefix, key].compact.join(".")
        value.is_a?(Hash) ? flat_keys(value, path) : [path]
      end.sort
    end
  end
end

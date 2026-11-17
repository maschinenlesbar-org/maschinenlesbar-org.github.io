# Checks the main navigation of the maschinenlesbar.org website: every ref in
# _data/nav.yml must have a page in every language listed under `languages`, or the
# build fails (a missing page would silently drop the link from that language's menu).

module Nav
  class Check < Jekyll::Generator
    safe true
    priority :highest

    def generate(site)
      pages = site.pages.map { |page| [page.data["ref"], page.data["lang"]] }
      site.data.fetch("nav").each do |ref|
        site.config.fetch("languages").each do |lang|
          next if pages.include?([ref, lang])

          raise Jekyll::Errors::FatalException,
                "_data/nav.yml: no page with ref #{ref.inspect} and lang #{lang.inspect}"
        end
      end
    end
  end
end

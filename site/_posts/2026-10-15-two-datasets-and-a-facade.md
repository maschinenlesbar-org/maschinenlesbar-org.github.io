---
title: Two datasets and a facade
ref: two-datasets-and-a-facade
---

I am modelling a crawler for the German public web. Around 12K sources: Bundestag, Bundesrat, Behörden, Kommunen, the official pages of office holders. Not their private accounts and not general media, that line is drawn at the host level and nowhere else. The back of the envelope says 200 million URLs over five years, a bit above 100K a day on average.

Five systems. Three produce data, one fronts it, one is the service people use.

The spider produces exactly one thing: a URL index dataset. One append-only record per URL, host, first seen, last fetch, status, content hash, outlinks. The raw bytes go to an object store, keyed by hash. The spider does not know what a press release is.

The indexer produces exactly one thing: a content dataset. And only for content pages. A page-type classifier runs before extraction and decides if a URL is a Drucksache, a notice, a council paper, a speech, a PDF, or if it is a listing, a calendar, a search result page, a login form. The second group is never extracted, it only gets a flag in the URL index. So the URL index knows about all 200 million, the content dataset holds only the part of it that someone would actually read.

The archive takes the same "fetched" event as the indexer and stores a new version whenever the hash changed. Separate system, separate storage, does not care about the classifier.

Between those datasets and the service sits a search engine. Boring name on purpose. It ingests the content dataset and the URL index incrementally, builds its own index (OpenSearch today, whatever tomorrow), keeps a queryable projection of the URL index, and exposes one API: `search_content`, `get_document`, `search_urls`, `source_info`. Hybrid retrieval, facets, "as of" dates. Nothing on the service side has a connection string to anything the pipeline owns.

![System context of the Search App (SaaS): a researcher and MCP clients use the Search App; it reaches crawl and content data only through the Search Engine facade (search_content, search_urls, get_document), reads snapshots from the Archive, calls the open public-sector APIs behind maschinenlesbar.org, and gets completions from a customer-supplied model provider.]({{ '/assets/img/2026-10-15-search-app-context.png' | relative_url }})

The service itself is for research and viewing. Web UI, a WebMCP endpoint for in-browser agents, a remote MCP server, and a research agent that runs against the customer's own model (bring your own, we ship none). The MCP server carries the [33 maschinenlesbar.org plugins](https://maschinenlesbar.org/plugins/) ported to MCP tools, grouped by domain (parliament and transparency, statistics, warnings, energy, labour, one news tool that is tool only, tagesschau is not crawled), plus a handful of native tools over our own data. The native tools are a thin wrapper around the facade. If the facade is good, the tools are good.

p.s. The archive is still accessed directly by the viewer. `list_versions` and `diff_versions` probably move behind the same API next.

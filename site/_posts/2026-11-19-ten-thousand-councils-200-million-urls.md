---
title: Ten thousand councils, 200 million URLs
ref: 200-million-urls
seo_title: "Why 10,000 municipalities make 200 million URLs in one term"
description: >-
  No sitemaps, no feeds, no binding standard: why indexing German local politics means
  crawling every URL, ranking the link graph and storing URLs as more than strings.
---

Germany has just under 11,000 municipalities. Each has a council, committees, councilors, parties, a gazette, press releases, and, in most cases, a council information system that makes every meeting, agenda item, and document available online. Over one term, or five years in most Länder, this quickly sums up to 200 million URLs. This page explains why and how that number affects the [search index]({{ '/search/' | relative_url }}).

## Nobody tells you what's there

The courteous method to find out what a website contains is to ask it. A sitemap lists the pages, whereas an RSS feed lists what's new. In politics, neither is employed uniformly. Some councils have a sitemap that just goes to the homepage, while others have a feed for press releases but not council papers, and the majority have neither.

A binding standard does not exist. There is [OParl](https://oparl.org/), an open API for council information systems, which is excellent. It is also voluntary. [oparl-cli](https://maschinenlesbar.org/oparl-cli/) knows around 170 OParl servers, approximately 150 of which were operational at the last check. This is a rounding error compared to 11,000 municipalities.

So, the only way to find out what's there is to look. We need to create a website indexer for each municipality, its lawmakers, parties, and committees, as well as every document.

## Where does 200 million come from?

200 million across 10,000 towns equals 20,000 URLs per term, or around eleven per day. That seems like a lot until you consider a single council.

Consider a medium-sized town with ten committees that meet eight times per year. That equals 400 meetings per term. Each meeting has a page, an agenda, a dozen agenda items with one page each, two or three documents with one page and one file each, minutes, and a print view. Call it 60 URLs per meeting, or 24,000 for the meetings alone. Then there are the councilors, the parties and Fraktionen, the gazette, the press releases, and the town's pages.

And then there are the URLs that no one intended to create. The same document is served from a second address with a session id. The same list sorted five times. A calendar with one page for each month from 2004 to 2099. Search results pages, one for each query entered by anyone or any crawler. These are frequently the majority, and none are worth reading.

## We need all of them, to toss the majority away

To sort out the bad ones, we first need to see them. The [page-type classifier]({% post_url 2026-10-15-two-datasets-and-a-facade %}) determines if each page is a document, listing, calendar, or search result. A single page rarely says anything. Its neighbors do.

Surprisingly, we will implement a PageRank for this. Which page relates to which other page reveals a lot: a council paper is linked from an agenda, a committee page, and a councilor's profile. A search result page is linked from nothing stable but other search result sites. A calendar month continues to the next indefinitely. The link graph is how a crawler tells the town's archive from its limitless corridors.

That also includes storing the edges: which URLs link to which and when we saw them. In September, I [asked how to store 200 million URLs](https://sebs.maschinenlesbar.org/2026/09/15/200-million-urls-please/) and labeled the link structure optional. It's not.

## Suggestions for a solution

**A URL is not a string, so do not save it as one.** A heavily normalized schema divides each URL into its constituent parts: scheme, host, path segments, and query parameters, which are represented as key-value pairs.

Every host, path segment, and parameter value is only stored once and can be referenced. The majority of a council's URLs share the same host and path, so this is also compression. It makes useful questions cheap: every URL on this host with a `sort` parameter, every URL whose path begins with `/sitzung/`, and every host below `muenchen.de`. When the classifier determines that one parameter generates search result pages, it drops an entire family of URLs in a single statement.

The parameter order is normalized on the way in. `?a=1&b=2` and `?b=2&a=1` refer to the same page on practically every website, thus they should be the same row.

**Maybe we can create our own URL type.** PostgreSQL allows an extension to specify a type and [teach the indexes how to organize it](https://www.postgresql.org/docs/current/xindex.html) using an operator class. A URL type with the host's labels reversed (`de.muenchen.risi`), then the path, followed by the sorted query, would convert "this domain and all its subdomains" and "this path and everything below it" into range scans on the same index. There is prior art ([pguri](https://github.com/petere/pguri)), but it orders URLs as text. The measurements will tell us whether the normalized tables are sufficient or whether we should do this ourselves.

The normalized schema is built; the URL type, the PageRank and the crawler are not yet. The numbers above are estimations; I'll give the actual ones when the crawler has run for a while.

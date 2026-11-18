---
title: Ten thousand councils, 200 million URLs
ref: 200-million-urls
seo_title: "Why 10,000 municipalities make 200 million URLs in one term"
description: >-
  No sitemaps, no feeds, no binding standard: why indexing German local politics means
  crawling every URL, ranking the link graph and storing URLs as more than strings.
---

Germany has a little under 11,000 municipalities. Each has a council, committees, councillors, parties, a gazette, press releases and usually a council information system that puts every meeting, agenda item and document online. Over one term, five years in most Länder, that easily adds up to 200 million URLs. This post is about why, and about what that number does to the [search index]({{ '/search/' | relative_url }}).

## Nobody tells you what is there

The polite way to learn what a website holds is to ask it. A sitemap lists its pages, an RSS feed lists what is new. In politics neither is used consistently. Some councils have a sitemap that stops at the homepage, some have a feed for press releases but not for council papers, most have neither.

A binding standard doesn't exist. There is [OParl](https://oparl.org/), the open API for council information systems, and it is good. It is also voluntary. [oparl-cli](https://maschinenlesbar.org/oparl-cli/) knows about 170 OParl servers, around 150 of which worked at their last check. Against 11,000 municipalities, that is a rounding error.

So the only way to know what is there is to look. We need to build a web site indexer: for every municipality, every one of its politicians, parties and committees, every document.

## Where 200 million comes from

200 million over 10,000 municipalities is 20,000 URLs each per term, about eleven a day. That sounds like a lot until you count a single council.

Take a mid-sized town with ten committees that meet eight times a year. That is 400 meetings per term. Each meeting has a page, an agenda, a dozen agenda items with a page each, two or three documents per item with a page and a file each, minutes and a print view. Call it 60 URLs per meeting, 24,000 for the meetings alone. Then come the councillors, the parties and Fraktionen, the gazette, the press releases, the town's own pages.

And then the URLs nobody meant to make. The same document under a second address with a session id. The same list sorted five ways. A calendar with a page for every month back to 2004 and forward to 2099. Search result pages, one for every query anyone, or any crawler, ever typed. These are often the majority, and none of them is worth reading.

## We need all of them, to throw most away

To sort out the bad ones, we first need to have seen them. The [page-type classifier]({% post_url 2026-10-15-two-datasets-and-a-facade %}) decides per page whether it is a document or a listing, a calendar or a search result. A single page often doesn't say. Its neighbourhood does.

Surprisingly enough, we will code a PageRank for this. Which page links to which other page tells you a lot: a council paper is linked from an agenda, a committee page and a councillor's profile. A search result page is linked from nothing stable, only from other search result pages. A calendar month links to the next one, forever. The link graph is how a crawler tells the town's archive from the town's infinite corridors.

That means storing the edges too: which URL links to which, and when we saw it. In September I [asked how to store 200 million URLs](https://sebs.maschinenlesbar.org/2026/09/15/200-million-urls-please/) and called the link structure optional. It isn't.

## Ideas for a solution

**A URL is not a string, so don't store it as one.** A heavily normalised schema splits each URL into its parts: scheme, host, path segments, query parameters as key–value pairs. Every host, every path segment and every parameter value is stored once and referenced. Most URLs of a council share their host and most of their path, so this is also compression. It makes the useful questions cheap: every URL on this host with a `sort` parameter, every URL whose path starts with `/sitzung/`, every host below `muenchen.de`. And when the classifier decides that one parameter makes search result pages, a whole family of URLs goes in one statement.

The parameter order gets normalised on the way in. `?a=1&b=2` and `?b=2&a=1` are the same page on almost every site, so they should be the same row.

**Maybe a URL type of our own.** PostgreSQL lets an extension define a type and [teach the indexes how to order it](https://www.postgresql.org/docs/current/xindex.html), through an operator class. A URL type whose order is the host's labels reversed (`de.muenchen.risi`), then the path, then the sorted query would turn "this domain and all its subdomains" and "this path and everything below it" into range scans on one index. There is prior art ([pguri](https://github.com/petere/pguri)), but it orders URLs as text. Whether the normalised tables are enough, or whether this is worth doing ourselves, is what the measurements will say.

None of this is built yet. The numbers above are estimates, and I'll report the real ones when the crawler has run for a while.

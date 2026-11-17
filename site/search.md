---
layout: page
lang: en
ref: search
title: Search
eyebrow: Search index
heading: Where is it? Across 12,000 public sources.
intro: >-
  A maintained index of the German public web, from the Bundestag down to individual
  municipalities: searchable by people in the browser and by agents over MCP.
status: making
---

## The corpus

Around 12,000 official sources: parliaments, federal and state ministries, authorities,
municipal councils, and the official pages of office holders. Not their private accounts
and not general media; that line is drawn per host and nowhere else.

## Two datasets

- **URL index**: every page we fetch, with its host, when it was first seen and last
  fetched, its status and a hash of its content.
- **Content dataset**: only the pages someone would actually read, such as Drucksachen,
  notices, council papers and speeches. An open-source page-type classifier tells them
  apart from listings, calendars, search result pages and login forms.

A page that changes is kept as a new version, so a document can be read as it stood on a
given date.

## Search

One API over both datasets: full-text and hybrid search, facets, and documents as of a
date. Every hit carries its provenance: the source, the URL, and when it was fetched. The
same API serves two surfaces:

- **Web search**, for people. {% include status.html status="making" %}
- **A search tool over MCP**, for agents. {% include status.html status="making" %}

## From a hit to live data

The index answers *where is this?* Where the source has an official API, the matching
[wrapper]({{ '/wrappers/' | relative_url }}) answers *what does it say right now?*, live
and structured. And when a wrapper's answer cites a document, the index retrieves it in
full.

[How it fits together: Two datasets and a facade →]({% post_url 2026-10-15-two-datasets-and-a-facade %})

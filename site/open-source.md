---
layout: page
lang: en
ref: open-source
title: Open source
eyebrow: Open source and service
heading: The code is open. What we derive from it is a service.
intro: >-
  The code that wraps public endpoints is open source. What we derive from the public web,
  the curated sources, the index and the search over it, and running all of it for you, is
  a service.
---

## Open source

- **Every API wrapper**: the client, the command-line tool, its Claude Code skills, and
  the MCP servers to come. Licensed under the
  [AGPL-3.0-or-later](https://www.gnu.org/licenses/agpl-3.0.html): run it yourself for
  free; whoever runs a modified version as a network service publishes the changes.
- **A commercial license**, in parallel, for building the wrappers into a proprietary
  product without the AGPL's obligations.
- **The classifiers**: the models that tell a Drucksache, a notice or a speech from a
  listing, a calendar or a login page. {% include status.html status="making" %}

Offering both licenses needs a single copyright holder, so we don't accept external code
contributions. Bug reports and AGPL forks are welcome; each repository's `LICENSING.md`
and `CONTRIBUTING.md` have the details.

## Service

- **Source dataset**: the curated list of around 12,000 sources. How much of it will be
  open is still being decided. {% include status.html status="making" %}
- **Search**: the [search index]({{ '/search/' | relative_url }}) over the maintained
  corpus, as an API and on the web. {% include status.html status="making" %}
- **Hosted MCP servers**: the wrappers and the search tool, run and kept current for you.
  Finding and fetching from one endpoint, without running containers or following API
  changes yourself. {% include status.html status="making" %}

## The data belongs to its publishers

The wrappers fetch data; they don't own it. Every upstream API has its own terms, which
each tool documents in its `DATA_LICENSE.md`. We provide the tool, not the data.

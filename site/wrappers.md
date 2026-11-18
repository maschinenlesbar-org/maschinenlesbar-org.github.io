---
layout: page
lang: en
ref: wrappers
title: API wrappers
nav: Wrappers
eyebrow: API wrappers
heading: What does the source say right now?
description: "Open-source wrappers around official German public-sector APIs: a typed client, a command-line tool and an MCP server per API."
intro: >-
  The official APIs of the German public sector are documented unevenly, each one works
  differently, and they change often. A wrapper absorbs one API's quirks and changes behind
  an interface that stays put.
---

## One template for every API

Every wrapper is built to the same template. A typed client does the real integration
work: requests, retries on `429` and `503` that honour `Retry-After`, timeouts, input
checks, error mapping, and credentials that never leave their host. Thin layers sit on
top: a command-line tool for people and an MCP server for agents. Because both share the
client, a command and its options map directly onto an MCP tool and its input schema, so
each further wrapper costs little.

## Three ways to use one

- **Library**: the typed TypeScript client, in the npm package.
  {% include status.html status="available" %}
- **Command-line tool**: one per API, with Claude Code skills that teach Claude to use it.
  {% include status.html status="available" %}
- **MCP server**: the same commands as MCP tools, also as a container image to run
  yourself. {% include status.html status="making" %}

No runtime HTTP dependencies: everything is built on Node.js itself.

## The wrappers today

Parliament and transparency, statistics, weather and water levels, energy, warnings,
labour and more. The [tool list]({{ site.plugins_url }}) has every one of them, each with
its own website, its commands and its skills. All are open source on
[GitHub](https://github.com/{{ site.org }}) and published on
[npm](https://www.npmjs.com/org/{{ site.npm_scope }}).

The [FIM Portal wrapper]({{ '/fim-portal-cli/' | relative_url }}) is the reference
implementation: it defines the template the others follow.

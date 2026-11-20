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
top: a command-line tool for people and an MCP server for agents. Both share the client,
and the use cases live there too: the MCP tools answer the questions an agent asks (a
politician's voting record, the weather warnings for a place) next to the plain lookups.
So each further wrapper costs little.

## Three ways to use one

- **Library**: the typed TypeScript client, in the npm package.
  {% include status.html status="available" %}
- **Command-line tool**: one per API, with Claude Code skills that teach Claude to use it.
  {% include status.html status="available" %}
- **MCP server**: tools for the questions agents ask, on npm and as a container image to run
  yourself. {% include status.html status="available" %}

No runtime HTTP dependencies: everything is built on Node.js itself.

## Running an MCP server

Every wrapper's server is an npm package, `@maschinenlesbar.org/<api>-mcp`, and a
multi-arch container image, `ghcr.io/{{ site.org }}/<api>-mcp`. It speaks MCP on stdio, or
over Streamable HTTP when you start it with `--transport http`. For the FIM Portal API,
in Claude Code:

```sh
npm i -g @maschinenlesbar.org/fim-portal-mcp
claude mcp add fim-portal -- fim-portal-mcp
# or, with nothing installed but Docker:
claude mcp add fim-portal -- docker run -i --rm ghcr.io/{{ site.org }}/fim-portal-mcp:latest
```

Each API's page in the [tool list]({{ site.plugins_url }}#mcp) has the commands for its
server, and the `MCP.md` in its repository covers other clients, the options and any
credentials. Releases can't be changed once published; each one carries SBOMs for the
package and the image, and the image's provenance is signed, so
`gh attestation verify` can check it against the release that built it.

## The wrappers today

Parliament and transparency, statistics, weather and water levels, energy, warnings,
labour and more. The [tool list]({{ site.plugins_url }}) has every one of them, each with
its own website, its commands and its skills. All are open source on
[GitHub](https://github.com/{{ site.org }}) and published on
[npm](https://www.npmjs.com/org/{{ site.npm_scope }}).

The [FIM Portal wrapper]({{ '/fim-portal-cli/' | relative_url }}) is the reference
implementation: it defines the template the others follow.

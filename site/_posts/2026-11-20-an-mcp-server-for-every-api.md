---
title: An MCP server for every API
ref: mcp-servers
seo_title: "32 MCP servers for German public-sector APIs, on npm and ghcr.io"
description: >-
  Every maschinenlesbar.org wrapper now has an MCP server: 178 tools over 32 official
  German APIs, on npm and as container images you can verify.
---

Every one of the 32 API wrappers now has an MCP server next to its command-line tool. Together they have 178 tools, from the Bundestag's documents to water levels, weather warnings and the Tagesschau. Each is an npm package and a container image, open source like the rest.

## Tools for questions, not endpoints

An MCP tool is something an agent picks by its description, so the tools are shaped around the questions people ask, not around the API's routes. `getVotingRecord` gives a politician's roll-call votes in one mandate; `getWarningBriefing` merges the DWD's three warning feeds for a place, most severe first; Tagesschau's `getRegionalNews` takes a Bundesland by name. Next to them sit the plain lookups, for whatever the questions don't cover.

The logic behind those tools lives in the same typed client as the CLI's, not in the server. The checks the CLI has learned over many review rounds apply to the agent too: inputs canonicalised or refused, never sent raw, an answer exact or an error, and credentials that never leave their host. The server itself is a thin layer, with the official TypeScript SDK as its one runtime dependency, bundled into the package. On every push, a test drives each server with the official MCP client.

## Running one

The server speaks MCP on stdio, or over Streamable HTTP with `--transport http`. In Claude Code:

```sh
npm i -g @maschinenlesbar.org/fim-portal-mcp
claude mcp add fim-portal -- fim-portal-mcp
```

Or with nothing installed but Docker:

```sh
claude mcp add fim-portal -- docker run -i --rm ghcr.io/maschinenlesbar-org/fim-portal-mcp:latest
```

Every API's page in the [tool list]({{ site.plugins_url }}#mcp) has the commands for its own server, and the `MCP.md` in each repository covers other clients, the options and credentials. Where an API publishes its key, the server looks it up at the first call, as the CLI's `obtain-key` does. The two GENESIS servers need an account, and over HTTP they require a bearer token of your own.

Some APIs set limits the server has to keep. The Tagesschau API allows 60 requests an hour, so its server counts them and, at the limit, says when the next one is possible instead of being blocked.

## Releases you can check

The CLI and the server are released together from one tag, and a release can't be changed after it is published. It carries the npm packages, the container image as an archive, SBOMs for packages and images, checksums and signed provenance. The publish step puts exactly those files on npm and `ghcr.io`, after checking them against the release.

The images are built on distroless Node 24 for amd64 and arm64, run as a non-root user, are smoke-tested on both architectures on every push and are scanned for vulnerabilities every week. To check one against the release that built it:

```sh
gh attestation verify oci://ghcr.io/maschinenlesbar-org/fim-portal-mcp:0.10.0 \
  --repo maschinenlesbar-org/fim-portal-cli
```

## What's next

The Claude Code plugins don't start a server for you: a plugin that starts a command you may not have installed would have to install it, and the plugins never install anything. The servers run where you put them.

Next come the search tool over the [index]({{ '/search/' | relative_url }}) and hosted servers, so that finding a source and fetching its live data work from one endpoint.

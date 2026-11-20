---
layout: page
lang: de
ref: wrappers
title: API-Wrapper
nav: Wrapper
eyebrow: API-Wrapper
heading: Was sagt die Quelle gerade?
description: "Quelloffene Wrapper um die amtlichen APIs von Staat und Verwaltung: pro API ein typisierter Client, ein Kommandozeilen-Tool und ein MCP-Server."
intro: >-
  Die amtlichen APIs von Staat und Verwaltung sind ungleich dokumentiert, jede funktioniert
  anders, und sie ändern sich oft. Ein Wrapper fängt die Eigenheiten und Änderungen einer
  API ab, hinter einer Schnittstelle, die bleibt, wie sie ist.
---

## Eine Vorlage für jede API

Jeder Wrapper ist nach derselben Vorlage gebaut. Ein typisierter Client erledigt die
eigentliche Anbindung: Anfragen, Wiederholungen bei `429` und `503` unter Beachtung von
`Retry-After`, Timeouts, Eingabeprüfung, Fehlerbehandlung und Zugangsdaten, die ihren Host
nie verlassen. Darauf sitzen dünne Schichten: ein Kommandozeilen-Tool für Menschen und ein
MCP-Server für Agenten. Beide nutzen denselben Client, und dort liegen auch die
Anwendungsfälle: Die MCP-Tools beantworten die Fragen, die ein Agent stellt (das
Abstimmungsverhalten einer Abgeordneten, die Wetterwarnungen für einen Ort), neben den
einfachen Abfragen. So kostet jeder weitere Wrapper wenig.

## Drei Arten, einen zu nutzen

- **Bibliothek**: der typisierte TypeScript-Client, im npm-Paket.
  {% include status.html status="available" %}
- **Kommandozeilen-Tool**: eines pro API, mit Skills, die Claude Code beibringen, es zu
  nutzen. {% include status.html status="available" %}
- **MCP-Server**: Tools für die Fragen, die Agenten stellen, auf npm und als Container-Image zum
  Selbstbetrieb. {% include status.html status="available" %}

Keine Laufzeit-Abhängigkeiten für HTTP: Alles baut auf Node.js selbst auf.

## Einen MCP-Server betreiben

Den Server jedes Wrappers gibt es als npm-Paket, `@maschinenlesbar.org/<api>-mcp`, und als
Container-Image für mehrere Architekturen, `ghcr.io/{{ site.org }}/<api>-mcp`. Er spricht
MCP über stdio oder, mit `--transport http` gestartet, über Streamable HTTP. Für die API
des FIM-Portals, in Claude Code:

```sh
npm i -g @maschinenlesbar.org/fim-portal-mcp
claude mcp add fim-portal -- fim-portal-mcp
# oder, ohne etwas außer Docker zu installieren:
claude mcp add fim-portal -- docker run -i --rm ghcr.io/{{ site.org }}/fim-portal-mcp:latest
```

Die Seite jeder API in der [Tool-Übersicht]({{ site.plugins_url }}de/#mcp) zeigt die Befehle
für ihren Server; die `MCP.md` im jeweiligen Repository beschreibt andere Clients, die
Optionen und nötige Zugangsdaten. Veröffentlichte Releases lassen sich nicht mehr ändern;
jedes enthält SBOMs für Paket und Image, und die Provenienz des Images ist signiert, sodass
`gh attestation verify` sie gegen das Release prüfen kann, das es gebaut hat.

## Die Wrapper heute

Parlament und Transparenz, Statistik, Wetter und Pegelstände, Energie, Warnungen, Arbeit
und mehr. Die [Tool-Übersicht]({{ site.plugins_url }}de/) führt alle auf, jeden mit
eigener Website, seinen Befehlen und seinen Skills. Alle sind quelloffen auf
[GitHub](https://github.com/{{ site.org }}) und auf
[npm](https://www.npmjs.com/org/{{ site.npm_scope }}) veröffentlicht.

Der [Wrapper für das FIM-Portal]({{ '/fim-portal-cli/de/' | relative_url }}) ist die
Referenzimplementierung: Er gibt die Vorlage vor, der die anderen folgen.

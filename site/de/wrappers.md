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
MCP-Server für Agenten. Weil beide denselben Client nutzen, wird aus einem Befehl und
seinen Optionen direkt ein MCP-Tool mit seinem Eingabeschema – jeder weitere Wrapper
kostet wenig.

## Drei Arten, einen zu nutzen

- **Bibliothek**: der typisierte TypeScript-Client, im npm-Paket.
  {% include status.html status="available" %}
- **Kommandozeilen-Tool**: eines pro API, mit Skills, die Claude Code beibringen, es zu
  nutzen. {% include status.html status="available" %}
- **MCP-Server**: dieselben Befehle als MCP-Tools, auch als Container-Image zum
  Selbstbetrieb. {% include status.html status="making" %}

Keine Laufzeit-Abhängigkeiten für HTTP: Alles baut auf Node.js selbst auf.

## Die Wrapper heute

Parlament und Transparenz, Statistik, Wetter und Pegelstände, Energie, Warnungen, Arbeit
und mehr. Die [Tool-Übersicht]({{ site.plugins_url }}de/) führt alle auf, jeden mit
eigener Website, seinen Befehlen und seinen Skills. Alle sind quelloffen auf
[GitHub](https://github.com/{{ site.org }}) und auf
[npm](https://www.npmjs.com/org/{{ site.npm_scope }}) veröffentlicht.

Der [Wrapper für das FIM-Portal]({{ '/fim-portal-cli/de/' | relative_url }}) ist die
Referenzimplementierung: Er gibt die Vorlage vor, der die anderen folgen.

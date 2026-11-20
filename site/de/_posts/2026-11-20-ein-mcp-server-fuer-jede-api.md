---
title: Ein MCP-Server für jede API
ref: mcp-servers
seo_title: "32 MCP-Server für APIs aus Staat und Verwaltung, auf npm und ghcr.io"
description: >-
  Jeder Wrapper von maschinenlesbar.org hat jetzt einen MCP-Server: 178 Tools für 32
  amtliche APIs, auf npm und als Container-Images, die sich prüfen lassen.
---

Jeder der 32 API-Wrapper hat jetzt neben seinem Kommandozeilen-Tool einen MCP-Server. Zusammen haben sie 178 Tools, von den Dokumenten des Bundestags über Pegelstände und Wetterwarnungen bis zur Tagesschau. Jeder ist ein npm-Paket und ein Container-Image, Open Source wie alles andere.

## Tools für Fragen, nicht für Endpunkte

Ein Agent wählt ein MCP-Tool anhand seiner Beschreibung. Deshalb sind die Tools nach den Fragen geschnitten, die Menschen stellen, nicht nach den Routen der API. `getVotingRecord` liefert das namentliche Abstimmungsverhalten einer Abgeordneten in einem Mandat; `getWarningBriefing` führt die drei Warn-Feeds des DWD für einen Ort zusammen, die schwersten zuerst; `getRegionalNews` der Tagesschau nimmt ein Bundesland beim Namen. Daneben stehen die einfachen Abfragen, für alles, was die Fragen nicht abdecken.

Die Logik hinter diesen Tools liegt im selben typisierten Client wie die der CLI, nicht im Server. Was die CLI in vielen Prüfrunden gelernt hat, gilt damit auch für den Agenten: Eingaben werden vereinheitlicht oder abgelehnt, nie roh weitergereicht, eine Antwort ist exakt oder ein Fehler, und Zugangsdaten verlassen ihren Host nie. Der Server selbst ist eine dünne Schicht mit dem offiziellen TypeScript-SDK als einziger Laufzeit-Abhängigkeit, gebündelt im Paket. Bei jedem Push steuert ein Test jeden Server mit dem offiziellen MCP-Client.

## Einen betreiben

Der Server spricht MCP über stdio oder, mit `--transport http`, über Streamable HTTP. In Claude Code:

```sh
npm i -g @maschinenlesbar.org/fim-portal-mcp
claude mcp add fim-portal -- fim-portal-mcp
```

Oder ohne etwas außer Docker zu installieren:

```sh
claude mcp add fim-portal -- docker run -i --rm ghcr.io/maschinenlesbar-org/fim-portal-mcp:latest
```

Die Seite jeder API in der [Tool-Übersicht]({{ site.plugins_url }}de/#mcp) zeigt die Befehle für ihren Server; die `MCP.md` im jeweiligen Repository beschreibt andere Clients, die Optionen und Zugangsdaten. Wo eine API ihren Schlüssel veröffentlicht, holt der Server ihn beim ersten Aufruf, wie es `obtain-key` in der CLI tut. Die beiden GENESIS-Server brauchen ein Konto und verlangen über HTTP ein eigenes Bearer-Token.

Manche APIs setzen Grenzen, die der Server einhalten muss. Die Tagesschau-API erlaubt 60 Anfragen pro Stunde. Ihr Server zählt mit und sagt an der Grenze, wann die nächste Anfrage möglich ist, statt gesperrt zu werden.

## Releases, die sich prüfen lassen

CLI und Server erscheinen gemeinsam mit einem Tag, und ein Release lässt sich nach der Veröffentlichung nicht mehr ändern. Es enthält die npm-Pakete, das Container-Image als Archiv, SBOMs für Pakete und Images, Prüfsummen und signierte Provenienz. Der Veröffentlichungsschritt bringt genau diese Dateien auf npm und `ghcr.io`, nachdem er sie gegen das Release geprüft hat.

Die Images bauen auf distroless Node 24 auf, für amd64 und arm64, laufen ohne Root-Rechte, werden bei jedem Push auf beiden Architekturen getestet und jede Woche auf Schwachstellen untersucht. So prüfen Sie eines gegen das Release, das es gebaut hat:

```sh
gh attestation verify oci://ghcr.io/maschinenlesbar-org/fim-portal-mcp:0.10.0 \
  --repo maschinenlesbar-org/fim-portal-cli
```

## Wie es weitergeht

Die Plugins für Claude Code starten keinen Server: Ein Plugin, das einen Befehl startet, der vielleicht nicht installiert ist, müsste ihn installieren, und die Plugins installieren nie etwas. Die Server laufen dort, wo Sie sie hinstellen.

Als Nächstes kommen das Such-Tool über den [Index]({{ '/de/search/' | relative_url }}) und gehostete Server, damit sich eine Quelle finden und ihre aktuellen Daten abrufen lassen, über einen Endpunkt.

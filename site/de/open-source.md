---
layout: page
lang: de
ref: open-source
title: Open Source
eyebrow: Open Source und Dienst
heading: Der Code ist offen. Was wir daraus gewinnen, ist ein Dienst.
intro: >-
  Der Code, der öffentliche Schnittstellen anbindet, ist quelloffen. Was wir aus dem
  öffentlichen Web gewinnen – die kuratierten Quellen, den Index und die Suche darüber –
  und der Betrieb all dessen für Sie, ist ein Dienst.
---

## Open Source

- **Jeder API-Wrapper**: der Client, das Kommandozeilen-Tool, seine Skills für Claude
  Code und die kommenden MCP-Server. Lizenziert unter der
  [AGPL-3.0-or-later](https://www.gnu.org/licenses/agpl-3.0.html): Selbst betreiben ist
  kostenlos; wer eine veränderte Fassung als Netzwerkdienst anbietet, legt die Änderungen
  offen.
- **Eine kommerzielle Lizenz** daneben, für den Einbau der Wrapper in proprietäre
  Produkte ohne die Pflichten der AGPL.
- **Die Klassifikatoren**: die Modelle, die eine Drucksache, eine Bekanntmachung oder eine
  Rede von einer Übersicht, einem Kalender oder einer Anmeldeseite unterscheiden.
  {% include status.html status="making" %}

Beide Lizenzen anzubieten setzt einen einzigen Rechteinhaber voraus. Deshalb nehmen wir
keine fremden Code-Beiträge an. Fehlermeldungen und Forks unter der AGPL sind willkommen;
die Einzelheiten stehen in `LICENSING.md` und `CONTRIBUTING.md` jedes Repositorys.

## Dienst

- **Quellendatensatz**: die kuratierte Liste der rund 12.000 Quellen. Wie viel davon offen
  sein wird, ist noch nicht entschieden. {% include status.html status="making" %}
- **Suche**: der [Suchindex]({{ '/de/search/' | relative_url }}) über den gepflegten
  Bestand, als Schnittstelle und im Web. {% include status.html status="making" %}
- **Gehostete MCP-Server**: die Wrapper und das Such-Tool, für Sie betrieben und aktuell
  gehalten. Finden und abrufen über einen Endpunkt, ohne selbst Container zu betreiben oder
  API-Änderungen hinterherzulaufen. {% include status.html status="making" %}

## Die Daten gehören denen, die sie veröffentlichen

Die Wrapper rufen Daten ab, sie besitzen sie nicht. Jede API hat ihre eigenen
Nutzungsbedingungen; jedes Tool dokumentiert sie in seiner `DATA_LICENSE.md`. Wir liefern
das Werkzeug, nicht die Daten.

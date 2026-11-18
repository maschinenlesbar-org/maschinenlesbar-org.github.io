---
layout: page
lang: de
ref: search
title: Suche
eyebrow: Suchindex
heading: Wo steht das? In 12.000 öffentlichen Quellen.
description: "Ein gepflegter Suchindex über rund 12.000 Quellen aus Staat und Verwaltung, vom Bundestag bis zur Gemeinde, für Menschen und Agenten."
intro: >-
  Ein gepflegter Index des öffentlichen deutschen Webs, vom Bundestag bis zur einzelnen
  Gemeinde: durchsuchbar für Menschen im Browser und für Agenten über MCP.
status: making
---

## Der Bestand

Rund 12.000 amtliche Quellen: Parlamente, Bundes- und Landesministerien, Behörden,
Gemeinderäte und die offiziellen Seiten von Amtsträgern. Nicht ihre privaten Accounts und
keine allgemeinen Medien; diese Grenze wird pro Host gezogen und nirgends sonst.

## Zwei Datensätze

- **URL-Index**: jede Seite, die wir abrufen, mit Host, wann sie zuerst gesehen und
  zuletzt abgerufen wurde, Status und einem Hash ihres Inhalts.
- **Inhaltsdatensatz**: nur die Seiten, die jemand tatsächlich lesen würde, etwa
  Drucksachen, Bekanntmachungen, Ratsvorlagen und Reden. Ein quelloffener
  Seitentyp-Klassifikator trennt sie von Übersichtslisten, Kalendern, Suchergebnisseiten
  und Login-Formularen.

Ändert sich eine Seite, wird sie als neue Version aufbewahrt. So lässt sich ein Dokument
lesen, wie es an einem bestimmten Tag aussah.

## Suche

Eine Schnittstelle für beide Datensätze: Volltext- und hybride Suche, Filter und Dokumente
zu einem Stichtag. Jeder Treffer nennt seine Herkunft: die Quelle, die URL und wann sie
abgerufen wurde. Dieselbe Schnittstelle bedient zwei Oberflächen:

- **Websuche** für Menschen. {% include status.html status="making" %}
- **Ein Such-Tool über MCP** für Agenten. {% include status.html status="making" %}

## Vom Treffer zu den aktuellen Daten

Der Index beantwortet *Wo steht das?* Hat die Quelle eine amtliche API, beantwortet der
passende [Wrapper]({{ '/de/wrappers/' | relative_url }}) *Was sagt sie gerade?* – aktuell
und strukturiert. Und verweist die Antwort eines Wrappers auf ein Dokument, holt der Index
es vollständig.

[Wie alles zusammenspielt: Zwei Datensätze und eine Fassade →]({% post_url de/2026-10-15-zwei-datensaetze-und-eine-fassade %})

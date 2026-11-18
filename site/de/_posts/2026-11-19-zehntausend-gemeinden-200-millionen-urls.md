---
title: Zehntausend Gemeinden, 200 Millionen URLs
ref: 200-million-urls
seo_title: "Warum 10.000 Gemeinden in einer Wahlperiode 200 Millionen URLs erzeugen"
description: >-
  Keine Sitemaps, keine Feeds, kein verbindlicher Standard: warum ein Index der
  Kommunalpolitik jede URL erfassen, den Linkgraphen bewerten und URLs als mehr als
  Zeichenketten speichern muss.
---

Deutschland hat knapp 11.000 Gemeinden. Jede hat einen Rat, Ausschüsse, Ratsmitglieder, Parteien, ein Amtsblatt, Pressemitteilungen und meist ein Ratsinformationssystem, das jede Sitzung, jeden Tagesordnungspunkt und jedes Dokument online stellt. Über eine Wahlperiode, in den meisten Ländern fünf Jahre, kommen so leicht 200 Millionen URLs zusammen. In diesem Beitrag geht es darum, warum, und was diese Zahl für den [Suchindex]({{ '/de/search/' | relative_url }}) bedeutet.

## Niemand sagt, was da ist

Der höfliche Weg, herauszufinden, was eine Website enthält, ist, sie zu fragen. Eine Sitemap listet ihre Seiten, ein RSS-Feed listet, was neu ist. In der Politik wird beides nicht durchgängig genutzt. Manche Gemeinden haben eine Sitemap, die bei der Startseite aufhört, manche einen Feed für Pressemitteilungen, aber nicht für Vorlagen, die meisten haben keines von beiden.

Einen verbindlichen Standard gibt es nicht. Es gibt [OParl](https://oparl.org/), die offene API für Ratsinformationssysteme, und sie ist gut. Sie ist auch freiwillig. Die [oparl-cli](https://maschinenlesbar.org/oparl-cli/de/) kennt etwa 170 OParl-Server, von denen rund 150 bei der letzten Prüfung funktionierten. Gemessen an 11.000 Gemeinden ist das ein Rundungsfehler.

Also bleibt nur, nachzusehen. Wir müssen einen Website-Indexer bauen: für jede Gemeinde, jede ihrer Politikerinnen und Politiker, Parteien und Ausschüsse, jedes Dokument.

## Woher die 200 Millionen kommen

200 Millionen auf 10.000 Gemeinden sind 20.000 URLs je Gemeinde und Wahlperiode, etwa elf am Tag. Das klingt nach viel, bis man einen einzigen Rat durchzählt.

Eine mittelgroße Stadt mit zehn Ausschüssen, die achtmal im Jahr tagen: Das sind 400 Sitzungen pro Wahlperiode. Jede Sitzung hat eine Seite, eine Tagesordnung, ein Dutzend Tagesordnungspunkte mit je einer Seite, zwei oder drei Dokumente pro Punkt mit je einer Seite und einer Datei, ein Protokoll und eine Druckansicht. Rund 60 URLs pro Sitzung, 24.000 allein für die Sitzungen. Dazu kommen die Ratsmitglieder, die Parteien und Fraktionen, das Amtsblatt, die Pressemitteilungen, die eigenen Seiten der Stadt.

Und dann die URLs, die niemand machen wollte. Dasselbe Dokument unter einer zweiten Adresse mit Session-ID. Dieselbe Liste in fünf Sortierungen. Ein Kalender mit einer Seite für jeden Monat von 2004 bis 2099. Suchergebnisseiten, eine für jede Anfrage, die je ein Mensch oder ein Crawler eingetippt hat. Sie sind oft die Mehrheit, und keine davon ist lesenswert.

## Wir brauchen alle, um die meisten wegzuwerfen

Um die schlechten auszusortieren, müssen wir sie erst einmal gesehen haben. Der [Seitentyp-Klassifikator]({% post_url de/2026-10-15-zwei-datensaetze-und-eine-fassade %}) entscheidet je Seite, ob sie ein Dokument ist oder eine Liste, ein Kalender oder ein Suchergebnis. Eine einzelne Seite verrät das oft nicht. Ihre Nachbarschaft schon.

Überraschenderweise werden wir dafür einen PageRank programmieren. Welche Seite auf welche andere verlinkt, sagt viel: Eine Vorlage wird von einer Tagesordnung, einer Ausschussseite und dem Profil eines Ratsmitglieds verlinkt. Eine Suchergebnisseite wird von nichts Beständigem verlinkt, nur von anderen Suchergebnisseiten. Ein Kalendermonat verlinkt auf den nächsten, endlos. Am Linkgraphen erkennt ein Crawler das Archiv der Stadt und unterscheidet es von ihren endlosen Fluren.

Also speichern wir auch die Kanten: welche URL auf welche verlinkt und wann wir das gesehen haben. Im September habe ich [gefragt, wie man 200 Millionen URLs speichert](https://sebs.maschinenlesbar.org/2026/09/15/200-million-urls-please/) (englisch), und die Linkstruktur optional genannt. Das ist sie nicht.

## Ideen für eine Lösung

**Eine URL ist keine Zeichenkette, also speichern wir sie nicht so.** Ein stark normalisiertes Schema zerlegt jede URL in ihre Teile: Schema, Host, Pfadsegmente, Query-Parameter als Schlüssel-Wert-Paare. Jeder Host, jedes Pfadsegment und jeder Parameterwert wird einmal gespeichert und referenziert. Die meisten URLs einer Gemeinde teilen sich den Host und den größten Teil des Pfads, das ist also auch Kompression. Damit werden die nützlichen Fragen billig: jede URL auf diesem Host mit einem `sort`-Parameter, jede URL, deren Pfad mit `/sitzung/` beginnt, jeder Host unterhalb von `muenchen.de`. Und wenn der Klassifikator feststellt, dass ein Parameter Suchergebnisseiten erzeugt, geht eine ganze Familie von URLs mit einer Anweisung.

Die Reihenfolge der Parameter wird beim Einlesen normalisiert. `?a=1&b=2` und `?b=2&a=1` sind auf fast jeder Website dieselbe Seite, also sollten sie dieselbe Zeile sein.

**Vielleicht ein eigener URL-Typ.** PostgreSQL erlaubt einer Erweiterung, einen Typ zu definieren und [den Indexen beizubringen, wie er sortiert wird](https://www.postgresql.org/docs/current/xindex.html), über eine Operatorklasse. Ein URL-Typ, der nach den umgedrehten Labels des Hosts sortiert (`de.muenchen.risi`), dann nach dem Pfad, dann nach der sortierten Query, würde „diese Domain und alle Subdomains“ und „dieser Pfad und alles darunter“ zu Bereichsabfragen auf einem Index machen. Es gibt Vorarbeiten ([pguri](https://github.com/petere/pguri)), die URLs aber als Text sortieren. Ob die normalisierten Tabellen reichen oder ob sich das Selbermachen lohnt, werden die Messungen zeigen.

Das normalisierte Schema steht; der URL-Typ, der PageRank und der Crawler noch nicht. Die Zahlen oben sind Schätzungen, und ich berichte die echten, wenn der Crawler eine Weile gelaufen ist.

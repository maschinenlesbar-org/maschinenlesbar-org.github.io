---
title: Zehnmal so weit, wie sie hoch sind
ref: 10h-research
seo_title: "Wie Bayern zu 10H kam: ein Agent, vier APIs und 140 PDFs"
description: >-
  Wie Bayerns 10H-Regel für Windräder entstand, recherchiert mit einem Agenten und
  den CLIs von maschinenlesbar.org: was die APIs belegen und wo sie enden.
---

Seit 2014 müssen Windräder in Bayern das Zehnfache ihrer Höhe Abstand zur Wohnbebauung halten. Die Regel heißt 10H, seit 2022 ist sie gelockert. Ich wollte wissen, wie es dazu kam, aus den Dokumenten, nicht aus der Berichterstattung, und habe bei der Fassung angefangen, die man meist hört: Sachsen und Bayern drängten, der Bund öffnete die Tür, Bayern ging hindurch.

Herausgekommen sind ein [Wiki](https://github.com/maschinenlesbar-org/10h-rule), ein Archiv aus PDFs und der [10H Explorer](https://maschinenlesbar.org/10h-rule/), in dem jede Aussage auf eine Seite verweist. Das hat vier Tage gedauert, und den größten Teil des Lesens hat Claude Code übernommen.

## Die Werkzeuge

Vier Plugins aus dem [Marktplatz]({{ site.plugins_url }}), freigeschaltet in der `.claude/settings.json` des Recherche-Repos, und keine weiteren:

- `dip` aus der [dip-bundestag-cli](https://maschinenlesbar.org/dip-bundestag-cli/): Drucksachen, Plenarprotokolle, Vorgänge, Personen und ihre Aktivitäten. Das Arbeitspferd. DIP erfasst auch die Drucksachen des Bundesrats, also kamen die Bundesratsinitiativen darüber.
- `abgeordnetenwatch`: Mandate, Fraktionen, Ausschüsse und Abstimmungen, für den Bundestag und die Landtage.
- `fragdenstaat`: Informationsfreiheitsanfragen und was darauf zurückkam.
- `bundesrat`: freigeschaltet, aber was der Bundesrat zu sagen hatte, deckte DIP ab.

Drumherum Werkzeuge, die nicht von uns sind: `pdftotext` und `pdftoppm` aus poppler, `tesseract` für die Scans und `node:sqlite` für den Explorer.

Ein eigenes Werkzeug kam nicht zum Einsatz: `ka` von openka. Seine Quelle für Bayern ist ein RSS-Feed, der nur die neuesten Wochen enthält und keinen Zeitraum kennt, 2013 liegt also außer Reichweite, und die Erkundung für Sachsen blieb hängen. Die Anfragen wurden stattdessen direkt per HTTP geladen. Das ist ein Befund über openka genauso wie über 10H.

## Warum ein Agent

Ein Agent, dem man eine These gibt, bringt sie gern bestätigt zurück. Dieser kam mit „teilweise“ und „Ergebnis ja, Weg nein“ zurück, und genau dafür war er da. Die `CLAUDE.md` des Recherche-Repos verlangt für jede Aussage eine Markierung: `[secondary]`, wenn nur eine Sekundärquelle sie stützt, `[not verified]`, wenn gar nichts, und keine Markierung nur dann, wenn das Primärdokument gelesen wurde. Die Aufgabe des Agenten war nicht, die Geschichte zu schreiben. Sie war, so lange zu lesen, bis jede Aussage ihre Markierung verlieren konnte oder behalten musste.

Das ist viel Lesestoff: über 3.300 Seiten, rund 9,5 Millionen Zeichen. Jede Antwort im Bundestag wurde im PDF gelesen. Jede Drucksachennummer musste über drei Zitierweisen hinweg zugeordnet werden (`BT-Drs 18/1310`, `BR-Drs 155/14(B)`, `BY Drs 17/2137`) und über drei Parlamente, die einander zitieren. Das ist die Arbeit, an der ehrenamtliche Projekte enden, und der Agent langweilt sich nicht bei Frage 40 von 48.

Er führt auch Buch. Ein neues PDF bekommt eine Zeile in der `manifest.tsv` seines Ordners, mit Quell-URL und SHA-256, und eine Zeile im Archivverzeichnis. Ein neuer Befund berührt die Themenseite, die Zeitleiste, das Quellenverzeichnis und die Liste der offenen Fragen. Ein Mensch lässt das am dritten Tag weg. Der Agent hat es in jedem Commit gemacht.

Und er schreibt den Code rund um die Recherche. Die Pipeline des Explorers, der Profil-Abruf und der Parser für die namentlichen Abstimmungen sind in denselben Sitzungen entstanden. Wie bei openka hat das Modell Code geschrieben, aber selbst nichts aus den Dokumenten gezogen: Der Explorer wird mit festen Regeln und Wörterbüchern gebaut, und kein Sprachmodell läuft darin. Ein Modell darf eine Verknüpfung vorschlagen, aber sie landet als unbestätigt in der Datenbank, bis jemand sie bestätigt.

## Wie die APIs die Recherche erden

Die Regel war: Die API findet, das PDF belegt, der Build prüft.

**Finden.** DIP wurde nach Titeln durchsucht (Windkraft, Windenergie, Mindestabstand, Länderöffnungsklausel, 10H und weitere) und nach dem Deskriptor „Windenergieanlage“, über die Wahlperioden 17 und 18. Das brachte die Schriftlichen Fragen, die beiden Kleinen Anfragen, die das Thema berühren, und DIP-Vorgang 59400 mit jedem Schritt der Bundesklausel, von der Kabinettsklausur in Meseberg bis zum Bundesgesetzblatt. Danach wurde jede Antwort im PDF gelesen. Wer geantwortet hat, steht im gedruckten Kopf; DIP nennt dieselben Namen, zwei unabhängige Quellen stimmen also überein.

**Personen zur damaligen Zeit.** 81 Politikerinnen und Politiker haben ein Profil aus abgeordnetenwatch (CC0) und DIP: Mandate, Fraktion, Ausschüsse, Ämter je Wahlperiode, Zahl der Aktivitäten 2012 bis 2016. Jede Beziehung hat einen Anfang und ein Ende, denn „Umweltminister“ gilt für einen Zeitraum, nicht allgemein. Über die abgeordnetenwatch-ID ist außerdem jede Person exakt mit Wikidata verknüpft (Eigenschaft P5355), keine wurde über ihren Namen zugeordnet.

**Abstimmungen.** Die Namenslisten wurden Name für Name aus den Protokollen gelesen. Bei den bayerischen Abstimmungen kam die Fraktion jedes Mitglieds am Abstimmungstag aus den Landtagsdaten von abgeordnetenwatch. Die Summen müssen dem Protokoll entsprechen, 465 : 114 : 3 im Bundestag und 92 : 63 im Landtag, sonst schlägt der Build fehl.

**Informationsfreiheit.** Die Such-API von FragDenStaat bekam 18 Suchbegriffe. Das wichtigste Ergebnis ist ein negatives, und es ist ein Befund: Zu Bayern 2013 gibt es nichts, weil Bayern kein Informationsfreiheitsgesetz hat. Was es gibt, ist die Bundesseite, darunter die Liste der über 100 Verbände, die das Bundesumweltministerium zum Gesetzentwurf angehört hat.

**Zahlen.** Der Explorer sammelt 357 Zahlen aus den Antworten der Regierungen: Anträge, Genehmigungen, in Betrieb genommene Anlagen. Jede trägt das Zitat, aus dem sie stammt, der Build sucht dieses Zitat auf seiner Seite, und nur gefundene Zahlen kommen ins Diagramm. Wo zwei Antworten sich widersprechen (64 oder 62 Genehmigungen 2015), bleiben beide stehen, mit einer Anmerkung. Die wenigen deutenden Verknüpfungen, „das führte zu jenem“, werden genauso geprüft, tragen eine schriftliche Begründung und eine eigene Farbe, damit man Belegtes von Gefolgertem unterscheiden kann.

## Weitere Befunde

- **Seehofers eigenes Ministerium riet ab.** Nach dem Treffen vom 05.03.2013 mit den Bürgerinitiativen von „Gegenwind Unterfranken“ rechnete das Umweltministerium Abstandsvarianten für ganz Bayern durch und kam zu dem Ergebnis, dass „einheitliche Abstände größer als 1000 Meter nicht rechtssicher dargestellt werden können“. Das war drei Monate vor der Bundesratsinitiative.
- **Der Auftrag hinterließ kein Papier.** Seehofer erteilte ihn mündlich in einem Gespräch. Der einzige amtliche Beleg ist die Antwort der Staatsregierung auf eine Anfrage zum Plenum eines Abgeordneten der Freien Wähler ([BY Drs 16/16465](https://www.bayern.landtag.de/www/ElanTextAblage_WP16/Drucksachen/Basisdrucksachen/0000010500/0000010751.pdf), S. 20). Ohne diese Frage gäbe es kein Datum.
- **In der Bundesratsinitiative steht kein 10H.** [BR-Drs 569/13](https://dserver.bundestag.de/brd/2013/0569-13.pdf) verlangt „angemessene höhenbezogene“ Abstände. Der Faktor 10 taucht nur in der Begründung auf, als Beispiel und als „Obergrenze der Angemessenheit“. Abgestimmt wurde darüber nie, 2018 wurde sie für erledigt erklärt. Die Klausel kam über den Koalitionsvertrag des Bundes vom 27.11.2013, und der Bundesrat empfahl, sie als „überflüssig“ und „kontraproduktiv“ abzulehnen. Als Einspruchsgesetz ging sie trotzdem durch.
- **Der Mitantragsteller hat sie nie genutzt.** Sachsen brachte die Initiative mit Bayern ein, dann wurde gewählt. Die neue Koalition schrieb: „Starre Mindestabstandsregelungen für die Errichtung von Windkraftanlagen lehnen wir ab.“ Davor hatte Jana Pinka (LINKE) gefragt, ob die Staatsregierung eine Studie zu den Flächen unter 10H in Auftrag gegeben habe, und die verweigerte die Antwort ganz, mit Verweis auf den „Kernbereich exekutiver Eigenverantwortung“.
- **Die Sachverständigen wurden gehört und überstimmt.** 11 von 12 Sachverständigen der bayerischen Anhörung vom 03.07.2014 waren dagegen. Eine zweite Anhörung, die die Opposition als Minderheitenrecht verlangt hatte, fand am 16.11.2017 statt, drei Jahre nach der Abstimmung.
- **Die Wirkung, in den Zahlen der Regierung.** Von April bis September 2015 wurden in ganz Bayern Anträge für 10 Windräder gestellt ([BY Drs 17/9570](https://www.bayern.landtag.de/www/ElanTextAblage_WP17/Drucksachen/Schriftliche%20Anfragen/17_0009570.pdf)).
- Auf der Anhörungsliste des Ministeriums steht auch der Verband der Zwerghuhnzüchter-Vereine.

## Grenzen

- **Die Landtage haben keine API.** Bayern lief über URL-Muster und die Dokumentensuche, Sachsen über den Parlamentsspiegel und den Dokumentenserver des Landtags. Im Parlamentsspiegel liefern Länder- und Datumsfilter zusammen nichts, also wurde lokal gefiltert. Unser eigenes openka erreicht die entscheidenden Jahre nicht.
- **robots.txt.** Der sächsische Dokumentenserver verbietet allen Crawlern den Zugriff. Ich habe das Laden der Dokumente dieser Recherche einmal bewusst erlaubt, mit einer Anfrage alle drei Sekunden. Das ist eine Entscheidung, keine Formalie, und die README des Repos sagt das.
- **Scans.** Die sächsischen Dokumente von 2012 bis 2014 sind Bilder ohne Textebene. Sie wurden per OCR gelesen, zunächst nur mit englischen Sprachdaten, also wurde jeder Umlaut in einem Zitat am Seitenbild geprüft, und die Zitate bleiben kurz.
- **Fallen in den APIs.** abgeordnetenwatch listet frühere Mandate nur mit `current_on=all`, antwortet auf schnelle Folgen von Anfragen mit 429 und kennt für zwei Abgeordnete nur eine spätere Fraktion; eine kleine Datei mit datierten Dokumenten füllt das. DIP kann Aktivitäten nicht nach Art filtern, also wird bei uns gezählt.
- **Was nicht online ist, fehlt.** Der Tag, an dem Seehofer den Faktor 10 zum ersten Mal öffentlich nannte (die Pressearchive sind nicht offen, und die Website einer Lokalzeitung, die über die Treffen berichtet hat, ist offline), Gutachten der Wissenschaftlichen Dienste, die der Bundestag nie veröffentlicht hat, eine schriftliche Fassung des Prüfauftrags, die Stellungnahmen der Verbände zum Gesetzentwurf. Die [offenen Fragen](https://github.com/maschinenlesbar-org/10h-rule/blob/main/10h-wiki/open-questions.md) listen sie auf, und ein Entwurf für eine Informationsanfrage an das bayerische Umweltministerium liegt im Repo, noch nicht abgeschickt.
- **Quellen widersprechen sich.** Ein Gutachten der Wissenschaftlichen Dienste trägt im PDF ein anderes Jahr als in der Datenbank des Bundestags. Das ist als offen vermerkt, nicht durch Raten aufgelöst.
- **Der Agent hat stellenweise seine eigene Arbeit geprüft.** Die 192 Entscheidungen darüber, welche Erwähnung einer Organisation, eines Orts oder eines Begriffs echt ist, hat Claude getroffen, anhand von zwei bis vier zufälligen Fundstellen je Fall, und die Datei sagt das. Kein Mensch hat jede Zeile geprüft.

[Der 10H Explorer](https://maschinenlesbar.org/10h-rule/) · [die Recherche auf GitHub](https://github.com/maschinenlesbar-org/10h-rule)

---
title: Siebzehn Arten, eine Frage zu veröffentlichen
ref: kleine-anfragen-landscape
---

Im Januar 2021 hat netzpolitik.org mit Maximilian Richt über das Ende von kleineAnfragen.de gesprochen, der Seite, die er fünf Jahre lang betrieben hatte. Die Überschrift war ein Satz von ihm: [„Die Lösung zu all unseren Problemen könnte in PDFs schlummern, die niemand liest“](https://netzpolitik.org/2021/zum-ende-von-kleineanfragen-de-die-loesung-zu-all-unseren-problemen-koennte-in-pdfs-schlummern-die-niemand-liest/). Mit diesem Interview hat openka angefangen.

Eine Kleine Anfrage ist eine schriftliche Frage von Abgeordneten an ihre Regierung, schriftlich beantwortet und als Drucksache veröffentlicht. Wie viele Brücken saniert werden müssen, was ein Ministerium für Beratung ausgegeben hat, wie lange ein Verfahren dauert: Näher kommt man an das Wissen einer Regierung kaum heran. Jede einzelne ist öffentlich. Alle zusammen sind so gut wie unerreichbar.

## Fünf Jahre Scraper neu bauen

Richt hat kleineAnfragen.de 2014 gestartet. Die Seite fragte die Systeme der Parlamente ab und schickte die PDFs durch Texterkennung und reguläre Ausdrücke. Dann ließen die Landtage ihre Systeme von GLOMAS oder j3s aktualisieren, den zwei Anbietern auf dem Markt, ohne dabei je auf Open Data zu setzen. Jedes Update brach einen Scraper, und jeder musste von Hand neu gebaut werden. „Das kann ich auf Dauer nicht ehrenamtlich leisten.“ Ende 2020 hat er die Seite abgeschaltet.

## Die Landschaft heute

Fast fünf Jahre später haben wir die siebzehn Parlamente, den Bundestag und sechzehn Landtage, für [openka](https://github.com/maschinenlesbar-org/openka-cli) durchgesehen. Jedes veröffentlicht seine Anfragen noch immer in einem eigenen System:

- Der Bundestag hat eine echte API, DIP: JSON, Cursor-Paging, ein Schlüssel. Einer von siebzehn.
- Berlin exportiert pro Wahlperiode eine XML-Datei, jede über 50 MB groß.
- Mecklenburg-Vorpommern und Thüringen betreiben Parldok, das über eine API in JSON antwortet, die niemand dokumentiert. Hamburg nutzt dieselbe Software; sein Dienst war nicht erreichbar, als wir die Konnektoren gebaut haben.
- Bremen betreibt ein STARWEB-Sitzungsformular. Wer nach Vorgangstyp filtert, bekommt nichts, ohne Fehlermeldung. Es geht nur über den Dokumenttyp.
- Bayern hat einen RSS-Feed. Er mischt Schriftliche Anfragen mit Anfragen zum Plenum, enthält nur die letzten Wochen und kein einziges Datum.
- Baden-Württemberg, Schleswig-Holstein und Rheinland-Pfalz betreiben Suchportale, die nur im Browser leben. Den Einstieg in die Suche Hessens haben wir noch nicht gefunden.
- In Thüringen ist die Antwort eine Drucksache, deren Nummer nichts mit der der Frage zu tun hat: 8/979 wird von 8/1715 beantwortet. In Niedersachsen verbindet nichts Erreichbares eine Frage mit ihrer Antwort. Also gehen wir einmal einen Bereich von Drucksachen durch und frieren die Zuordnung ein.
- Das Saarland verlinkt ein PDF, das sich als HTML-Seite mit einem iframe entpuppt. Sachsen verlinkt einen Frameset-Viewer, dessen Links verfallen, wie schon 2021: „Die URL zur jeweiligen PDF wird nach 15 Minuten einfach ungültig.“
- Brandenburg und Sachsen-Anhalt legen ihre Dokumente auf Hosts, deren robots.txt `Disallow: /` sagt. Nordrhein-Westfalen sperrt seine eigene Suche und den Teil seines Archivs, der die Wahlperioden 11 bis 15 enthält.

Es gibt ein gemeinsames Portal, den Parlamentsspiegel, den der Landtag NRW für alle sechzehn Länder betreibt. Er ist das, was einem gemeinsamen Index am nächsten kommt: ein Ergebnisformat für jedes Land. Nach eigener Aussage hat er keine API und keine Dokumentschnittstelle. Er liefert Metadaten und Links, und die Links führen zurück in die siebzehn Systeme.

Am Ende jedes Weges liegt ein PDF. Oft in Word gesetzt, manchmal eingescannt. Fragen und Antworten sind nummerierte Absätze im Fließtext, mal in einem gemeinsamen Dokument, mal in zweien.

## Praktische Unauffindbarkeit

Das Informationsrecht hat dafür einen Namen: *practical obscurity*. Jeder Datensatz ist für sich offen. Das Ganze ist es nicht, weil es verstreut ist, nicht erschlossen und sich nicht zusammenführen lässt. Absicht braucht es dafür nicht. Auf die Frage nach der Schuld sagte Richt „Schuld ist schwierig“ und nannte das Verschlafen und das Abfinden mit technisch längst überholten Infrastrukturen. Das Ergebnis ist so oder so dasselbe.

## Warum das kein Wrapper ist

Jedes andere Tool von maschinenlesbar.org umhüllt eine API. Hier gibt es keine API zum Umhüllen, und es kommt auch keine einzelne. Also ist openka anders gebaut: siebzehn Konnektoren, einer pro Parlament, jeder mit nur dem, was für sein Land gilt, und dahinter eine gemeinsame Strecke, die die Dokumente abruft, die PDFs liest und für alle dasselbe Datensatzformat schreibt.

Zwei Regeln ergeben sich aus den Dokumenten selbst. Die Strecke ist deterministisch: Kein generatives Modell liest ein Dokument, denn diese Datensätze speisen Journalismus, und ein Modell würde eine plausible Frage 4 erfinden, die nie gestellt wurde. Und sie enthält sich: Erkennt eine Regel ein Dokument nicht, bleibt das Feld leer und landet in `ka review`. Jeder Datensatz nennt die archivierten Bytes, aus denen er stammt, und `ka verify` wiederholt die Extraktion daraus und prüft, dass das Ergebnis Byte für Byte gleich ist.

Heute werden der Bundestag und fünf Landtage über ihre eigenen Schnittstellen gelesen. Sechs weitere kommen über den Parlamentsspiegel, mit Konnektoren, die den Weg zu den Dokumenten finden. Die übrigen fünf stehen nur mit den Metadaten des Parlamentsspiegels in der Liste. Brandenburg und Sachsen-Anhalt holen nichts, solange man nicht `--ignore-robots` angibt, und sagen, warum.

## Gegen die Zermürbung

Ob es jemand so meint oder nicht: Die Landschaft wirkt wie eine Zermürbungsstrategie. Sie muss niemandem etwas verweigern. Sie muss sich nur immer wieder ändern, hier ein Relaunch, dort ein neuer Viewer, bis der letzte Mensch, der noch mithält, aufgibt. Jede Änderung kostet einen Scraper, jeder Scraper kostet Feierabende, und die Feierabende gehen zuerst aus. So hat kleineAnfragen.de geendet.

LLM-gestütztes Programmieren ändert den Preis der Reparatur, nicht die Regeln des Lesens. Das Modell arbeitet dort, wo der Code geschrieben wird, nie dort, wo die Dokumente gelesen werden: Es schreibt die Konnektoren und repariert sie, und was läuft, ist eingefrorener, deterministischer Code. Der erste Commit von openka war am 21. September 2026. Am nächsten Tag gab es Konnektoren für Bayern, Bremen, Nordrhein-Westfalen, das Saarland, Sachsen und Thüringen, sechs verschiedene Systeme.

Auf Tempo kommt es erst nach dem ersten Bau an. `ka-factory health` hält für jede Quelle eine Basislinie fest, und `ka-factory drift` merkt, wenn eine Quelle plötzlich nichts mehr liefert oder ein Feld leer zu bleiben beginnt, ordnet die Änderung ein und schlägt die Reparatur vor. Claude Code schreibt den Konnektor neu, die Golden Fixtures, echte Dokumente mit geprüften Datensätzen, entscheiden, ob die Korrektur hält, und ein Release liefert sie aus. Richt hat Scraper „alle paar Wochen“ von Hand angepasst. Hier ist die Anpassung eine Änderung, die die Maschine schon geschrieben und getestet hat und die auf ein Review wartet.

Das ist die Antwort: Automatisierung wird nicht müde. Siebzehn bewegliche Systeme zermürben keinen Menschen mehr, sondern eine Testsuite, und der macht das nichts aus.

Die Ursache behebt das nicht. Freiwillige, die die Infrastrukturarbeit des Staates machen, tun das nie. Richt wünschte sich 2021 offene Schnittstellen zu den bereits existierenden Daten der Parlamente und die gemeinsame Überlegung mit dem Landtag NRW, wie man den Parlamentsspiegel als Open Source öffnet, „sodass kleineAnfragen unnötig wird“. Das ist noch immer das beste Ergebnis. Bis dahin hält openka mit, und genau damit rechnet eine Zermürbungsstrategie nicht.

[openka auf seiner Website]({{ '/openka-cli/de/' | relative_url }}) · [auf GitHub](https://github.com/maschinenlesbar-org/openka-cli)

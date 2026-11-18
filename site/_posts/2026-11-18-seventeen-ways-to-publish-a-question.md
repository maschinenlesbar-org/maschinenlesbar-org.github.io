---
title: Seventeen ways to publish a question
ref: kleine-anfragen-landscape
seo_title: "Kleine Anfragen: 17 parliaments, 17 systems, and why openka exists"
description: >-
  How Germany's 17 parliaments publish Kleine Anfragen, why kleineAnfragen.de gave up in
  2020, and how openka uses automation to keep up.
---

In January 2021 netzpolitik.org interviewed Maximilian Richt about the end of kleineAnfragen.de, the site he had run for five years. The headline was a quote of his: [„Die Lösung zu all unseren Problemen könnte in PDFs schlummern, die niemand liest“](https://netzpolitik.org/2021/zum-ende-von-kleineanfragen-de-die-loesung-zu-all-unseren-problemen-koennte-in-pdfs-schlummern-die-niemand-liest/), the solution to all our problems could be sleeping in PDFs nobody reads. openka started with that interview.

A Kleine Anfrage is a written question from members of a parliament to its government, answered in writing and published as a Drucksache. How many bridges need repair, what a ministry spent on consultants, how long a procedure takes: it is the most direct look into what a government knows. Every single one is public. All of them together are close to unreachable.

## Five years of rebuilding scrapers

Richt started kleineAnfragen.de in 2014. It scraped the parliaments' systems and ran the PDFs through text recognition and regular expressions. Then the Landtage had their systems updated by GLOMAS or j3s, the two vendors on the market, and never asked for open data. Every update broke a scraper, and every scraper had to be rebuilt by hand. „Das kann ich auf Dauer nicht ehrenamtlich leisten“, he said, I can't keep doing this as a volunteer. At the end of 2020 he shut the site down.

## The landscape today

Nearly five years later we surveyed the seventeen parliaments, the Bundestag and sixteen Landtage, for [openka](https://github.com/maschinenlesbar-org/openka-cli). Each still publishes its Anfragen in a system of its own:

- The Bundestag has a real API, DIP: JSON, cursor paging, a key. One of seventeen.
- Berlin exports one XML file per Wahlperiode, more than 50 MB each.
- Mecklenburg-Vorpommern and Thüringen run Parldok, which answers in JSON through an API nobody documents. Hamburg runs the same software; its service was unreachable when we built the connectors.
- Bremen runs a STARWEB session form. Filter by Vorgangstyp and you get nothing, silently. It only works through Dokumenttyp.
- Bayern has an RSS feed. It mixes Schriftliche Anfragen with Anfragen zum Plenum, holds only the newest weeks and carries no dates.
- Baden-Württemberg, Schleswig-Holstein and Rheinland-Pfalz run search portals that live in the browser. Hessen's search entry point we haven't found yet.
- In Thüringen the answer is a Drucksache whose number has nothing to do with the question's: 8/979 is answered by 8/1715. In Niedersachsen nothing reachable links a question to its answer at all, so we sweep a range of Drucksachen once and freeze the map.
- Saarland links a PDF that turns out to be an HTML page with an iframe. Sachsen links a frameset viewer whose links expire, as they did in 2021: „Die URL zur jeweiligen PDF wird nach 15 Minuten einfach ungültig.“
- Brandenburg and Sachsen-Anhalt keep their documents on hosts whose robots.txt says `Disallow: /`. Nordrhein-Westfalen disallows its own search, and the part of its archive that holds Wahlperioden 11 to 15.

There is one shared portal, the Parlamentsspiegel, run by the Landtag NRW for all sixteen Länder. It is the closest thing to a common index, one result markup for every Land. By its own statement it has no API and no document interface. It gives metadata and links, and the links lead back into the seventeen systems.

At the end of every path is a PDF. Often typeset in Word, sometimes scanned. Questions and answers are numbered paragraphs in running text, sometimes in one combined paper, sometimes in two.

## Practical obscurity

Information law has a name for this: practical obscurity. Each record is open on its own. The aggregate is not, because it is scattered, unindexed and can't be put together. Nobody has to intend it. Asked who is to blame, Richt said „Schuld ist schwierig“, and named sleeping through it and making do with long outdated infrastructure. The result is the same either way.

## Why this is not a wrapper

Every other tool on maschinenlesbar.org wraps one API. Here there is no API to wrap, and no single one coming. So openka is built differently: seventeen connectors, one per parliament, each holding only what is specific to its Land, and one shared line behind them that fetches the documents, reads the PDFs and writes one record format for all of them.

Two rules come from the documents themselves. The line is deterministic: no generative model reads a document, because these records feed journalism, and a model would invent a plausible question 4 that was never asked. And it abstains: when a rule doesn't recognise a document, the field stays empty and goes to `ka review`. Every record names the archived bytes it came from, and `ka verify` runs the extraction again from them and checks that the output is byte-identical.

Today the Bundestag and five Landtage are read through their own interfaces. Six more come through the Parlamentsspiegel, with connectors that find their way to the documents. The remaining five are listed from the Parlamentsspiegel's metadata alone. Brandenburg and Sachsen-Anhalt fetch nothing unless you pass `--ignore-robots`, and say why.

## Against exhaustion

Whether anyone means it or not, the landscape works like an exhaustion strategy. It never has to refuse anyone. It only has to keep changing, a redesign here, a new viewer there, until the last person keeping up gives up. Every change costs a scraper, every scraper costs evenings, and the evenings run out first. That is how kleineAnfragen.de ended.

LLM-assisted coding changes the price of the repair, not the rules of reading. The model works where the code is written, never where the documents are read: it writes the connectors and repairs them, and what runs is frozen, deterministic code. openka's first commit was on 21 September 2026. The next day it had connectors for Bayern, Bremen, Nordrhein-Westfalen, Saarland, Sachsen and Thüringen, six different systems.

Speed matters more after the first build. `ka-factory health` keeps a baseline for every source, and `ka-factory drift` notices when a source suddenly yields nothing or a field starts to go empty, says what kind of change it looks like and suggests the repair. Claude Code rewrites the connector, the golden fixtures, real documents with checked records, decide whether the fix holds, and a release ships it. Richt adjusted scrapers „alle paar Wochen“ by hand. Here the adjustment is a change the machine has already written and tested, waiting for a review.

That is the counter: automation doesn't get tired. Seventeen moving systems no longer wear down a person, they wear down a test suite, and a test suite doesn't mind.

It doesn't fix the cause. Volunteers doing the state's infrastructure work never do. In 2021 Richt wished for open interfaces to the data the parliaments already have, and for working out with the Landtag NRW how to open-source the Parlamentsspiegel, „sodass kleineAnfragen unnötig wird“. That is still the best outcome. Until then openka keeps up, which is the one thing a strategy of exhaustion doesn't plan for.

[openka on its website]({{ '/openka-cli/' | relative_url }}) · [on GitHub](https://github.com/maschinenlesbar-org/openka-cli)

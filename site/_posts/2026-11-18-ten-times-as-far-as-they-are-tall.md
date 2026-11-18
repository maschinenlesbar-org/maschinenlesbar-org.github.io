---
title: Ten times as far as they are tall
ref: 10h-research
seo_title: "How Bayern got 10H: an agent, four APIs and 140 PDFs"
description: >-
  Researching how Bayern's 10H wind rule came about with an agent and the
  maschinenlesbar.org CLIs: what the APIs prove and where they stop.
---

Since 2014 Bayern has required wind turbines to stand ten times their height away from housing. The rule is called 10H, and it has been loosened since 2022. I wanted to know how it came about, from the documents, not from the coverage, starting from the version usually told: Sachsen and Bayern pushed, the Bund opened the door, Bayern walked through.

What came out is a [wiki](https://github.com/maschinenlesbar-org/10h-rule), an archive of PDFs and the [10H Explorer](https://maschinenlesbar.org/10h-rule/), in which every statement points to a page. It took four days, with Claude Code doing most of the reading.

## The tools

Four plugins from the [marketplace]({{ site.plugins_url }}), enabled in the research repo's `.claude/settings.json`, and no others:

- `dip`, from [dip-bundestag-cli](https://maschinenlesbar.org/dip-bundestag-cli/): Drucksachen, Plenarprotokolle, Vorgänge, persons and their activities. The workhorse. It indexes the Bundesrat's Drucksachen too, so the Bundesrat bills came through it.
- `abgeordnetenwatch`: mandates, Fraktionen, committees and votes, for the Bundestag and the Landtage.
- `fragdenstaat`: freedom-of-information requests and what came back.
- `bundesrat`: enabled, though DIP covered what the Bundesrat had to say.

Around them, tools that aren't ours: `pdftotext` and `pdftoppm` from poppler, `tesseract` for the scans, and `node:sqlite` for the explorer.

One of our own tools was not used: openka's `ka`. Its Bayern source is an RSS feed that holds only the newest weeks and takes no date window, so 2013 is out of its reach, and the Sachsen discovery hung. The Anfragen were fetched over plain HTTP instead. That is a finding about openka as much as about 10H.

## Why an agent

An agent handed a thesis tends to bring it back confirmed. This one came back with "partly" and "result yes, route no", and that was the point of using it. The research repo's `CLAUDE.md` makes every statement carry a marker: `[secondary]` when only a secondary source backs it, `[not verified]` when nothing does, no marker only when the primary document was read. The agent's job was not to write the story. It was to read until each claim could lose its marker or had to keep it.

That is a lot of reading: over 3,300 pages, about 9.5 million characters. Every Bundestag answer was read in its PDF. Every Drucksache number had to be matched across three citation styles (`BT-Drs 18/1310`, `BR-Drs 155/14(B)`, `BY Drs 17/2137`) and three parliaments that cite each other. This is the work that ends volunteer projects, and the agent doesn't get bored at question 40 of 48.

It also keeps the books. A new PDF gets a row in its folder's `manifest.tsv` with its source URL and SHA-256, and a row in the archive's index. A new finding touches the topic page, the timeline, the source index and the list of open questions. A person skips that by the third day. The agent did it in every commit.

And it writes the code around the research. The explorer's pipeline, the profile fetcher and the roll-call parser came out of the same sessions. As in openka, the model wrote code but extracted nothing itself: the explorer is built with fixed rules and dictionaries, and no language model runs in it. A model may suggest a link, but the link goes in marked unverified until someone confirms it.

## How the APIs ground it

The rule was: the API finds, the PDF proves, the build checks.

**Finding.** DIP was searched by title (Windkraft, Windenergie, Mindestabstand, Länderöffnungsklausel, 10H and more) and by the descriptor "Windenergieanlage", over Wahlperioden 17 and 18. That turned up the Schriftliche Fragen, the two Kleine Anfragen that touch the topic, and DIP Vorgang 59400, which has every step of the federal clause from the cabinet retreat in Meseberg to the Bundesgesetzblatt. Then every answer was read in its PDF. Who answered was taken from the printed heading; DIP names the same people, so two independent records agree.

**People at the time.** 81 politicians have a profile, built from abgeordnetenwatch (CC0) and DIP: mandates, Fraktion, committees, offices by Wahlperiode, activity counts for 2012 to 2016. Every relation has a start and an end, because "Umweltminister" is true for a span, not in general. The abgeordnetenwatch id also links each of them to Wikidata exactly (property P5355), so no person was matched by name.

**Votes.** The roll-call lists were read from the protocols, name by name. For the Bavarian votes, each member's Fraktion on the day came from abgeordnetenwatch's records of the Landtag. The totals have to equal the protocol, 465 : 114 : 3 in the Bundestag and 92 : 63 in the Landtag, or the build fails.

**Freedom of information.** FragDenStaat's search API was asked 18 terms. The main result is a negative one, and it is a finding: nothing covers Bayern in 2013, because Bayern has no freedom-of-information law. What exists is the federal side, among it the environment ministry's list of the more than 100 associations it consulted on the federal bill.

**Numbers.** The explorer collects 357 figures from the government's own answers: applications, approvals, turbines commissioned. Each carries the quote it came from, the build looks for that quote on its page, and only figures it finds are charted. Where two answers disagree (64 or 62 approvals in 2015), both stay, with a note. The few interpretive links, "this led to that", are checked the same way, carry a written rationale and get their own colour, so a reader can tell what is documented from what is argued.

## Other findings

- **Seehofer's own ministry advised against it.** After the meeting of 05.03.2013 with the citizens' groups of "Gegenwind Unterfranken", the environment ministry calculated distance options for all of Bayern and found that „einheitliche Abstände größer als 1000 Meter nicht rechtssicher dargestellt werden können“. That was three months before the Bundesrat bill.
- **The order left no paper.** Seehofer gave it orally in a meeting. The only official record is a government answer to an Anfrage zum Plenum by a Freie Wähler member ([BY Drs 16/16465](https://www.bayern.landtag.de/www/ElanTextAblage_WP16/Drucksachen/Basisdrucksachen/0000010500/0000010751.pdf), p. 20). Without that question there would be no date.
- **The Bundesrat bill doesn't say 10H.** [BR-Drs 569/13](https://dserver.bundestag.de/brd/2013/0569-13.pdf) asks for "angemessene höhenbezogene" distances. Factor 10 appears only in its Begründung, as an example and as the "Obergrenze der Angemessenheit". It was never voted on and was declared erledigt in 2018. The clause came through the federal coalition agreement of 27.11.2013, and the Bundesrat recommended rejecting it as „überflüssig“ and „kontraproduktiv“. As an Einspruchsgesetz it passed anyway.
- **The co-author never used it.** Sachsen tabled the bill with Bayern, then held an election. The new coalition wrote: „Starre Mindestabstandsregelungen für die Errichtung von Windkraftanlagen lehnen wir ab.“ Before that, asked by Jana Pinka (LINKE) whether it had commissioned a study of the land left under 10H, the government declined to answer at all, citing the „Kernbereich exekutiver Eigenverantwortung“.
- **The experts were heard, then outvoted.** 11 of 12 experts at the Bavarian hearing of 03.07.2014 were against. A second hearing, demanded by the opposition as a minority right, was held on 16.11.2017, three years after the vote.
- **The effect, in the government's numbers.** From April to September 2015, applications were filed for 10 turbines in the whole of Bayern ([BY Drs 17/9570](https://www.bayern.landtag.de/www/ElanTextAblage_WP17/Drucksachen/Schriftliche%20Anfragen/17_0009570.pdf)).
- The ministry's consultation list includes the Verband der Zwerghuhnzüchter-Vereine.

## Shortcomings

- **The Landtage have no API.** Bayern was worked through URL patterns and its Dokumentensuche, Sachsen through the Parlamentsspiegel and the Landtag's document server. In the Parlamentsspiegel, the Land filter and the date filter together return nothing, so the results were filtered locally. Our own openka couldn't reach the years that matter.
- **robots.txt.** The Saxon document server disallows all crawlers. I allowed fetching the documents of this research once, deliberately, at one request every three seconds. That is a decision, not a technicality, and the repo's README says so.
- **Scans.** The Saxon documents of 2012 to 2014 are images without a text layer. They were read through OCR, at first with English language data only, so every umlaut in a quote was checked against the page image and the quotes stay short.
- **API traps.** abgeordnetenwatch lists earlier mandates only with `current_on=all`, answers bursts with 429, and for two members knows only a later Fraktion; a small file of dated documents fills that in. DIP can't filter activities by kind, so they are counted on our side.
- **What isn't online stays missing.** The first day Seehofer named factor 10 in public (the press archives are not open, and the website of a local paper that reported on the meetings is offline), research-service papers the Bundestag never published, any written record of the review order, the associations' statements on the federal bill. The [open questions](https://github.com/maschinenlesbar-org/10h-rule/blob/main/10h-wiki/open-questions.md) list them, and a draft information request to the Bavarian environment ministry is in the repo, not yet sent.
- **Sources disagree.** One research-service paper carries a different year in its PDF than in the Bundestag's database. It is recorded as open, not resolved by guessing.
- **The agent checked its own work in places.** The 192 decisions on which mention of an organisation, place or concept is real were made by Claude, from two to four random contexts each, and the file says so. No person has checked every row.

[The 10H Explorer](https://maschinenlesbar.org/10h-rule/) · [the research on GitHub](https://github.com/maschinenlesbar-org/10h-rule)

---
title: maschinenlesbar.org
description: TypeScript API clients & command-line tools for German open-government APIs
---

**maschinenlesbar.org** publishes small, well-tested **TypeScript API clients and
CLIs** for German open-government and public-sector APIs. Each tool is its own
package: a typed client library you can import, plus a command-line interface that
prints clean JSON — ideal for scripting, data pipelines, and quick exploration.

- 📦 Published on npm under the [`@maschinenlesbar.org`](https://www.npmjs.com/org/maschinenlesbar.org) scope
- 🛠️ Source on GitHub at [github.com/maschinenlesbar-org](https://github.com/maschinenlesbar-org)
- 🧾 Licensed AGPL-3.0-or-later

## The tools

| Tool | API | Links |
| --- | --- | --- |
| `ausbildungssuche` | Bundesagentur für Arbeit Ausbildungssuche API | [npm](https://www.npmjs.com/package/@maschinenlesbar.org/ausbildungssuche-cli) · [GitHub](https://github.com/maschinenlesbar-org/ausbildungssuche-cli) |
| `autobahn` | open Autobahn App API (verkehr.autobahn.de) | [npm](https://www.npmjs.com/package/@maschinenlesbar.org/autobahn-cli) · [GitHub](https://github.com/maschinenlesbar-org/autobahn-cli) |
| `bundeshaushalt` | open German federal budget API (bundeshaushalt.de) | [npm](https://www.npmjs.com/package/@maschinenlesbar.org/bundeshaushalt-cli) · [GitHub](https://github.com/maschinenlesbar-org/bundeshaushalt-cli) |
| `dip` | Bundestag DIP API (search.dip.bundestag.de) | [npm](https://www.npmjs.com/package/@maschinenlesbar.org/dip-bundestag-cli) · [GitHub](https://github.com/maschinenlesbar-org/dip-bundestag-cli) |
| `dwd` | open DWD Warnwetter app API (warnwetter.de) | [npm](https://www.npmjs.com/package/@maschinenlesbar.org/dwd-cli) · [GitHub](https://github.com/maschinenlesbar-org/dwd-cli) |
| `fim-portal` | FIM Portal REST API (fimportal.de) | [npm](https://www.npmjs.com/package/@maschinenlesbar.org/fim-portal-cli) · [GitHub](https://github.com/maschinenlesbar-org/fim-portal-cli) |
| `govdata` | open GovData CKAN catalogue API (ckan.govdata.de) | [npm](https://www.npmjs.com/package/@maschinenlesbar.org/govdata-cli) · [GitHub](https://github.com/maschinenlesbar-org/govdata-cli) |
| `jobsuche` | Bundesagentur für Arbeit Jobsuche API | [npm](https://www.npmjs.com/package/@maschinenlesbar.org/jobsuche-cli) · [GitHub](https://github.com/maschinenlesbar-org/jobsuche-cli) |
| `lobbyregister` | open German Lobbyregister search API (lobbyregister.bundestag.de) | [npm](https://www.npmjs.com/package/@maschinenlesbar.org/lobbyregister-cli) · [GitHub](https://github.com/maschinenlesbar-org/lobbyregister-cli) |
| `luftqualitaet` | open Umweltbundesamt Air Data API (umweltbundesamt.de) | [npm](https://www.npmjs.com/package/@maschinenlesbar.org/luftqualitaet-cli) · [GitHub](https://github.com/maschinenlesbar-org/luftqualitaet-cli) |
| `nina` | open NINA civil-protection warning API (warnung.bund.de) | [npm](https://www.npmjs.com/package/@maschinenlesbar.org/nina-warnungen-cli) · [GitHub](https://github.com/maschinenlesbar-org/nina-warnungen-cli) |
| `pegel` | open PEGELONLINE water-level REST API (pegelonline.wsv.de) | [npm](https://www.npmjs.com/package/@maschinenlesbar.org/pegel-online-cli) · [GitHub](https://github.com/maschinenlesbar-org/pegel-online-cli) |
| `reisewarnungen` | open Auswärtiges Amt travel-warning API (auswaertiges-amt.de) | [npm](https://www.npmjs.com/package/@maschinenlesbar.org/reisewarnungen-cli) · [GitHub](https://github.com/maschinenlesbar-org/reisewarnungen-cli) |
| `smard` | open SMARD electricity-market chart-data API (smard.de) | [npm](https://www.npmjs.com/package/@maschinenlesbar.org/smard-cli) · [GitHub](https://github.com/maschinenlesbar-org/smard-cli) |
| `strahlenschutz` | open BfS ODL-Info radiation API (imis.bfs.de) | [npm](https://www.npmjs.com/package/@maschinenlesbar.org/strahlenschutz-cli) · [GitHub](https://github.com/maschinenlesbar-org/strahlenschutz-cli) |
| `tagesschau` | open Tagesschau news API (tagesschau.de) | [npm](https://www.npmjs.com/package/@maschinenlesbar.org/tagesschau-cli) · [GitHub](https://github.com/maschinenlesbar-org/tagesschau-cli) |

## Install

Every tool installs the same way (Node.js ≥ 20):

```bash
npm install -g '@maschinenlesbar.org/<tool>-cli'
```

> On Windows PowerShell, keep the single quotes around the scoped name.

For example:

```bash
npm install -g '@maschinenlesbar.org/tagesschau-cli'
tagesschau --help
```

## Use as a library

```ts
import { TagesschauClient } from '@maschinenlesbar.org/tagesschau-cli';

const client = new TagesschauClient();
const news = await client.homepage();
```

---

<small>16 tools · built with TypeScript · open data, made machine-readable.</small>

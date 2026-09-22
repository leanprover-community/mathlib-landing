# mathlib.org

This repository builds and deploys <https://mathlib.org>.
At the moment, the site consists of a subset of pages from [leanprover-community.github.io](https://github.com/leanprover-community/leanprover-community.github.io), served at the root.

The sources live in `community/`, and can be compared to the source repo using `diff -r`.

## Migration status

See [MIGRATION-CHECKLIST.md](./MIGRATION-CHECKLIST.md) for a list of pages and their status in this repo.

Currently both sites serve the migrated pages.
Until the switch is completed, very page built here contains a `<meta name="robots" content="noindex">` tag so that only the established copy appears in search results.
Set `SITE_NOINDEX=0` to remove this tag.

`robots.txt` deliberately allows crawling: a crawler has to fetch a page to see its noindex tag, so disallowing would hide the instruction and leave Google free to index the URLs regardless.

`community/` is a copy of that repository's `lean4` branch, last synced at `52a665f5`, with these deliberate exceptions:

- `.github/` is not copied, and neither is `deploy.sh`.
- `README.md` is this repository's, not that one's, and `robots.txt` and `opensearch.xml` are deleted: `build.sh` writes the former, and the latter pointed browser search at a Lean 3 endpoint that 404s.
- The templates and data files for pages that were not migrated are deleted, and `make_site.py` has the code that reads them commented out.
- `data/menus.yaml` links to the unmigrated pages by absolute URL, and so do the pages that were migrated.
- `LICENSE` has been copied to the root of this repository, and `templates/cite.md` points there rather than to the other repository's copy.

`diff -r` against a checkout of that branch shows exactly how far the two have drifted.
Re-syncing is not a plain overwrite any more, because that would restore the deleted files; take the upstream diff instead:

```
( cd ../leanprover-community.github.io
  git diff 52a665f5..lean4 ) | git apply --3way --directory=community
```

dropping the hunks for files that were deliberately deleted here, and update the commit named above.

## Building

```
./build.sh          # into _site/
./serve.sh          # the above, then serve it on http://localhost:8000
```

`serve.sh` builds for `http://localhost:$PORT` so that internal links work locally; they are absolute, so a build made for mathlib.org is not browsable from disk.

### Dependencies

- Python 3.11, as CI pins. (TODO: 3.13 and 3.14 appear to produce byte-identical output from the same `requirements.txt`, so we may be able to upgrade the Python version).
- `pip install -r community/requirements.txt`
- [`bibtool`](https://github.com/ge-ne/bibtool), optional: without it the build prints a warning and copies `lean.bib` unprocessed.

The build downloads data from the GitHub API, the mathlib4 docs, `mathlib_stats`, 1000+ theorems and the review dashboard, so it needs network access and takes a few minutes. `community/data/header-data.json` alone expands to about 1.1 GB. Setting `NODOWNLOAD=1` reuses whatever `community/data_cache/` already holds, which is much faster.

Four optional variables are currently safe to omit, and only the first still changes the output:

| Variable | Without it |
| --- | --- |
| `GITHUB_TOKEN` | API rate limits are hit quickly |
| `MAP_ZULIP_EMAIL` | no effect; the Zulip scrape this and `MAP_ZULIP_KEY` enabled is commented out alongside `meet.html`, its only consumer, so nothing reads either |
| `MAP_ZULIP_KEY` | as above, and the two are only useful together |
| `QUEUEBOARD_REVIEWER_INTERESTS_API_URL` | no effect; likewise for the reviewers team page |

CI still passes the latter three in case we decide to migrate those pages later.

Two more variables control where the build points: `SITE_DOCS_URL` and `SITE_NOINDEX`, both described below.

`build.sh` unsets `GITHUB_TOKEN`, `MAP_ZULIP_EMAIL` and `MAP_ZULIP_KEY` when they are set but empty, which is what GitHub Actions passes for a secret or variable that has not been configured.
`make_site.py` tests whether they are present rather than whether they are usable, so without that an unconfigured pair would reach the Zulip API with an empty address and no credentials.

The map needs both halves because Zulip authenticates with the bot address as the basic-auth user and its key as the password. A mismatched pair is rejected exactly as a bad key is, and Zulip reports that rejection in an ordinary response body rather than an error status, so the scrape failed the whole build on `KeyError: 'members'` instead of emptying the map. That is why it is commented out rather than left to degrade; re-enabling it should check the response's `result` field.

`MAP_ZULIP_EMAIL` is a repository variable rather than a secret because a bot address is not sensitive, and it has no default in the code deliberately. The original site scrapes with `map-scraper-bot@leanprover.zulipchat.com`, whose key this repository does not hold, and hardcoding that address is precisely what turned an unrelated key into a failed deploy. Point it at whichever bot owns the key in `MAP_ZULIP_KEY`; Zulip shows an address and its key together under the bot in its settings.

The scrape also reads four hardcoded Zulip custom profile field IDs, which are numeric and specific to the `leanprover` realm because Zulip tracks those fields by ID rather than by name. They fail silently rather than loudly: a stale ID drops a user's website and GitHub links, and a stale coordinate field drops that user from the map entirely. If the map ever comes back sparse or empty without an error, check those IDs first.

## Deployment

CI deploys to GitHub Pages on every push to `main`, and nightly, because the site embeds data fetched at build time which would go stale otherwise.
Pull requests trigger a build and upload the output as an artifact without deploying.

## Where the site is built for

`community/make_site.py` forms every internal link by appending to a base URL, so the whole site's location is one variable, `SITE_URL`, defaulting to `https://mathlib.org`.

The generated API documentation is a separate site and has its own variable, `SITE_DOCS_URL`, defaulting to `https://leanprover-community.github.io/mathlib4_docs/`.
It is used to form every declaration link on `100.html`, `1000.html`, `undergrad.html` and `mathlib-overview.html`.

`robots.txt` is the one file `make_site.py` does not produce: `build.sh` writes it directly, after the build.

## Known gaps

- **Google site verification.** `googlef0c00cb4d31b246f.html` verifies the other site and was not migrated; mathlib.org needs its own.
- **Branding.** The front page, its title and the sidebar brand still say "Lean community"; the page that said "Mathlib" was the landing page this replaced.
- **`theories.html` is not in the sidebar.** It is built and reachable, but only from `mathlib-overview.html` and `contribute/doc.html`; the sidebar lists the individual theory pages instead.

# mathlib.org

This repository builds and deploys <https://mathlib.org>. The site is the
subset of [leanprover-community.github.io](https://github.com/leanprover-community/leanprover-community.github.io)
that has been migrated here, served at the root.

The sources still live in `community/`, which is where the copy landed and
which keeps the two trees comparable with `diff -r`. The directory name no
longer corresponds to a URL prefix.

## Migration status

The migrated pages are **no longer** under `/community/`: they are the site.
The pages that have not been migrated stay on
<https://leanprover-community.github.io/>, and everything here that refers to
one of them links to it there by absolute URL.

Both sites therefore serve the migrated pages — this repository at
`https://mathlib.org/contribute/style.html`, the other at
`https://leanprover-community.github.io/contribute/style.html`. Until one side
stops, every page built here carries `<meta name="robots" content="noindex">`
so that only the established copy appears in search results. Set
`SITE_NOINDEX=0` to lift it, once the migrated pages have been deleted from
the other repository or redirected here.

`robots.txt` deliberately allows crawling: a crawler has to fetch a page to
see its noindex tag, so disallowing would hide the instruction and leave
Google free to index the URLs regardless.

`community/` is a copy of that repository's `lean4` branch, last synced at
`52a665f5`, with these deliberate exceptions:

- `.github/` is not copied, and neither is `deploy.sh`. They deploy to the
  other repository's `master` branch, announce pull requests to Zulip, and
  reconcile emoji against
  `leanprover-community/leanprover-community.github.io`, none of which should
  happen from here.
- `README.md` is this repository's, not that one's, and `robots.txt` and
  `opensearch.xml` are deleted: `build.sh` writes the former, and the latter
  pointed browser search at a Lean 3 endpoint that 404s.
- The templates and data files for pages that were not migrated are deleted,
  and `make_site.py` has the code that reads them commented out.
- `data/menus.yaml` links to the unmigrated pages by absolute URL, and so do
  the pages that were migrated.

`diff -r` against a checkout of that branch shows exactly how far the two have
drifted. Re-syncing is not a plain overwrite any more, because that would
restore the deleted files; take the upstream diff instead:

```
( cd ../leanprover-community.github.io
  git diff 52a665f5..lean4 ) | git apply --3way --directory=community
```

dropping the hunks for files that were deliberately deleted here, and update
the commit named above.

## Building

```
./build.sh          # into _site/
./serve.sh          # the above, then serve it on http://localhost:8000
```

`serve.sh` builds for `http://localhost:$PORT` so that internal links work
locally; they are absolute, so a build made for mathlib.org is not browsable
from disk.

### Dependencies

- Python 3.11, as CI pins. 3.13 and 3.14 were checked to produce
  byte-identical output from the same `requirements.txt`, so the pin is
  conservative rather than required.
- `pip install -r community/requirements.txt`
- [`bibtool`](https://github.com/ge-ne/bibtool), optional: without it the build
  prints a warning and copies `lean.bib` unprocessed.

The build downloads data from the GitHub API, the mathlib4 docs,
`mathlib_stats`, 1000+ theorems and the review dashboard, so it needs network
access and takes a few minutes. `community/data/header-data.json` alone
expands to about 1.1 GB. Setting `NODOWNLOAD=1` reuses whatever
`community/data_cache/` already holds, which is much faster.

Three optional variables are all safe to omit, and only the first still
changes the output:

| Variable | Without it |
| --- | --- |
| `GITHUB_TOKEN` | API rate limits are hit quickly |
| `ZULIP_KEY` | no effect; the Zulip scrape it enables feeds only `meet.html`, which is not built here, so its result is discarded |
| `QUEUEBOARD_REVIEWER_INTERESTS_API_URL` | no effect; likewise for the reviewers team page |

CI still passes the latter two. They cost an API call each and are worth
keeping only because the pages that use them are candidates for migration.

Two more control where the build points rather than what it contains:
`SITE_DOCS_URL` and `SITE_NOINDEX`, both described below.

`build.sh` unsets the first two when they are set but empty, which is what
GitHub Actions passes for a secret that has not been configured.
`make_site.py` tests whether `ZULIP_KEY` is present rather than whether it is
usable, so without that an unconfigured secret would fail the build instead of
degrading.

## Deployment

CI deploys to GitHub Pages on every push to `main`, and nightly, because the
site embeds data fetched at build time and goes stale otherwise. Pull requests
build the site and upload it as an artifact without deploying.

## Where the site is built for

`community/make_site.py` forms every internal link by appending to a base URL,
so the whole site's location is one variable, `SITE_URL`, defaulting to
`https://mathlib.org`.

The generated API documentation is a separate site and has its own variable,
`SITE_DOCS_URL`, defaulting to
`https://leanprover-community.github.io/mathlib4_docs/`. Every declaration
link on `100.html`, `1000.html`, `undergrad.html` and `mathlib-overview.html`
is built from it. Point it elsewhere if mathlib.org ever serves its own copy.

`robots.txt` is the one file `make_site.py` does not produce: `build.sh`
writes it directly, after the build.

## Known gaps

- **Google site verification.** `googlef0c00cb4d31b246f.html` verifies the
  other site and was not migrated; mathlib.org needs its own.
- **Branding.** The front page, its title and the sidebar brand still say
  "Lean community"; the page that said "Mathlib" was the landing page this
  replaced.
- **`theories.html` is not in the sidebar.** It is built and reachable, but
  only from `mathlib-overview.html` and `contribute/doc.html`; the sidebar
  lists the individual theory pages instead.
- **`cite.html` points at the wrong licence.** It says this website is under
  the MIT licence, linking the other repository's `LICENSE`. That file is
  copied here as `community/LICENSE`, but this repository has no licence of
  its own at the root.

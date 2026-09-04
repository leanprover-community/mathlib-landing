# mathlib.org

This repository builds and deploys <https://mathlib.org>. It contains:

- `index.html`, the landing page, served at the root.
- `community/`, the pages migrated from
  [leanprover-community.github.io](https://github.com/leanprover-community/leanprover-community.github.io),
  served under `/community/`.

## Migration status

`community/` is currently a **duplicate** of the `lean4` branch of
leanprover-community.github.io, not a replacement for it. Both copies are live:
the original at <https://leanprover-community.github.io/> and this one at
<https://mathlib.org/community/>. The plan is to decide page by page which
material belongs where, remove it from the other side, and only then move the
surviving pages out of `/community/`.

While that is true, two things are worth knowing:

- `_site/robots.txt` disallows `/community/`, so search engines do not see two
  competing copies of the same page. Whichever pages end up staying here need
  that lifted.
- Pages under `/community/` that link to each other with a hardcoded absolute
  URL still link to `leanprover-community.github.io`, so following them takes
  you back to the original site. 31 pages are reached this way, most of them
  from `community/data/documentation.yaml`. They need rewriting as the pages
  they point at are migrated for real.

`community/` is a byte-for-byte copy of that branch's tracked files, with one
exception: `.github/` is deliberately not copied. Its workflows deploy to the
other repository's `master` branch, announce pull requests to Zulip, and
reconcile emoji against `leanprover-community/leanprover-community.github.io`,
none of which should happen from here. Everything else is verbatim so that
`diff -r` against a checkout of that branch shows exactly how far the two have
drifted — including `community/deploy.sh`, which deploys the *other*
repository and is unused here.

Copying is done with `git archive`, so re-syncing is:

```
( cd ../leanprover-community.github.io && git archive lean4 ) \
  | tar -x -C community && rm -rf community/.github
```

## Building

```
./build.sh          # landing page and community site, into _site/
./serve.sh          # the above, then serve it on http://localhost:8000
```

`serve.sh` builds for `http://localhost:$PORT` so that the community site's
links work locally; internal links there are absolute, so a build made for
mathlib.org is not browsable from disk.

Iterating on the landing page alone:

```
./build.sh --landing-only
```

That output must not be deployed. Deploying replaces the whole site, so it
would take `/community/` down with it.

### Dependencies

- Python 3.11 (`community/make_site.py` does not build on 3.12 or above yet)
- `pip install -r community/requirements.txt`
- [`bibtool`](https://github.com/ge-ne/bibtool), optional: without it the build
  prints a warning and copies `lean.bib` unprocessed.

The community build downloads data from the GitHub API, the mathlib4 docs,
`mathlib_stats`, 1000+ theorems and the review dashboard, so it needs network
access and takes a few minutes. `community/data/header-data.json` alone
expands to about 1.1 GB. Setting `NODOWNLOAD=1` reuses whatever
`community/data_cache/` already holds, which is much faster.

Three optional variables improve the result and are all safe to omit:

| Variable | Without it |
| --- | --- |
| `GITHUB_TOKEN` | API rate limits are hit quickly |
| `ZULIP_KEY` | the community map on `meet.html` is empty |
| `QUEUEBOARD_REVIEWER_INTERESTS_API_URL` | the reviewers team page omits review interests |

`build.sh` unsets these when they are set but empty, which is what GitHub
Actions passes for a secret that has not been configured. `make_site.py` tests
whether `ZULIP_KEY` is present rather than whether it is usable, so without
that an unconfigured secret would fail the build instead of degrading.

## Deployment

CI deploys to GitHub Pages on every push to `main`, and nightly, because the
community site embeds data fetched at build time and goes stale otherwise.
Pull requests build the site and upload it as an artifact without deploying.

## Where the site is built for

`community/make_site.py` forms every internal link by appending to a base URL,
so the whole site's location is one variable. `build.sh` sets it from:

| Variable | Default |
| --- | --- |
| `SITE_URL` | `https://mathlib.org` |
| `COMMUNITY_PREFIX` | `community` |

Moving the migrated pages to the root is therefore mostly a matter of changing
`COMMUNITY_PREFIX` — but not only that, since the migrated site has its own
`index.html` which would collide with the landing page, so `build.sh` rejects
an empty prefix. Retiring or folding in the landing page is a deliberate
step, not a configuration change.

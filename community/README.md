# Site sources

This directory holds the pages migrated from
[leanprover-community.github.io](https://github.com/leanprover-community/leanprover-community.github.io)
and the script `make_site.py` that builds them.
The build is driven by [`../build.sh`](../build.sh) and the result is served at the
root of <https://mathlib.org>.

**See [`../README.md`](../README.md)** for how the site is built and deployed,
and for how this copy is kept in sync with the other repository.

The rest of this file is the upstream repository's own README, kept because it
documents `make_site.py` itself, and trimmed to what is still true here.

## Dependencies

* `pip install -r requirements.txt`

Building the bibliography requires [`bibtool`](https://github.com/ge-ne/bibtool). If `bibtool` is not found, the build script will print a warning and just copy the raw `lean.bib` file to the target.

In order to rebuild the CSS from SCSS, you also need:

* [sass](https://sass-lang.com/)
* [bootstrap](https://github.com/twbs/bootstrap/archive/v4.4.1.zip)
  should be unpacked at the project root

The website relies on several components which are built in other repositories:
- [`mathlib_stats`](https://github.com/leanprover-community/mathlib_stats)
- [`lean4web`](https://github.com/leanprover-community/lean4web)
- [`mathlib4_docs`](https://github.com/leanprover-community/mathlib4_docs) (built by CI in [doc-gen4](https://github.com/leanprover/doc-gen4/))

## Building

* Build CSS if needed: `sass scss/lean.scss > css/lean.css`
* Build site using `make_site.py`. Use option `--local` for local
  viewing (internal url will be prefixed by local file path).
  Use option `--reload` to continuously build when templates are
  changed (this won't work for watching changes in `data/`).

Five environment variables control where the site is built and where it
expects to be served from. `../build.sh` sets the first three; all have
defaults, so running `make_site.py` directly needs none of them:

* `SITE_TARGET`: output directory (default `build/`).
* `SITE_BASE_URL`: the URL the site will be served from
  (default `https://leanprover-community.github.io/`). Every internal link is
  built by appending to it, so setting it relocates the whole site; a trailing
  slash is added if missing. It is ignored when `--local` is passed, which
  derives a `file://` url from `SITE_TARGET` instead.
* `SITE_EDIT_BASE`: prefix for the "Suggest edits to this page on GitHub"
  footer link, which points at the templates rather than at the built site
  (default
  `https://github.com/leanprover-community/mathlib-landing/blob/main/community/templates/`,
  where these templates live; `../build.sh` passes the same value).
* `SITE_DOCS_URL`: where the generated API documentation is served
  (default `https://leanprover-community.github.io/mathlib4_docs/`). Every
  declaration link on `100.html`, `1000.html`, `undergrad.html` and
  `mathlib-overview.html` is built from it.
* `SITE_NOINDEX`: set to `0` to drop the `noindex` meta tag that every page
  carries while leanprover-community.github.io serves the same pages.

Note that links to the other leanprover-community GitHub Pages sites
(`mathlib_stats`, `blog`, ...) are deliberately absolute: those are separate
repositories that only happen to be served next to the original site, so they
must not move with `SITE_BASE_URL`. The API documentation was in that category
too, until it needed a variable of its own; see `SITE_DOCS_URL` above.

If you want to retrieve the list of Zulip users to get the users map, set
`MAP_ZULIP_EMAIL` to the address of the bot doing the scraping and
`MAP_ZULIP_KEY` to that same bot's Zulip API key; a key paired with any other
address is rejected. Both have no effect here for now: that scrape is
commented out in `make_site.py` along with `meet.html`, the only page that
draws the map.

If you want to work on a new feature, there are several helpful tricks to know.

First you will very quickly hit the GitHub API rate limit without
authentication. You can
[create a personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic)
and run `GITHUB_TOKEN=my_token_copied_from_github ./make_site.py --local` during
your experiments.

You can also run the script once normally and then run
`NODOWNLOAD=1 ./make_site.py --local` to build the website using the information
previously downloaded. This information is stored into the `data_cache` folder.
If you need the script to download something but not everything you can
temporarily change the relevant `if DOWNLOAD:` into a `if not DOWNLOAD:`.

You can also choose to render only certain templates using
`./make_site.py --local --only my_template.html`.
This argument can actually be a regular expression, but giving one template
name is the most common use case.

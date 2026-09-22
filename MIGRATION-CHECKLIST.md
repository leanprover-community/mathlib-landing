# Community site migration checklist

All pages of the original site, as a checklist for deciding page-by-page
whether it should live on mathlib.org or stay on
[leanprover-community.github.io](https://leanprover-community.github.io/).
Synced with the `lean4` branch at `52a665f5` (2026-09-21).

A checked box means the page is built by `build.sh` and served at the root
of mathlib.org. An unchecked one is not built here; links to it point at the
other site by absolute URL.

**Nesting means the parent links to the child** (excluding sidebar navigation links)

## Front page

- [x] `index.html` — serves as mathlib.org's front page, replacing the old
  landing page. Still titled "Lean community" and still advertising itself as
  the community site.

## Community and teams

- [ ] `meet.html`
  - [x] `community_guidelines.html`
  - [ ] `teams.html`
    - [ ] `teams/admin.html`
    - [ ] `teams/maintainers.html`
    - [ ] `teams/reviewers.html`
    - [ ] `teams/ci.html`
    - [ ] `teams/moderation.html`
    - [ ] `teams/coc.html`
    - [ ] `teams/site.html`

## Contributing

There are many links between these files so should be migrated together.

- [x] `contribute/index.html`
- [x] `contribute/how-to-contribute.html`
- [x] `contribute/values.html`
- [x] `contribute/style.html`
- [x] `contribute/naming.html`
- [x] `contribute/doc.html`
- [x] `contribute/commit.html`
- [x] `contribute/pr-review.html`
- [x] `contribute/git.html`
- [ ] `contribute/tags_and_branches.html` — this was rewritten for the
  lean-downstream repo in #916
- [x] `mathlib_stats.html`
- [ ] `queue-redirect.html`

## Library overviews

- [x] `mathlib-overview.html`
  - [x] `undergrad.html`
    - [x] `undergrad_todo.html`
- [x] `theories.html` — absent from the sidebar, which lists the individual
  theories instead; reached from `mathlib-overview.html` and `contribute/doc.html`
  - [x] `theories/naturals.html`
  - [x] `theories/sets.html`
  - [x] `theories/linear_algebra.html`
  - [x] `theories/topology.html`
  - [x] `theories/category_theory.html`
- [x] `100.html`
  - [x] `100-missing.html`
- [x] `1000.html`
  - [x] `1000-missing.html`

## Documentation

- [ ] `documentation.html`
  - [ ] `glossary.html`
    - [ ] `mwe.html`
  - [ ] `extras/pitfalls.html`
    - [ ] `extras/simp.html`
  - [ ] `extras/calc.html`
    - [ ] `extras/conv.html`
  - [ ] `extras/congr.html`
  - [ ] `extras/well_founded_recursion.html`
  - [ ] `extras/speedup.html`
- [ ] `extras/tactic_writing.html`
- [ ] `did_you_prove_it.html`
- [ ] `latex.html`

## Getting started and install

- [x] `get_started.html`
  - [ ] `learn.html`
    - [ ] `events.html`
- [ ] `install/project.html` -> discuss!

Do not move (these are just redirects)
- [ ] `install/macos.html`
- [ ] `install/macos_details.html`
- [ ] `install/linux.html`
- [ ] `install/debian.html`
- [ ] `install/debian_details.html`
- [ ] `install/windows.html`

## Teaching

- [ ] `teaching/index.html`
  - [ ] `teaching/courses.html`
  - [ ] `teaching/practices.html`
    - [ ] `teaching/resources.html`
- [ ] `courses.html`

## Papers, citation and projects

- [x] `papers.html`
- [x] `cite.html`
- [ ] `lean_projects.html`

## Site files

- [ ] ~~`opensearch.xml`~~ Registered the site as a browser search engine
  against the Lean 3 `mathlib_docs/find/` endpoint, which 404s. Deleted here,
  along with the `<link rel="search">` in `_base.html` that pointed at it.
- [ ] ~~`googlef0c00cb4d31b246f.html`~~ For google site verification; we'd have to redo this anyways for mathlib.org

---

## Other links

Most of these links cross a group boundary; the rest are second parents inside one
group. Each breaks if the target moves and the source does not.

- `index.html` → `meet.html`, `contribute/index.html`, `mathlib_stats.html`,
  `mathlib-overview.html`, `lean_projects.html`, `papers.html`, `learn.html`
- `documentation.html` → `contribute/index.html`,
  `contribute/how-to-contribute.html`, `contribute/style.html`,
  `contribute/naming.html`, `contribute/doc.html`, `contribute/commit.html`,
  `contribute/pr-review.html`, `contribute/git.html`,
  `contribute/tags_and_branches.html`, `mathlib-overview.html`,
  `undergrad.html`, `100.html`, `1000.html`, `theories/naturals.html`,
  `theories/sets.html`, `theories/linear_algebra.html`,
  `theories/topology.html`, `theories/category_theory.html`,
  `teaching/practices.html`
- `mathlib-overview.html` → `theories/naturals.html`, `theories/sets.html`,
  `theories/linear_algebra.html`, `theories/topology.html`,
  `theories/category_theory.html`, `contribute/index.html`
- `contribute/doc.html` → `theories.html`, `theories/topology.html`
- `contribute/how-to-contribute.html` → `teams/maintainers.html`,
  `teams/reviewers.html`
- `meet.html` → `contribute/index.html`, `mwe.html`
- `glossary.html` → `extras/calc.html`, `extras/conv.html`, `extras/simp.html`
- `100.html` → `contribute/index.html`
- `1000.html` → `contribute/index.html`
- `install/project.html` → `contribute/index.html`
- `teaching/resources.html` → `learn.html`

## No internal links

These are probably linked to from outside sources (Zulip linkifiers?).
This list ignores webpages we don't want to move over.

- `cite.html`
- `did_you_prove_it.html`
- `extras/tactic_writing.html`
- `latex.html`
- `googlef0c00cb4d31b246f.html`
- `queue-redirect.html` (clearly mathlib-specific; unclear if still relevant)

## Meta-refresh redirects

- `courses.html` → `teaching/courses.html`
- `queue-redirect.html` → mathlib4 PR search on GitHub

## Shared build inputs

Pages that must move together, or duplicate a build-time download.

- `header-data.json` (≈1.1 GB, from `mathlib4_docs`) — `mathlib-overview.html`,
  `undergrad.html`, `undergrad_todo.html`, `100.html`, `100-missing.html`,
  `1000.html`, `1000-missing.html`
- `lean.bib` + `bibtool` — `papers.html`, `cite.html`
- `teams.yaml` + `people.yaml` + GitHub API — `teams.html`, `teams/admin.html`,
  `teams/maintainers.html`, `teams/reviewers.html`, `teams/ci.html`,
  `teams/moderation.html`, `teams/coc.html`, `teams/site.html`
- GitHub API star counts — `lean_projects.html`
- `MAP_ZULIP_EMAIL` + `MAP_ZULIP_KEY` — `meet.html` (the scrape is commented
  out in `make_site.py`; neither is configured, and the bot to use is undecided)
- `QUEUEBOARD_REVIEWER_INTERESTS_API_URL` — `teams/reviewers.html`
- `mathlib_stats` contributor count and `gitstats.js` — `mathlib_stats.html`

---

## Blocking deployment

- `googlef0c00cb4d31b246f.html` — mathlib.org needs its own verification file.
- Duplicate content — the migrated pages are served by both sites. Held off
  for now with a site-wide noindex; lifting it (`SITE_NOINDEX=0`) means first
  deleting them from the other repository or redirecting those URLs here.

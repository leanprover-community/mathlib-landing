# Community site migration checklist

All pages under `/community/`, as a checklist for deciding page-by-page
whether it should live on mathlib.org or stay on
[leanprover-community.github.io](https://leanprover-community.github.io/).
Snapshot of the `lean4` branch at `0679c847` (2026-09-03).

**Nesting means the parent links to the child** (excluding sidebar navigation links)

## Front page

- [ ] `index.html`

## Community and teams

- [ ] `meet.html`
  - [ ] `community_guidelines.html`
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
- [ ] `contribute/tags_and_branches.html` (describes the old system: will be out of date with move to lean-downstream repo; don't migrate (but update and then move over)
- [x] `mathlib_stats.html`
- [x] `queue-redirect.html`

## Library overviews

- [x] `mathlib-overview.html`
  - [x] `undergrad.html`
    - [x] `undergrad_todo.html`
- [x] `theories.html`
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

- [ ] `get_started.html`
  - [ ] `learn.html`
    - [ ] `events.html`

Do not move?
- [ ] `install/project.html`
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

- [ ] `papers.html`
- [x] `cite.html`
- [ ] `lean_projects.html`

## Site files

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

- `cite.html`
- `did_you_prove_it.html`
- `extras/tactic_writing.html`
- `latex.html`
- `googlef0c00cb4d31b246f.html`
- `queue-redirect.html`
- `install/macos.html`, `install/macos_details.html`, `install/linux.html`,
  `install/debian.html`, `install/debian_details.html`, `install/windows.html`

## Meta-refresh redirects

- `courses.html` → `teaching/courses.html`
- `queue-redirect.html` → mathlib4 PR search on GitHub
- `install/macos.html`, `install/macos_details.html`, `install/linux.html`,
  `install/debian.html`, `install/debian_details.html`,
  `install/windows.html` → `docs.lean-lang.org` quickstart

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
- `ZULIP_KEY` — `meet.html`
- `QUEUEBOARD_REVIEWER_INTERESTS_API_URL` — `teams/reviewers.html`
- `mathlib_stats` contributor count and `gitstats.js` — `mathlib_stats.html`

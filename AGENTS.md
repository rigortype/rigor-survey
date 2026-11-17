# rigor-survey — agent notes

This repository is a **corpus**, not a product. The targets are
read-only upstream checkouts analysed *as data*. Rigor itself lives
in a sibling clone (`../rigor` or `~/repo/ruby/rigor`).

## Layout

- `<name>/` is a git submodule. The gitlink SHA is the pin. Do not
  commit inside a submodule unless the task is to bump that pin.
- `overlays/<name>/` holds the survey artifacts (`.rigor.dist.yml`,
  `.rigor-baseline.yml`, `rbs_collection.yaml`, generated `sig/`).
  They are applied with `make apply-overlays`. After apply they sit
  untracked in the submodule working tree; that is intended.
- `_reports/` is local-only (gitignored). Do not add it.
- `corpus.yml` is generated from the live submodule pins. Edit it in
  the same commit as the gitlink it describes.

## Measurement

Cwd must be the target. Config discovery and baseline paths are
cwd-relative. Invoke Rigor through its own Flake / bundle:

```sh
nix develop --command bash -c '
  cd ~/repo/ruby/rigor-survey/<project> &&
  BUNDLE_GEMFILE=<rigor>/Gemfile bundle exec <rigor>/exe/rigor <subcommand>'
```

A target under measurement is exclusive state. Two agents sharing one
checkout corrupt `.rigor.yml`, `.rigor/cache`, and
`.rigor-effects.yml`. Copy the target first, or assign disjoint
projects.

Do not `git stash` in a target: several sessions share the
submodule's object store after `absorbgitdirs`. Do not
`git submodule deinit`.

## What belongs in a commit here

- New or updated overlays
- Submodule pin bumps (gitlink + `corpus.yml` + `.gitmodules` url)
- Docs / Makefile / tools

Vendor bundles, `.rigor/cache`, and `_reports/` do not.

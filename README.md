# rigor-survey

OSS Ruby libraries and applications used as an external corpus for
[Rigor](https://github.com/rigortype/rigor). Each target is a git
submodule pinned to a revision. Rigor configuration, generated
signatures, and baselines live in this repository under `overlays/`
and are copied into the submodule working trees.

The engine is never added to a target's `Gemfile`. Measurement runs
from the target directory through Rigor's own bundle; see
[`docs/agents/measurement.md`](https://github.com/rigortype/rigor/blob/master/docs/agents/measurement.md)
in the Rigor tree.

## Layout

```
overlays/<name>/     Rigor artifacts applied onto the target
  .rigor.dist.yml
  .rigor-baseline.yml
  rbs_collection.yaml
  sig/
<name>/              git submodule (upstream at a pinned SHA)
corpus.yml           name, url, revision, branch for every target
_reports/            local run logs (gitignored)
```

`REPORT.md` is the original 2026-05 library-survey write-up. Later
re-init runs live under `_reports/` on the machine that produced them.

## Setup

```sh
git clone https://github.com/rigortype/rigor-survey.git
cd rigor-survey
make setup
```

`make setup` initializes every submodule with `--filter=blob:none` and
applies `overlays/` into each working tree. A target under measurement
is exclusive state: its `.rigor/cache` and cwd-relative baseline must
not be shared by two agents at once.

## Adding a target

```sh
git submodule add --filter=blob:none <upstream-url> <name>
# record the pin in corpus.yml
# add overlays/<name>/.rigor.dist.yml (and baseline / sig as needed)
```

Bump a pin by updating the submodule checkout, then staging the
gitlink and the matching `corpus.yml` row together.

## License

The files authored in this repository are MIT. Each submodule remains
under its own upstream license; this repo does not relicense them.

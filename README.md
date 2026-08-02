# mirror-lychee

OCX mirror for [lychee](https://github.com/lycheeverse/lychee). One repository,
one spec directory per package.

| Package | Spec | Publishes to | Announced as | Upstream SPDX |
|---|---|---|---|---|
| [lychee](https://github.com/lycheeverse/lychee) | [`lychee/mirror.yml`](lychee/mirror.yml) | `ghcr.io/ocx-contrib/lychee/lychee` | `ocx.sh/lychee/lychee` | `Apache-2.0 OR MIT` |

Each upstream release is discovered, re-bundled, smoke-tested per
`(version, platform)` and only then pushed with cascade tags, after which the
result is announced into the OCX index.

> This repository previously published the same upstream to the flat coordinate
> `ocx.sh/lychee`. `lychee/lychee` is the grouped successor. Upstream's owner is
> the org handle `lycheeverse`, which means nothing to someone who does not
> already know the tool, so the tool names itself.

## Layout

```
mirror-base.yml         repo-wide policy every spec inherits via `extends:`
lychee/
├── mirror.yml          the spec — never at the repo root
├── metadata.json       bundle interface
├── CATALOG.md          → ocx package describe
├── logo.svg / logo.png describe assets, 512px PNG
└── tests/smoke.star    Starlark smoke test
```

`LICENSE` and `NOTICE.md` are shared at the root. Logos are **not** — each
package carries its own, because a repo-root `logo.*` sits in no workflow's
`paths:` filter, so replacing it would publish nothing until some unrelated
edit happened to fire.

⚠️ `extends:` is a **shallow** merge of top-level keys. A spec that restates
`platforms:` to change one runner drops every `containers:` entry with it, and
nothing reds — the legs simply stop existing, and every `os.features` claim
goes back to being asserted rather than verified. Restate a block in full or
not at all.

## Platforms

`lychee` publishes five platform entries: both Linux arches, both macOS arches
and `windows/amd64`. Upstream ships no `windows/arm64` build.

Upstream ships **both** a gnu and a musl build per Linux arch. This mirror
carries the **musl** one: measured on v0.24.2 it is static-pie with no
`PT_INTERP` and no `DT_NEEDED`, while the gnu twin needs `libgcc_s.so.1`.
`os.features` states what an artifact requires *of the host*, so both Linux
keys are **bare** — tagging them `+libc.musl` would be a false requirement that
hid them from every glibc host, since that suffix describes a *dynamic* musl
link. Publishing the gnu build under a bare key, which the flat spec this
replaces did, is the mirror-image error: a universality claim the bytes do not
support. The `alpine:3.20` container leg in `mirror-base.yml` is what turns the
bare claim into evidence; the measurement itself is recorded above the
`assets:` block in `lychee/mirror.yml`.

The version floor is `0.24.1` because the `lychee-<triple>/` archive wrapper
arrives in 0.24 — below it `strip_components: 1` would strip the binary itself.

## Editing

| File | Edit | Regenerate after |
|------|------|------------------|
| `mirror-base.yml`, `lychee/mirror.yml` | hand | yes — see below |
| `lychee/{metadata.json,CATALOG.md,logo.*}` | hand | — |
| `lychee/tests/smoke.star` | hand | — |
| `.github/workflows/*.yml` | **generated — never hand-edit** | re-run when a spec changes |

```bash
ocx-mirror package pipeline generate ci --spec lychee/mirror.yml
```

**Name every spec.** `--spec` *appends* rather than replaces, so a command
naming a subset silently stops rendering the rest while staying green — and the
drift guard reds on a generated workflow the current spec set no longer
produces.

`verify-generated.yml` exits 65 on drift. If a generated workflow is wrong, the
spec or the renderer template is wrong — fix it there and regenerate.

Run `direnv allow` once to put the pinned toolchain on `PATH`, and invoke
`ocx-mirror` directly — never `ocx run -- ocx-mirror`, which pins
`OCX_BINARY_PIN` to the bootstrap `ocx` and false-reds the nested push.

## The binaries claim

Every asset wraps its payload in a single `lychee-<triple>/` directory, so
`strip_components: 1` lands `lychee` at the bundle content root alongside
`docs/` and `complete/` — there is no `bin/` dir, and the bundle's only PATH
entry is a bare `${installPath}`. `bin_scan` only looks *below* an
`${installPath}/<dir>` entry, so `auto`/`verify` is rejected at spec load with
exit 65. `mirror-base.yml` therefore sets `bin_scan: off` and
`lychee/metadata.json` hand-lists `binaries: ["lychee"]` — the blessed shape for
this layout.

## The smoke test

Fully offline; the mirror never reaches the network to test a link checker.
`lychee/tests/smoke.star` writes a hermetic markdown file with a relative link
to a sibling it also wrote, runs `lychee --no-progress --offline`, and asserts
the exit code: `0` when the target exists, `2` when it does not. That pair
proves the checker computes a result rather than rubber-stamping, and the
exit-code contract is stable across releases in a way help text is not.

## Required secrets

| Secret | Use |
|--------|-----|
| `OCX_ANNOUNCE_TOKEN` | opens the index pull request from the `ocx-contrib/index` fork |
| `OCX_MIRROR_DISCORD_HOOK` | notify-stage Discord webhook URL |

(Inherited from the `ocx-contrib` org with visibility ALL. GHCR pushes use the
run's own `GITHUB_TOKEN` — no registry secret needed.)

## License

Apache-2.0 — see [`LICENSE`](LICENSE). Upstream assets are out of scope; each
package's redistribution license is recorded in [`NOTICE.md`](NOTICE.md).

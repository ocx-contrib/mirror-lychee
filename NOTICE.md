# NOTICE

This repository packages and redistributes upstream software published by the
[lycheeverse](https://github.com/lycheeverse) organisation. The Apache-2.0
license in [`LICENSE`](LICENSE) covers the OCX pipeline files authored here. It
does **not** cover any upstream-derived asset — each package's redistributed
bytes carry their own license, recorded below.

Each package's logo is reproduced for catalog identification only, under
nominative fair use. The marks remain the property of their respective owners
and no endorsement is implied.

| Package | GHCR path | Upstream SPDX |
|---|---|---|
| `lychee` | `ghcr.io/ocx-contrib/lychee/lychee` | `Apache-2.0 OR MIT` |

---

## `lychee`

Upstream: <https://github.com/lycheeverse/lychee>
Published to `ghcr.io/ocx-contrib/lychee/lychee`.

| Component | SPDX | Holder |
|---|---|---|
| lychee (`lychee`) | **Apache-2.0 OR MIT** | Copyright (c) 2020 lychee contributors |

Permissive, dual-licensed at the recipient's option — the expression is
upstream's own, declared as `license = "Apache-2.0 OR MIT"` in
`lychee-bin/Cargo.toml`, with both texts shipped as
[`LICENSE-APACHE`](https://github.com/lycheeverse/lychee/blob/master/LICENSE-APACHE)
and [`LICENSE-MIT`](https://github.com/lycheeverse/lychee/blob/master/LICENSE-MIT).
Redistribution of the compiled binary is granted under either, provided the
copyright and permission notices are retained. Upstream's release archives ship
`README.md`, `docs/` and shell completions but no `LICENSE` file, so the terms
are those linked above. The published binaries statically link third-party Rust
crates under permissive licenses, enumerated in upstream's `Cargo.lock`.

The lychee name is used for catalog identification under nominative fair use.

No modifications are made to any upstream artifact in this repository; they are
republished byte-for-byte inside an OCX bundle.

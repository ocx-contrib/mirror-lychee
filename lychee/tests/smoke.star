# tests/smoke.star — stable across upstream lychee releases.
# Asserts behavior + contract (exit codes, version digits, link-check
# result), never prose (help text, banner, vendor name).
LYCHEE = "lychee.exe" if ocx.target_platform.os == ocx.os.Windows else "lychee"

# Tier 1 + 2: liveness + version shape.
r = ocx.run(LYCHEE, "--version")
expect.ok(r)
expect.matches(r.stdout, r"\d+\.\d+\.\d+")

# Tier 3: functional link-check on hermetic input, asserting the computed
# result (exit code), not help prose. `--offline` parses the document
# without touching the network, so the run is fully hermetic.
#
# A relative `./README.md` link resolving to a sibling file we wrote → no
# broken links → exit 0.
ocx.write_file("README.md", "# Hello\n")
ocx.write_file("links.md", "[ok](./README.md)\n")
r_ok = ocx.run(LYCHEE, "--no-progress", "--offline", "links.md")
expect.ok(r_ok)

# A relative link to a file that does not exist → broken link → non-zero
# exit. Proves the checker actually computes a result rather than rubber
# stamping; the exit-code contract is stable across releases.
ocx.write_file("broken.md", "[missing](./does-not-exist.md)\n")
r_broken = ocx.run(LYCHEE, "--no-progress", "--offline", "broken.md")
expect.eq(r_broken.exit_code, 2)

LYCHEE = "lychee.exe" if ocx.platform()["os"] == "windows" else "lychee"

r_version = ocx.run(LYCHEE, "--version")
expect.ok(r_version)
expect.eq(r_version.exit_code, 0)
expect.contains(r_version.stdout, "lychee")

r_help = ocx.run(LYCHEE, "--help")
expect.eq(r_help.exit_code, 0)
expect.contains(r_help.stdout, "link checker")

# Smoke-check the link-checking pipeline against a tiny inline document.
# `--no-progress` keeps stderr clean; `--offline` skips network so the test
# is hermetic — lychee still parses the input and exits 0 when no links
# remain to check.
ocx.write_file("links.md", "[ok](./README.md)\n")
r_check = ocx.run(LYCHEE, "--no-progress", "--offline", "links.md")
expect.eq(r_check.exit_code, 0)

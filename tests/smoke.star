LYCHEE = "lychee.exe" if ocx.platform()["os"] == "windows" else "lychee"

r_version = ocx.run(LYCHEE, "--version")
expect.ok(r_version)
expect.eq(r_version.exit_code, 0)
expect.contains(r_version.stdout, "lychee")

r_help = ocx.run(LYCHEE, "--help")
expect.eq(r_help.exit_code, 0)
expect.contains(r_help.stdout, "link checker")

# Hermetic link-check: write both the input document and its referenced
# target into the sandbox, then run `--offline` so lychee parses the input
# without touching the network. The relative `./README.md` link resolves
# to the sibling file we just wrote → 0 broken links → exit 0.
ocx.write_file("README.md", "# Hello\n")
ocx.write_file("links.md", "[ok](./README.md)\n")
r_check = ocx.run(LYCHEE, "--no-progress", "--offline", "links.md")
expect.eq(r_check.exit_code, 0)

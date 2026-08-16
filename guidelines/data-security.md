## Data Security

### External codebases under analysis

**Never reference an external codebase under analysis** — names, APIs, domains, packages, class names, organisation names — in any tracked artifact: commit messages, specs, plans, docs, test names, screenshots. Use generic stand-ins (`com.example.utils`, `class Foo`). Keep anything specific to it in untracked experiment directories.

Leaking proprietary identifiers into public git history is catastrophic and effectively irreversible. This matters most on projects whose whole purpose is analysing other people's code, where the workspace, transcripts and job queues are full of it.

### Secret detection (Talisman)

- If Talisman flags a potential secret, **stop** and ask before touching `.talismanrc`.
- **Append** entries — never edit or remove an existing one, even for the same file. Duplicate filenames with different checksums are expected.
- Reword the flagged line when the wording is incidental; suppress only when it is not.
- Use the checksum Talisman reports, not one computed by hand — it does not compute them the same way.

# Bootstrap status

## Completed

- Fork verified with write access.
- Protected working branch created: `modernization/bootstrap`.
- Target platforms documented.
- Reproducible source-audit script added.
- GitHub Actions audit workflow added for Linux x86-64.

## Current gate

Before changing the legacy engine, the audit must identify:

1. top-level qmake projects and executable entry points;
2. bundled Qt and QSA source locations and versions;
3. database driver sources and PostgreSQL assumptions;
4. compiler/platform conditionals for Linux, macOS and Windows;
5. architecture-size assumptions that prevent ARM64 builds;
6. Kugar dependencies that can later be isolated;
7. module-loading and script-execution boundaries.

## Next implementation step

Create a reproducible legacy Linux x86-64 build job from the actual build roots found by the audit. The first build is allowed to fail, but every failure must be captured as a CI artifact and converted into a small, reviewable compatibility patch.

No Qt 6 migration or UI redesign will begin until the legacy build and QSA execution path are understood and covered by smoke tests.

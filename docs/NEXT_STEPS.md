# Immediate implementation sequence

1. Run and collect the source audit artifact.
2. Identify the real legacy build root and required bundled dependencies.
3. Add a Linux x86-64 build workflow that preserves complete logs.
4. Patch compiler incompatibilities one by one without changing QSA semantics.
5. Add a smoke test for application startup and module loading.
6. Only after the Linux baseline, introduce Raspberry Pi ARM64 and macOS build jobs.

The first successful milestone is not a redesigned interface. It is a reproducible engine build that can load the existing module system reliably.

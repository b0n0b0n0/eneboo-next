# Target matrix

| Target | Architecture | Minimum system | Initial status |
|---|---|---|---|
| Linux desktop | x86-64 | modern glibc distribution | primary development target |
| Raspberry Pi OS | ARM64/aarch64 | 64-bit Raspberry Pi OS, Pi 4/5 | supported target after x86-64 baseline |
| macOS Intel | x86-64 | macOS 10.14 Mojave | required compatibility target |
| macOS Apple Silicon | ARM64 | native Apple Silicon macOS | required native target |
| Windows | x86-64 | to be fixed after core stabilization | secondary target |

## Packaging policy

Each platform receives its own build and package. ARM64 does not imply binary compatibility between Raspberry Pi OS and macOS. macOS may later ship as a universal application containing x86-64 and ARM64 slices, provided all dependencies can be built with a common deployment policy.

## Compatibility policy

The QSA/module compatibility contract has priority over visual modernization. Platform-specific UI and packaging code must remain outside business logic, module loading, SQL transactions and script semantics.

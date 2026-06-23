# Eneboo Next

## Objetivo

Construir una evolución mantenible del motor Eneboo que conserve la compatibilidad funcional con los módulos QSA existentes y permita una interfaz moderna, generación PDF sin Kugar, integración nativa con VeriFactu y nuevas capacidades de análisis.

## Plataformas objetivo

1. Linux x86-64 — plataforma principal de desarrollo y primera compilación estable.
2. Linux ARM64 — Raspberry Pi OS de 64 bits, orientado inicialmente a Raspberry Pi 4 y 5.
3. macOS Intel x86-64 — compatible desde macOS Mojave 10.14.
4. macOS Apple Silicon ARM64 — compilación nativa.
5. Windows x86-64 — objetivo posterior, sin bloquear el diseño inicial.

## Principios

- Mantener `master` como referencia del motor original.
- Desarrollar en ramas separadas y mediante cambios verificables.
- No reescribir simultáneamente motor, QSA, interfaz y lógica empresarial.
- Crear primero una compilación Linux x86-64 reproducible.
- Preservar la semántica de QSA, cursores, formularios, eventos, transacciones y carga de módulos.
- Separar el núcleo funcional de la capa visual para permitir diferentes frontends y plataformas.
- Integrar VeriFactu dentro del ciclo de facturación y su comunicación con contabilidad.
- Sustituir Kugar por un motor moderno de generación PDF.

## Primer hito

Obtener una compilación Linux x86-64 reproducible del motor original, documentando:

- toolchain;
- dependencias;
- arquitectura del código;
- componentes Qt/QSA;
- sistema de carga de módulos;
- controladores de base de datos;
- incompatibilidades actuales con compiladores y sistemas modernos.

## Segundo hito

Crear una capa de pruebas que permita abrir una base de datos de prueba, cargar módulos QSA y comprobar el comportamiento de clientes, artículos y formularios básicos.

## Estrategia ARM64

Raspberry Pi y Apple Silicon comparten arquitectura ARM64, pero no binarios ni toolchains. Se mantendrán objetivos de compilación independientes:

- `linux-aarch64` para Raspberry Pi;
- `macos-arm64` para Apple Silicon.

La compatibilidad con Raspberry Pi se centrará en sistemas operativos de 64 bits. No se priorizará ARM de 32 bits salvo necesidad posterior demostrada.

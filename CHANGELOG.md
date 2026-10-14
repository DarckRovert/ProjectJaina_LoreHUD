# 📋 Registro de Cambios — ProjectJaina_LoreHUD

Todos los cambios notables de este proyecto están documentados en este archivo siguiendo el estándar [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

---

## [1.0.2] — 2026-10-13
### Integración de Eventos de Mundo Abierto (Baluartes y Encuentros Navales)
- **Sincronización LOREWOW de Asalto Naval:** Recepción del evento `JAINA_EVENT|Galeon de los Desertores|12|Asalto Naval en los arrecifes del sur de Theramore` al detonar la alerta costera del galeón pirata.
- **Sincronización LOREWOW de Conquista Territorial:** Proyección en pantalla del banner dorado de conquista `JAINA_EVENT|Baluarte Reclamado|12|<Hermandad> ha conquistado [Nombre]` con animación de desvanecimiento suave y sonido de aviso de banda.
- **Validación de Runtime:** Verificado al 100% en cliente 3.3.5a (Build 12340).

---

## [1.0.1] — 2026-10-10
### Estabilización de Ecosistema y Gobernanza Oficial (Project Jaina)
- **Normalización de UI y Gráficos:** Regeneración del avatar de Jaina a Truevision TGA 32-bit RGBA uncompressed (256x256), corrección de ratio 1:1 a 64x64 sin distorsión elíptica y SetBlendMode('BLEND') anti-halos negros.
- **Homologación Documental:** Incorporación y actualización formal de `GOVERNANCE.md`, `LICENSE`, `NOTICE.md` y `SECURITY.md`.
- **Licencia Canónica:** Consolidación de licencia MIT 2026 bajo titularidad de DarckRovert & Project Jaina Team.
- **Validación de Runtime:** Verificado al 100% con compilador sintáctico `lua52_compiler.exe -p` con 0 errores y 0 warnings.

---

## [1.0.0] — 2026-10-04
### Lanzamiento Inicial — Ecosistema Project Jaina WotLK 3.3.5a
- Implementación de la arquitectura base para Project Jaina LoreHUD.
- Registro de comandos slash: `/lorehud`.
- Persistencia de configuración en `LoreHUDDB`.
- Compatibilidad certificada con cliente WotLK 3.3.5a (Build 12340) y directiva `Interface: 30300`.

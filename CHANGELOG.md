# Registro de Cambios — WoWPeru_LoreHUD

Todos los cambios notables de este proyecto están documentados en este archivo siguiendo el estándar [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

---

## [1.0.0-wp] — 2026-10-05
### Correcciones de Animación y Gobernanza (WoW Perú)
- **Desacoplamiento de Alpha Maestro:** Modificado el ciclo de animación de subtítulos para desacoplar el alpha maestro del frame principal, eliminando el parpadeo visual en burbujas de chat y previniendo deadlocks en la cola de diálogos cinematográficos.
- **Licencia Canónica:** Adición formal de la licencia MIT ([LICENSE](LICENSE)) bajo titularidad de DarckRovert & WoW Perú Team.
- **Higiene Documental:** Creación de `CHANGELOG.md`, `ECOSYSTEM_REGISTRY.md` y `.gitattributes`.

---

## [1.0.0] — 2026-10-04
### Lanzamiento Inicial — Theramore Living World
- Subtítulos cinematográficos de alta inmersión para eventos narrativos de LoreBots (Lady Jaina Proudmoore).
- HUD de estado contextual interactivo comunicado vía mensajes de addon (`LOREWOW`) sobre canal WHISPER (canal 7).
- Persistencia de configuración en `LoreHUDDB` y comandos `/lorehud`.

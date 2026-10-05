# 🌐 Registro de Ecosistema — WoWPeru_LoreHUD

Ficha técnica oficial de registro en la infraestructura multi-addon de **WoW Perú - Reino Andino**.

---

## 1. Identidad del Addon

| Campo | Valor |
|---|---|
| **Nombre Técnico** | `WoWPeru_LoreHUD` |
| **Título en Cliente** | `LoreHUD — Theramore Living World` |
| **Versión** | `1.0.0` |
| **Tipo de Sistema** | HUD Cinemático e Inmersión Narrativa (Client-Side con Backend Eluna) |
| **Repositorio GitHub** | [DarckRovert/WoWPeru_LoreHUD](https://github.com/DarckRovert/WoWPeru_LoreHUD) |
| **Directorio de Instalación** | `Interface\AddOns\LoreHUD\` |

---

## 2. Red y Mensajería de Addon

| Propiedad | Valor |
|---|---|
| **Prefijo Oficial** | `LOREWOW` |
| **Canales de Red** | `WHISPER` (Canal 7 de Eluna) |
| **OpCodes Manejados** | `JAINA_STATE\|<Mood>\|<Location>\|<Activity>`, `JAINA_EVENT\|<Name>\|<Duration>\|<Desc>`, `LORE_REQ_SYNC` |
| **Presupuesto Máximo** | < 160 bytes por paquete |
| **Transporte Seguro** | Filtrado por distancia y estado contextual del NPC de lore activo |

---

## 3. Persistencia de Datos

| Variable Global | Tipo | Ámbito | Propósito |
|---|---|---|---|
| `LoreHUDDB` | Tabla Lua (`SavedVariables`) | Por Cuenta | Almacena posiciones de subtítulos, escala del HUD y preferencias de volumen. |

---

## 4. Matriz de Integración del Ecosistema

| Sistema Coexistente | Modo de Interacción | Flujo de Datos |
|---|---|---|
| **Eluna LoreEngine (`00b_LoreEngine_WorldState.lua`)** | Comunicación Bidireccional | Recibe telemetría de estado del mundo de Jaina y solicita sincronización al cargar. |
| **`WoWPeru_Companion`** | Detección P2P | Notifica estado activo de HUD cinematográfico a los miembros del grupo. |

---

## 5. Garantías de Rendimiento

- **Tiempo de Cuadro:** < 0.02 ms por frame (animaciones interpoladas sin garbage collection).
- **Memoria en Tiempo de Ejecución:** ~ 120 KB de memoria Lua.
- **Compatibilidad de Hardware:** 100% verificado para PCs de cabina con procesadores de gama baja.

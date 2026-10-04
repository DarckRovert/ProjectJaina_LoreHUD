-- =======================================================================
-- LOREHUD v2.0 — Subtitulos Cinematograficos, Burbujas 3D y Estado de Jaina
-- Proyecto: WoW Peru — Reino Andino (WotLK 3.3.5a)
-- Autores: Darckrovert & Antigravity L9 (Mythos 5)
-- 100% Compatible con WoW 3.3.5a (Sin C_Timer, puro OnUpdate de alta eficiencia)
-- =======================================================================

-- 1. MOTOR DE TEMPORIZADORES Y ANIMACIONES LIGERAS (WotLK 3.3.5a)
local timers = {}
local timerFrame = CreateFrame("Frame", "LoreHUDTimerFrame", UIParent)
timerFrame:SetScript("OnUpdate", function(self, elapsed)
    local now = GetTime()
    for i = #timers, 1, -1 do
        local t = timers[i]
        if now >= t.time then
            table.remove(timers, i)
            pcall(t.func)
        end
    end
end)

local function TimerAfter(delay, func)
    table.insert(timers, { time = GetTime() + delay, func = func })
end

-- Marco de animación estático reutilizable (Zero Heap Thrashing)
local animFrame = CreateFrame("Frame", "LoreHUDAnimFrame", UIParent)

-- 2. DICCIONARIO BILINGÜE DE PERSONAJES DE LORE (esES / enUS)
local LORE_NPC_NAMES = {
    ["Lady Jaina Proudmoore"] = { color = "FF69B4FF", role = "Señora de Theramore",   icon = "Interface\\Icons\\Spell_Frost_FrostBolt02" },
    ["Lady Jaina Valiente"]   = { color = "FF69B4FF", role = "Gobernadora de Theramore", icon = "Interface\\Icons\\Spell_Frost_FrostBolt02" },
    ["Teniente Aden"]             = { color = "FFAAAAAA", role = "Oficial de la Alianza", icon = "Interface\\Icons\\Ability_Warrior_ShieldWall" },
    ["Lieutenant Aden"]           = { color = "FFAAAAAA", role = "Oficial de la Alianza", icon = "Interface\\Icons\\Ability_Warrior_ShieldWall" },
    ["Teniente de Theramore"]     = { color = "FFAAAAAA", role = "Oficial de la Alianza", icon = "Interface\\Icons\\Ability_Warrior_ShieldWall" },
    ["Theramore Lieutenant"]      = { color = "FFAAAAAA", role = "Oficial de la Alianza", icon = "Interface\\Icons\\Ability_Warrior_ShieldWall" },
    ["Guardia Byron"]         = { color = "FFAAAAAA", role = "Guardia de Theramore",  icon = "Interface\\Icons\\INV_Shield_06" },
    ["Guard Byron"]           = { color = "FFAAAAAA", role = "Guardia de Theramore",  icon = "Interface\\Icons\\INV_Shield_06" },
    ["Guardia de Theramore"]  = { color = "FFAAAAAA", role = "Centinela",             icon = "Interface\\Icons\\INV_Shield_06" },
    ["Theramore Guard"]       = { color = "FFAAAAAA", role = "Centinela",             icon = "Interface\\Icons\\INV_Shield_06" },
    ["Captain Thomas"]        = { color = "FFAAAAAA", role = "Capitán Naval",         icon = "Interface\\Icons\\INV_Helmet_69" },
    ["Capitán Thomas"]        = { color = "FFAAAAAA", role = "Capitán Naval",         icon = "Interface\\Icons\\INV_Helmet_69" },
    ["Captain Andrews"]       = { color = "FFAAAAAA", role = "Capitán Naval",         icon = "Interface\\Icons\\INV_Helmet_69" },
    ["Capitán Andrews"]       = { color = "FFAAAAAA", role = "Capitán Naval",         icon = "Interface\\Icons\\INV_Helmet_69" },
    ["Archmage Tervosh"]      = { color = "FF9966FF", role = "Archimago Kirin Tor",   icon = "Interface\\Icons\\Spell_Holy_MagicalSentry" },
    ["Archimago Tervosh"]     = { color = "FF9966FF", role = "Archimago Kirin Tor",   icon = "Interface\\Icons\\Spell_Holy_MagicalSentry" },
    ["Pained"]                = { color = "FF88FF88", role = "Guardaespaldas Real",   icon = "Interface\\Icons\\Ability_Rogue_Shadowstep" },
    ["Dolida"]                = { color = "FF88FF88", role = "Guardaespaldas Real",   icon = "Interface\\Icons\\Ability_Rogue_Shadowstep" },
    ["Smiling Jim"]           = { color = "FFFFFFCC", role = "Ciudadano",             icon = "Interface\\Icons\\INV_Misc_Beer_01" },
    ["Jim Sonrisas"]          = { color = "FFFFFFCC", role = "Ciudadano",             icon = "Interface\\Icons\\INV_Misc_Beer_01" },
    ["Jim Sonriente"]         = { color = "FFFFFFCC", role = "Ciudadano",             icon = "Interface\\Icons\\INV_Misc_Beer_01" },
    ["Innkeeper Janene"]      = { color = "FFDDBB88", role = "Posadera",              icon = "Interface\\Icons\\INV_Misc_Food_14" },
    ["Tabernera Janene"]      = { color = "FFDDBB88", role = "Posadera",              icon = "Interface\\Icons\\INV_Misc_Food_14" },
    ["Guardia en instrucción"] = { color = "FFAAAAAA", role = "Recluta",              icon = "Interface\\Icons\\Ability_Warrior_OffensiveStance" },
    ["Practicing Guard"]      = { color = "FFAAAAAA", role = "Recluta",              icon = "Interface\\Icons\\Ability_Warrior_OffensiveStance" },
    ["Agitador desertor"]     = { color = "FFFF7744", role = "Disidente",            icon = "Interface\\Icons\\Ability_Rogue_Disguise" },
    ["Deserting Agitator"]    = { color = "FFFF7744", role = "Disidente",            icon = "Interface\\Icons\\Ability_Rogue_Disguise" },
    ["Guard Edward"]          = { color = "FFAAAAAA", role = "Guardia de Theramore",  icon = "Interface\\Icons\\INV_Shield_06" },
    ["Guardia Edward"]        = { color = "FFAAAAAA", role = "Guardia de Theramore",  icon = "Interface\\Icons\\INV_Shield_06" },
    ["Guard Kahil"]           = { color = "FFAAAAAA", role = "Guardia de Theramore",  icon = "Interface\\Icons\\INV_Shield_06" },
    ["Guardia Kahil"]         = { color = "FFAAAAAA", role = "Guardia de Theramore",  icon = "Interface\\Icons\\INV_Shield_06" },
    ["Guard Narrisha"]        = { color = "FFAAAAAA", role = "Guardia de Theramore",  icon = "Interface\\Icons\\INV_Shield_06" },
    ["Guardia Narrisha"]      = { color = "FFAAAAAA", role = "Guardia de Theramore",  icon = "Interface\\Icons\\INV_Shield_06" },
    ["Theramore Sentry"]      = { color = "FFAAAAAA", role = "Centinela",             icon = "Interface\\Icons\\INV_Shield_06" },
    ["Centinela de Theramore"]= { color = "FFAAAAAA", role = "Centinela",             icon = "Interface\\Icons\\INV_Shield_06" },
    -- Soberanos y Aliados de Lore en Expediciones Multi-Mapa
    ["King Varian Wrynn"]     = { color = "FF3399FF", role = "Rey de Ventormenta",    icon = "Interface\\Icons\\INV_Crown_02" },
    ["Rey Varian Wrynn"]      = { color = "FF3399FF", role = "Rey de Ventormenta",    icon = "Interface\\Icons\\INV_Crown_02" },
    ["Archmage Rhonin"]       = { color = "FFB366FF", role = "Líder del Kirin Tor",   icon = "Interface\\Icons\\Spell_Holy_MagicalSentry" },
    ["Archimago Rhonin"]      = { color = "FFB366FF", role = "Líder del Kirin Tor",   icon = "Interface\\Icons\\Spell_Holy_MagicalSentry" },
    ["Warchief Thrall"]       = { color = "FFFF4422", role = "Jefe de Guerra",        icon = "Interface\\Icons\\Spell_Nature_BloodLust" },
    ["Jefe de Guerra Thrall"] = { color = "FFFF4422", role = "Jefe de Guerra",        icon = "Interface\\Icons\\Spell_Nature_BloodLust" }
}

-- Asegurar CVars de visibilidad para anclaje 3D fluido
pcall(function()
    SetCVar("nameplateShowFriends", "1")
    SetCVar("UnitNameFriendlyCreatureName", "1")
end)

-- 3. FRAME DE BURBUJA FLOTANTE SOBRE LA CABEZA (3D HEAD-BUBBLE CON BACKDROP PREMIUM)
local headBubble = CreateFrame("Frame", "LoreHUDHeadBubble", UIParent)
headBubble:SetFrameStrata("TOOLTIP")
headBubble:SetSize(280, 60)
headBubble:SetAlpha(0)
headBubble:Hide()

headBubble:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 14,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
})
headBubble:SetBackdropColor(0.04, 0.06, 0.12, 0.94)
headBubble:SetBackdropBorderColor(1, 0.82, 0.20, 0.88)

-- Flecha inferior apuntando a la cabeza / placa del PNJ
local bubbleTail = headBubble:CreateTexture(nil, "OVERLAY")
bubbleTail:SetSize(14, 10)
bubbleTail:SetPoint("TOP", headBubble, "BOTTOM", 0, 2)
bubbleTail:SetTexture("Interface\\Buttons\\Arrow-Down-Up")
bubbleTail:SetTexCoord(0, 1, 0, 0.5) -- Mitad superior: flecha orientada hacia abajo
bubbleTail:SetVertexColor(1, 0.82, 0.20, 0.90)

-- Texto del hablante (Nombre + Rol)
local bubbleSpeaker = headBubble:CreateFontString(nil, "OVERLAY")
bubbleSpeaker:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
bubbleSpeaker:SetTextColor(1, 0.84, 0, 1)
bubbleSpeaker:SetJustifyH("LEFT")
bubbleSpeaker:SetJustifyV("TOP")

-- Texto de diálogo (Autoajustable, multi-línea, 0% truncamiento)
local bubbleText = headBubble:CreateFontString(nil, "OVERLAY")
bubbleText:SetFont("Fonts\\FRIZQT__.TTF", 11, "")
bubbleText:SetTextColor(0.96, 0.96, 0.96, 1)
bubbleText:SetShadowColor(0, 0, 0, 0.85)
bubbleText:SetShadowOffset(1, -1)
bubbleText:SetJustifyH("LEFT")
bubbleText:SetJustifyV("TOP")
bubbleText:SetWordWrap(true)

-- Formateador dinámico sin truncamiento
local function FormatHeadBubble(speaker, text)
    if not speaker or not text or text == "" then
        headBubble:Hide()
        return
    end
    
    local textLen = string.len(text)
    local targetWidth = 280
    if textLen > 90 then
        targetWidth = 380
    elseif textLen > 45 then
        targetWidth = 320
    end
    
    local npcData = LORE_NPC_NAMES[speaker]
    local role = npcData and npcData.role or ""
    local speakerFormatted = "|cFFFFD700" .. speaker .. "|r"
    if role ~= "" then
        speakerFormatted = speakerFormatted .. " |cFF888888[" .. role .. "]|r"
    end
    
    headBubble:SetWidth(targetWidth)
    
    bubbleSpeaker:ClearAllPoints()
    bubbleSpeaker:SetPoint("TOPLEFT", headBubble, "TOPLEFT", 12, -8)
    bubbleSpeaker:SetPoint("TOPRIGHT", headBubble, "TOPRIGHT", -12, -8)
    bubbleSpeaker:SetWidth(targetWidth - 24)
    bubbleSpeaker:SetText(speakerFormatted)
    local speakerH = math.max(12, bubbleSpeaker:GetStringHeight() or 12)
    
    bubbleText:ClearAllPoints()
    bubbleText:SetPoint("TOPLEFT", headBubble, "TOPLEFT", 12, -(speakerH + 12))
    bubbleText:SetPoint("TOPRIGHT", headBubble, "TOPRIGHT", -12, -(speakerH + 12))
    bubbleText:SetWidth(targetWidth - 24)
    bubbleText:SetText(text)
    
    local textH = math.max(14, bubbleText:GetStringHeight() or 14)
    local totalHeight = math.ceil(speakerH + textH + 22)
    headBubble:SetHeight(math.max(54, totalHeight))
end

-- Comparador estricto de identidad de PNJ (Evita cualquier cruce entre hablantes)
local function NormalizeName(str)
    if not str then return "" end
    str = string.lower(str)
    str = string.gsub(str, "[\194\160]", " ")
    return str
end

local function IsSpeakerMatch(targetStr, speakerStr)
    if not targetStr or not speakerStr then return false end
    local a = NormalizeName(targetStr)
    local b = NormalizeName(speakerStr)
    
    if a == b then return true end
    if string.find(a, b, 1, true) or string.find(b, a, 1, true) then return true end
    
    if string.find(a, "jaina") and string.find(b, "jaina") then return true end
    if string.find(a, "byron") and string.find(b, "byron") then return true end
    if string.find(a, "aden") and string.find(b, "aden") then return true end
    if string.find(a, "thomas") and string.find(b, "thomas") then return true end
    if string.find(a, "andrews") and string.find(b, "andrews") then return true end
    if string.find(a, "tervosh") and string.find(b, "tervosh") then return true end
    if (string.find(a, "pained") or string.find(a, "dolida")) and (string.find(b, "pained") or string.find(b, "dolida")) then return true end
    if string.find(a, "jim") and string.find(b, "jim") then return true end
    if string.find(a, "janene") and string.find(b, "janene") then return true end
    if string.find(a, "desertor") and string.find(b, "desertor") then return true end
    if string.find(a, "edward") and string.find(b, "edward") then return true end
    if string.find(a, "kahil") and string.find(b, "kahil") then return true end
    if string.find(a, "narrisha") and string.find(b, "narrisha") then return true end
    if (string.find(a, "sentry") or string.find(a, "centinela")) and (string.find(b, "sentry") or string.find(b, "centinela")) then return true end
    if (string.find(a, "guardia") or string.find(a, "guard")) and (string.find(b, "guardia") or string.find(b, "guard")) then return true end
    
    return false
end

-- Buscador de Placas en WorldFrame con selección focal (Mínima distancia al centro de cámara)
local function FindNameplateForSpeaker(speaker)
    if not speaker then return nil end
    local bestPlate = nil
    local bestDistSq = 99999999
    local screenW = (UIParent and UIParent:GetWidth()) or 1024
    local screenH = (UIParent and UIParent:GetHeight()) or 768
    local midX, midY = screenW / 2, screenH / 2

    local numChildren = WorldFrame:GetNumChildren()
    for i = 1, numChildren do
        local child = select(i, WorldFrame:GetChildren())
        if child and child:IsShown() then
            local name = child:GetName()
            if not name or string.find(name, "^NamePlate") then
                local numRegions = select("#", child:GetRegions())
                for j = 1, numRegions do
                    local r = select(j, child:GetRegions())
                    if r and r:GetObjectType() == "FontString" then
                        local text = r:GetText()
                        if text and IsSpeakerMatch(text, speaker) then
                            local cX, cY = child:GetCenter()
                            if cX and cY then
                                local distSq = (cX - midX) * (cX - midX) + (cY - midY) * (cY - midY)
                                if distSq < bestDistSq then
                                    bestDistSq = distSq
                                    bestPlate = child
                                end
                            elseif not bestPlate then
                                bestPlate = child
                            end
                            break
                        end
                    end
                end
            end
        end
    end
    return bestPlate
end

-- Rastreador de Nameplate o Target en 3D
local activeSpeaker = nil
local bubbleThrottle = 0
local bubbleUpdateFrame = CreateFrame("Frame")
bubbleUpdateFrame:SetScript("OnUpdate", function(self, elapsed)
    if not activeSpeaker then
        headBubble:Hide()
        return
    end
    
    bubbleThrottle = bubbleThrottle + elapsed
    if bubbleThrottle < 0.03 then return end
    bubbleThrottle = 0
    
    -- Prioridad 1: Placa de nombre 3D visible en WorldFrame
    local foundPlate = FindNameplateForSpeaker(activeSpeaker)
    if foundPlate and foundPlate:IsShown() then
        headBubble:ClearAllPoints()
        headBubble:SetPoint("BOTTOM", foundPlate, "TOP", 0, 14)
        headBubble:SetAlpha(1)
        headBubble:Show()
        bubbleTail:Show()
        return
    end
    
    -- Prioridad 2: Si el jugador tiene al hablante en Target seleccionado
    if UnitExists("target") and IsSpeakerMatch(UnitName("target"), activeSpeaker) then
        headBubble:ClearAllPoints()
        headBubble:SetPoint("BOTTOM", TargetFrame, "TOP", 0, 12)
        headBubble:SetAlpha(0.95)
        headBubble:Show()
        bubbleTail:Hide()
        return
    end
    
    -- Prioridad 3: El hablante no está en pantalla o está fuera de rango de placas.
    -- Ocultar limpiamente la burbuja sobre la cabeza para no generar cuadros flotantes
    -- en el aire. La barra cinematográfica inferior maneja la línea con elegancia.
    headBubble:Hide()
end)

-- 4. FRAME DE SUBTÍTULOS CINEMATOGRÁFICOS (CINEMATIC LOWER-THIRD)
local subtitleQueue = {}
local subtitleActive = false
local MAX_QUEUE_SIZE = 4

local subtitleBG = CreateFrame("Frame", "LoreHUDSubtitleBG", UIParent)
subtitleBG:SetFrameStrata("HIGH")
subtitleBG:SetSize(720, 68)
subtitleBG:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 115)
subtitleBG:SetAlpha(0)
subtitleBG:Hide()

local bg = subtitleBG:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints(subtitleBG)
bg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
bg:SetVertexColor(0.03, 0.05, 0.10, 0.85)

-- Borde dorado superior e inferior
local topLine = subtitleBG:CreateTexture(nil, "OVERLAY")
topLine:SetSize(720, 2)
topLine:SetPoint("TOP", subtitleBG, "TOP", 0, 0)
topLine:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
topLine:SetVertexColor(1, 0.84, 0, 0.95)

local botLine = subtitleBG:CreateTexture(nil, "OVERLAY")
botLine:SetSize(720, 1)
botLine:SetPoint("BOTTOM", subtitleBG, "BOTTOM", 0, 0)
botLine:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
botLine:SetVertexColor(1, 0.84, 0, 0.50)

-- Icono del personaje hablante
local speakerIcon = subtitleBG:CreateTexture(nil, "ARTWORK")
speakerIcon:SetSize(42, 42)
speakerIcon:SetPoint("LEFT", subtitleBG, "LEFT", 14, 0)
speakerIcon:SetTexture("Interface\\Icons\\Spell_Frost_FrostBolt02")

local iconBorder = subtitleBG:CreateTexture(nil, "OVERLAY")
iconBorder:SetSize(44, 44)
iconBorder:SetPoint("CENTER", speakerIcon, "CENTER", 0, 0)
iconBorder:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
iconBorder:SetBlendMode("ADD")
iconBorder:SetVertexColor(1, 0.84, 0, 0.8)

-- Emblema Oficial WoW Perú en Lower-Third
local cineLogo = subtitleBG:CreateTexture(nil, "ARTWORK")
cineLogo:SetSize(48, 24)
cineLogo:SetPoint("RIGHT", subtitleBG, "RIGHT", -12, 0)
cineLogo:SetTexture("Interface\\AddOns\\LoreHUD\\Textures\\wowperu_logo.tga")
cineLogo:SetAlpha(0.45)

-- Nombre y rol
local speakerText = subtitleBG:CreateFontString(nil, "OVERLAY", "GameFontNormal")
speakerText:SetPoint("TOPLEFT", subtitleBG, "TOPLEFT", 68, -10)
speakerText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
speakerText:SetTextColor(1, 0.84, 0, 1)
speakerText:SetText("")

-- Diálogo
local dialogText = subtitleBG:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
dialogText:SetPoint("TOPLEFT", subtitleBG, "TOPLEFT", 68, -26)
dialogText:SetPoint("BOTTOMRIGHT", subtitleBG, "BOTTOMRIGHT", -16, 6)
dialogText:SetFont("Fonts\\FRIZQT__.TTF", 12, "")
dialogText:SetTextColor(1, 1, 1, 1)
dialogText:SetJustifyH("LEFT")
dialogText:SetJustifyV("TOP")
dialogText:SetWordWrap(true)
dialogText:SetText("")

local function ProcessSubtitleQueue()
    if #subtitleQueue == 0 then
        subtitleActive = false
        activeSpeaker = nil
        return
    end
    
    subtitleActive = true
    local entry = table.remove(subtitleQueue, 1)
    local npcData = LORE_NPC_NAMES[entry.speaker] or {}
    local role = npcData.role or ""
    local icon = npcData.icon or "Interface\\Icons\\Spell_Frost_FrostBolt02"
    
    speakerIcon:SetTexture(icon)
    
    local displayName = entry.speaker
    if role ~= "" then
        displayName = entry.speaker .. " |cFF888888[" .. role .. "]|r"
    end
    speakerText:SetText("|cFFFFD700" .. displayName .. "|r")
    dialogText:SetText(entry.text)
    
    -- Configurar y formatear la burbuja 3D sobre la cabeza
    activeSpeaker = entry.speaker
    FormatHeadBubble(entry.speaker, entry.text)
    
    -- Ajustar altura de la barra cinematográfica inferior
    local textH = dialogText:GetStringHeight() or 20
    subtitleBG:SetHeight(math.max(64, textH + 34))
    
    -- Chime de audio
    PlaySound("TellMessage")
    
    -- Animación de fade in cinematográfico
    subtitleBG:SetAlpha(0)
    subtitleBG:Show()
    headBubble:SetAlpha(0)
    
    local fadeInStart = GetTime()
    animFrame:SetScript("OnUpdate", function(self, el)
        local p = math.min((GetTime() - fadeInStart) / 0.20, 1)
        subtitleBG:SetAlpha(p)
        headBubble:SetAlpha(p)
        if p >= 1 then
            self:SetScript("OnUpdate", nil)
        end
    end)
    
    -- Duración inteligente según longitud y cola
    local textLength = string.len(entry.text)
    local displayDuration = math.min(8.0, math.max(4.5, textLength * 0.055))
    if #subtitleQueue > 0 then
        displayDuration = math.min(displayDuration, 3.8)
    end
    
    TimerAfter(displayDuration, function()
        -- Fade out sincronizado
        local fadeOutStart = GetTime()
        animFrame:SetScript("OnUpdate", function(self, el)
            local p = math.min((GetTime() - fadeOutStart) / 0.30, 1)
            subtitleBG:SetAlpha(1 - p)
            headBubble:SetAlpha(1 - p)
            if p >= 1 then
                self:SetScript("OnUpdate", nil)
                subtitleBG:Hide()
                headBubble:Hide()
                activeSpeaker = nil
                TimerAfter(0.1, ProcessSubtitleQueue)
            end
        end)
    end)
end

local function ShowSubtitle(speaker, text)
    if not text or text == "" then return end
    
    -- Limitar tamaño de cola a 4 para prevenir acumulación
    if #subtitleQueue >= 4 then
        table.remove(subtitleQueue, 1)
    end
    
    table.insert(subtitleQueue, { speaker = speaker, text = text })
    
    if not subtitleActive then
        ProcessSubtitleQueue()
    end
end

-- 5. LISTENER DE EVENTOS DE CHAT (MONSTER SAY / YELL)
local chatListener = CreateFrame("Frame", "LoreHUDChatListener")
chatListener:RegisterEvent("CHAT_MSG_MONSTER_SAY")
chatListener:RegisterEvent("CHAT_MSG_MONSTER_YELL")
chatListener:SetScript("OnEvent", function(self, event, msg, sender, ...)
    local message = msg or arg1
    local speaker = sender or arg2
    if speaker and (LORE_NPC_NAMES[speaker] or string.find(speaker, "Jaina")) then
        ShowSubtitle(speaker, message)
    end
end)

-- 6. PANEL DE ESTADO COMPACTO DE JAINA (HUD LATERAL)
local MOOD_LABELS = {
    CALM       = "|cFF88FF88Tranquila|r",
    VIGILANT   = "|cFFFFCC00Vigilante|r",
    REFLECTIVE = "|cFF9966FFReflexiva|r",
    COMBAT     = "|cFFFF4444En Combate|r"
}
local LOCATION_LABELS = {
    COURTYARD = "Patio de Armas",
    KEEP      = "Plaza Central",
    DOCKS     = "Muelles Navales",
    VIGIL     = "El Gran Puente",
    BRIDGE    = "El Gran Puente",
    SANCTUM   = "Sanctum de la Torre",
    STORMWIND = "Castillo de Ventormenta",
    DALARAN   = "Ciudadela Violeta",
    SUMMIT    = "Cumbre de Paz (Kalimdor)"
}

local jainaPanel = CreateFrame("Frame", "LoreHUDJainaPanel", UIParent)
jainaPanel:SetFrameStrata("MEDIUM")
jainaPanel:SetSize(220, 62)
jainaPanel:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 12, -210)
jainaPanel:SetAlpha(0.92)

local panelBG = jainaPanel:CreateTexture(nil, "BACKGROUND")
panelBG:SetAllPoints(jainaPanel)
panelBG:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
panelBG:SetVertexColor(0.02, 0.05, 0.12, 0.85)

local panelBorder = jainaPanel:CreateTexture(nil, "OVERLAY")
panelBorder:SetSize(220, 2)
panelBorder:SetPoint("TOP", jainaPanel, "TOP", 0, 0)
panelBorder:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
panelBorder:SetVertexColor(0.43, 0.67, 1, 0.9)

local panelTitle = jainaPanel:CreateFontString(nil, "OVERLAY")
panelTitle:SetPoint("TOPLEFT", jainaPanel, "TOPLEFT", 8, -6)
panelTitle:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
panelTitle:SetTextColor(0.43, 0.67, 1, 1)
panelTitle:SetText("Lady Jaina Proudmoore")

-- Emblema Oficial WoW Perú en Panel de Estado
local peruLogo = jainaPanel:CreateTexture(nil, "ARTWORK")
peruLogo:SetSize(38, 19)
peruLogo:SetPoint("TOPRIGHT", jainaPanel, "TOPRIGHT", -6, -4)
peruLogo:SetTexture("Interface\\AddOns\\LoreHUD\\Textures\\wowperu_logo.tga")
peruLogo:SetAlpha(0.7)

local panelMood = jainaPanel:CreateFontString(nil, "OVERLAY")
panelMood:SetPoint("TOPLEFT", jainaPanel, "TOPLEFT", 8, -20)
panelMood:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
panelMood:SetText("Estado: " .. MOOD_LABELS["CALM"])

local panelLocation = jainaPanel:CreateFontString(nil, "OVERLAY")
panelLocation:SetPoint("TOPLEFT", jainaPanel, "TOPLEFT", 8, -34)
panelLocation:SetFont("Fonts\\FRIZQT__.TTF", 9, "")
panelLocation:SetTextColor(0.80, 0.80, 0.80, 1)
panelLocation:SetText("Zona: Plaza Central")

local panelActivity = jainaPanel:CreateFontString(nil, "OVERLAY")
panelActivity:SetPoint("TOPLEFT", jainaPanel, "TOPLEFT", 8, -47)
panelActivity:SetFont("Fonts\\FRIZQT__.TTF", 8, "")
panelActivity:SetTextColor(0.35, 0.75, 1, 1)
panelActivity:SetText("• Inspeccion de Defensas")

local function UpdateJainaPanel(mood, location, activity)
    panelMood:SetText("Estado: " .. (MOOD_LABELS[mood] or mood))
    panelLocation:SetText("Zona: " .. (LOCATION_LABELS[location] or location))
    if activity then
        panelActivity:SetText("• " .. activity)
    end
    panelBorder:SetVertexColor(1, 0.84, 0, 1)
    TimerAfter(1.5, function()
        panelBorder:SetVertexColor(0.43, 0.67, 1, 0.9)
    end)
end

-- 6.5 BANNER CINEMÁTICO DE EVENTOS MUNDIALES (JAINA_EVENT)
local eventBanner = CreateFrame("Frame", "LoreHUDEventBanner", UIParent)
eventBanner:SetFrameStrata("HIGH")
eventBanner:SetSize(460, 60)
eventBanner:SetPoint("TOP", UIParent, "TOP", 0, -120)
eventBanner:Hide()

local eventBG = eventBanner:CreateTexture(nil, "BACKGROUND")
eventBG:SetAllPoints(eventBanner)
eventBG:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
eventBG:SetVertexColor(0.04, 0.06, 0.12, 0.92)

local eventBorder = eventBanner:CreateTexture(nil, "OVERLAY")
eventBorder:SetSize(460, 2)
eventBorder:SetPoint("TOP", eventBanner, "TOP", 0, 0)
eventBorder:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
eventBorder:SetVertexColor(1, 0.3, 0.3, 1)

local eventTitle = eventBanner:CreateFontString(nil, "OVERLAY")
eventTitle:SetPoint("TOP", eventBanner, "TOP", 0, -10)
eventTitle:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
eventTitle:SetTextColor(1, 0.85, 0.2, 1)

local eventDesc = eventBanner:CreateFontString(nil, "OVERLAY")
eventDesc:SetPoint("TOP", eventBanner, "TOP", 0, -32)
eventDesc:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
eventDesc:SetTextColor(0.9, 0.9, 0.9, 1)

local function ShowEventBanner(eventName, duration, desc)
    local titleText = "¡ALERTA EN THERAMORE!"
    local colorR, colorG, colorB = 1, 0.3, 0.3
    if eventName == "AUDIENCE" then
        titleText = "AUDIENCIA SOBERANA CONVOCADA"
        colorR, colorG, colorB = 0.2, 0.9, 0.4
    elseif eventName == "RITUAL" then
        titleText = "RESONANCIA ARCANA EN LA TORRE"
        colorR, colorG, colorB = 0.7, 0.4, 1.0
    end
    eventBorder:SetVertexColor(colorR, colorG, colorB, 1)
    eventTitle:SetText(titleText)
    eventDesc:SetText(desc or "Evento en curso")
    pcall(function() PlaySound("RaidWarning") end)
    eventBanner:SetAlpha(0)
    eventBanner:Show()

    local alpha = 0
    local fader = CreateFrame("Frame")
    fader:SetScript("OnUpdate", function(self, elapsed)
        alpha = alpha + elapsed * 2
        if alpha >= 1 then
            alpha = 1
            self:SetScript("OnUpdate", nil)
        end
        eventBanner:SetAlpha(alpha)
    end)

    TimerAfter(6.0, function()
        local outAlpha = 1
        local outFader = CreateFrame("Frame")
        outFader:SetScript("OnUpdate", function(self, elapsed)
            outAlpha = outAlpha - elapsed * 1.5
            if outAlpha <= 0 then
                outAlpha = 0
                eventBanner:Hide()
                self:SetScript("OnUpdate", nil)
            end
            eventBanner:SetAlpha(outAlpha)
        end)
    end)
end

local function ShowExpeditionBanner(expKey, district, duration)
    local titleText = "EXPEDICIÓN DIPLOMÁTICA CONTINENTAL"
    local descText = "Lady Jaina ha partido en misión oficial."
    local colorR, colorG, colorB = 0.3, 0.7, 1.0

    if expKey == "STORMWIND" then
        titleText = "MISIÓN DE ESTADO: VENTORMENTA"
        descText = "Lady Jaina delibera con el Rey Varian Wrynn en la Sala del Trono."
        colorR, colorG, colorB = 0.2, 0.55, 1.0
        UpdateJainaPanel("VIGILANT", "STORMWIND", "Audiencia Soberana con Varian")
    elseif expKey == "DALARAN" then
        titleText = "CÓNCLAVE ARCANO: DALARAN"
        descText = "Lady Jaina coordina con el Archimago Rhonin en la Ciudadela Violeta."
        colorR, colorG, colorB = 0.75, 0.35, 1.0
        UpdateJainaPanel("REFLECTIVE", "DALARAN", "Consejo de los Seis en Dalaran")
    elseif expKey == "SUMMIT" then
        titleText = "CÓNCLAVE SECRETO DE PAZ"
        descText = "Lady Jaina se reúne con el Jefe de Guerra Thrall por el destino de Kalimdor."
        colorR, colorG, colorB = 0.2, 0.95, 0.45
        UpdateJainaPanel("CALM", "SUMMIT", "Pacto de Paz con Thrall")
    elseif expKey == "HOME" then
        titleText = "RETORNO A THERAMORE"
        descText = "Lady Jaina ha retornado a salvo a su trono en Theramore."
        colorR, colorG, colorB = 1.0, 0.84, 0.2
        UpdateJainaPanel("CALM", "KEEP", "Gobierno de Theramore")
    end

    eventBorder:SetVertexColor(colorR, colorG, colorB, 1)
    eventTitle:SetText(titleText)
    eventDesc:SetText(descText)
    pcall(function() PlaySound("QUESTCOMPLETED") end)
    eventBanner:SetAlpha(0)
    eventBanner:Show()

    local alpha = 0
    local fader = CreateFrame("Frame")
    fader:SetScript("OnUpdate", function(self, elapsed)
        alpha = alpha + elapsed * 2
        if alpha >= 1 then
            alpha = 1
            self:SetScript("OnUpdate", nil)
        end
        eventBanner:SetAlpha(alpha)
    end)

    TimerAfter(7.0, function()
        local outAlpha = 1
        local outFader = CreateFrame("Frame")
        outFader:SetScript("OnUpdate", function(self, elapsed)
            outAlpha = outAlpha - elapsed * 1.5
            if outAlpha <= 0 then
                outAlpha = 0
                eventBanner:Hide()
                self:SetScript("OnUpdate", nil)
            end
            eventBanner:SetAlpha(outAlpha)
        end)
    end)
end

-- Listener de Addon Messages ("LOREWOW") y Handshake
local addonListener = CreateFrame("Frame", "LoreHUDAddonListener")
addonListener:RegisterEvent("CHAT_MSG_ADDON")
addonListener:RegisterEvent("PLAYER_ENTERING_WORLD")
addonListener:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        if RegisterAddonMessagePrefix then
            RegisterAddonMessagePrefix("LOREWOW")
        end
        local pName = UnitName("player")
        if pName and pName ~= "" and pName ~= UNKNOWNOBJECT then
            SendAddonMessage("LOREWOW", "REQ_STATE", "WHISPER", pName)
        end
        return
    end

    local prefix, msg = ...
    local p = prefix or arg1
    local m = msg or arg2
    if p ~= "LOREWOW" or not m then return end
    local parts = { strsplit("|", m) }
    if parts[1] == "JAINA_STATE" then
        UpdateJainaPanel(parts[2] or "CALM", parts[3] or "KEEP", parts[4] or "En guardia")
    elseif parts[1] == "JAINA_EVENT" then
        ShowEventBanner(parts[2] or "EVENT", tonumber(parts[3]) or 180, parts[4] or "")
    elseif parts[1] == "JAINA_EXP" then
        ShowExpeditionBanner(parts[2] or "STORMWIND", parts[3] or "Destino", tonumber(parts[4]) or 300)
    end
end)

if RegisterAddonMessagePrefix then
    RegisterAddonMessagePrefix("LOREWOW")
end

-- 7. COMANDOS SLASH /lorehud
SLASH_LOREHUD1 = "/lorehud"
SlashCmdList["LOREHUD"] = function(msg)
    local cmd = string.lower(msg or "")
    if cmd == "hide" then
        jainaPanel:Hide()
        subtitleBG:Hide()
        headBubble:Hide()
        print("|cFFFFD700[LoreHUD]|r Interfaz oculta.")
    elseif cmd == "show" then
        jainaPanel:Show()
        print("|cFFFFD700[LoreHUD]|r Interfaz restaurada.")
    elseif cmd == "test" or cmd == "testjaina" then
        ShowSubtitle("Lady Jaina Valiente", "El poder que manipuláis camina por el filo de la perdición... lo conozco bien. Sed cuidadoso en Theramore.")
        print("|cFFFFD700[LoreHUD]|r Diálogo de prueba de Jaina emitido (Comprobar burbuja y ausencia de puntos suspensivos).")
    elseif cmd == "testbyron" then
        ShowSubtitle("Guardia Byron", "Así se hará, Lady Jaina. Los inspectores están revisando cada cargamento de trigo y pólvora en los almacenes.")
        print("|cFFFFD700[LoreHUD]|r Diálogo de prueba de Guardia Byron emitido.")
    else
        print("|cFFFFD700[LoreHUD]|r Comandos: /lorehud show | hide | test | testbyron")
    end
end

print("|cFFFFD700[LoreHUD v2.1]|r Cargado con éxito — Burbujas sobre la cabeza dinámicas y subtítulos cinematográficos activos.")

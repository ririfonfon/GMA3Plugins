-- ===========================================================================
-- GoboRecipes (YannLight) : gobos et prismes de la librairie -> presets + sequences recipes
--                           + apparences (image blanche / verte) + layout trie par roue
--
--   Plugin "GoboRecipes"                 -> accueil
--   Plugin "GoboRecipes" "gobo 12"       -> gobos / animation du groupe 12, sans accueil
--   Plugin "GoboRecipes" "prism 12"      -> prismes du groupe 12
--   Plugin "GoboRecipes" "probe 12"      -> sonde : ecrit GoboRecipes_diagnostic.txt (gma3_library)
--   Plugin "GoboRecipes" "update 12"     -> actualiser le groupe 12 ; "clean" -> nettoyer
--
-- Regles (comme GroupsFromPatch) : jamais d'objet existant ecrase ou efface ; seuls les objets
-- portant la marque GBR (propriete Note) sont reconnus et reutilises ; un seul "Oops" annule tout.
-- ===========================================================================

local UI_SIGNALS, UI_HANDLE = select(3, ...)

local PLUGIN_NAME = "GoboRecipes"
local VERSION = "1.3.0"
local UI_BRAND = "YannLight"
local TAG = "GBR"
local SETTINGS_PREFIX = "GBR_"

local DEFAULT_GOBO_POOL = 3   -- pool de presets Gobo
local DEFAULT_PRISM_POOL = 5  -- pool de presets Beam (prismes)
local MAX_DMX24 = 16777215

-- ---------------------------------------------------------------------------
-- Utilitaires
-- ---------------------------------------------------------------------------
local function safe(s)
    return (tostring(s or ""):gsub('"', "'"))
end

local function trim(s)
    return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function log(fmt, ...)
    Printf(PLUGIN_NAME .. ": " .. string.format(fmt, ...))
end

local function clean_label(s)
    return trim((tostring(s or ""):gsub('["\']', ""):gsub("%s+", " ")))
end

local function show_info(title, message)
    if MessageBox then
        MessageBox({ title = title, message = message, commands = { { value = 1, name = "OK" } } })
    else
        Printf(title .. ": " .. message)
    end
end

local function pause(seconds)
    pcall(coroutine.yield, seconds or 0.05)
end

local function to_number(value)
    if value == nil then return nil end
    if type(value) == "number" then return value end
    local text = tostring(value):gsub(",", ".")
    return tonumber(text:match("-?%d+%.?%d*"))
end

-- ---------------------------------------------------------------------------
-- Barre de progression (optionnelle) et annulation unique
-- ---------------------------------------------------------------------------
local PROGRESS_OPEN = {}

local function progress_start(title, total)
    local p = { n = 0, total = math.max(1, tonumber(total) or 1) }
    local ok, h = pcall(StartProgress, tostring(title))
    if ok and h then
        p.h = h
        pcall(SetProgressRange, h, 0, p.total)
        PROGRESS_OPEN[#PROGRESS_OPEN + 1] = p
    end
    return p
end

local function progress_step(p, text)
    if not p or not p.h then return end
    p.n = p.n + 1
    if text then
        pcall(SetProgressText, p.h, string.format("%d / %d   %s", math.min(p.n, p.total), p.total, tostring(text)))
    end
    pcall(IncProgress, p.h, 1)
    pcall(coroutine.yield, 0.01)
end

local function progress_stop(p)
    if not p or not p.h then return end
    pcall(StopProgress, p.h)
    for i = #PROGRESS_OPEN, 1, -1 do
        if PROGRESS_OPEN[i] == p then table.remove(PROGRESS_OPEN, i) end
    end
    p.h = nil
end

local function progress_stop_all()
    for i = #PROGRESS_OPEN, 1, -1 do
        local p = PROGRESS_OPEN[i]
        if p and p.h then pcall(StopProgress, p.h); p.h = nil end
        PROGRESS_OPEN[i] = nil
    end
end

local RawCmd = Cmd
local current_undo = nil

-- Cmd rend le texte de resultat de la console ("Ok", "Syntax Error"...)
local function Cmd(command)
    local ok, res
    if current_undo then
        ok, res = pcall(RawCmd, command, current_undo)
    else
        ok, res = pcall(RawCmd, command)
    end
    if not ok then
        log("commande refusee : %s (%s)", command, tostring(res))
        return "Error"
    end
    return tostring(res or "")
end

-- ---------------------------------------------------------------------------
-- Memoire des reglages (variables utilisateur GBR_)
-- ---------------------------------------------------------------------------
local function load_setting(name, default)
    local ok, value = pcall(function() return GetVar(UserVars(), SETTINGS_PREFIX .. name) end)
    if ok and value ~= nil and trim(value) ~= "" then return trim(value) end
    return default
end

-- reglage propre a chaque famille (gobos = nom nu, prismes = suffixe)
local function kkey(kind, name) return kind == "gobo" and name or (name .. "|" .. kind) end

local function save_setting(name, value)
    pcall(function() SetVar(UserVars(), SETTINGS_PREFIX .. name, tostring(value)) end)
end

-- ---------------------------------------------------------------------------
-- Acces aux objets (tolerant : une propriete absente ne casse jamais le plugin)
-- ---------------------------------------------------------------------------
local function rp(obj, name)
    if obj == nil then return nil end
    local ok, value = pcall(function() return obj[name] end)
    if ok and value ~= nil then return value end
    ok, value = pcall(function() return obj:Get(name) end)
    if ok and value ~= nil and tostring(value) ~= "" then return value end
    return nil
end

local function kids(obj)
    if obj == nil then return {} end
    local ok, list = pcall(function() return obj:Children() end)
    if ok and type(list) == "table" then return list end
    return {}
end

-- nom d'un objet, ou d'une reference vers un objet
local function oname(obj)
    if obj == nil then return "" end
    if type(obj) == "string" or type(obj) == "number" then return tostring(obj) end
    local n = rp(obj, "Name")
    if n ~= nil then return tostring(n) end
    return tostring(obj)
end

local function norm(s)
    return (tostring(s or ""):lower():gsub("[%s%*_%-%.<>]", ""))
end

-- enfant dont le nom correspond (sans casse), sinon la propriete du meme nom
local function child_named(obj, names)
    if obj == nil then return nil end
    for _, c in ipairs(kids(obj)) do
        local cn = norm(oname(c))
        for _, n in ipairs(names) do
            if cn == norm(n) then return c end
        end
    end
    for _, n in ipairs(names) do
        local v = rp(obj, n)
        if v ~= nil and type(v) ~= "string" and type(v) ~= "number" and type(v) ~= "boolean" then return v end
    end
    return nil
end

-- noms de toutes les proprietes d'un objet (en majuscules, comme la console les donne)
local function prop_names(obj)
    local names, seen = {}, {}
    if obj == nil then return names end
    local ok, count = pcall(function() return obj:PropertyCount() end)
    if not ok or not count then return names end
    for i = 0, count do
        local ok2, n = pcall(function() return obj:PropertyName(i) end)
        if ok2 and n and not seen[n] then
            seen[n] = true
            names[#names + 1] = n
        end
    end
    return names
end

local function find_prop(obj, candidates, contains)
    local names = prop_names(obj)
    for _, c in ipairs(candidates) do
        for _, n in ipairs(names) do
            if norm(n) == norm(c) then return n end
        end
    end
    if contains then
        for _, n in ipairs(names) do
            if norm(n):find(norm(contains), 1, true) then return n end
        end
    end
    return nil
end

-- ---------------------------------------------------------------------------
-- Numeros libres
-- ---------------------------------------------------------------------------
local function pool_numbers(getter)
    local used = {}
    pcall(function()
        for _, o in ipairs(getter()) do
            local no = tonumber(rp(o, "No"))
            if no then used[no] = o end
        end
    end)
    return used
end

local function preset_pool_children(pool)
    local list = {}
    pcall(function()
        local pp = DataPool().PresetPools[pool]
        list = kids(pp)
    end)
    if #list == 0 then
        pcall(function()
            for _, p in ipairs(kids(DataPool().PresetPools)) do
                if tonumber(rp(p, "No")) == pool then list = kids(p) end
            end
        end)
    end
    return list
end

local function sequences_list() return kids(DataPool().Sequences) end
local function appearances_list() return kids(ShowData().Appearances) end
local function layouts_list() return kids(DataPool().Layouts) end
local function groups_list() return kids(DataPool().Groups) end

local function next_free(used, from)
    local n = math.max(1, math.floor(from or 1))
    while used[n] do n = n + 1 end
    return n
end

local function block_free(used, start, count)
    for n = start, start + math.max(1, count) - 1 do
        if used[n] then return false end
    end
    return true
end

-- premiere plage "en centaines" (1, 101, 201...) >= hint ou `count` numeros consecutifs sont libres
local function hundreds_start(used, count, hint)
    local s = 1
    if hint and hint > 1 then s = math.ceil((hint - 1) / 100) * 100 + 1 end
    for _ = 1, 5000 do
        if block_free(used, s, count) then return s end
        s = s + 100
    end
    return next_free(used, hint or 1)
end

-- verifie la plage choisie : libre -> inchangee ; sinon on propose la suivante en centaines (rien n'est ecrase)
local function settle_block(used, start, count, label, notes)
    if block_free(used, start, count) then return start end
    local alt = hundreds_start(used, count, start)
    notes[#notes + 1] = string.format("%s : plage %d-%d deja occupee -> %d-%d utilisee",
        label, start, start + count - 1, alt, alt + count - 1)
    return alt
end

-- curseur sur un bloc de `count` numeros libres contigus (en centaines) ; alloc() le fait avancer
local function new_cursor(used, count, hint)
    return { n = hundreds_start(used, count, hint) }
end

local function alloc(used, cursor)
    local n = next_free(used, cursor.n)
    used[n] = true
    cursor.n = n + 1
    return n
end

-- ---------------------------------------------------------------------------
-- Familles de roues
-- ---------------------------------------------------------------------------
local FAMILIES = {
    gobo = {
        { attr = "Gobo1", label = "Gobo 1" },
        { attr = "Gobo2", label = "Gobo 2" },
        { attr = "Gobo3", label = "Gobo 3" },
        { attr = "AnimationWheel1", alias = { "EffectWheel", "EffectWheel1" }, label = "Animation" },
        { attr = "AnimationWheel2", alias = { "EffectWheel2" }, label = "Animation 2" },
        { attr = "AnimationWheel3", alias = { "EffectWheel3" }, label = "Animation 3" },
    },
    prism = {
        { attr = "Prism1", label = "Prisme 1" },
        { attr = "Prism2", label = "Prisme 2" },
        { attr = "Prism3", label = "Prisme 3" },
    },
}

local function family_of(kind, attr)
    local a = norm(attr)
    for i, f in ipairs(FAMILIES[kind]) do
        if a == norm(f.attr) then return i, f end
        for _, al in ipairs(f.alias or {}) do
            if a == norm(al) then return i, f end
        end
    end
    return nil
end

-- ---------------------------------------------------------------------------
-- Lecture du groupe : types de projecteurs et modes DMX presents
-- ---------------------------------------------------------------------------
local function mode_name_of(fixture)
    for _, key in ipairs({ "ModeDirect", "DMXMode", "Mode" }) do
        local v = rp(fixture, key)
        if v ~= nil then
            local n = oname(v)
            if n ~= "" then return n end
        end
    end
    return nil
end

local function read_group_types(group_no)
    Cmd("ClearAll")
    Cmd("SelectFixtures Group " .. group_no)
    pause(0.1)
    local types, order = {}, {}
    local ok, idx = pcall(SelectionFirst)
    local guard = 0
    while ok and idx and guard < 5000 do
        guard = guard + 1
        local okf, fx = pcall(GetSubfixture, idx)
        if okf and fx then
            local ft = rp(fx, "FixtureType")
            if ft ~= nil then
                local tname = oname(ft)
                local mname = mode_name_of(fx) or ""
                local key = tname .. "|" .. mname
                local t = types[key]
                if not t then
                    t = { key = key, type_name = tname, mode_name = mname, ftype = ft, fids = {}, first_sub = idx }
                    t.short = trim(oname(rp(ft, "ShortName") or tname))
                    if t.short == "" then t.short = tname end
                    types[key] = t
                    order[#order + 1] = t
                end
                local fid = to_number(rp(fx, "FID"))
                if fid then t.fids[#t.fids + 1] = fid end
            end
        end
        local okn, nxt = pcall(SelectionNext, idx)
        if not okn then break end
        idx = nxt
    end
    Cmd("ClearAll")
    for _, t in ipairs(order) do
        table.sort(t.fids)
        t.first_fid = t.fids[1]
    end
    return order
end

-- ---------------------------------------------------------------------------
-- Lecture des roues dans le fixture type :
--   DMXModes > mode > DMXChannels > DMXChannel > LogicalChannel > ChannelFunction > ChannelSet
-- ---------------------------------------------------------------------------
local function attr_of(obj)
    local v = rp(obj, "Attribute")
    local n = (v ~= nil) and oname(v) or oname(obj)
    return tostring(n)
end

local function slot_object(wheel, slot_index)
    if wheel == nil or type(wheel) == "string" then return nil end
    local list = kids(wheel)
    for _, s in ipairs(list) do
        if tonumber(rp(s, "No")) == slot_index then return s end
    end
    return list[slot_index]
end

local function scan_type(t, kind)
    local items = {}
    local modes = child_named(t.ftype, { "DMXModes" })
    local mode = nil
    for _, m in ipairs(kids(modes)) do
        if t.mode_name == "" or oname(m) == t.mode_name then mode = m; break end
    end
    if not mode then
        -- mode non lu sur le projecteur : on prend le premier qui contient la roue cherchee
        mode = kids(modes)[1]
        t.mode_warn = true
    end
    local chans = child_named(mode, { "DMXChannels" })
    local other = (kind == "gobo") and "prism" or "gobo"
    local seq = 0
    local blocks = {}          -- un bloc = une fonction de canal portant des channel sets a slot
    local pos_attrs = {}       -- attributs "...Pos" presents (la roue tourne -> a une fonction rotative)
    local rot_cfs = {}         -- prismes : fonction de rotation separee (Prism1PosRotate) -> version tournante
    local slotless = {}        -- prismes sans slot de roue : numero attribue par nom
    local slotless_n = 0
    local prism_wheels = {}    -- prismes : roues rencontrees par famille
    for di, dch in ipairs(kids(chans)) do
        for li, lc in ipairs(kids(dch)) do
            local lattr = attr_of(lc)
            pos_attrs[norm(lattr)] = true
            local _, lfam = family_of(kind, lattr)
            local lfam_i = (family_of(kind, lattr))
            for ci, cf in ipairs(kids(lc)) do
                local cattr = attr_of(cf)
                pos_attrs[norm(cattr)] = true
                if ((kind == "prism" and norm(cattr):match("^prism%d*posrotate$"))
                    or (kind == "gobo" and norm(cattr):match("^animationwheel%d*posrotate$"))) and (not rot_cfs[norm(cattr)] or rot_cfs[norm(cattr)].generic) then
                    rot_cfs[norm(cattr)] = { attr = cattr, cf = cf, lc_attr = lattr }
                end
                -- rotation du prisme portee par le canal d'effets (ex. Esprite : EFFECTROTATE) :
                -- EFFECTROTATE -> prisme 1, EFFECTROTATE2 -> prisme 2 (seulement si pas de PrismNPosRotate)
                if kind == "prism" then
                    local d = norm(cattr):match("^effect(%d*)rotate$")
                    if d then
                        local key = "prism" .. (d == "" and "1" or d) .. "posrotate"
                        if not rot_cfs[key] then
                            rot_cfs[key] = { attr = cattr, cf = cf, lc_attr = lattr, generic = true }
                        end
                    end
                end
                -- la famille vient de l'attribut de la fonction (ex. un prisme range dans le canal
                -- Effect wheel) ; sinon de celui du canal logique
                local fam_i, fam = family_of(kind, cattr)
                if not fam and not family_of(other, cattr) then fam_i, fam = lfam_i, lfam end
                if kind == "prism" and fam then
                    -- deux roues de prismes qui portent le meme attribut (Prism1) : une famille par roue, dans l'ordre
                    local wn = oname(rp(cf, "Wheel"))
                    prism_wheels[fam_i] = prism_wheels[fam_i] or {}
                    local pw = prism_wheels[fam_i]
                    local pos = nil
                    for k, w in ipairs(pw) do if w == wn then pos = k end end
                    if not pos then pw[#pw + 1] = wn; pos = #pw end
                    if pos > 1 and FAMILIES.prism[fam_i + pos - 1] then
                        fam_i = fam_i + pos - 1
                        fam = FAMILIES.prism[fam_i]
                    end
                end
                if fam then
                    local cfn = oname(cf):lower()
                    -- preuves explicites : repere grandMA (<Gobo1> rotatif, Gobo1* shake), noms
                    local ev_rot = (lattr .. cattr):find("<", 1, true) ~= nil or cfn:find("rotat", 1, true) ~= nil
                    local ev_shk = (lattr .. cattr):find("*", 1, true) ~= nil or cfn:find("shak", 1, true) ~= nil
                    local blk = { lc = lc, fam_i = fam_i, fam = fam, lattr = lattr, di = di, li = li, ci = ci, cf = cf,
                                  ev_rot = ev_rot, ev_shk = ev_shk, sets = {}, wheel = rp(cf, "Wheel") }
                    local anim_seen = {}
                    for si, cs in ipairs(kids(cf)) do
                        local slot = to_number(rp(cs, "WheelSlotIndex"))
                        -- roue d'animation : les rampes / plages proportionnelles d'un meme slot
                        -- ne donnent qu'une tuile (la premiere plage)
                        if slot and slot > 0 and norm(fam.attr):find("animation", 1, true) then
                            if anim_seen[slot] then slot = nil else anim_seen[slot] = true end
                        end
                        local noslot = false
                        if kind == "prism" and (not slot or slot <= 0) and norm(cattr) == norm(fam.attr) then
                            -- prisme sans slot de roue (open, prismes selectionnes par plage DMX) :
                            -- meme nom = meme ligne, quelle que soit la plage (indexe / rotatif)
                            local nm = oname(cs):lower():gsub("[<>%*]", ""):gsub("shake", ""):gsub("rotation", ""):gsub("rotating", "")
                                :gsub("indexing", ""):gsub("index", ""):gsub("%s+", " ")
                            nm = trim(nm)
                            if nm ~= "" then
                                local k = fam_i .. "|" .. nm
                                if not slotless[k] then slotless_n = slotless_n + 1; slotless[k] = 50 + slotless_n end
                                slot, noslot = slotless[k], true
                            end
                        end
                        if slot and slot > 0 then
                            local from = to_number(rp(cs, "DMXFrom")) or 0
                            local to = to_number(rp(cs, "DMXTo")) or from
                            blk.sets[#blk.sets + 1] = { cs = cs, si = si, slot = slot, from = from, to = to, noslot = noslot }
                        end
                    end
                    if #blk.sets > 0 then
                        blk.first = blk.sets[1].from
                        blocks[#blocks + 1] = blk
                    end
                end
            end
        end
    end
    -- classement des blocs, roue par roue, dans l'ordre DMX :
    -- indexe, puis rotatif (si la roue tourne), puis shake, puis shake rotatif
    local by_fam = {}
    for _, b in ipairs(blocks) do
        by_fam[b.fam_i] = by_fam[b.fam_i] or {}
        table.insert(by_fam[b.fam_i], b)
    end
    local dedupe = {}
    for fam_i, list in pairs(by_fam) do
        table.sort(list, function(x, y)
            if x.first ~= y.first then return x.first < y.first end
            return (x.di * 1000 + x.li * 10 + x.ci) < (y.di * 1000 + y.li * 10 + y.ci)
        end)
        local fam = list[1].fam
        -- sans repere explicite : 2 blocs = indexe + shake (roue fixe) ; 3 blocs ou plus =
        -- indexe, rotatif, shake, shake rotatif (roue rotative, dans l'ordre DMX)
        local rotates = (#list >= 3)
        for _, b in ipairs(list) do if b.ev_rot then rotates = true end end
        local is_anim = norm(fam.attr):find("animation", 1, true) ~= nil
        -- la roue est "rotative par defaut" si la librairie a un canal d'index/rotation pour elle
        local rot_default = (pos_attrs[norm(fam.attr) .. "pos"] or pos_attrs[norm(fam.attr) .. "posrotate"]) and true or false
        for _, b in ipairs(list) do if b.ev_rot then rot_default = true end end
        local expected = rotates and { "idx", "rot", "shk", "rotshk" } or { "idx", "shk" }
        for p, b in ipairs(list) do
            local cls
            if b.ev_rot or b.ev_shk then
                cls = (b.ev_rot and b.ev_shk) and "rotshk" or (b.ev_rot and "rot" or "shk")
            else
                cls = expected[p] or "shk"
            end
            if is_anim and p > 1 then cls = "shk" end   -- animation : seulement la premiere plage
            b.class = cls
        end
        -- une fonction rotative explicite avant tout bloc indexe : le premier bloc sans preuve reste indexe
        for _, b in ipairs(list) do
            local brot = (b.class == "rot" or b.class == "rotshk")
            local bshk = (b.class == "shk" or b.class == "rotshk")
            local rot, shk = brot, bshk
            local marker = (rot and "<" or "") .. fam.attr .. (rot and ">" or "") .. (shk and "*" or "")
            for _, st in ipairs(b.sets) do
                local sname = oname(st.cs)
                local irot, ishk = rot, shk
                if kind == "prism" then
                    -- les noms de sets font foi pour les prismes ("Prism indexing" / "Prism rotation", "8 facet prism<>")
                    local ln = sname:lower()
                    if ln:find("<", 1, true) or ln:find("rotat", 1, true) then irot = true
                    elseif ln:find("index", 1, true) then irot = false end
                    if ln:find("<", 1, true) or ln:find("shak", 1, true) or ln:find("*", 1, true) then
                        ishk = (ln:find("shak", 1, true) or ln:find("*", 1, true)) and true or false
                    end
                end
                -- repere dans le nom du channel set ("gobo 2 1<>", "gobo 1*")
                -- (le repere des noms de sets n'est pas utilise pour classer)
                local base = clean_label((sname:gsub("[<>%*]", "")))
                if base == "" then base = "Slot " .. st.slot end
                local m2 = (irot and "<" or "") .. fam.attr .. (irot and ">" or "") .. (ishk and "*" or "")
                local s2 = (irot and ishk) and " rot+shake" or (irot and " rot" or (ishk and " shake" or ""))
                seq = seq + 1
                local it = {
                    t = t, kind = kind, fam_i = fam_i, fam = fam, attr = b.lattr,
                    cf_i = b.ci, cs_i = st.si, cf_name = clean_label(oname(b.cf)),
                    base = base, name = base .. s2, marker = m2, rot = irot, shake = ishk,
                    slot = st.slot, from = st.from, to = st.to, block = b, set_name = sname,
                    wheel = b.wheel, wheel_name = oname(b.wheel),
                    main = not ishk, seq = seq, rot_default = rot_default, no_slot = st.noslot,
                    cmd_attr = (kind == "prism") and attr_of(b.cf) or nil,
                }
                it.key = table.concat({ t.type_name, t.mode_name, b.lattr, b.di, b.li, b.ci, st.si }, "|")
                -- doublon strict (meme roue, meme repere, meme slot, meme plage DMX) : on garde le premier
                local dk = table.concat({ kind, fam_i, m2, st.slot, st.from, st.to }, "|")
                if not dedupe[dk] then
                    dedupe[dk] = true
                    items[#items + 1] = it
                end
            end
        end
    end
    if kind == "prism" then
        -- 1) prismes et "open" portes par les autres fonctions du meme canal et de la meme roue
        --    (ex. EFFECTWHEEL : EFFECTWHEELSELECT contient "open" et "6 facet linear prism", Prism1 contient "8 facet prism")
        local function norm_base(n)
            return (n:lower():gsub("[<>%*]", ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", ""))
        end
        local have = {}
        local function cls_of(it) return (it.rot and it.shake) and "rotshk" or (it.rot and "rot" or (it.shake and "shk" or "idx")) end
        for _, it in ipairs(items) do have[it.fam_i .. "|" .. norm_base(it.base or "") .. "|" .. cls_of(it)] = true end
        local lc_done = {}
        for _, b in ipairs(blocks) do
            local bw = b.wheel and oname(b.wheel) or nil
            local dk = tostring(b.di) .. "/" .. tostring(b.li) .. "/" .. tostring(bw)
            if b.lc and bw and bw ~= "" and not lc_done[dk] then
                lc_done[dk] = true
                for ci2, ocf in ipairs(kids(b.lc)) do
                    if oname(rp(ocf, "Wheel")) == bw and not (ci2 == b.ci) then
                        local ocf_is_block = false
                        for _, b2 in ipairs(blocks) do if b2.lc == b.lc and b2.ci == ci2 then ocf_is_block = true end end
                        for si, cs in ipairs(kids(ocf)) do
                            local sname = oname(cs)
                            local ln = sname:lower()
                            if ln:find("prism", 1, true) or ln:find("open", 1, true) or ln:find("hole", 1, true) then
                                local rot = (ln:find("<", 1, true) or ln:find("rotat", 1, true)) and true or false
                                local shk = (ln:find("shak", 1, true) or ln:find("*", 1, true)) and true or false
                                local base = clean_label((sname:gsub("[<>%*]", "")))
                                if base == "" then base = "Open" end
                                local cls = (rot and shk) and "rotshk" or (rot and "rot" or (shk and "shk" or "idx"))
                                local hk = b.fam_i .. "|" .. norm_base(base) .. "|" .. cls
                                if not have[hk] then
                                    have[hk] = true
                                    local from = to_number(rp(cs, "DMXFrom")) or 0
                                    local slot = to_number(rp(cs, "WheelSlotIndex")) or 1
                                    if slot <= 0 then slot = 1 end
                                    seq = seq + 1
                                    local fam = b.fam
                                    local ob = { lc = b.lc, cf = ocf, sets = { { from = from, to = to_number(rp(cs, "DMXTo")) or from } }, ci = ci2, di = b.di, li = b.li }
                                    local m2 = (rot and "<" or "") .. fam.attr .. (rot and ">" or "") .. (shk and "*" or "")
                                    local s2 = (rot and shk) and " rot+shake" or (rot and " rot" or (shk and " shake" or ""))
                                    local it = {
                                        t = t, kind = kind, fam_i = b.fam_i, fam = fam, attr = b.lattr,
                                        cf_i = ci2, cs_i = si, cf_name = clean_label(oname(ocf)),
                                        base = base, name = base .. s2, marker = m2, rot = rot, shake = shk,
                                        slot = slot, from = from, to = to_number(rp(cs, "DMXTo")) or from, block = ob, set_name = sname,
                                        wheel = rp(ocf, "Wheel"), wheel_name = oname(rp(ocf, "Wheel")),
                                        main = not shk, seq = seq, rot_default = true,
                                    }
                                    it.key = table.concat({ t.type_name, t.mode_name, b.lattr, b.di, b.li, ci2, si }, "|")
                                    items[#items + 1] = it
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    do
        -- 2) version tournante : si la librairie ne la fournit pas mais que la rotation du prisme est un
        --    attribut separe (Prism1PosRotate), la version tournante = prisme + rotation
        local has_rot = {}
        for _, it in ipairs(items) do if it.rot then has_rot[it.fam_i] = true end end
        local extra = {}
        for _, it in ipairs(items) do
            local rc = rot_cfs[norm(it.fam.attr) .. "posrotate"]
            local ln = (it.base or ""):lower()
            if rc and not has_rot[it.fam_i] and not it.rot and not it.shake
                and not (ln:find("open", 1, true) or ln:find("hole", 1, true)) then
                local chosen, cands = nil, {}
                for _, cs in ipairs(kids(rc.cf)) do
                    local nm = oname(cs)
                    local low = nm:lower()
                    local from = to_number(rp(cs, "DMXFrom")) or 0
                    cands[#cands + 1] = { name = nm, from = from, to = to_number(rp(cs, "DMXTo")) or from,
                                          bad = (low:find("no ", 1, true) == 1 or low:find("stop", 1, true) or low:find("zero", 1, true)) and true or false }
                end
                for _, c in ipairs(cands) do if not chosen and c.name:sub(1, 1) == ">" then chosen = c end end
                if not chosen then
                    local good = {}
                    for _, c in ipairs(cands) do if not c.bad then good[#good + 1] = c end end
                    chosen = good[math.max(1, math.ceil(#good / 2))] or cands[#cands]
                end
                if chosen then
                    local cf_from = to_number(rp(rc.cf, "DMXFrom")) or (cands[1] and cands[1].from) or 0
                    local cf_to = to_number(rp(rc.cf, "DMXTo")) or (cands[#cands] and cands[#cands].to) or MAX_DMX24
                    if cf_to <= cf_from then cf_to = MAX_DMX24 end
                    local mid = (chosen.from + chosen.to) / 2
                    local uniq = 0
                    for _, c in ipairs(cands) do if c.name == chosen.name then uniq = uniq + 1 end end
                    local c2 = {}
                    for k, v in pairs(it) do c2[k] = v end
                    seq = seq + 1
                    c2.seq = seq
                    c2.rot = true
                    c2.marker = "<" .. it.fam.attr .. ">"
                    c2.name = it.base .. " rot"
                    c2.key = it.key .. "|rot"
                    c2.rot_extra = {
                        attr = rc.attr, lc_attr = rc.lc_attr, set_name = (uniq == 1 and chosen.name ~= "") and chosen.name or nil,
                        rel = math.max(0, math.min(100, (mid - cf_from) / (cf_to - cf_from) * 100)),
                    }
                    extra[#extra + 1] = c2
                end
            end
        end
        for _, e in ipairs(extra) do items[#items + 1] = e end
    end
    if kind == "gobo" then
        -- les sets de prismes (roue d'effets partagee) ne sont pas des gobos
        local kept = {}
        for _, it in ipairs(items) do
            local ln = (it.set_name or it.name or ""):lower()
            if not ln:find("prism", 1, true) then kept[#kept + 1] = it end
        end
        items = kept
    end
    -- tri : par roue, puis dans l'ordre DMX (valeur de depart), puis slot
    table.sort(items, function(a, b)
        if a.fam_i ~= b.fam_i then return a.fam_i < b.fam_i end
        if a.from ~= b.from then return a.from < b.from end
        if a.slot ~= b.slot then return a.slot < b.slot end
        return a.seq < b.seq
    end)
    return items
end

-- ---------------------------------------------------------------------------
-- Fenetres personnalisees (meme charte que GroupsFromPatch : barre YannLight,
-- cases a cocher, boutons en haut ET en bas, coche / decoche immediats)
-- ---------------------------------------------------------------------------
local function ui_color(group, name)
    local ok, c = pcall(function() return Root().ColorTheme.ColorGroups[group][name] end)
    if ok then return c end
    return nil
end

local function ui_add(parent, class, props)
    local o = parent:Append(class)
    for k, v in pairs(props or {}) do o[k] = v end
    return o
end

local function ui_valid(o)
    local ok, v = pcall(IsObjectValid, o)
    if not ok then return true end
    return v and true or false
end

local function ui_close(overlay, base)
    pcall(function()
        if ui_valid(base) then Obj.Delete(overlay, Obj.Index(base)) end
    end)
end

local function ui_titlebar(base, title, cancel_signal, width)
    local bar = ui_add(base, "TitleBar", { Columns = 3, Rows = 1, Anchors = "0,0", Texture = "corner2" })
    bar[2][1].SizePolicy = "Fixed"
    bar[2][1].Size = "200"
    bar[2][3].SizePolicy = "Fixed"
    bar[2][3].Size = "60"
    ui_add(bar, "TitleButton", { Text = UI_BRAND, Texture = "corner1", Anchors = "0,0", Font = "Medium20" })
    ui_add(bar, "TitleButton", { Text = tostring(title or ""), Anchors = "1,0", Font = "Medium20" })
    ui_add(bar, "Button", {
        Text = "X", Anchors = "2,0", Texture = "corner2", Font = "Medium20",
        PluginComponent = UI_HANDLE, Clicked = cancel_signal,
    })
    return bar
end

local function ui_limits(base, W, H, dw, dh)
    pcall(function()
        base.MinSize = string.format("%d,%d", math.floor(W * 0.6), math.floor(H * 0.6))
        base.MaxSize = string.format("%d,%d", math.floor(dw * 0.96), math.floor(dh * 0.96))
    end)
end

local function ui_resize_corner(base)
    pcall(function()
        local rc = base:Append("ResizeCorner")
        rc.Anchors = "0,1"
        rc.AlignmentH = "Right"
        rc.AlignmentV = "Bottom"
    end)
end

-- Liste a cocher / a choix unique.
-- p : title, help, items {{key, text, header}}, checked (cle -> bool), single (bool),
--     buttons {{texte, code, "needs"}}
-- renvoie { result = code, states = cle -> bool }
local function ui_list_dialog(p)
    if type(UI_SIGNALS) ~= "table" or UI_HANDLE == nil then error("objets UI indisponibles") end
    if type(coroutine) ~= "table" or type(coroutine.yield) ~= "function" then error("attente impossible") end
    local display = GetFocusDisplay()
    local overlay = display.ScreenOverlay
    local dw = tonumber(display.W) or 1600
    local dh = tonumber(display.H) or 900

    local tabs = p.tabs
    local items = tabs and tabs[1].items or p.items
    local n = 0
    if tabs then
        for _, tb in ipairs(tabs) do n = math.max(n, #tb.items) end
    else
        n = #items
    end
    local TAB_H = tabs and 64 or 0
    local has_opts = false
    if tabs then
        for _, tb in ipairs(tabs) do if tb.opts and #tb.opts > 0 then has_opts = true end end
    end
    local OPT_H = has_opts and 64 or 0
    local max_opts = 0
    if has_opts then
        for _, tb in ipairs(tabs) do max_opts = math.max(max_opts, #(tb.opts or {})) end
    end
    local TITLE_H, HELP_H, HEAD_H, BTN_H, ROW_H = 60, 70, 92, 86, 56
    local all_wheels = (p.all_wheels and tabs) and true or false
    if all_wheels then HEAD_H = 142 end
    local fixed = TITLE_H + HELP_H + HEAD_H + TAB_H + OPT_H + BTN_H
    local max_rows = math.max(3, math.floor((dh * 0.92 - fixed) / ROW_H))
    local cols = (n <= 6) and 1 or 2
    local rows = math.max(1, math.min(math.ceil(n / cols), max_rows))
    local per_page = rows * cols
    local pages = math.max(1, math.ceil(n / per_page))
    local W = math.floor(math.min((cols == 1 and not tabs) and 800 or 1200, dw * 0.94))
    local H = fixed + rows * ROW_H

    local st = { result = nil, page = 1, tab = 1, checked = {}, opts = {} }
    if tabs then
        for i, tb in ipairs(tabs) do
            st.opts[i] = {}
            for _, o in ipairs(tb.opts or {}) do st.opts[i][o.key] = o.on and true or false end
        end
    end
    for k, v in pairs(p.checked or {}) do st.checked[k] = v and true or false end
    local transparent = ui_color("Global", "Transparent")

    local base = overlay:Append("BaseInput")
    local built, err = pcall(function()
        base.Name = "GBR_Choix"
        base.W = tostring(W)
        base.H = tostring(H)
        base.Columns = 1
        base.Rows = 2
        base[1][1].SizePolicy = "Fixed"
        base[1][1].Size = tostring(TITLE_H)
        base[1][2].SizePolicy = "Stretch"
        base.AutoClose = "No"
        base.CloseOnEscape = "No"
        ui_limits(base, W, H, dw, dh)

        ui_titlebar(base, p.title, "GBR_PkCancel", W)

        local frame = ui_add(base, "DialogFrame", {
            H = "100%", W = "100%", Columns = 1, Rows = tabs and (has_opts and 7 or 6) or 5,
            Anchors = { left = 0, right = 0, top = 1, bottom = 1 },
        })
        local ROW_LIST = tabs and (has_opts and 5 or 4) or 3
        local ROW_BTN2 = ROW_LIST + 1
        local heights = { HELP_H, 0, HEAD_H }   -- rangee 1 : vide (boutons en bas)
        if tabs then heights[#heights + 1] = TAB_H end
        if has_opts then heights[#heights + 1] = OPT_H end
        heights[#heights + 1] = rows * ROW_H
        heights[#heights + 1] = BTN_H
        for i, s in ipairs(heights) do
            if i == ROW_LIST + 1 then
                frame[1][i].SizePolicy = "Stretch"
                frame[1][i].Size = 1
            else
                frame[1][i].SizePolicy = "Fixed"
                frame[1][i].Size = tostring(s)
            end
        end

        local function label(parent, text, l, r, t, align)
            return ui_add(parent, "UIObject", {
                Text = text, TextalignmentH = align or "Left", Font = "Medium20",
                Anchors = { left = l, right = r, top = t or 0, bottom = t or 0 },
                Padding = { left = 16, right = 16, top = 0, bottom = 0 },
                HasHover = "No", BackColor = transparent,
            })
        end

        local help = ui_add(frame, "UIObject", {
            Text = p.help or "", Font = "Medium20", TextalignmentH = "Centre",
            Anchors = { left = 0, right = 0, top = 0, bottom = 0 },
            Padding = { left = 24, right = 24, top = 8, bottom = 8 },
            HasHover = "No", BackColor = transparent,
        })

        local g3 = ui_add(frame, "UILayoutGrid", {
            Columns = 16, Rows = all_wheels and 2 or 1, Anchors = { left = 0, right = 0, top = 2, bottom = 2 },
            Margin = { left = 12, right = 12, top = 38, bottom = 6 },
        })
        local count_lbl = label(g3, "", 0, 5)
        local page_lbl
        if pages > 1 then
            ui_add(g3, "Button", {
                Text = "<", Font = "Medium20", Anchors = { left = 6, right = 6, top = 0, bottom = 0 },
                PluginComponent = UI_HANDLE, Clicked = "GBR_PkPrev",
            })
            page_lbl = label(g3, "", 7, 8, 0, "Centre")
            ui_add(g3, "Button", {
                Text = ">", Font = "Medium20", Anchors = { left = 9, right = 9, top = 0, bottom = 0 },
                PluginComponent = UI_HANDLE, Clicked = "GBR_PkNext",
            })
        end
        if not p.single then
            ui_add(g3, "Button", {
                Text = "Tout cocher", Font = "Medium20", Anchors = { left = 10, right = 12, top = 0, bottom = 0 },
                Margin = { left = 2, right = 2, top = 0, bottom = 0 },
                PluginComponent = UI_HANDLE, Clicked = "GBR_PkAll",
            })
            ui_add(g3, "Button", {
                Text = "Tout decocher", Font = "Medium20", Anchors = { left = 13, right = 15, top = 0, bottom = 0 },
                Margin = { left = 2, right = 2, top = 0, bottom = 0 },
                PluginComponent = UI_HANDLE, Clicked = "GBR_PkNone",
            })
            if all_wheels then
                ui_add(g3, "Button", {
                    Text = "Cocher toutes les roues", Font = "Medium20", Anchors = { left = 7, right = 11, top = 1, bottom = 1 },
                    Margin = { left = 2, right = 2, top = 2, bottom = 0 },
                    PluginComponent = UI_HANDLE, Clicked = "GBR_PkAllW",
                })
                ui_add(g3, "Button", {
                    Text = "Decocher toutes les roues", Font = "Medium20", Anchors = { left = 12, right = 15, top = 1, bottom = 1 },
                    Margin = { left = 2, right = 2, top = 2, bottom = 0 },
                    PluginComponent = UI_HANDLE, Clicked = "GBR_PkNoneW",
                })
            end
        end

        local tab_btns = {}
        if tabs then
            local gt = ui_add(frame, "UILayoutGrid", {
                Columns = #tabs, Rows = 1, Anchors = { left = 0, right = 0, top = 3, bottom = 3 },
                Margin = { left = 12, right = 12, top = 8, bottom = 8 },
            })
            for i, tb in ipairs(tabs) do
                tab_btns[i] = ui_add(gt, "Button", {
                    Name = "gbr_tab_" .. i, Text = tb.label, Font = "Medium20", TextalignmentH = "Centre",
                    Anchors = { left = i - 1, right = i - 1, top = 0, bottom = 0 },
                    Margin = { left = 3, right = 3, top = 0, bottom = 0 },
                    PluginComponent = UI_HANDLE, Clicked = "GBR_PkTab",
                })
            end
        end

        local opt_btns = {}
        if has_opts then
            local go = ui_add(frame, "UILayoutGrid", {
                Columns = max_opts, Rows = 1, Anchors = { left = 0, right = 0, top = 4, bottom = 4 },
                Margin = { left = 12, right = 12, top = 0, bottom = 8 },
            })
            for j = 1, max_opts do
                opt_btns[j] = ui_add(go, "Button", {
                    Name = "gbr_opt_" .. j, Text = "", Font = "Medium20", TextalignmentH = "Centre",
                    Anchors = { left = j - 1, right = j - 1, top = 0, bottom = 0 },
                    Margin = { left = 3, right = 3, top = 0, bottom = 0 },
                    PluginComponent = UI_HANDLE, Clicked = "GBR_PkOpt",
                })
            end
        end

        local g4 = ui_add(frame, "UILayoutGrid", {
            Columns = cols, Rows = rows, Anchors = { left = 0, right = 0, top = ROW_LIST, bottom = ROW_LIST },
            Margin = { left = 12, right = 12, top = 0, bottom = 0 },
        })
        local slots = {}
        for i = 1, per_page do
            local c = math.floor((i - 1) / rows)
            local r = (i - 1) % rows
            slots[i] = ui_add(g4, "CheckBox", {
                Name = "gbr_pick_" .. i, Text = "", Font = "Medium20", TextalignmentH = "Left",
                Anchors = { left = c, right = c, top = r, bottom = r },
                Margin = { left = 3, right = 3, top = 3, bottom = 3 },
                Padding = { left = 10, right = 6, top = 0, bottom = 0 },
                State = 0, PluginComponent = UI_HANDLE, Clicked = "GBR_PkToggle",
            })
        end

        for _, row in ipairs({ ROW_BTN2 }) do
            local g5 = ui_add(frame, "UILayoutGrid", {
                Columns = #p.buttons, Rows = 1, Anchors = { left = 0, right = 0, top = row, bottom = row },
                Margin = { left = 12, right = 12, top = 14, bottom = 10 },
            })
            for i, b in ipairs(p.buttons) do
                ui_add(g5, "Button", {
                    Name = "gbr_pkbtn_" .. i, Text = b[1], Font = "Medium20", TextalignmentH = "Centre",
                    Anchors = { left = i - 1, right = i - 1, top = 0, bottom = 0 },
                    Margin = { left = 4, right = 4, top = 0, bottom = 0 },
                    PluginComponent = UI_HANDLE, Clicked = "GBR_PkBtn",
                })
            end
        end

        local function cur_items() return tabs and tabs[st.tab].items or p.items end
        local function cur_pages() return math.max(1, math.ceil(#cur_items() / per_page)) end
        -- repartition equilibree sur les colonnes : chaque colonne garde au moins une case visible
        -- (une colonne entierement masquee fait se recalculer la fenetre)
        local function layout_for_page()
            local list = cur_items()
            local base = (st.page - 1) * per_page
            local m = math.max(0, math.min(per_page, #list - base))
            local ru = (cols == 2) and math.min(rows, math.max(1, math.ceil(m / 2))) or math.min(rows, m)
            return list, base, m, ru
        end
        local function slot_pos(i)
            local _, _, m, ru = layout_for_page()
            local c = math.floor((i - 1) / rows)
            local r = (i - 1) % rows
            if r >= ru then return nil, c, r end
            local pos = c * ru + r + 1
            if pos > m then return nil, c, r end
            return pos, c, r
        end
        local function slot_item(i)
            local list, base = layout_for_page()
            local pos = slot_pos(i)
            return pos and list[base + pos] or nil
        end
        local function paint()
            if st.page > cur_pages() then st.page = 1 end
            for i, cb in ipairs(slots) do
                local it = slot_item(i)
                local _, c, r = slot_pos(i)
                if it then
                    cb.Text = it.header and ("--  " .. it.text) or it.text
                    cb.State = (not it.header and st.checked[it.key]) and 1 or 0
                    cb.Enabled = it.header and "No" or "Yes"
                    pcall(function() cb.Visible = "Yes" end)
                else
                    cb.Text = ""
                    cb.State = 0
                    cb.Enabled = "No"
                    -- case sans valeur : masquee, sauf la 1re de chaque colonne (evite le recalcul de la fenetre)
                    local keep = (r == 0)
                    pcall(function() cb.Visible = keep and "Yes" or "No" end)
                end
            end
            for i, b in ipairs(tab_btns) do
                b.Text = (i == st.tab) and ("[ " .. tabs[i].label .. " ]") or tabs[i].label
            end
            for j, b in ipairs(opt_btns) do
                local o = tabs[st.tab].opts and tabs[st.tab].opts[j]
                if o then
                    b.Text = ((st.opts[st.tab][o.key]) and "[x]  " or "[  ]  ") .. o.label
                    b.Enabled = "Yes"
                    pcall(function() b.Visible = "Yes" end)
                else
                    b.Text = ""
                    b.Enabled = "No"
                    pcall(function() b.Visible = (j == 1) and "Yes" or "No" end)
                end
            end
            local nchk = 0
            for _, v in pairs(st.checked) do if v then nchk = nchk + 1 end end
            count_lbl.Text = string.format("%s : %d coche(s)", p.count_label or "Elements", nchk)
            if page_lbl then page_lbl.Text = string.format("%d / %d", st.page, cur_pages()) end
        end
        local function index_of(caller) return tonumber(tostring(caller.Name or ""):match("(%d+)$")) end

        UI_SIGNALS.GBR_PkToggle = function(caller)
            local it = slot_item(index_of(caller) or 0)
            if it and not it.header then
                if p.single then
                    st.checked = {}
                    st.checked[it.key] = true
                    paint()
                else
                    st.checked[it.key] = not st.checked[it.key]
                    caller.State = st.checked[it.key] and 1 or 0
                end
            end
        end
        UI_SIGNALS.GBR_PkAll = function()
            for _, it in ipairs(cur_items()) do if not it.header then st.checked[it.key] = true end end
            paint()
        end
        UI_SIGNALS.GBR_PkNone = function()
            if tabs then
                for _, it in ipairs(cur_items()) do st.checked[it.key] = nil end
            else
                st.checked = {}
            end
            paint()
        end
        UI_SIGNALS.GBR_PkAllW = function()
            for _, tb in ipairs(tabs or {}) do
                for _, it in ipairs(tb.items) do if not it.header then st.checked[it.key] = true end end
            end
            paint()
        end
        UI_SIGNALS.GBR_PkNoneW = function()
            st.checked = {}
            paint()
        end
        UI_SIGNALS.GBR_PkPrev = function()
            local np = cur_pages()
            st.page = (st.page > 1) and (st.page - 1) or np
            paint()
        end
        UI_SIGNALS.GBR_PkNext = function()
            local np = cur_pages()
            st.page = (st.page < np) and (st.page + 1) or 1
            paint()
        end
        UI_SIGNALS.GBR_PkOpt = function(caller)
            local j = tonumber(tostring(caller.Name or ""):match("(%d+)$"))
            local o = j and tabs[st.tab].opts and tabs[st.tab].opts[j]
            if o then
                st.opts[st.tab][o.key] = not st.opts[st.tab][o.key]
                paint()
            end
        end
        UI_SIGNALS.GBR_PkTab = function(caller)
            local i = tonumber(tostring(caller.Name or ""):match("(%d+)$"))
            if i and tabs[i] then
                st.tab = i
                st.page = 1
                paint()
            end
        end
        UI_SIGNALS.GBR_PkBtn = function(caller)
            local b = p.buttons[index_of(caller) or 0]
            if b then
                if b[2] ~= 0 and b[3] == "needs" then
                    local any = false
                    for _, v in pairs(st.checked) do any = any or v end
                    if not any then
                        help.Text = p.empty_text or "Rien de coche."
                        return
                    end
                end
                st.result = b[2]
            end
        end
        UI_SIGNALS.GBR_PkCancel = function() st.result = 0 end
        paint()
        ui_resize_corner(base)
    end)

    if not built then
        ui_close(overlay, base)
        error(err, 0)
    end
    while st.result == nil do
        coroutine.yield(0.05)
        if not ui_valid(base) then st.result = 0 end
    end
    ui_close(overlay, base)
    pcall(coroutine.yield, 0.3)
    local states = {}
    local function collect(list)
        for _, it in ipairs(list) do
            if not it.header then states[it.key] = st.checked[it.key] and true or false end
        end
    end
    if tabs then
        for _, tb in ipairs(tabs) do collect(tb.items) end
    else
        collect(items)
    end
    return { result = st.result, states = states, opts = st.opts }
end

-- ---------------------------------------------------------------------------
-- Preset : valeur du channel set appliquee a UN projecteur du type, stockee en /Global
-- (un projecteur par fixture type suffit : le preset vaut pour tous les projecteurs du type)
-- ---------------------------------------------------------------------------
local function preset_object(pool, no)
    for _, p in ipairs(preset_pool_children(pool)) do
        if tonumber(rp(p, "No")) == no then return p end
    end
    return nil
end

local function object_empty(obj)
    local ok, empty = pcall(function() return obj:IsEmpty() end)
    if ok and empty ~= nil then return empty and true or false end
    return false
end

local function value_percent(item)
    local mid = (item.from + item.to) / 2
    return math.max(0, math.min(100, mid / MAX_DMX24 * 100))
end

-- nombre de channel sets portant le meme nom dans le canal logique (un nom ambigu ne sert pas a viser)
local function set_name_count(item)
    local n = 0
    local lc = item.block and item.block.lc
    local ok = pcall(function()
        for _, cf in ipairs(kids(lc)) do
            for _, cs in ipairs(kids(cf)) do
                if oname(cs) == item.set_name then n = n + 1 end
            end
        end
    end)
    if not ok then return 2 end
    return n
end

-- plage DMX (24 bits) de la fonction de canal qui porte le set
local function cf_range(item)
    local b = item.block
    local from = to_number(rp(b.cf, "DMXFrom"))
    local to = to_number(rp(b.cf, "DMXTo"))
    local lo, hi = math.huge, -math.huge
    for _, st in ipairs(b.sets) do
        lo = math.min(lo, st.from or lo); hi = math.max(hi, st.to or st.from or hi)
    end
    if not from then from = lo end
    if not to or to <= from then to = hi end
    return from, to
end

-- variantes d'ecriture de la valeur dans le programmer (la premiere qui produit un preset non vide gagne) :
-- 1) le channel set appele par son nom (comme dans la fenetre Channel Sets de la console)
-- 2) pourcentage de la plage de la fonction de canal 3) pourcentage du canal entier 4) Decimal8
-- attributs reellement presents sur le projecteur (canaux UI du premier projecteur du type)
local function load_real_attrs(t)
    if t.real_attrs then return t.real_attrs end
    local names, seen = {}, {}
    t.real_attrs = names
    if not t.first_sub then return names end
    local ok, chans = pcall(GetUIChannels, t.first_sub)
    if ok and type(chans) == "table" then
        for _, ui in ipairs(chans) do
            local ok2, a = pcall(GetAttributeByUIChannel, ui)
            if ok2 and a then
                local n = oname(a)
                if n ~= "" and not seen[n] then seen[n] = true; names[#names + 1] = n end
            end
        end
    end
    return names
end

-- noms a essayer : l'orthographe reelle de la console d'abord, puis les noms de la librairie
local function attr_candidates(t, a1, a2)
    local list, seen = {}, {}
    local function push(a)
        if a and a ~= "" and not seen[a] then seen[a] = true; list[#list + 1] = a end
    end
    local real = load_real_attrs(t)
    local cands = {}
    if a1 and a1 ~= "" then cands[#cands + 1] = a1 end
    if a2 and a2 ~= "" then cands[#cands + 1] = a2 end
    local exact = 0
    for _, cand in ipairs(cands) do
        local nc = norm(cand)
        for _, n in ipairs(real) do if norm(n) == nc then push(n); exact = exact + 1 end end
    end
    for _, cand in ipairs(cands) do push(cand) end
    if exact == 0 then
        for _, cand in ipairs(cands) do
            local nc = norm(cand)
            for _, n in ipairs(real) do
                local nn = norm(n)
                if nn ~= nc and (nn:find(nc, 1, true) or nc:find(nn, 1, true)) and #nn >= 5 then push(n) end
            end
        end
    end
    return list
end

-- chaque variante = { label, cmds = { commandes } } ; essayees dans l'ordre jusqu'a un preset non vide
local function value_commands(item)
    local pct = value_percent(item)
    local dec8 = math.floor((item.from + item.to) / 2 * 255 / MAX_DMX24 + 0.5)
    local uniq = item.set_name and item.set_name ~= "" and set_name_count(item) == 1
    local cfrom, cto = cf_range(item)
    local rel = nil
    if cto > cfrom then
        rel = math.max(0, math.min(100, ((item.from + item.to) / 2 - cfrom) / (cto - cfrom) * 100))
    end
    local list = {}
    local function add(label, ...) list[#list + 1] = { label = label, cmds = { ... } } end
    -- le channel set appele par son nom, avec l'attribut du canal logique ou de la fonction
    for _, a in ipairs(attr_candidates(item.t, item.cmd_attr, item.attr)) do
        if uniq then
            add("ChannelSet/" .. a, string.format('Attribute "%s" At ChannelSet "%s"', a, item.set_name))
            add("Attribute+ChannelSet/" .. a, string.format('Attribute "%s"', a), string.format('At ChannelSet "%s"', item.set_name))
        end
    end
    if uniq then add("ChannelSet nu", string.format('At ChannelSet "%s"', item.set_name)) end
    for _, a in ipairs(attr_candidates(item.t, item.cmd_attr, item.attr)) do
        if rel then add("% fonction/" .. a, string.format('Attribute "%s" At %.4f', a, rel)) end
        add("% canal/" .. a, string.format('Attribute "%s" At %.4f', a, pct))
        add("Decimal8/" .. a, string.format('Fixture %%d At Absolute Decimal8 %d Attribute "%s"', dec8, a))
    end
    return list
end

local function cmd_ok(result)
    if result == nil then return true end
    return tostring(result):lower():find("^ok") ~= nil
end

-- rotation d'un prisme (attribut separe) : on essaie l'attribut de la fonction puis celui du canal
local function apply_rotation(t, re)
    local tried = {}
    for _, a in ipairs(attr_candidates(t, re.attr, re.lc_attr)) do
        if re.set_name then
            local c = string.format('Attribute "%s" At ChannelSet "%s"', a, re.set_name)
            tried[#tried + 1] = c
            if cmd_ok(Cmd(c)) then return true end
        end
        local c = string.format('Attribute "%s" At %.4f', a, re.rel)
        tried[#tried + 1] = c
        if cmd_ok(Cmd(c)) then return true end
    end
    return false, tried[#tried]
end

local function store_preset(item, pool, no, stats, overwrite)
    local fid = item.t.first_fid
    if not fid then return false, "aucun projecteur lu dans le groupe" end
    local last_fail = nil
    for vi, var in ipairs(value_commands(item)) do
        Cmd("ClearAll")
        Cmd("Fixture " .. fid)
        pause(0.05)
        local all_ok = true
        for _, c in ipairs(var.cmds) do
            local r = Cmd((c:gsub("%%d", tostring(fid))))
            if not cmd_ok(r) then
                all_ok = false
                last_fail = string.format("%s -> %s", c, tostring(r))
                break
            end
        end
        if all_ok and item.rot_extra then
            local okr, why = apply_rotation(item.t, item.rot_extra)
            if not okr then all_ok = false; last_fail = "rotation : " .. tostring(why) end
        end
        if all_ok then
            pause(0.05)
            local opts = { "/Global /NoConfirmation", "/NoConfirmation" }
            if overwrite then opts = { "/Overwrite /Global /NoConfirmation", "/Overwrite /NoConfirmation" } end
            for _, o in ipairs(opts) do
                Cmd(string.format("Store Preset %d.%d %s", pool, no, o))
                pause(0.05)
                local obj = preset_object(pool, no)
                if obj and not object_empty(obj) then
                    Cmd("ClearAll")
                    if vi > 1 then stats.fallback_value = (stats.fallback_value or 0) + 1 end
                    stats.forms = stats.forms or {}
                    stats.forms[var.label] = (stats.forms[var.label] or 0) + 1
                    stats.last_form = var.label
                    return true
                end
                if obj and not overwrite then
                    -- cree mais vide : on le retire pour reessayer proprement (c'est NOTRE preset, tout juste cree)
                    Cmd(string.format("Delete Preset %d.%d /NoConfirmation", pool, no))
                    pause(0.05)
                end
            end
            last_fail = var.label .. " : programmer vide apres la commande"
        end
    end
    Cmd("ClearAll")
    return false, "valeur non ecrite dans le programmer (" .. tostring(last_fail) .. ")"
end

-- ---------------------------------------------------------------------------
-- Apparences : image du slot (blanc) et meme image teintee en vert (cue active)
-- ---------------------------------------------------------------------------
local function get_appearance(no)
    for _, a in ipairs(appearances_list()) do
        if tonumber(rp(a, "No")) == no then return a end
    end
    return nil
end

local function same_value(a, b)
    return tostring(a) == tostring(b)
end

local function set_prop(obj, no, class, name, value)
    local okset = pcall(function() obj[name] = value end)
    local back = rp(obj, name)
    if okset and back ~= nil and same_value(back, value) then return true end
    pcall(function() obj:Set(name, tostring(value)) end)
    back = rp(obj, name)
    if back ~= nil and tostring(back) == tostring(value) then return true end
    if type(value) ~= "userdata" then
        Cmd(string.format('Set %s %d Property "%s" "%s"', class, no, name, tostring(value)))
        back = rp(obj, name)
        if back ~= nil and tostring(back) == tostring(value) then return true end
    end
    return false
end

-- cherche l'image du slot dans le pool d'images Gobos (au cas ou le slot ne la porte pas)
local function find_pool_image(slot, wheel_name)
    local wanted = {}
    for _, key in ipairs({ "MediaFileName", "Media", "Image", "FileName", "Name" }) do
        local v = rp(slot, key)
        if v ~= nil and type(v) ~= "userdata" then wanted[#wanted + 1] = norm(v) end
    end
    if #wanted == 0 then return nil end
    local found = nil
    pcall(function()
        local pools = child_named(ShowData(), { "MediaPools" })
        local gobos = child_named(pools, { "Gobos" })
        for _, img in ipairs(kids(gobos)) do
            local n = norm(oname(img))
            for _, w in ipairs(wanted) do
                if w ~= "" and (n == w or n:find(w, 1, true)) then found = img; return end
            end
        end
    end)
    return found
end

local CLASS_ORDER = { "idx", "rot", "shk", "rotshk" }
local CLASS_LABEL = { idx = "Indexes", rot = "Rotatifs", shk = "Shakes", rotshk = "Shakes rotatifs" }
local CLASS_RANK = { idx = 1, rot = 2, shk = 3, rotshk = 4 }
-- fond discret des tuiles : l'indexe reste nu, le rotatif est bleu-vert, le shake ambre, les deux violet
local CLASS_BACK = { idx = { 20, 22, 28 }, rot = { 24, 84, 104 }, shk = { 104, 72, 24 }, rotshk = { 96, 40, 88 } }
-- prismes : icones noires sur fond transparent -> fond clair pour qu'elles restent lisibles
local CLASS_BACK_PRISM = { rot = { 150, 205, 235 }, shk = { 235, 195, 140 }, rotshk = { 215, 170, 225 } }  -- indexe : transparent
local PRISM_BACK_ON = { 110, 215, 110 }
local function back_for(item, cls, green)
    if item and item.kind == "prism" then
        -- indexe : transparent pour "open" (disque blanc) ; gris clair pour les autres (icones parfois
        -- dessinees en noir sans remplissage : invisibles et peu cliquables sur fond transparent)
        if cls == "idx" then
            local ln = (item.base or ""):lower()
            if ln:find("open", 1, true) or ln:find("hole", 1, true) then return nil end
            if green then return PRISM_BACK_ON end
            return { 205, 208, 215 }
        end
        if green and CLASS_BACK_PRISM[cls] then return PRISM_BACK_ON end   -- ON : fond vert (icone noire sans remplissage)
        return CLASS_BACK_PRISM[cls]
    end
    return CLASS_BACK[cls]
end

local function class_of(it)
    if it.rot and it.shake then return "rotshk" end
    if it.rot then return "rot" end
    if it.shake then return "shk" end
    return "idx"
end

-- repere grandMA pour les libelles : Gobo 2 / <Gobo 2> / Gobo 2 * / <Gobo 2> *
local function class_notation(label, cls)
    if cls == "rot" then return "<" .. label .. ">" end
    if cls == "shk" then return label .. " *" end
    if cls == "rotshk" then return "<" .. label .. "> *" end
    return label
end

local APP_IMAGE_PROPS = { "Appearance", "ImageR", "ImageG", "ImageB", "ImageAlpha" }

local function make_appearance(no, name, item, slot, green, warn, cls)
    Cmd(string.format("Store Appearance %d", no))
    pause(0.05)
    Cmd(string.format('Label Appearance %d "%s"', no, name))
    local obj = get_appearance(no)
    if not obj then
        warn("apparence " .. no .. " non creee")
        return false
    end
    local has_image = false
    if slot then
        for _, prop in ipairs(APP_IMAGE_PROPS) do
            local v = rp(slot, prop)
            if v ~= nil then
                if prop == "Appearance" then
                    has_image = set_prop(obj, no, "Appearance", prop, v) or has_image
                else
                    set_prop(obj, no, "Appearance", prop, v)
                end
            end
        end
        if not has_image then
            local img = find_pool_image(slot, item.wheel_name)
            if img then
                has_image = set_prop(obj, no, "Appearance", "Appearance", img)
            end
        end
    end
    if not has_image then
        -- pas d'image (ex. Open) : case pleine, blanche ou verte
        set_prop(obj, no, "Appearance", "BackR", green and 0 or 255)
        set_prop(obj, no, "Appearance", "BackG", 255)
        set_prop(obj, no, "Appearance", "BackB", green and 0 or 255)
        set_prop(obj, no, "Appearance", "BackAlpha", 255)
        local lname = item.name:lower()
        if slot and not (lname:find("open", 1, true) or lname:find("hole", 1, true)) then
            warn(string.format("%s : pas d'image dans le slot", item.name))
        end
    end
    if has_image and cls and item.kind == "prism" then
        -- prismes (comme les gobos) : indexe = fond transparent, rotatif = bleu clair, shake = orange clair ;
        -- l'icone est blanche, verte quand le prisme est actif
        local bc = back_for(item, cls, green)
        if bc then
            set_prop(obj, no, "Appearance", "BackR", bc[1])
            set_prop(obj, no, "Appearance", "BackG", bc[2])
            set_prop(obj, no, "Appearance", "BackB", bc[3])
            set_prop(obj, no, "Appearance", "BackAlpha", 255)
        else
            set_prop(obj, no, "Appearance", "BackAlpha", 0)
        end
        set_prop(obj, no, "Appearance", "ImageAlpha", 255)
    elseif has_image and cls and CLASS_BACK[cls] then
        local bc = back_for(item, cls, green)
        set_prop(obj, no, "Appearance", "BackR", bc[1])
        set_prop(obj, no, "Appearance", "BackG", bc[2])
        set_prop(obj, no, "Appearance", "BackB", bc[3])
        set_prop(obj, no, "Appearance", "BackAlpha", 255)
        -- l'image elle-meme reste opaque a 100 % : meme rendu quelle que soit l'image source
        set_prop(obj, no, "Appearance", "ImageAlpha", 255)
    end
    if green then
        -- teinte verte : rouge et bleu a 0 (le vert reste au maximum du slot)
        set_prop(obj, no, "Appearance", "ImageR", 0)
        set_prop(obj, no, "Appearance", "ImageB", 0)
    end
    Cmd(string.format('Set Appearance %d Property "Note" "%s"', no, safe(TAG .. "|A|" .. name)))
    return true
end

-- ---------------------------------------------------------------------------
-- Sequence recipe : une cue, une ligne de recipe (groupe + preset), apparences, reglages
-- ---------------------------------------------------------------------------
local function get_sequence(no)
    for _, s in ipairs(sequences_list()) do
        if tonumber(rp(s, "No")) == no then return s end
    end
    return nil
end

-- reglage de sequence par nom exact ou approchant ; verifie en relisant
local function set_sequence_prop(no, candidates, contains, value)
    local seq = get_sequence(no)
    if not seq then return false end
    local name = find_prop(seq, candidates, contains) or candidates[1]
    Cmd(string.format('Set Sequence %d Property "%s" "%s"', no, name, tostring(value)))
    local back = rp(seq, name)
    if back == nil then return false end
    local b, v = tostring(back):lower(), tostring(value):lower()
    if b == v then return true end
    if v == "1" or v == "yes" then return b == "1" or b == "yes" or b == "true" end
    return b:find(v, 1, true) ~= nil
end

local function make_sequence(no, seq_name, group_no, pool, preset_no, white_no, green_no, cue_name, note, warn, extras)
    Cmd(string.format("Store Sequence %d", no))
    pause(0.1)
    Cmd(string.format('Label Sequence %d "%s"', no, seq_name))
    Cmd(string.format("Store Sequence %d Cue 1 /NoConfirmation", no))
    pause(0.1)
    Cmd(string.format('Label Sequence %d Cue 1 "%s"', no, cue_name))

    -- ligne de recipe : groupe + preset (partie 0, ligne 1)
    Cmd(string.format("Assign Group %d At Sequence %d Cue 1 Part 0.1", group_no, no))
    Cmd(string.format("Assign Preset %d.%d At Sequence %d Cue 1 Part 0.1", pool, preset_no, no))
    pause(0.1)
    -- lignes de recipe supplementaires (un meme bouton qui agit sur plusieurs presets)
    for i, e in ipairs(extras or {}) do
        Cmd(string.format("Assign Group %d At Sequence %d Cue 1 Part 0.%d", group_no, no, i + 1))
        Cmd(string.format("Assign Preset %d.%d At Sequence %d Cue 1 Part 0.%d", e[1], e[2], no, i + 1))
    end

    -- controle : le preset doit maintenant etre reference par la cue
    local referenced = false
    local pobj = preset_object(pool, preset_no)
    if pobj then
        local ok, has = pcall(function() return pobj:HasReferences() end)
        referenced = ok and has and true or false
        if not ok then referenced = nil end
    end
    local recipe = (referenced ~= false)
    if referenced == false then
        -- repli : valeurs stockees dans la cue (fonctionne, mais ce n'est pas une recipe)
        Cmd("ClearAll")
        Cmd("Group " .. group_no)
        Cmd(string.format("At Preset %d.%d", pool, preset_no))
        Cmd(string.format("Store Sequence %d Cue 1 /Overwrite /NoConfirmation", no))
        Cmd("ClearAll")
        warn(string.format("sequence %d : recipe refusee, valeurs stockees a la place", no))
        recipe = false
    end

    set_sequence_prop(no, { "OffwhenOverridden", "OffWhenOverridden" }, "overridden", 1)
    set_sequence_prop(no, { "PreferCueAppearance" }, "prefercue", 1)
    local mode_ok = set_sequence_prop(no, { "ExecutorDisplayMode" }, "displaymode", "Appearance")
    if not mode_ok then
        log("sequence %d : mode d'affichage executeur non regle (propriete introuvable)", no)
    end

    -- apparences : blanche sur la sequence, verte sur la cue 1
    Cmd(string.format("Assign Appearance %d At Sequence %d", white_no, no))
    local seq = get_sequence(no)
    local shown = seq and rp(seq, "Appearance")
    if shown == nil or tostring(shown) == "" or tostring(shown) == "nil" then
        set_sequence_prop(no, { "Appearance" }, nil, white_no)
    end
    Cmd(string.format("Assign Appearance %d At Sequence %d Cue 1", green_no, no))

    Cmd(string.format('Set Sequence %d Property "Note" "%s"', no, note))
    return recipe
end

-- ---------------------------------------------------------------------------
-- Layout : un cadre par type de projecteur, une rangee par roue (Gobo 1, Gobo 2, Animation, Prismes)
-- ---------------------------------------------------------------------------
local TILE, GAP, PAD = 60, 10, 12
local LABEL_W = 130
local MAX_COLS = 20
local TITLE_ABOVE = 34
local FRAME_GAP = 24
local TITLE_SIZE = 24
local LAYOUT_TITLE_SIZE = 40
local FRAME_APPEARANCE = "GBR_FOND"
local PREFERRED_FRAME = "Fond Menu"

local function round(v) return math.floor(v + 0.5) end

local function find_appearance(name)
    for _, a in ipairs(appearances_list()) do
        if tostring(rp(a, "Name")) == name then return a end
    end
    return nil
end

local function frame_appearance(used_app, cursor)
    if find_appearance(PREFERRED_FRAME) then return PREFERRED_FRAME end
    if find_appearance(FRAME_APPEARANCE) then return FRAME_APPEARANCE end
    local no = alloc(used_app, cursor)
    Cmd(string.format("Store Appearance %d", no))
    Cmd(string.format('Label Appearance %d "%s"', no, FRAME_APPEARANCE))
    Cmd(string.format('Set Appearance %d Property "BackR" %d', no, 40))
    Cmd(string.format('Set Appearance %d Property "BackG" %d', no, 52))
    Cmd(string.format('Set Appearance %d Property "BackB" %d', no, 72))
    Cmd(string.format('Set Appearance %d Property "BackAlpha" %d', no, 255))
    if find_appearance(FRAME_APPEARANCE) then return FRAME_APPEARANCE end
    return nil
end

-- onglets d'etiquette : teinte d'accent par genre (meme logique que les tuiles), version adoucie
local TAB_COLORS = { idx = { 52, 66, 92 }, rot = { 30, 92, 114 }, shk = { 118, 82, 36 }, rotshk = { 104, 52, 98 } }
local function tab_appearance(cls, used_app, cursor)
    local name = "GBR ONGLET " .. tostring(cls)
    if find_appearance(name) then return name end
    local c = TAB_COLORS[cls] or TAB_COLORS.idx
    local no = alloc(used_app, cursor)
    Cmd(string.format("Store Appearance %d", no))
    Cmd(string.format('Label Appearance %d "%s"', no, name))
    Cmd(string.format('Set Appearance %d Property "BackR" %d', no, c[1]))
    Cmd(string.format('Set Appearance %d Property "BackG" %d', no, c[2]))
    Cmd(string.format('Set Appearance %d Property "BackB" %d', no, c[3]))
    Cmd(string.format('Set Appearance %d Property "BackAlpha" %d', no, 255))
    Cmd(string.format('Set Appearance %d Property "Note" "%s"', no, safe(TAG .. "|A|" .. name)))
    if find_appearance(name) then return name end
    return nil
end

local function get_layout(no)
    for _, l in ipairs(layouts_list()) do
        if tonumber(rp(l, "No")) == no then return l end
    end
    return nil
end

local function layout_elements(no)
    return kids(get_layout(no))
end

local function set_element(no, index, prop, value)
    Cmd(string.format('Set Layout %d.%d Property "%s" %d', no, index, prop, round(value)))
end

local function set_element_text(no, index, prop, value)
    Cmd(string.format('Set Layout %d.%d Property "%s" "%s"', no, index, prop, tostring(value):gsub('"', "'")))
end

-- couleur du texte d'un element (les etiquettes ressortaient en sombre sur le cadre) : on essaie
-- plusieurs formats de valeur et on garde celui que la console accepte
local TEXT_COLOR_FORMATS = { "FFFFFFFF", "#FFFFFF", "#FFFFFFFF", "FFFFFF", "255,255,255", "1,1,1,1" }
local text_color_format = nil
local function set_text_white(no, idx)
    local function put(fmt)
        local r = Cmd(string.format('Set Layout %d.%d Property "CustomTextColor" "%s"', no, idx, fmt))
        return tostring(r):lower():find("^ok") ~= nil
    end
    if text_color_format then return put(text_color_format) end
    for _, fmt in ipairs(TEXT_COLOR_FORMATS) do
        if put(fmt) then text_color_format = fmt; return true end
    end
    return false
end

local function create_empty_element(no)
    local before = #layout_elements(no)
    local layout = get_layout(no)
    local attempts = {
        function() return layout:Append() end,
        function() return layout:Append("Element") end,
        function() Cmd(string.format("Store Layout %d.%d", no, before + 1)) end,
    }
    for _, try in ipairs(attempts) do
        pcall(try)
        local after = #layout_elements(no)
        if after == before + 1 then return after end
        if after > before + 1 then return nil end
    end
    return nil
end

-- style d'une tuile : seul l'objet est visible (pas de nom, de barre ni de bordure)
local TILE_STYLE = {
    { "VisibilityObjectName", "Hidden" },
    { "VisibilityBar", "Hidden" },
    { "VisibilityIndicatorBar", "Hidden" },
    { "VisibilityBorder", "Hidden" },
    { "VisibilityID", "Hidden" },
    { "VisibilityValue", "Hidden" },
}

-- lecture numerique tolerante d'une propriete (noms possibles + recherche partielle)
local function read_num(obj, candidates, contains)
    local v = to_number(rp(obj, candidates[1]))
    if v ~= nil then return v end
    local nm = find_prop(obj, candidates, contains)
    if nm then return to_number(rp(obj, nm)) end
    return nil
end

local function build_layout(no, name, group_name, placed, used_app, app_cursor, warn)
    -- placed : liste d'entrees { t, fam_i, fam, cls, items = { {seq_no, item}, ... } } deja triees
    -- Layout existant : les nouveaux blocs sont ajoutes a la suite (sous le contenu), sans rien modifier.
    local append = get_layout(no) ~= nil
    local ex_minx, ex_miny = nil, nil
    local known_tiles = {}
    local own_note = nil
    local renamed = 0
    if append then
        -- emprise enregistree par le plugin dans la Note du layout (fiable, independante des unites)
        local ln = tostring(rp(get_layout(no), "Note") or "")
        if ln:sub(1, #TAG + 3) == TAG .. "|L|" then
            own_note = ln:gsub("|left=%-?%d+", ""):gsub("|bottom=%-?%d+", "")
            local l, bt = tonumber(ln:match("|left=(%-?%d+)")), tonumber(ln:match("|bottom=(%-?%d+)"))
            if l then ex_minx = l end
            if bt then ex_miny = bt end
        end
        for _, el in ipairs(layout_elements(no)) do
            local note = tostring(rp(el, "Note") or "")
            local tno = note:match("^" .. TAG .. "|E|T|(%d+)$")
            if tno then known_tiles[tonumber(tno)] = true end
            local px = read_num(el, { "PosX", "PositionX", "X" }, "posx")
            local py = read_num(el, { "PosY", "PositionY", "Y" }, "posy")
            -- la console renvoie parfois les positions negatives en 16 bits non signes (65346 = -190)
            if px and px > 32767 and px < 65536 then px = px - 65536 end
            if py and py > 32767 and py < 65536 then py = py - 65536 end
            if px then ex_minx = ex_minx and math.min(ex_minx, px) or px end
            if py then ex_miny = ex_miny and math.min(ex_miny, py) or py end
        end
        -- renommage : le titre des cadres existants suit le nouveau nom du type de projecteur
        do
            local seen_t = {}
            for _, row in ipairs(placed) do
                local t = row.t
                if not seen_t[t.key] then
                    seen_t[t.key] = true
                    local tkey = "F|" .. tostring(t.type_name):gsub("[^%w]", "_")
                    local new_txt = string.upper(t.short)
                    local old_txt = t.old_short and string.upper(t.old_short) or nil
                    for i, el in ipairs(layout_elements(no)) do
                        local note = tostring(rp(el, "Note") or "")
                        local txt = tostring(rp(el, "CustomTextText") or "")
                        local mine = (note == TAG .. "|E|" .. tkey)
                            or (note == TAG .. "|E|X" and old_txt and txt == old_txt)
                        if mine and txt ~= new_txt then
                            set_element_text(no, i, "CustomTextText", new_txt)
                            if note == TAG .. "|E|X" then tag(i, tkey) end
                            renamed = renamed + 1
                        end
                    end
                end
            end
        end
        -- tuiles deja presentes (relance) : on ne les rajoute pas
        local kept = {}
        for _, row in ipairs(placed) do
            local items = {}
            for _, e in ipairs(row.items) do
                if not known_tiles[e.seq_no] then items[#items + 1] = e end
            end
            if #items > 0 then
                kept[#kept + 1] = { t = row.t, fam_i = row.fam_i, fam = row.fam, cls = row.cls, items = items }
            end
        end
        placed = kept
        if #placed == 0 then
            if renamed > 0 then warn(string.format("%d titre(s) de cadre renomme(s)", renamed)) end
            return 0
        end
    else
        Cmd("Store Layout " .. no)
        if not get_layout(no) then
            warn("layout " .. no .. " non cree")
            return 0
        end
        Cmd(string.format('Label Layout %d "%s"', no, clean_label(name)))
        Cmd(string.format('Set Layout %d Property "Note" "%s|L|group=%s"', no, TAG, clean_label(group_name)))
    end
    local function tag(idx, what) Cmd(string.format('Set Layout %d.%d Property "Note" "%s|E|%s"', no, idx, TAG, what)) end

    -- blocs : un par type de projecteur
    local blocks, order = {}, {}
    for _, row in ipairs(placed) do
        local b = blocks[row.t.key]
        if not b then
            b = { t = row.t, rows = {} }
            blocks[row.t.key] = b
            order[#order + 1] = b
        end
        -- une rangee par roue ; au-dela de MAX_COLS la rangee passe a la ligne
        local i = 1
        while i <= #row.items do
            local part = {}
            for k = i, math.min(i + MAX_COLS - 1, #row.items) do part[#part + 1] = row.items[k] end
            b.rows[#b.rows + 1] = { fam = row.fam, cls = row.cls, items = part, first = (i == 1) }
            i = i + MAX_COLS
        end
    end

    local pitch = TILE + GAP
    local widest = 0
    for _, b in ipairs(order) do
        local cols = 0
        for _, r in ipairs(b.rows) do cols = math.max(cols, #r.items) end
        b.w = PAD + LABEL_W + cols * pitch - GAP + PAD
        b.h = PAD + #b.rows * pitch - GAP + PAD
        widest = math.max(widest, b.w)
    end
    local total_h = (append and 0 or (LAYOUT_TITLE_SIZE + FRAME_GAP))
    for i, b in ipairs(order) do
        total_h = total_h + TITLE_ABOVE + b.h + (i > 1 and FRAME_GAP or 0)
    end
    local x0 = -round(widest / 2)
    local cursor = round(total_h / 2)
    if append and ex_miny then
        x0 = round(ex_minx or x0)
        cursor = round(ex_miny) - FRAME_GAP
    elseif append then
        -- dernier recours : emprise utilisee du layout (USEDX / USEDY / USEDW / USEDH)
        local lay = get_layout(no)
        local ux, uy = read_num(lay, { "UsedX" }, "usedx"), read_num(lay, { "UsedY" }, "usedy")
        local uh = read_num(lay, { "UsedH" }, "usedh")
        if uy and uh and uh > 0 then
            x0 = round(ux or x0)
            cursor = round(math.min(uy, uy - uh)) - FRAME_GAP
        else
            warn("emprise du layout illisible : lance la sonde pour que je lise les elements de ce layout")
            x0 = round(ex_minx or x0)
            cursor = -1500
        end
    end
    local last_bottom = nil
    local labels_made = {}
    local label_n = 0
    local okt, now = pcall(os.time)
    local stamp = tostring(okt and now and (now % 1000000) or math.random(1, 999999))
    local background, bg_checked = nil, false
    local count = 0

    -- titre general (nouveau layout seulement)
    local title_el = (not append) and create_empty_element(no) or nil
    if title_el then
        tag(title_el, "X")
        set_element(no, title_el, "PosX", x0)
        set_element(no, title_el, "PosY", cursor - LAYOUT_TITLE_SIZE - 10)
        set_element(no, title_el, "Width", widest)
        set_element(no, title_el, "Height", LAYOUT_TITLE_SIZE + 10)
        set_element_text(no, title_el, "CustomTextText", string.upper(clean_label(name)))
        set_element_text(no, title_el, "CustomTextAlignmentH", "Centre")
        set_element_text(no, title_el, "CustomTextAlignmentV", "Middle")
        set_element(no, title_el, "CustomTextSize", LAYOUT_TITLE_SIZE)
        set_element_text(no, title_el, "VisibilityBorder", "Hidden")
    end
    if not append then cursor = cursor - LAYOUT_TITLE_SIZE - 10 - FRAME_GAP end

    local prog = progress_start("Layout " .. no, #placed + #order)
    for _, b in ipairs(order) do
        progress_step(prog, b.t.short)
        local frame_top = cursor - TITLE_ABOVE
        local frame_bottom = frame_top - b.h

        -- cadre (element vide : cree AVANT les etiquettes : un cadre cree apres les recouvre (fond semi-transparent) et les assombrit), titre au-dessus a gauche
        local frame = create_empty_element(no)
        if frame then
            tag(frame, "F|" .. tostring(b.t.type_name):gsub("[^%w]", "_"))
            if not bg_checked then
                bg_checked = true
                background = frame_appearance(used_app, app_cursor)
                if not background then warn("fond des cadres non cree : bordure seule") end
            end
            set_element(no, frame, "PosX", x0 + LABEL_W)
            set_element(no, frame, "PosY", frame_bottom)
            set_element(no, frame, "Width", widest - LABEL_W)
            set_element(no, frame, "Height", frame_top - frame_bottom)
            set_element_text(no, frame, "CustomTextText", string.upper(b.t.short))
            set_element_text(no, frame, "CustomTextAlignmentH", "Left")
            set_element_text(no, frame, "CustomTextAlignmentV", "Above")
            set_element(no, frame, "CustomTextSize", TITLE_SIZE)
            set_element_text(no, frame, "VisibilityBorder", "Hidden")
            if background then set_element_text(no, frame, "Appearance", background) end
        else
            warn("cadre non cree (element vide non supporte)")
        end
        -- tuiles, rangee par rangee
        local y = frame_top - PAD - TILE
        for _, r in ipairs(b.rows) do
            if r.first then
                local lab = create_empty_element(no)
                if lab then
                    pause(0.05)
                    label_n = label_n + 1
                    local ltag = "L|" .. (tostring(b.t.type_name):gsub("[^%w]", "_")) .. "|" .. stamp .. "." .. label_n .. "." .. lab
                    tag(lab, ltag)
                    set_element(no, lab, "PosX", x0 + PAD)
                    set_element(no, lab, "PosY", y)
                    set_element(no, lab, "Width", LABEL_W - PAD)
                    set_element(no, lab, "Height", TILE)
                    set_element_text(no, lab, "CustomTextText", class_notation(r.fam.label, r.cls))
                    set_element_text(no, lab, "CustomTextAlignmentH", "Centre")
                    set_element_text(no, lab, "CustomTextAlignmentV", "Middle")
                    set_element(no, lab, "CustomTextSize", 20)
                    set_element_text(no, lab, "VisibilityBorder", "Hidden")
                    set_text_white(no, lab)
                    -- un element sans apparence n'affiche pas son texte : meme fond que le cadre
                    local tab = tab_appearance(r.cls, used_app, app_cursor) or background
                    if tab then set_element_text(no, lab, "Appearance", tab) end
                    labels_made[#labels_made + 1] = { note = TAG .. "|E|" .. ltag, app = tab, text = class_notation(r.fam.label, r.cls),
                        x = x0 + PAD, y = y, w = LABEL_W - PAD, h = TILE }
                else
                    warn("etiquette de ligne non creee : " .. class_notation(r.fam.label, r.cls))
                end
            end
            for k, entry in ipairs(r.items) do
                local before = #layout_elements(no)
                Cmd(string.format("Assign Sequence %d At Layout %d", entry.seq_no, no))
                pause(0.03)
                local after = #layout_elements(no)
                if after == before + 1 then
                    tag(after, "T|" .. entry.seq_no)
                    if count == 0 then
                        local chk = layout_elements(no)[after]
                        local got = chk and tostring(rp(chk, "Note") or "") or ""
                        if got:sub(1, #TAG + 3) ~= TAG .. "|E|" then
                            warn("les elements de layout n'ont pas pris la marque Note : le nettoyage retirera le layout en entier")
                        end
                    end
                    set_element(no, after, "Width", TILE)
                    set_element(no, after, "Height", TILE)
                    set_element(no, after, "PosX", x0 + PAD + LABEL_W + (k - 1) * pitch)
                    set_element(no, after, "PosY", y)
                    local el = layout_elements(no)[after]
                    for _, kv in ipairs(TILE_STYLE) do
                        if not el or find_prop(el, { kv[1] }) then
                            set_element_text(no, after, kv[1], kv[2])
                        end
                    end
                    -- prisme sans image de roue : le nom de la sequence reste visible sur la tuile
                    if entry.item and entry.item.no_slot then
                        set_element_text(no, after, "VisibilityObjectName", "Visible")
                    end
                    count = count + 1
                else
                    warn(string.format("sequence %d : %d element(s) ajoute(s) au lieu de 1", entry.seq_no, after - before))
                end
            end
            y = y - pitch
            progress_step(prog, b.t.short)
        end

        cursor = frame_bottom - FRAME_GAP
        last_bottom = frame_bottom
    end
    progress_stop(prog)
    -- controle des etiquettes : retrouve chaque etiquette par sa marque Note (les index peuvent bouger),
    -- relit texte et position, corrige ce qui differe
    local fixed = 0
    do
        local by_note = {}
        for i, el in ipairs(layout_elements(no)) do
            local n = tostring(rp(el, "Note") or "")
            if n:sub(1, #TAG + 5) == TAG .. "|E|L|" then by_note[n] = i end
        end
        for _, L in ipairs(labels_made) do
            local idx = by_note[L.note]
            if not idx then
                warn("etiquette introuvable apres creation : " .. L.text)
            else
                local el = layout_elements(no)[idx]
                local got = tostring(rp(el, "CustomTextText") or "")
                local px = read_num(el, { "PosX", "PositionX", "X" }, "posx")
                local py = read_num(el, { "PosY", "PositionY", "Y" }, "posy")
                local bad = (got ~= L.text) or (px and math.abs(px - L.x) > 2) or (py and math.abs(py - L.y) > 2)
                if bad then
                    fixed = fixed + 1
                    set_element_text(no, idx, "CustomTextText", L.text)
                    set_element(no, idx, "PosX", L.x)
                    set_element(no, idx, "PosY", L.y)
                    set_element(no, idx, "Width", L.w)
                    set_element(no, idx, "Height", L.h)
                    set_element(no, idx, "CustomTextSize", 20)
                    set_element_text(no, idx, "VisibilityBorder", "Hidden")
                    set_element_text(no, idx, "CustomTextAlignmentH", "Centre")
                    set_element_text(no, idx, "CustomTextAlignmentV", "Middle")
                    set_text_white(no, idx)
                    local ap = L.app or background
                    if ap then set_element_text(no, idx, "Appearance", ap) end
                end
            end
        end
    end
    if labels_made[1] then
        local el1
        for i, el in ipairs(layout_elements(no)) do
            if tostring(rp(el, "Note") or "") == labels_made[1].note then el1 = el end
        end
        log("couleur etiquette : %s (format %s)", tostring(el1 and rp(el1, "CustomTextColor")), tostring(text_color_format))
    end
    if fixed > 0 then warn(string.format("%d etiquette(s) de ligne corrigee(s) apres controle", fixed)) end
    -- memorise l'emprise (gauche / bas) pour les prochains ajouts a la suite
    if last_bottom and (not append or own_note) then
        local base = own_note or string.format("%s|L|group=%s", TAG, clean_label(group_name))
        Cmd(string.format('Set Layout %d Property "Note" "%s|left=%d|bottom=%d"', no, base, x0, last_bottom))
    end
    return count
end

-- ---------------------------------------------------------------------------
-- Creation : presets -> apparences -> sequences -> layout
-- ---------------------------------------------------------------------------
local function existing_by_note(list, prefix)
    local map = {}
    for _, o in ipairs(list) do
        local note = tostring(rp(o, "Note") or "")
        if note:sub(1, #prefix) == prefix then map[note] = tonumber(rp(o, "No")) end
    end
    return map
end

local function create_all(ctx)
    local warns, report = {}, { presets = 0, reused_presets = 0, apps = 0, sequences = 0, tiles = 0, recipe_fallback = 0 }
    local function warn(text)
        warns[#warns + 1] = text
        log("%s", text)
    end

    local pool = ctx.pool
    local used_preset = pool_numbers(function() return preset_pool_children(pool) end)
    local used_seq = pool_numbers(sequences_list)
    local used_app = pool_numbers(appearances_list)
    local preset_cursor = { n = ctx.preset_start }
    local seq_cursor = { n = ctx.seq_start }
    local app_cursor = { n = ctx.app_start }

    local known_presets = {}
    for _, p in ipairs(preset_pool_children(pool)) do
        local note = tostring(rp(p, "Note") or "")
        if note:sub(1, #TAG + 3) == TAG .. "|P|" then known_presets[note] = tonumber(rp(p, "No")) end
    end
    local known_seq = existing_by_note(sequences_list(), TAG .. "|S|")
    local known_app = {}
    for _, a in ipairs(appearances_list()) do
        local n = tostring(rp(a, "Name") or "")
        if n:sub(1, #TAG + 1) == TAG .. " " then known_app[n] = tonumber(rp(a, "No")) end
    end

    local prog = progress_start("GoboRecipes", #ctx.items * 3)
    local app_cache = {}
    local placed_rows, row_index = {}, {}

    for _, item in ipairs(ctx.items) do
        local label = string.format("%s %s", item.t.short, item.name)

        -- 1) preset
        progress_step(prog, "Preset " .. label)
        local pkey = safe(string.format("%s|P|%s", TAG, item.key))
        local preset_no = known_presets[pkey]
        if preset_no and preset_object(pool, preset_no) then
            report.reused_presets = report.reused_presets + 1
            Cmd(string.format('Label Preset %d.%d "%s"', pool, preset_no, clean_label(label)))
        else
            preset_no = alloc(used_preset, preset_cursor)
            local ok, why = store_preset(item, pool, preset_no, report)
            if ok then
                Cmd(string.format('Label Preset %d.%d "%s"', pool, preset_no, clean_label(label)))
                Cmd(string.format('Set Preset %d.%d Property "Note" "%s"', pool, preset_no, pkey))
                report.presets = report.presets + 1
                report.log = report.log or {}
                report.log[#report.log + 1] = string.format("preset %d.%d  %s  [set '%s' DMX %s-%s]  via %s", pool, preset_no, label,
                    tostring(item.set_name), tostring(item.from), tostring(item.to), tostring(report.last_form))
                known_presets[pkey] = preset_no
            else
                used_preset[preset_no] = nil
                preset_cursor.n = preset_no
                preset_no = nil
                warn(string.format("%s : preset non cree (%s)", label, tostring(why)))
            end
        end

        -- 2) apparences (une paire par slot, partagee entre les variantes)
        progress_step(prog, "Apparences " .. label)
        local white_no, green_no
        if preset_no then
            local cls = class_of(item)
            local akey = table.concat({ item.t.type_name, item.attr, item.wheel_name, item.slot, cls, item.base or "" }, "|")
            local pair = app_cache[akey]
            if not pair then
                local base = string.format("%s %s %s %02d", TAG, item.t.app_short or item.t.short, item.fam.label, item.slot)
                if cls ~= "idx" then base = base .. " " .. cls end
                if item.kind == "prism" and item.base then base = base .. " " .. item.base:sub(1, 14) end
                local wname, gname = base, base .. " ON"
                local slot = slot_object(item.wheel, item.slot)
                local w = known_app[wname] or nil
                local g = known_app[gname] or nil
                for ei, ex in ipairs({ w, g }) do
                    local eo = ex and get_appearance(ex)
                    local img = eo and rp(eo, "Appearance")
                    if eo and img ~= nil and tostring(img) ~= "" and tostring(img) ~= "nil" and CLASS_BACK[cls] then
                        if item.kind == "prism" and not back_for(item, cls, ei == 2) then
                            set_prop(eo, ex, "Appearance", "BackAlpha", 0)
                        else
                            local bc = back_for(item, cls, ei == 2)
                            set_prop(eo, ex, "Appearance", "BackR", bc[1])
                            set_prop(eo, ex, "Appearance", "BackG", bc[2])
                            set_prop(eo, ex, "Appearance", "BackB", bc[3])
                            set_prop(eo, ex, "Appearance", "BackAlpha", 255)
                        end
                    end
                end
                if not w then
                    w = alloc(used_app, app_cursor)
                    if make_appearance(w, wname, item, slot, false, warn, cls) then
                        report.apps = report.apps + 1
                        known_app[wname] = w
                    end
                end
                if not g then
                    g = alloc(used_app, app_cursor)
                    if make_appearance(g, gname, item, slot, true, warn, cls) then
                        report.apps = report.apps + 1
                        known_app[gname] = g
                    end
                end
                pair = { w, g }
                app_cache[akey] = pair
            end
            white_no, green_no = pair[1], pair[2]
        end

        -- 3) sequence recipe
        progress_step(prog, "Sequence " .. label)
        if preset_no and white_no and green_no then
            local skey = safe(string.format("%s|S|g%d|%s", TAG, ctx.group_no, item.key))
            local seq_no = known_seq[skey]
            local seq_name = clean_label(string.format("%s %s %s %s", ctx.prefix, item.t.short, item.fam.label, item.name))
            if seq_no then
                if item.t.old_short and item.t.old_short ~= item.t.short then
                    Cmd(string.format('Label Sequence %d "%s"', seq_no, seq_name))
                end
            else
                seq_no = alloc(used_seq, seq_cursor)
                local ok = make_sequence(seq_no, seq_name, ctx.group_no, pool, preset_no, white_no, green_no,
                    clean_label(item.name), skey, warn)
                if not ok then report.recipe_fallback = report.recipe_fallback + 1 end
                report.sequences = report.sequences + 1
                known_seq[skey] = seq_no
            end
            do
                local cls = class_of(item)
                local rk = item.t.key .. "|" .. item.fam_i .. "|" .. cls
                local ri = row_index[rk]
                if not ri then
                    ri = { t = item.t, fam_i = item.fam_i, fam = item.fam, cls = cls, items = {} }
                    row_index[rk] = ri
                    placed_rows[#placed_rows + 1] = ri
                end
                ri.items[#ri.items + 1] = { seq_no = seq_no, item = item }
            end
        end
        pause(0.05)
    end
    progress_stop(prog)

    -- 4) layout
    if ctx.layout_no and ctx.layout_no > 0 then
        if #placed_rows > 0 then
            table.sort(placed_rows, function(a, b)
                if a.t.key ~= b.t.key then return a.t.key < b.t.key end
                if a.fam_i ~= b.fam_i then return a.fam_i < b.fam_i end
                return CLASS_RANK[a.cls] < CLASS_RANK[b.cls]
            end)
            report.layout_appended = get_layout(ctx.layout_no) ~= nil
            report.tiles = build_layout(ctx.layout_no, ctx.layout_name, ctx.group_name, placed_rows, used_app, app_cursor, warn)
        end
    end
    return report, warns
end

-- ---------------------------------------------------------------------------
-- Sonde : ecrit la vraie structure vue par la console (a m'envoyer en cas de souci)
-- ---------------------------------------------------------------------------
local function dump_props(lines, title, obj, limit)
    local names = prop_names(obj)
    local parts = {}
    for i, n in ipairs(names) do
        if i > (limit or 80) then break end
        local v = rp(obj, n)
        local s = (v == nil) and "nil" or tostring(v)
        if #s > 40 then s = s:sub(1, 40) .. "..." end
        parts[#parts + 1] = n .. "=" .. s
    end
    lines[#lines + 1] = string.format("%s [%s] : %s", title, tostring(select(2, pcall(function() return obj:GetClass() end))), table.concat(parts, "  "))
end

local function run_probe(group_no)
    local lines = { string.format("=== %s %s : sonde ===", PLUGIN_NAME, VERSION) }
    local function out(fmt, ...) lines[#lines + 1] = string.format(fmt, ...) end
    pcall(function() out("Console : %s %s  version %s", tostring(HostType()), tostring(HostSubType()), tostring(Version())) end)
    local types = read_group_types(group_no)
    out("Groupe %d : %d type(s)", group_no, #types)
    for _, t in ipairs(types) do
        out("")
        out("TYPE %s | mode '%s' | %d projecteur(s) | premier FID %s", t.type_name, t.mode_name, #t.fids, tostring(t.first_fid))
        dump_props(lines, "  FixtureType", t.ftype, 30)
        do
            local ra = load_real_attrs(t)
            out("  Attributs reels du projecteur (%d) : %s", #ra, table.concat(ra, ", "))
        end
        local modes = child_named(t.ftype, { "DMXModes" })
        out("  DMXModes : %d enfant(s)", #kids(modes))
        do
            local md = nil
            for _, m in ipairs(kids(modes)) do if t.mode_name == "" or oname(m) == t.mode_name then md = m; break end end
            md = md or kids(modes)[1]
            local n = 0
            for di, dch in ipairs(kids(child_named(md, { "DMXChannels" }))) do
                for li, lc in ipairs(kids(dch)) do
                    local la = attr_of(lc)
                    local low = la:lower()
                    if low:find("gobo", 1, true) or low:find("prism", 1, true) or low:find("effect", 1, true) or low:find("anim", 1, true) then
                        out("  [canal %d/%d] LC attr='%s' nom='%s'", di, li, la, oname(lc))
                        for ci, cf in ipairs(kids(lc)) do
                            local nsets, withslot, first = 0, 0, ""
                            for _, cs in ipairs(kids(cf)) do
                                nsets = nsets + 1
                                if (to_number(rp(cs, "WheelSlotIndex")) or 0) > 0 then withslot = withslot + 1 end
                                if first == "" then first = oname(cs) end
                            end
                            out("      CF %d attr='%s' nom='%s' sets=%d (avec slot %d) 1er='%s' roue='%s'",
                                ci, attr_of(cf), oname(cf), nsets, withslot, first, oname(rp(cf, "Wheel")))
                        end
                        n = n + 1
                        if n > 40 then break end
                    end
                end
            end
        end
        for _, kind in ipairs({ "gobo", "prism" }) do
            local items = scan_type(t, kind)
            out("  %s : %d channel set(s) avec slot", kind, #items)
            local seen = {}
            for _, it in ipairs(items) do
                local k = it.attr .. it.cf_i
                if not seen[k] then
                    seen[k] = true
                    out("    %s | CF %d '%s' | roue '%s'", it.attr, it.cf_i, it.cf_name, it.wheel_name)
                end
            end
            if items[1] then
                local it = items[1]
                local slot = slot_object(it.wheel, it.slot)
                if slot then dump_props(lines, "  slot " .. it.slot, slot, 60) end
                if it.wheel then dump_props(lines, "  roue", it.wheel, 30) end
                out("  valeur du 1er item : from=%s to=%s -> %.4f %%", tostring(it.from), tostring(it.to), value_percent(it))
            end
        end
    end
    local app = appearances_list()[1]
    if app then dump_props(lines, "Appearance (modele)", app, 60) end
    local seq = sequences_list()[1]
    if seq then dump_props(lines, "Sequence (modele)", seq, 90) end
    local lay = layouts_list()[1]
    if lay then
        dump_props(lines, "Layout (modele)", lay, 30)
        local el = kids(lay)[1]
        if el then dump_props(lines, "Element de layout (modele)", el, 90) end
    end
    -- elements des layouts crees par le plugin (positions, tailles, textes) : pour diagnostiquer les etiquettes
    for _, ly in ipairs(layouts_list()) do
        local ln = tostring(rp(ly, "Note") or "")
        local mine = ln:sub(1, #TAG + 3) == TAG .. "|L|"
        if not mine then
            for _, el in ipairs(kids(ly)) do
                if tostring(rp(el, "Note") or ""):sub(1, #TAG + 3) == TAG .. "|E|" then mine = true; break end
            end
        end
        if mine then
            lines[#lines + 1] = string.format("ELEMENTS layout %s (%s)", tostring(rp(ly, "No")), tostring(rp(ly, "Name")))
            for i, el in ipairs(kids(ly)) do
                if i > 250 then lines[#lines + 1] = "  ..."; break end
                lines[#lines + 1] = string.format("  %3d note=%s x=%s y=%s w=%s h=%s txt=%s size=%s border=%s color=%s",
                    i, tostring(rp(el, "Note")), tostring(rp(el, "PosX")), tostring(rp(el, "PosY")),
                    tostring(rp(el, "Width")), tostring(rp(el, "Height")), tostring(rp(el, "CustomTextText")),
                    tostring(rp(el, "CustomTextSize")), tostring(rp(el, "VisibilityBorder")), tostring(rp(el, "CustomTextColor")))
            end
            for _, i in ipairs({ 1, 2, 3 }) do
                local el = kids(ly)[i]
                if el then dump_props(lines, "  PROPS element " .. i, el, 90) end
            end
        end
    end
    local p = preset_pool_children(DEFAULT_GOBO_POOL)[1]
    if p then dump_props(lines, "Preset pool gobo (modele)", p, 40) end

    local path = nil
    pcall(function() path = GetPath(Enums.PathType.Library) end)
    local text = table.concat(lines, "\n")
    Printf("%s", text)
    if path then
        local f = io.open(path .. "/GoboRecipes_diagnostic.txt", "w")
        if f then
            f:write(text, "\n")
            f:close()
            return path .. "/GoboRecipes_diagnostic.txt"
        end
    end
    return nil
end

-- ---------------------------------------------------------------------------
-- Menus
-- ---------------------------------------------------------------------------
local function choose_group()
    local list = {}
    for _, g in ipairs(groups_list()) do
        local no = tonumber(rp(g, "No"))
        if no then list[#list + 1] = { no = no, name = trim(oname(g)) } end
    end
    table.sort(list, function(a, b) return a.no < b.no end)
    if #list == 0 then
        show_info(PLUGIN_NAME, "Aucun groupe dans le datapool.")
        return nil
    end
    local items, last = {}, tonumber(load_setting("Group", "0"))
    local checked = {}
    for _, g in ipairs(list) do
        items[#items + 1] = { key = tostring(g.no), text = string.format("%d   %s", g.no, g.name) }
        if g.no == last then checked[tostring(g.no)] = true end
    end
    local r = ui_list_dialog({
        title = PLUGIN_NAME .. " - Groupe", single = true, items = items, checked = checked,
        help = "Choisis le groupe de projecteurs.",
        empty_text = "Choisis un groupe.", count_label = "Groupes",
        buttons = { { "Choisir", 1, "needs" }, { "Annuler", 0 } },
    })
    if not r or r.result ~= 1 then return nil end
    for _, g in ipairs(list) do
        if r.states[tostring(g.no)] then
            save_setting("Group", g.no)
            return g.no, g.name
        end
    end
    return nil
end

local function item_text(it)
    local text = string.format("%02d  %s", it.slot, it.base or it.name)
    if it.rot or it.shake then text = text .. "   " .. (it.marker or "") end
    return text
end

-- une ligne par gobo (slot) ; les fonctions (indexe / rotatif / shake) se choisissent par roue
local function pick_items(types, kind, group_name, group_no)
    local all = {}
    for _, t in ipairs(types) do
        for _, it in ipairs(scan_type(t, kind)) do all[#all + 1] = it end
    end
    if #all == 0 then return nil, nil, "none" end

    local multi_type = #types > 1
    local tabs, tab_index = {}, {}
    for _, it in ipairs(all) do
        local tk = it.t.key .. "|" .. it.fam_i
        local tb = tab_index[tk]
        if not tb then
            local lbl = multi_type and (it.t.short .. " " .. it.fam.label) or it.fam.label
            tb = { id = tk, label = lbl, items = {}, slots = {}, by_class = {}, range = {}, rot_default = it.rot_default }
            tab_index[tk] = tb
            tabs[#tabs + 1] = tb
        end
        local cls = class_of(it)
        tb.by_class[cls] = tb.by_class[cls] or {}
        local lo, hi = math.floor(it.from / 65536), math.floor(it.to / 65536)
        local r = tb.range[cls]
        if not r then tb.range[cls] = { lo, hi } else r[1] = math.min(r[1], lo); r[2] = math.max(r[2], hi) end
        local sl = tb.slots[it.slot]
        if not sl then
            sl = { slot = it.slot, by_class = {}, first = it.from, base = it.base, noslot = it.no_slot }
            tb.slots[it.slot] = sl
            tb.items[#tb.items + 1] = sl
        end
        if not sl.by_class[cls] then sl.by_class[cls] = it end
        -- le nom affiche est celui de la fonction indexee quand elle existe
        if cls == "idx" then sl.base = it.base; sl.first = math.min(sl.first, it.from) end
    end
    for _, tb in ipairs(tabs) do
        table.sort(tb.items, function(x, y)
            if x.first ~= y.first then return x.first < y.first end
            return x.slot < y.slot
        end)
        tb.entries = tb.items
        tb.items = {}
        for _, sl in ipairs(tb.entries) do
            sl.key = tb.id .. "|" .. sl.slot
            tb.items[#tb.items + 1] = { key = sl.key, text = sl.noslot and sl.base or string.format("%02d  %s", sl.slot, sl.base) }
        end
        tb.opts = {}
        for _, cls in ipairs(CLASS_ORDER) do
            if tb.by_class[cls] then
                local r = tb.range[cls]
                local on = (cls == "idx") or (cls == "rot" and tb.rot_default)
                tb.opts[#tb.opts + 1] = {
                    key = cls, on = on,
                    label = string.format("%s  (DMX %d-%d)", CLASS_LABEL[cls], r[1], r[2]),
                }
            end
        end
    end

    -- selection retenue d'une fois sur l'autre (par groupe et par famille)
    local mem_key = string.format("Sel|%s|%s", kind, tostring(group_no or group_name))
    local mem_items, mem_opts, has_mem = {}, {}, false
    do
        local raw = load_setting(mem_key, "")
        local a, b = raw:match("^(.-)@@(.*)$")
        if a then
            has_mem = true
            for k in (a .. ";;"):gmatch("(.-);;") do if k ~= "" then mem_items[k] = true end end
            for k in (b .. ";;"):gmatch("(.-);;") do if k ~= "" then mem_opts[k] = true end end
        end
    end
    local all_keys = {}
    for _, tb in ipairs(tabs) do for _, it in ipairs(tb.items) do all_keys[#all_keys + 1] = it.key end end
    local default_on = {}
    for _, tb in ipairs(tabs) do for _, o in ipairs(tb.opts) do default_on[tb.id .. ":" .. o.key] = o.on end end
    local checked = {}
    if has_mem then
        for k in pairs(mem_items) do checked[k] = true end
        for _, tb in ipairs(tabs) do
            for _, o in ipairs(tb.opts) do
                local ok = tb.id .. ":" .. o.key
                if mem_opts[ok] ~= nil or next(mem_opts) then o.on = mem_opts[ok] and true or false end
            end
        end
    end
    local r
    while true do
        r = ui_list_dialog({
            title = PLUGIN_NAME .. (kind == "gobo" and " - Gobos" or " - Prismes"),
            tabs = tabs, checked = checked, all_wheels = true,
            help = string.format("Groupe %s : coche les gobos, puis les fonctions de chaque roue.", group_name),
            empty_text = "Rien de coche : coche au moins un gobo.", count_label = "Gobos",
            buttons = { { "Creer", 1, "needs" }, { "Annuler", 0 } },
        })
        if not r then return nil end
        if r.result == 2 or r.result == 3 then
            -- on garde les fonctions choisies par roue ; on ne change que les gobos coches
            for ti, tb in ipairs(tabs) do
                for _, o in ipairs(tb.opts) do o.on = (r.opts[ti] and r.opts[ti][o.key]) and true or false end
            end
            checked = {}
            if r.result == 2 then for _, k in ipairs(all_keys) do checked[k] = true end end
        else
            break
        end
    end
    if r.result ~= 1 then return nil end
    do
        local a, b = {}, {}
        for _, k in ipairs(all_keys) do if r.states[k] then a[#a + 1] = k end end
        for ti, tb in ipairs(tabs) do
            for _, o in ipairs(tb.opts) do
                if r.opts[ti] and r.opts[ti][o.key] then b[#b + 1] = tb.id .. ":" .. o.key end
            end
        end
        save_setting(mem_key, table.concat(a, ";;") .. "@@" .. table.concat(b, ";;"))
    end

    local chosen = {}
    for ti, tb in ipairs(tabs) do
        for _, cls in ipairs(CLASS_ORDER) do
            if r.opts[ti] and r.opts[ti][cls] then
                for _, sl in ipairs(tb.entries) do
                    local it = sl.by_class[cls]
                    if it and r.states[sl.key] then chosen[#chosen + 1] = it end
                end
            end
        end
    end
    return chosen, true
end

local function numbers_box(kind, group_name, count, need_app, type_list, already)
    local pool_default = tonumber(load_setting(kind == "gobo" and "GoboPool" or "PrismPool",
        tostring(kind == "gobo" and DEFAULT_GOBO_POOL or DEFAULT_PRISM_POOL)))
    local used_seq = pool_numbers(sequences_list)
    local used_app = pool_numbers(appearances_list)
    local used_lay = pool_numbers(layouts_list)
    local used_pre = pool_numbers(function() return preset_pool_children(pool_default) end)
    local sug_pre = hundreds_start(used_pre, count)
    local sug_seq = hundreds_start(used_seq, count)
    local sug_app = hundreds_start(used_app, need_app)
    local last_lay = tonumber(load_setting(kkey(kind, "Layout"), "0")) or 0
    local sug_lay = (last_lay > 0) and last_lay or next_free(used_lay, 1)

    local inputs = {
        { name = "Pool de presets", value = tostring(pool_default), vkPlugin = "TextInputNumOnly" },
        { name = "Premier preset", value = tostring(sug_pre), vkPlugin = "TextInputNumOnly" },
        { name = "Premiere sequence", value = tostring(sug_seq), vkPlugin = "TextInputNumOnly" },
        { name = "Premiere appearance", value = tostring(sug_app), vkPlugin = "TextInputNumOnly" },
        { name = "Layout (0 = aucun)", value = tostring(sug_lay), vkPlugin = "TextInputNumOnly" },
        { name = "Nom du layout", value = load_setting(kkey(kind, "LayoutName"), kind == "gobo" and "Gobos" or "Prismes"), vkPlugin = "TextInput" },
        { name = "Prefixe des sequences", value = load_setting(kkey(kind, "Prefix"), kind == "gobo" and "Gobo" or "Prism"), vkPlugin = "TextInput" },
    }
    -- un nom d'affichage par type de projecteur (titre des cadres du layout, noms des sequences)
    local type_input = {}
    for i, t in ipairs(type_list or {}) do
        local prev = load_setting("TypeName|" .. t.type_name, t.short)
        t.old_short = prev
        -- nom utilise dans les apparences : fige a la premiere creation (pour les retrouver apres un renommage)
        local an = load_setting("AppName|" .. t.type_name, "")
        t.app_short = (an ~= "") and an or prev
        local nm = string.format("Nom projecteur %d (%s)", i, t.type_name)
        type_input[#type_input + 1] = { t = t, name = nm }
        inputs[#inputs + 1] = { name = nm, value = load_setting("TypeName|" .. t.type_name, t.short), vkPlugin = "TextInput" }
    end
    local box = MessageBox({
        title = PLUGIN_NAME .. " - Numeros",
        message = string.format("%d presets, %d sequences, %d apparences%s.\nLayout existant : les blocs sont ajoutes a la suite ; 0 = pas de layout.",
            count, count, need_app,
            (already and already > 0) and string.format(" (%d deja crees, reutilises)", already) or ""),
        commands = { { value = 1, name = "Creer" }, { value = 0, name = "Annuler" } },
        inputs = inputs,
    })
    if not box or box.result ~= 1 then return nil end
    local function num(name, default)
        local v = tonumber((tostring(box.inputs[name] or ""):gsub("%D", "")))
        if v == nil then return default end
        return math.floor(v)
    end
    local ctx = {
        pool = math.max(1, num("Pool de presets", pool_default)),
        preset_start = math.max(1, num("Premier preset", sug_pre)),
        seq_start = math.max(1, num("Premiere sequence", sug_seq)),
        app_start = math.max(1, num("Premiere appearance", sug_app)),
        layout_no = num("Layout (0 = aucun)", sug_lay),
        layout_name = trim(box.inputs["Nom du layout"] or "Gobos"),
        prefix = trim(box.inputs["Prefixe des sequences"] or "Gobo"),
    }
    if ctx.layout_name == "" then ctx.layout_name = "Gobos" end
    for _, ti in ipairs(type_input) do
        local nm = clean_label(trim(box.inputs[ti.name] or ""))
        if nm ~= "" then
            ti.t.short = nm
            save_setting("TypeName|" .. ti.t.type_name, nm)
        end
        save_setting("AppName|" .. ti.t.type_name, ti.t.app_short or ti.t.short)
    end

    -- controle des plages choisies : jamais d'ecrasement, on decale a la centaine suivante
    ctx.notes = {}
    if ctx.pool ~= pool_default then
        used_pre = pool_numbers(function() return preset_pool_children(ctx.pool) end)
    end
    ctx.preset_start = settle_block(used_pre, ctx.preset_start, count, "Presets", ctx.notes)
    ctx.seq_start = settle_block(used_seq, ctx.seq_start, count, "Sequences", ctx.notes)
    ctx.app_start = settle_block(used_app, ctx.app_start, need_app, "Apparences", ctx.notes)

    save_setting(kind == "gobo" and "GoboPool" or "PrismPool", ctx.pool)
    save_setting(kkey(kind, "Layout"), ctx.layout_no > 0 and ctx.layout_no or 0)
    save_setting(kkey(kind, "LayoutName"), ctx.layout_name)
    save_setting(kkey(kind, "Prefix"), ctx.prefix)
    return ctx
end

local build_commands   -- defini plus bas (boutons de commande)

local function family_step(kind, group_no, group_name)
    if not group_no then
        group_no, group_name = choose_group()
        if not group_no then return end
    end
    group_name = group_name or ("Groupe " .. group_no)
    local types = read_group_types(group_no)
    if #types == 0 then
        show_info(PLUGIN_NAME, string.format("Le groupe %d est vide ou illisible.", group_no))
        return
    end
    local chosen, with_variants, status = pick_items(types, kind, group_name, group_no)
    if status == "none" then
        show_info(PLUGIN_NAME, string.format("Aucune roue %s trouvee dans les types de ce groupe.\nLance \"probe %d\" pour relever la structure.",
            kind == "gobo" and "de gobos / animation" or "de prismes", group_no))
        return
    end
    if not chosen or #chosen == 0 then return end

    local pairs_seen, need_app = {}, 1
    for _, it in ipairs(chosen) do
        local k = table.concat({ it.t.type_name, it.attr, it.wheel_name, it.slot, class_of(it) }, "|")
        if not pairs_seen[k] then pairs_seen[k] = true; need_app = need_app + 2 end
    end
    local type_list, type_seen = {}, {}
    for _, it in ipairs(chosen) do
        if not type_seen[it.t.type_name] then
            type_seen[it.t.type_name] = true
            type_list[#type_list + 1] = it.t
        end
    end
    local already = 0
    do
        local ppool = tonumber(load_setting(kind == "gobo" and "GoboPool" or "PrismPool",
            tostring(kind == "gobo" and DEFAULT_GOBO_POOL or DEFAULT_PRISM_POOL))) or DEFAULT_GOBO_POOL
        local known = {}
        for _, pr in ipairs(preset_pool_children(ppool)) do
            local note = tostring(rp(pr, "Note") or "")
            if note:sub(1, #TAG + 3) == TAG .. "|P|" then known[note] = true end
        end
        for _, it in ipairs(chosen) do
            if known[safe(string.format("%s|P|%s", TAG, it.key))] then already = already + 1 end
        end
    end
    local ctx = numbers_box(kind, group_name, #chosen, need_app, type_list, already)
    if not ctx then return end
    ctx.items = chosen
    ctx.with_variants = with_variants
    ctx.group_no = group_no
    ctx.group_name = group_name

    local report, warns = create_all(ctx)
    local lines = {
        string.format("Presets : %d crees, %d reutilises", report.presets, report.reused_presets),
        string.format("Sequences : %d, apparences : %d", report.sequences, report.apps),
    }
    if report.forms then
        local fl = {}
        for label, n in pairs(report.forms) do fl[#fl + 1] = string.format("%s x%d", label, n) end
        table.sort(fl)
        lines[#lines + 1] = "Valeurs ecrites par : " .. table.concat(fl, ", ")
    end
    for _, n in ipairs(ctx.notes or {}) do lines[#lines + 1] = n end
    if kind == "gobo" and ctx.layout_no > 0 then
        -- boutons de commande : Tout open / Stop / Slow / Fast, crees avec le layout
        local okc, rc = pcall(build_commands, group_no, group_name, types, ctx.layout_no)
        if okc and rc then
            lines[#lines + 1] = string.format("Boutons de commande : %d crees, %d poses", rc.made, rc.put)
            if #rc.presets > 0 then lines[#lines + 1] = "Presets de vitesse crees : " .. table.concat(rc.presets, ", ") end
            for _, w in ipairs(rc.warns) do warns[#warns + 1] = w end
        else
            warns[#warns + 1] = "boutons de commande non crees : " .. tostring(rc)
        end
    end
    if ctx.layout_no > 0 then
        lines[#lines + 1] = string.format("Layout %d : %d tuile(s)%s", ctx.layout_no, report.tiles,
            report.layout_appended and " ajoutee(s) a la suite" or "")
    end
    if report.recipe_fallback > 0 then
        lines[#lines + 1] = string.format("Attention : %d sequence(s) sans recipe (valeurs stockees)", report.recipe_fallback)
    end
    if #warns > 0 then
        lines[#lines + 1] = ""
        for i = 1, math.min(6, #warns) do lines[#lines + 1] = "- " .. warns[i] end
        if #warns > 6 then lines[#lines + 1] = string.format("(+ %d autres, voir System Monitor)", #warns - 6) end
    end
    -- journal de la derniere creation (a m'envoyer en cas de souci) : methode d'ecriture de chaque preset
    pcall(function()
        local path = GetPath(Enums.PathType.Library)
        local f = path and io.open(path .. "/GoboRecipes_derniere_creation.txt", "w")
        if f then
            f:write("GoboRecipes ", VERSION, " : derniere creation (", kind, ", groupe ", tostring(group_name), ")\n")
            for _, l in ipairs(lines) do f:write(l, "\n") end
            for _, l in ipairs(report.log or {}) do f:write(l, "\n") end
            for _, w in ipairs(warns) do f:write("WARN ", w, "\n") end
            f:close()
        end
    end)
    show_info(PLUGIN_NAME, table.concat(lines, "\n"))
end

-- ---------------------------------------------------------------------------
-- Nettoyage : ne supprime QUE ce que le plugin a cree (marque GBR dans le champ Note / le nom)
-- ---------------------------------------------------------------------------
local function scan_created()
    local found = { presets = {}, sequences = {}, apps = {}, elements = {}, layouts = {}, whole = {} }
    -- presets : pools de gobos et de prismes (et ceux utilises recemment)
    local pools, seen_pool = {}, {}
    for _, pl in ipairs({ DEFAULT_GOBO_POOL, DEFAULT_PRISM_POOL,
        tonumber(load_setting("GoboPool", "0")) or 0, tonumber(load_setting("PrismPool", "0")) or 0 }) do
        if pl > 0 and not seen_pool[pl] then seen_pool[pl] = true; pools[#pools + 1] = pl end
    end
    local gpool = tonumber(load_setting("GoboPool", tostring(DEFAULT_GOBO_POOL))) or DEFAULT_GOBO_POOL
    local ppool = tonumber(load_setting("PrismPool", tostring(DEFAULT_PRISM_POOL))) or DEFAULT_PRISM_POOL
    local seq_info, key_kind, key_type = {}, {}, {}
    for _, sq in ipairs(sequences_list()) do
        local note = tostring(rp(sq, "Note") or "")
        if note:sub(1, #TAG + 3) == TAG .. "|S|" then
            local no = tonumber(rp(sq, "No"))
            local key = note:match("^" .. TAG .. "|S|g%d+|(.*)$") or ""
            local ty = key:match("^([^|]*)|") or "?"
            local nm = tostring(rp(sq, "Name") or "")
            local kind = nm:find("Prisme%s%d") and "prism" or "gobo"
            seq_info[no] = { kind = kind, type = ty }
            key_kind[key] = kind; key_type[key] = ty
            found.sequences[#found.sequences + 1] = { no = no, kind = kind, type = ty }
        end
    end
    for _, pl in ipairs(pools) do
        for _, pr in ipairs(preset_pool_children(pl)) do
            local note = tostring(rp(pr, "Note") or "")
            if note:sub(1, #TAG + 3) == TAG .. "|P|" then
                local key = note:sub(#TAG + 4)
                local kind = key_kind[key] or ((pl == ppool and pl ~= gpool) and "prism" or "gobo")
                local ty = key_type[key] or key:match("^([^|]*)|") or "?"
                found.presets[#found.presets + 1] = { pool = pl, no = tonumber(rp(pr, "No")), kind = kind, type = ty }
            end
        end
    end
    -- nom court d'apparence -> type
    local short_type = {}
    for _, si in pairs(seq_info) do
        local sh = load_setting("AppName|" .. si.type, "")
        if sh ~= "" then short_type[sh] = si.type end
        local sh2 = load_setting("TypeName|" .. si.type, "")
        if sh2 ~= "" then short_type[sh2] = short_type[sh2] or si.type end
    end
    for _, ap in ipairs(appearances_list()) do
        local note = tostring(rp(ap, "Note") or "")
        local name = tostring(rp(ap, "Name") or "")
        if note:sub(1, #TAG + 3) == TAG .. "|A|" or name:sub(1, #TAG + 1) == TAG .. " " then
            local kind = name:find("Prisme%s%d") and "prism" or "gobo"
            local ty = "?"
            for sh, t in pairs(short_type) do
                if name:sub(1, #TAG + #sh + 2) == TAG .. " " .. sh .. " " then ty = t end
            end
            found.apps[#found.apps + 1] = { no = tonumber(rp(ap, "No")), kind = kind, type = ty }
        end
    end
    for _, ly in ipairs(layouts_list()) do
        local lno = tonumber(rp(ly, "No"))
        local note = tostring(rp(ly, "Note") or "")
        local mine = note:sub(1, #TAG + 3) == TAG .. "|L|"
        if mine then found.layouts[#found.layouts + 1] = lno end
        local tagged, total = 0, 0
        for i, el in ipairs(kids(ly)) do
            total = total + 1
            local en = tostring(rp(el, "Note") or "")
            if en:sub(1, #TAG + 3) == TAG .. "|E|" then
                tagged = tagged + 1
                local e = { layout = lno, index = i }
                local tno = en:match("^" .. TAG .. "|E|T|(%d+)$")
                if tno then
                    local si = seq_info[tonumber(tno)]
                    e.tile = true; e.seq_no = tonumber(tno)
                    if si then e.kind = si.kind; e.type = si.type end
                end
                local lt = en:match("^" .. TAG .. "|E|L|(.-)|[%d%.]+$")
                local ft = en:match("^" .. TAG .. "|E|F|(.*)$") or lt
                if lt then e.label = true end
                if ft then
                    if not lt then e.frame = true end
                    e.type = ft
                    for _, si in pairs(seq_info) do if (tostring(si.type):gsub("[^%w]", "_")) == ft then e.type = si.type end end
                end
                found.elements[#found.elements + 1] = e
            end
        end
        -- layout cree par le plugin dont les elements n'ont pas pu etre marques : on le prend en entier
        if mine and total > 0 and tagged == 0 then found.whole[lno] = true end
    end
    return found
end

-- garde seulement les objets des combinaisons (type, genre) cochees
local function filter_created(f, sel, all_selected)
    local function ok(o) return sel[(o.kind or "?") .. "|" .. (o.type or "?")] end
    local out = { presets = {}, sequences = {}, apps = {}, elements = {}, layouts = {}, whole = f.whole }
    for _, o in ipairs(f.presets) do if ok(o) then out.presets[#out.presets + 1] = o end end
    for _, o in ipairs(f.sequences) do if ok(o) then out.sequences[#out.sequences + 1] = o end end
    for _, o in ipairs(f.apps) do if ok(o) then out.apps[#out.apps + 1] = o end end
    if all_selected then
        out.elements = f.elements
        out.layouts = f.layouts
        return out
    end
    -- tuiles selectionnees, puis cadres dont le type n'a plus aucune tuile dans ce layout
    local gone, left = {}, {}
    for _, e in ipairs(f.elements) do
        if e.tile then
            if ok(e) then out.elements[#out.elements + 1] = e; gone[e] = true
            else left[e.layout .. "|" .. tostring(e.type)] = true end
        end
    end
    for _, e in ipairs(f.elements) do
        if (e.frame or e.label) and not left[e.layout .. "|" .. tostring(e.type)] then
            local has = false
            for k in pairs(sel) do if k:match("|(.*)$") == e.type then has = true end end
            if has then out.elements[#out.elements + 1] = e end
        end
    end
    return out
end

local function clean_step()
    local all = scan_created()
    local total = #all.presets + #all.sequences + #all.apps + #all.elements + #all.layouts
    if total == 0 then
        show_info(PLUGIN_NAME .. " - Nettoyer", "Rien a nettoyer : aucun objet marque GoboRecipes n'a ete trouve.")
        return
    end
    -- etape 1 : quels projecteurs / quels genres (gobos, prismes)
    local combos, order = {}, {}
    local function add(o, what)
        local k = (o.kind or "?") .. "|" .. (o.type or "?")
        if not combos[k] then combos[k] = { kind = o.kind or "?", type = o.type or "?", n = 0 }; order[#order + 1] = k end
        combos[k].n = combos[k].n + 1
    end
    for _, o in ipairs(all.sequences) do add(o) end
    for _, o in ipairs(all.presets) do add(o) end
    for _, o in ipairs(all.apps) do add(o) end
    table.sort(order, function(a, b)
        if combos[a].kind ~= combos[b].kind then return combos[a].kind < combos[b].kind end
        return combos[a].type < combos[b].type
    end)
    local sel, all_selected = {}, true
    if #order > 0 then
        local citems, cchecked = {}, {}
        for _, k in ipairs(order) do
            local c = combos[k]
            local nm = load_setting("TypeName|" .. c.type, "")
            if nm == "" then nm = c.type end
            if nm == "?" then nm = "(type non identifie)" end
            citems[#citems + 1] = { key = k, text = string.format("%s  -  %s   (%d objets)", c.kind == "prism" and "Prismes" or "Gobos", nm, c.n) }
            cchecked[k] = true
        end
        local r1 = ui_list_dialog({
            title = PLUGIN_NAME .. " - Nettoyer : quoi ?", items = citems, checked = cchecked,
            help = "Coche les projecteurs et genres a nettoyer (decoche pour les garder).",
            empty_text = "Rien de coche.", count_label = "Selection",
            buttons = { { "Suite", 1, "needs" }, { "Annuler", 0 } },
        })
        if not r1 or r1.result ~= 1 then return end
        for _, k in ipairs(order) do
            if r1.states[k] then sel[k] = true else all_selected = false end
        end
    end
    local f = filter_created(all, sel, all_selected)
    total = #f.presets + #f.sequences + #f.apps + #f.elements + #f.layouts
    if total == 0 then
        show_info(PLUGIN_NAME .. " - Nettoyer", "Rien a nettoyer pour cette selection.")
        return
    end
    local items = {
        { key = "lay", text = string.format("Layouts crees (%d) et tuiles / cadres (%d)", #f.layouts, #f.elements) },
        { key = "seq", text = string.format("Sequences (%d)", #f.sequences) },
        { key = "pre", text = string.format("Presets (%d)", #f.presets) },
        { key = "app", text = string.format("Apparences (%d)", #f.apps) },
    }
    local r = ui_list_dialog({
        title = PLUGIN_NAME .. " - Nettoyer", items = items,
        checked = { lay = true, seq = true, pre = true, app = true },
        help = "Coche ce que tu veux effacer. Seuls les objets crees par GoboRecipes sont concernes.",
        empty_text = "Rien de coche.", count_label = "Categories",
        buttons = { { "Effacer", 1, "needs" }, { "Annuler", 0 } },
    })
    if not r or r.result ~= 1 then return end
    local want = r.states
    local n_total = (want.lay and (#f.layouts + #f.elements) or 0) + (want.seq and #f.sequences or 0)
        + (want.pre and #f.presets or 0) + (want.app and #f.apps or 0)
    local ask = MessageBox({
        title = PLUGIN_NAME .. " - Confirmer",
        message = string.format("Effacer %d objet(s) crees par GoboRecipes ?\nRien d'autre n'est touche. Un seul Oops annule tout.", n_total),
        commands = { { value = 1, name = "Effacer" }, { value = 0, name = "Annuler" } },
    })
    if not ask or ask.result ~= 1 then return end

    local done = { elements = 0, layouts = 0, sequences = 0, presets = 0, apps = 0 }
    local prog = progress_start("Nettoyage", n_total)
    if want.lay then
        -- tuiles et cadres ajoutes : du dernier au premier pour garder les index valides
        table.sort(f.elements, function(a, b)
            if a.layout ~= b.layout then return a.layout < b.layout end
            return a.index > b.index
        end)
        for _, e in ipairs(f.elements) do
            progress_step(prog, string.format("Layout %d", e.layout))
            Cmd(string.format("Delete Layout %d.%d /NoConfirmation", e.layout, e.index))
            done.elements = done.elements + 1
        end
        -- layouts crees par le plugin : supprimes seulement s'ils sont vides
        for _, lno in ipairs(f.layouts) do
            local lay = get_layout(lno)
            if lay and (#kids(lay) == 0 or f.whole[lno]) then
                Cmd(string.format("Delete Layout %d /NoConfirmation", lno))
                done.layouts = done.layouts + 1
            end
        end
    end
    if want.seq then
        for _, o in ipairs(f.sequences) do
            progress_step(prog, "Sequence " .. o.no)
            Cmd(string.format("Delete Sequence %d /NoConfirmation", o.no))
            done.sequences = done.sequences + 1
        end
    end
    if want.pre then
        for _, pr in ipairs(f.presets) do
            progress_step(prog, string.format("Preset %d.%d", pr.pool, pr.no))
            Cmd(string.format("Delete Preset %d.%d /NoConfirmation", pr.pool, pr.no))
            done.presets = done.presets + 1
        end
    end
    if want.app then
        for _, o in ipairs(f.apps) do
            progress_step(prog, "Apparence " .. o.no)
            Cmd(string.format("Delete Appearance %d /NoConfirmation", o.no))
            done.apps = done.apps + 1
        end
    end
    progress_stop(prog)

    local left = scan_created()
    local remaining = #left.presets + #left.sequences + #left.apps + #left.elements
    local lines = {
        string.format("Layouts : %d supprime(s), %d tuile(s) retiree(s)", done.layouts, done.elements),
        string.format("Sequences : %d, presets : %d, apparences : %d", done.sequences, done.presets, done.apps),
    }
    local kept = {}
    for _, lno in ipairs(f.layouts) do if get_layout(lno) then kept[#kept + 1] = lno end end
    if #kept > 0 then lines[#lines + 1] = "Layout(s) conserve(s) (non vides) : " .. table.concat(kept, ", ") end
    if remaining > 0 and all_selected and (want.lay and want.seq and want.pre and want.app) then
        lines[#lines + 1] = string.format("Attention : %d objet(s) marque(s) restent (suppression refusee).", remaining)
    end
    if not all_selected and want.lay then
        lines[#lines + 1] = "Selection partielle : titres et layouts restent en place (seuls tuiles et cadres du type retires)."
    end
    lines[#lines + 1] = "\nUn seul Oops annule tout."
    show_info(PLUGIN_NAME .. " - Nettoyer", table.concat(lines, "\n"))
end

-- ---------------------------------------------------------------------------
-- Actualiser : apres un changement de librairie / de mode, reecrit les valeurs des presets GoboRecipes
-- existants (sans rien supprimer) et remet a jour leurs noms et leurs cles
-- ---------------------------------------------------------------------------
-- remet en forme les layouts GoboRecipes existants : etiquettes (teinte par genre, centrees), cadre decale a
-- droite des etiquettes et sans bordure. Ne supprime rien, ne deplace pas les tuiles.
local function repair_layouts()
    local used_app = pool_numbers(appearances_list)
    local cursor = new_cursor(used_app, 5)
    local res = { layouts = 0, labels = 0, frames = 0 }
    local function signed(v) if v and v > 32767 and v < 65536 then return v - 65536 end return v end
    for _, ly in ipairs(layouts_list()) do
        local no = tonumber(rp(ly, "No"))
        local frames, labels = {}, {}
        for i, el in ipairs(kids(ly)) do
            local note = tostring(rp(el, "Note") or "")
            local k, rest = note:match("^" .. TAG .. "|E|(%u)|(.*)$")
            if k == "F" or k == "L" then
                local d = {
                    i = i, type = (k == "F") and rest or rest:match("^(.-)|"),
                    x = signed(read_num(el, { "PosX", "PositionX", "X" }, "posx")),
                    w = read_num(el, { "Width" }, "width"),
                    text = tostring(rp(el, "CustomTextText") or ""),
                }
                if k == "F" then frames[#frames + 1] = d else labels[#labels + 1] = d end
            end
        end
        if no and (#frames > 0 or #labels > 0) then
            res.layouts = res.layouts + 1
            local bg = find_appearance(PREFERRED_FRAME) and PREFERRED_FRAME or (find_appearance(FRAME_APPEARANCE) and FRAME_APPEARANCE or nil)
            for _, L in ipairs(labels) do
                local t = L.text
                local rot = t:sub(1, 1) == "<"
                local shk = t:sub(-1) == "*"
                local cls = rot and (shk and "rotshk" or "rot") or (shk and "shk" or "idx")
                local ap = tab_appearance(cls, used_app, cursor) or bg
                if ap then set_element_text(no, L.i, "Appearance", ap) end
                set_element_text(no, L.i, "CustomTextAlignmentH", "Centre")
                set_text_white(no, L.i)
                res.labels = res.labels + 1
            end
            for _, F in ipairs(frames) do
                local right = nil
                for _, L in ipairs(labels) do
                    if L.type == F.type and L.x and L.w then right = math.max(right or -1e9, L.x + L.w) end
                end
                if right and F.x and F.w and F.x < right - 1 then
                    set_element(no, F.i, "PosX", right)
                    set_element(no, F.i, "Width", F.x + F.w - right)
                end
                set_element_text(no, F.i, "VisibilityBorder", "Hidden")
                res.frames = res.frames + 1
            end
        end
    end
    return res
end

local function update_step(group_no, group_name)
    if not group_no then
        group_no, group_name = choose_group()
        if not group_no then return end
    end
    group_name = group_name or ("Groupe " .. group_no)
    local types = read_group_types(group_no)
    if #types == 0 then
        show_info(PLUGIN_NAME, string.format("Le groupe %d est vide ou illisible.", group_no))
        return
    end
    local by_type = {}
    for _, t in ipairs(types) do
        t.short = load_setting("TypeName|" .. t.type_name, t.short)
        by_type[t.type_name] = t
    end
    local gpool = tonumber(load_setting("GoboPool", tostring(DEFAULT_GOBO_POOL))) or DEFAULT_GOBO_POOL
    local ppool = tonumber(load_setting("PrismPool", tostring(DEFAULT_PRISM_POOL))) or DEFAULT_PRISM_POOL
    -- elements actuels de la librairie
    local by_key, by_name = {}, { gobo = {}, prism = {} }
    local all_items = {}
    for _, kind in ipairs({ "gobo", "prism" }) do
        for _, t in ipairs(types) do
            for _, it in ipairs(scan_type(t, kind)) do
                all_items[#all_items + 1] = it
                by_key[it.key] = it
                local nm = clean_label(string.format("%s %s", it.t.short, it.name)):lower()
                by_name[kind][nm] = by_name[kind][nm] and false or it     -- false = ambigu
            end
        end
    end
    -- presets GoboRecipes existants de ces types
    local pools, seen = {}, {}
    for _, pl in ipairs({ gpool, ppool }) do if not seen[pl] then seen[pl] = true; pools[#pools + 1] = pl end end
    local matched, orphans = {}, {}
    local used_items = {}
    for _, pl in ipairs(pools) do
        for _, pr in ipairs(preset_pool_children(pl)) do
            local note = tostring(rp(pr, "Note") or "")
            if note:sub(1, #TAG + 3) == TAG .. "|P|" then
                local key = note:sub(#TAG + 4)
                local ty = key:match("^([^|]*)|")
                if ty and by_type[ty] then
                    local no = tonumber(rp(pr, "No"))
                    local it = by_key[key]
                    local how = "cle"
                    if not it and gpool ~= ppool then
                        local kind = (pl == ppool) and "prism" or "gobo"
                        local nm = tostring(rp(pr, "Name") or ""):lower()
                        local cand = by_name[kind][nm]
                        if cand then it = cand; how = "nom" end
                    end
                    if it and not used_items[it] then
                        used_items[it] = true
                        matched[#matched + 1] = { pool = pl, no = no, item = it, old_key = key, how = how, name = tostring(rp(pr, "Name") or "") }
                    else
                        orphans[#orphans + 1] = { pool = pl, no = no, name = tostring(rp(pr, "Name") or "") }
                    end
                end
            end
        end
    end
    local new_count = 0
    for _, it in ipairs(all_items) do if not used_items[it] then new_count = new_count + 1 end end
    local has_lay = false
    for _, ly in ipairs(layouts_list()) do
        for _, el in ipairs(kids(ly)) do
            if tostring(rp(el, "Note") or ""):sub(1, #TAG + 3) == TAG .. "|E|" then has_lay = true; break end
        end
        if has_lay then break end
    end
    if #matched == 0 and #orphans == 0 and not has_lay then
        show_info(PLUGIN_NAME .. " - Actualiser", "Rien a actualiser pour ce groupe.")
        return
    end
    local by_name_n = 0
    for _, m in ipairs(matched) do if m.how == "nom" then by_name_n = by_name_n + 1 end end
    local r = ui_list_dialog({
        title = PLUGIN_NAME .. " - Actualiser",
        items = {
            { key = "val", text = string.format("Valeurs des presets (%d)", #matched) },
            { key = "nom", text = "Noms des presets" },
            { key = "lay", text = "Mise en forme des layouts" },
            { key = "cmd", text = "Boutons Tout open / Stop / Slow / Fast" },
        },
        checked = { val = true, nom = true, lay = has_lay, cmd = true },
        help = string.format("%d preset(s) retrouves (%d par nom), %d sans equivalent (gardes), %d nouveau(x) non crees.",
            #matched, by_name_n, #orphans, new_count),
        empty_text = "Rien de coche.", count_label = "Actions",
        buttons = { { "Actualiser", 1, "needs" }, { "Annuler", 0 } },
    })
    if not r or r.result ~= 1 then return end
    local want = r.states
    local report = { forms = {}, presets = 0 }
    local prog = progress_start("Actualiser", #matched)
    local ok_n, fail = 0, {}
    local rekey = {}
    for _, m in ipairs(matched) do
        progress_step(prog, m.name)
        local ok = true
        if want.val then
            local good, why = store_preset(m.item, m.pool, m.no, report, true)
            if not good then ok = false; fail[#fail + 1] = string.format("%s : %s", m.name, tostring(why)) end
        end
        if ok then
            ok_n = ok_n + 1
            if want.nom then
                Cmd(string.format('Label Preset %d.%d "%s"', m.pool, m.no,
                    clean_label(string.format("%s %s", m.item.t.short, m.item.name))))
            end
            if m.item.key ~= m.old_key then
                Cmd(string.format('Set Preset %d.%d Property "Note" "%s"', m.pool, m.no, safe(TAG .. "|P|" .. m.item.key)))
                rekey[m.old_key] = m.item.key
            end
        end
    end
    local lay_res = nil
    if want.lay and has_lay then lay_res = repair_layouts() end
    local cmd_res = nil
    if want.cmd then
        local okc, rc = pcall(build_commands, group_no, group_name, types, tonumber(load_setting("Layout", "0")) or 0)
        if okc then cmd_res = rc else fail[#fail + 1] = "boutons : " .. tostring(rc) end
    end
    -- les sequences retrouvent leur preset par la meme cle
    local n_seq = 0
    for _, sq in ipairs(sequences_list()) do
        local note = tostring(rp(sq, "Note") or "")
        local pre, key = note:match("^(" .. TAG .. "|S|g%d+|)(.*)$")
        if pre and rekey[key] then
            Cmd(string.format('Set Sequence %d Property "Note" "%s"', tonumber(rp(sq, "No")), safe(pre .. rekey[key])))
            n_seq = n_seq + 1
        end
    end
    progress_stop(prog)
    local lines = { string.format("Presets : %d / %d actualises", ok_n, #matched) }
    if lay_res then lines[#lines + 1] = string.format("Layouts : %d mis en forme", lay_res.layouts) end
    if cmd_res then
        lines[#lines + 1] = string.format("Boutons : %d crees, %d poses", cmd_res.made, cmd_res.put)
        if #cmd_res.presets > 0 then lines[#lines + 1] = "Presets de vitesse crees : " .. table.concat(cmd_res.presets, ", ") end
        for i = 1, math.min(3, #cmd_res.warns) do lines[#lines + 1] = "- " .. cmd_res.warns[i] end
    end
    if new_count > 0 then lines[#lines + 1] = string.format("%d nouveau(x) element(s) : utilise Gobos / Prismes", new_count) end
    for i = 1, math.min(5, #fail) do lines[#lines + 1] = "- " .. fail[i] end
    if #fail > 5 then lines[#lines + 1] = string.format("(+ %d autres)", #fail - 5) end
    show_info(PLUGIN_NAME .. " - Actualiser", table.concat(lines, "\n"))
end

local function probe_step(group_no)
    if not group_no then
        group_no = choose_group()
        if not group_no then return end
    end
    local path = run_probe(group_no)
    show_info(PLUGIN_NAME .. " - Sonde", path and ("Releve ecrit : " .. path) or "Releve affiche dans le System Monitor.")
end

local function home_menu()
    local r = MessageBox({
        title = PLUGIN_NAME .. "  v" .. VERSION,
        message = "Choisis une famille.",
        commands = {
            { value = 1, name = "Gobos" },
            { value = 2, name = "Prismes" },
            { value = 6, name = "Options" },
            { value = 0, name = "Fermer" },
        },
    })
    if not r or r.result == nil or r.result == 0 then return nil end
    return r.result
end

-- ---------------------------------------------------------------------------
-- Boutons de commande : Tout open / Stop / Slow / Fast (sequences recipe + barre en haut d'un layout)
-- ---------------------------------------------------------------------------
local PRESET_POOL_NAMES = { "Dim", "Position", "Gobo", "Couleur", "Beam", "Focus", "Control", "Shapers", "Video", "Pool 10" }
local SPEED_KEYS = { { "stop", "Stop" }, { "slow", "Slow" }, { "fast", "Fast" } }

local function preset_label(pool, no)
    local o = preset_object(pool, no)
    if not o then return string.format("%d.%d (introuvable)", pool, no) end
    return string.format("%d.%d  %s", pool, no, tostring(rp(o, "Name") or ""))
end

local function saved_speed(key)
    local raw = load_setting("Speed|" .. key, "")
    local pl, no = raw:match("^(%d+)%.(%d+)$")
    if not pl then return nil end
    pl, no = tonumber(pl), tonumber(no)
    if not preset_object(pl, no) then return nil end
    return pl, no
end

-- liste de tous les presets (une page = une serie), choix unique
local function choose_preset(title, cur_pool, cur_no)
    local items, checked = {}, {}
    for pl = 1, 10 do
        for _, pr in ipairs(preset_pool_children(pl)) do
            local no = tonumber(rp(pr, "No"))
            if no then
                local k = pl .. "." .. no
                items[#items + 1] = { key = k, text = string.format("%s %d  %s", PRESET_POOL_NAMES[pl] or "", no, tostring(rp(pr, "Name") or "")) }
                if cur_pool == pl and cur_no == no then checked[k] = true end
            end
        end
    end
    if #items == 0 then
        show_info(PLUGIN_NAME, "Aucun preset trouve dans les pools.")
        return nil
    end
    local r = ui_list_dialog({
        title = PLUGIN_NAME .. " - " .. title, single = true, items = items, checked = checked,
        help = "Choisis ton preset.", empty_text = "Choisis un preset.", count_label = "Preset",
        buttons = { { "Choisir", 1, "needs" }, { "Annuler", 0 } },
    })
    if not r or r.result ~= 1 then return nil end
    for _, it in ipairs(items) do
        if r.states[it.key] then
            local pl, no = it.key:match("^(%d+)%.(%d+)$")
            return tonumber(pl), tonumber(no)
        end
    end
    return nil
end

local function speeds_menu()
    for _ = 1, 20 do
        local cmds = {}
        for i, sk in ipairs(SPEED_KEYS) do
            local pl, no = saved_speed(sk[1])
            cmds[#cmds + 1] = { value = i, name = sk[2] .. " : " .. (pl and preset_label(pl, no) or "non defini") }
        end
        cmds[#cmds + 1] = { value = 0, name = "Retour" }
        local r = MessageBox({
            title = PLUGIN_NAME .. " - Vitesses de rotation",
            message = "Un preset par vitesse, pour tous les projecteurs.",
            commands = cmds,
        })
        if not r or r.result == nil or r.result == 0 then return end
        local sk = SPEED_KEYS[r.result]
        if not sk then return end
        local cpl, cno = saved_speed(sk[1])
        local pl, no = choose_preset("Preset " .. sk[2], cpl, cno)
        if pl then save_setting("Speed|" .. sk[1], pl .. "." .. no) end
    end
end

local CMD_BTN_W = 140
local function place_buttons(no, entries, warn)
    if #entries == 0 then return 0 end
    if not get_layout(no) then
        Cmd("Store Layout " .. no)
        Cmd(string.format('Label Layout %d "Commandes"', no))
        Cmd(string.format('Set Layout %d Property "Note" "%s|L|group=Commandes"', no, TAG))
    end
    local function signed(v) if v and v > 32767 and v < 65536 then return v - 65536 end return v end
    local minx, top, tile_y
    local placed = {}
    for _, el in ipairs(kids(get_layout(no))) do
        local x = signed(read_num(el, { "PosX", "PositionX", "X" }, "posx"))
        local y = signed(read_num(el, { "PosY", "PositionY", "Y" }, "posy"))
        local h = read_num(el, { "Height" }, "height") or 0
        if x then minx = minx and math.min(minx, x) or x end
        if y then top = top and math.max(top, y + h) or (y + h) end
        local tno = tostring(rp(el, "Note") or ""):match("^" .. TAG .. "|E|T|(%d+)$")
        if tno then placed[tonumber(tno)] = { x = x, y = y } end
    end
    -- boutons deja poses : on garde leur rangee et on continue a droite
    local last_x, row_y
    for _, e in ipairs(entries) do
        local pl = placed[e.seq_no]
        if pl then
            last_x = last_x and math.max(last_x, pl.x) or pl.x
            row_y = pl.y
        end
    end
    local n = 0
    local x = last_x and (last_x + CMD_BTN_W + GAP) or (minx or -300)
    local y = row_y or ((top or 0) + 60)
    for _, e in ipairs(entries) do
        if not placed[e.seq_no] then
            local before = #layout_elements(no)
            Cmd(string.format("Assign Sequence %d At Layout %d", e.seq_no, no))
            pause(0.03)
            local after = #layout_elements(no)
            if after == before + 1 then
                Cmd(string.format('Set Layout %d.%d Property "Note" "%s|E|T|%d"', no, after, TAG, e.seq_no))
                set_element(no, after, "Width", CMD_BTN_W)
                set_element(no, after, "Height", TILE)
                set_element(no, after, "PosX", x)
                set_element(no, after, "PosY", y)
                local el = layout_elements(no)[after]
                for _, kv in ipairs(TILE_STYLE) do
                    if kv[1] ~= "VisibilityObjectName" and (not el or find_prop(el, { kv[1] })) then
                        set_element_text(no, after, kv[1], kv[2])
                    end
                end
                set_element_text(no, after, "VisibilityObjectName", "Visible")
                x = x + CMD_BTN_W + GAP
                n = n + 1
            else
                warn(string.format("sequence %d : %d element(s) ajoute(s) au lieu de 1", e.seq_no, after - before))
            end
        end
    end
    return n
end

local function cmd_appearance(name, rgb, used_app, cursor)
    if find_appearance(name) then return tonumber(rp(find_appearance(name), "No")) end
    local no = alloc(used_app, cursor)
    Cmd(string.format("Store Appearance %d", no))
    Cmd(string.format('Label Appearance %d "%s"', no, name))
    Cmd(string.format('Set Appearance %d Property "BackR" %d', no, rgb[1]))
    Cmd(string.format('Set Appearance %d Property "BackG" %d', no, rgb[2]))
    Cmd(string.format('Set Appearance %d Property "BackB" %d', no, rgb[3]))
    Cmd(string.format('Set Appearance %d Property "BackAlpha" %d', no, 255))
    Cmd(string.format('Set Appearance %d Property "Note" "%s"', no, safe(TAG .. "|A|" .. name)))
    return no
end

-- fonctions de rotation de la librairie pour un type : { {attr, lc_attr, stop, slow, fast} } ; chaque vitesse
-- = { name (si unique), rel (% dans la fonction) }
local function rotation_speeds(t)
    local out = {}
    local modes = child_named(t.ftype, { "DMXModes" })
    local mode = nil
    for _, m in ipairs(kids(modes)) do
        if t.mode_name == "" or oname(m) == t.mode_name then mode = m; break end
    end
    mode = mode or kids(modes)[1]
    local chans = child_named(mode, { "DMXChannels" })
    for _, dch in ipairs(kids(chans)) do
        for _, lc in ipairs(kids(dch)) do
            local lattr = attr_of(lc)
            for _, cf in ipairs(kids(lc)) do
                local cattr = attr_of(cf)
                local n = norm(cattr)
                if n:match("posrotate$") or n:match("^effect%d*rotate$") then
                    local sets, counts = {}, {}
                    for _, cs in ipairs(kids(cf)) do
                        local nm = oname(cs)
                        local from = to_number(rp(cs, "DMXFrom")) or 0
                        sets[#sets + 1] = { name = nm, low = nm:lower(), from = from, to = to_number(rp(cs, "DMXTo")) or from }
                        counts[nm] = (counts[nm] or 0) + 1
                    end
                    table.sort(sets, function(x, y) return x.from < y.from end)
                    local cf_from = sets[1] and sets[1].from or 0
                    local cf_to = sets[#sets] and sets[#sets].to or MAX_DMX24
                    local function pack(st)
                        if not st then return nil end
                        local rel = 50
                        if cf_to > cf_from then rel = math.max(0, math.min(100, ((st.from + st.to) / 2 - cf_from) / (cf_to - cf_from) * 100)) end
                        return { name = (counts[st.name] == 1 and st.name ~= "") and st.name or nil, rel = rel }
                    end
                    local function rel_of(dmx)
                        if cf_to <= cf_from then return 50 end
                        return math.max(0, math.min(100, (dmx - cf_from) / (cf_to - cf_from) * 100))
                    end
                    local stop_i = nil
                    for i, st in ipairs(sets) do
                        if not stop_i and (st.low:find("stop", 1, true) or st.low:find("no rot", 1, true)) then stop_i = i end
                    end
                    if stop_i then
                        local slow_v, fast_v = nil, nil
                        -- 1) sets marques ">" : plus il y en a, plus c'est rapide
                        local fwd = {}
                        for i, st in ipairs(sets) do
                            if i ~= stop_i then
                                local _, gt = st.name:gsub(">", "")
                                if gt > 0 and not st.name:find("<", 1, true) then fwd[#fwd + 1] = { st = st, k = gt } end
                            end
                        end
                        if #fwd > 0 then
                            local lo, hi = fwd[1], fwd[1]
                            for _, f in ipairs(fwd) do
                                if f.k < lo.k then lo = f end
                                if f.k >= hi.k then hi = f end
                            end
                            slow_v, fast_v = pack(lo.st), pack(hi.st)
                        end
                        -- 2) rampes "Fast to slow n/N" / "Slow to fast" apres le stop : on prend la premiere serie continue
                        if not slow_v then
                            local first
                            for i = stop_i + 1, #sets do
                                if sets[i].low:find(" to ", 1, true) then first = i; break end
                            end
                            if first then
                                local dir = sets[first].low:match("^(%a+)")
                                local last = first
                                while sets[last + 1] and sets[last + 1].low:find(" to ", 1, true) and sets[last + 1].low:match("^(%a+)") == dir do
                                    last = last + 1
                                end
                                local lo, hi = sets[first].from, sets[last].to
                                local m = (hi - lo) * 0.03
                                if dir == "fast" then
                                    fast_v, slow_v = { rel = rel_of(lo + m) }, { rel = rel_of(hi - m) }
                                else
                                    slow_v, fast_v = { rel = rel_of(lo + m) }, { rel = rel_of(hi - m) }
                                end
                            end
                        end
                        -- 3) sets nommes slow / fast
                        if not slow_v then
                            for i = stop_i + 1, #sets do
                                local l = sets[i].low
                                if not slow_v and l:find("slow", 1, true) and not l:find("fast", 1, true) then slow_v = pack(sets[i]) end
                                if not fast_v and l:find("fast", 1, true) and not l:find("slow", 1, true) then fast_v = pack(sets[i]) end
                            end
                        end
                        -- 4) dernier recours : premier et dernier sets apres le stop
                        if not slow_v then
                            local after = {}
                            for i = stop_i + 1, #sets do
                                if not sets[i].low:find("stop", 1, true) then after[#after + 1] = sets[i] end
                            end
                            if #after > 0 then slow_v, fast_v = pack(after[1]), pack(after[#after]) end
                        end
                        if slow_v and fast_v then
                            out[#out + 1] = { attr = cattr, lc_attr = lattr, stop = pack(sets[stop_i]), slow = slow_v, fast = fast_v }
                        end
                    end
                end
            end
        end
    end
    return out
end

-- cree les presets Stop / Slow / Fast manquants (un preset par vitesse pour tout le groupe) ; renvoie les creations
local function ensure_speed_presets(group_no, types, warn)
    local gpool = tonumber(load_setting("GoboPool", tostring(DEFAULT_GOBO_POOL))) or DEFAULT_GOBO_POOL
    local used_pre = pool_numbers(function() return preset_pool_children(gpool) end)
    local made = {}
    local per_type
    local cursor = new_cursor(used_pre, #SPEED_KEYS, 900)
    for _, sk in ipairs(SPEED_KEYS) do
        if not saved_speed(sk[1]) then
            if not per_type then
                per_type = {}
                for _, t in ipairs(types) do
                    local list = rotation_speeds(t)
                    if #list > 0 then per_type[#per_type + 1] = { t = t, list = list } end
                end
            end
            if #per_type == 0 then
                warn("aucune fonction de rotation lisible dans la librairie : preset " .. sk[2] .. " non cree")
            else
                local no = alloc(used_pre, cursor)
                Cmd("ClearAll")
                local applied = 0
                for _, pt in ipairs(per_type) do
                    if pt.t.fids and #pt.t.fids > 0 then
                        Cmd("Fixture " .. table.concat(pt.t.fids, " + "))
                        pause(0.05)
                        for _, rs in ipairs(pt.list) do
                            local sp = rs[sk[1]]
                            if sp and apply_rotation(pt.t, { attr = rs.attr, lc_attr = rs.lc_attr, set_name = sp.name, rel = sp.rel }) then
                                applied = applied + 1
                            end
                        end
                    end
                end
                if applied > 0 then
                    Cmd(string.format("Store Preset %d.%d /Global /NoConfirmation", gpool, no))
                    pause(0.05)
                    local obj = preset_object(gpool, no)
                    if obj and not object_empty(obj) then
                        Cmd(string.format('Label Preset %d.%d "Rot %s"', gpool, no, sk[2]))
                        Cmd(string.format('Set Preset %d.%d Property "Note" "%s"', gpool, no, safe(TAG .. "|P|Vitesse|" .. sk[1])))
                        save_setting("Speed|" .. sk[1], gpool .. "." .. no)
                        made[#made + 1] = sk[2]
                    else
                        if obj then Cmd(string.format("Delete Preset %d.%d /NoConfirmation", gpool, no)) end
                        warn("preset " .. sk[2] .. " vide apres ecriture : associe le tien dans Options > Vitesses de rotation")
                    end
                else
                    warn("preset " .. sk[2] .. " : valeurs de rotation non appliquees")
                end
                Cmd("ClearAll")
            end
        end
    end
    return made
end

-- cree / met a jour les sequences recipe (Tout open, Stop, Slow, Fast) et les pose en haut du layout
build_commands = function(group_no, group_name, types, layout_no)
    local warns = {}
    local function warn(m) warns[#warns + 1] = m end
    local made_presets = ensure_speed_presets(group_no, types, warn)
    local gpool = tonumber(load_setting("GoboPool", tostring(DEFAULT_GOBO_POOL))) or DEFAULT_GOBO_POOL
    local known = {}
    for _, pr in ipairs(preset_pool_children(gpool)) do
        local note = tostring(rp(pr, "Note") or "")
        if note:sub(1, #TAG + 3) == TAG .. "|P|" then known[note:sub(#TAG + 4)] = tonumber(rp(pr, "No")) end
    end
    local opens = {}
    for _, t in ipairs(types) do
        for _, it in ipairs(scan_type(t, "gobo")) do
            if class_of(it) == "idx" and (it.base or ""):lower():find("open", 1, true) and known[it.key] then
                opens[#opens + 1] = { gpool, known[it.key] }
            end
        end
    end
    local buttons = {}
    if #opens > 0 then
        buttons[#buttons + 1] = { key = "open", name = "Tout open", pool = opens[1][1], no = opens[1][2],
            extras = { table.unpack(opens, 2) }, rgb = { 70, 70, 76 } }
    else
        warn("Tout open : aucun preset open trouve (cree d'abord les gobos de ce groupe)")
    end
    for _, sk in ipairs(SPEED_KEYS) do
        local pl, no = saved_speed(sk[1])
        if pl then
            buttons[#buttons + 1] = { key = sk[1], name = sk[2] .. " rotation", pool = pl, no = no, rgb = { 30, 92, 114 } }
        end
    end
    local result = { made = 0, put = 0, presets = made_presets, warns = warns }
    if #buttons == 0 then return result end
    local used_seq = pool_numbers(sequences_list)
    local used_app = pool_numbers(appearances_list)
    local known_seq = existing_by_note(sequences_list(), TAG .. "|S|")
    local seq_cursor = new_cursor(used_seq, #buttons)
    local app_cursor = new_cursor(used_app, 4)
    local on_app = cmd_appearance("GBR CMD on", { 110, 215, 110 }, used_app, app_cursor)
    local entries = {}
    local prog = progress_start("Boutons", #buttons)
    for _, b in ipairs(buttons) do
        progress_step(prog, b.name)
        local off_app = cmd_appearance("GBR CMD " .. b.key, b.rgb, used_app, app_cursor)
        local skey = safe(string.format("%s|S|g%d|Commandes|%s", TAG, group_no, b.key))
        local seq_no = known_seq[skey]
        local name = clean_label(b.name)
        if seq_no then
            -- deja la : on remet les lignes de recipe a jour (preset de vitesse change, nouveaux open)
            Cmd(string.format("Assign Preset %d.%d At Sequence %d Cue 1 Part 0.1", b.pool, b.no, seq_no))
            for i, e in ipairs(b.extras or {}) do
                Cmd(string.format("Assign Group %d At Sequence %d Cue 1 Part 0.%d", group_no, seq_no, i + 1))
                Cmd(string.format("Assign Preset %d.%d At Sequence %d Cue 1 Part 0.%d", e[1], e[2], seq_no, i + 1))
            end
        else
            seq_no = alloc(used_seq, seq_cursor)
            make_sequence(seq_no, name, group_no, b.pool, b.no, off_app, on_app, name, skey, warn, b.extras)
            known_seq[skey] = seq_no
            result.made = result.made + 1
        end
        entries[#entries + 1] = { seq_no = seq_no }
    end
    progress_stop(prog)
    if layout_no and layout_no > 0 then result.put = place_buttons(layout_no, entries, warn) end
    return result
end


local function options_menu()
    local r = MessageBox({
        title = PLUGIN_NAME .. " - Options",
        message = "Actualiser : librairie, mode, layouts, boutons.\nNettoyer : efface seulement ce que le plugin a cree.",
        commands = {
            { value = 7, name = "Vitesses de rotation" },
            { value = 5, name = "Actualiser" },
            { value = 4, name = "Nettoyer" },
            { value = 3, name = "Sonde" },
            { value = 0, name = "Retour" },
        },
    })
    if not r or r.result == nil or r.result == 0 then return nil end
    return r.result
end

local function run_main(args)
    local text = trim(args):lower()
    if text ~= "" then
        local no = tonumber(text:match("(%d+)"))
        if text:find("clean", 1, true) or text:find("nettoy", 1, true) then
            clean_step()
        elseif text:find("update", 1, true) or text:find("actualis", 1, true) then
            update_step(no)
        elseif text:find("probe", 1, true) or text:find("sonde", 1, true) then
            probe_step(no)
        elseif text:find("prism", 1, true) then
            family_step("prism", no)
        else
            family_step("gobo", no)
        end
        return
    end
    -- on revient au menu apres chaque action ; un Oops par action
    local guard = 0
    while guard < 50 do
        guard = guard + 1
        local mode = home_menu()
        if not mode then break end
        if mode == 6 then
            mode = options_menu()
            if not mode then mode = -1 end
        end
        if mode == 1 then family_step("gobo")
        elseif mode == 2 then family_step("prism")
        elseif mode == 3 then probe_step()
        elseif mode == 4 then clean_step()
        elseif mode == 5 then update_step()
        elseif mode == 7 then speeds_menu()
        elseif mode ~= -1 then break end
        progress_stop_all()
        if current_undo then pcall(CloseUndo, current_undo) end
        local okn, nu = pcall(CreateUndo, PLUGIN_NAME)
        current_undo = okn and nu or nil
    end
end

local function main(display_handle, args)
    local ok_undo, undo = pcall(CreateUndo, PLUGIN_NAME)
    current_undo = ok_undo and undo or nil
    local ok, err = xpcall(run_main, function(e)
        local tb = debug and debug.traceback and debug.traceback(tostring(e), 2) or tostring(e)
        pcall(Printf, PLUGIN_NAME .. " ERREUR : " .. tb:gsub("\n", " | "))
        return tb
    end, args)
    progress_stop_all()
    if current_undo then pcall(CloseUndo, current_undo) end
    current_undo = nil
    if not ok then error(err, 0) end
end

if rawget(_G, "GBR_TEST") then
    return {
        clean_step = clean_step, update_step = update_step, build_commands = function(...) return build_commands(...) end, rotation_speeds = rotation_speeds, place_buttons = place_buttons, saved_speed = saved_speed, scan_created = scan_created, filter_created = filter_created, hundreds_start = hundreds_start,
        settle_block = settle_block, main = main, scan_type = scan_type, read_group_types = read_group_types, create_all = create_all,
        value_percent = value_percent, value_commands = value_commands, store_preset = store_preset, run_probe = run_probe, item_text = item_text,
    }
end

return main

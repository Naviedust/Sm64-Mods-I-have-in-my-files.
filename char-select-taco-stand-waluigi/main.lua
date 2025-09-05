-- name: [CS] \\#FFC168\\Taco Stand\\#6300C5\\ Waluigi
-- description: After Waluigi lost his money in the Casino, he needed a job. His landowner gave him the opportunity to pay up by working a taco stand!\n\nModel and Texture edits by: WBmarioo\nHealth Texture Text: mingokrb\nOriginal Model Edits by: Kaze\nOriginal Model by: FluffaMario\nCoop Templates by: xLuigiGamerx\n\n\\#ff7777\\This Pack requires Character Select\nto use as a Library!

-- Replace Mod Name with your Character/Pack name.
local TEXT_MOD_NAME = "Taco Stand Waluigi"

-- Stops mod from loading if Character Select isn't on, Does not need to be touched
if not _G.charSelectExists then
    djui_popup_create("\\#ffffdc\\\n"..TEXT_MOD_NAME.."\nRequires the Character Select Mod\nto use as a Library!\n\nPlease turn on the Character Select Mod\nand Restart the Room!", 6)
    return 0
end

local VOICETABLE_TACO_WALUIGI = {
    [CHAR_SOUND_OKEY_DOKEY] = 'taco_okiedokie.ogg', -- Starting game
	[CHAR_SOUND_LETS_A_GO] = 'taco_startlevel.ogg', -- Starting level
	[CHAR_SOUND_PUNCH_YAH] = 'taco_hit1.ogg', -- Punch 1
	[CHAR_SOUND_PUNCH_WAH] = 'taco_hit2.ogg', -- Punch 2
    [CHAR_SOUND_WAH2] = 'taco_throwobj.ogg', -- Throwing an object
	[CHAR_SOUND_PUNCH_HOO] = 'taco_kick3.ogg', -- Punch 3
	[CHAR_SOUND_YAH_WAH_HOO] = {'taco_jump1.ogg', 'taco_jump2.ogg', 'taco_hit1.ogg'}, -- First/Second jump sounds
	[CHAR_SOUND_HOOHOO] = 'taco_doublejump.ogg', -- Third jump sound
	[CHAR_SOUND_YAHOO_WAHA_YIPPEE] = {'taco_triple1.ogg', 'taco_triple2.ogg', 'taco_longjump.ogg'}, -- Triple jump sounds
	[CHAR_SOUND_UH] = 'taco_smallbonk.ogg', -- Wall bonk
	[CHAR_SOUND_UH2] = 'taco_grabledgequick.ogg', -- Landing after long jump
	[CHAR_SOUND_UH2_2] = 'taco_grabledgequick.ogg', -- Same sound as UH2; jumping onto ledge
	[CHAR_SOUND_HAHA] = 'taco_haha.ogg', -- Landing triple jump
    [CHAR_SOUND_HAHA_2] = 'taco_haha.ogg', -- Landing triple jump
	[CHAR_SOUND_YAHOO] = 'taco_longjump.ogg', -- Long jump
	[CHAR_SOUND_DOH] = 'taco_bigbonk.ogg', -- Long jump wall bonk
	[CHAR_SOUND_WHOA] = 'taco_fallledge.ogg', -- Grabbing ledge
	[CHAR_SOUND_EEUH] = 'taco_slowledgegrab.ogg', -- Climbing over ledge
	[CHAR_SOUND_WAAAOOOW] = 'taco_fall.ogg', -- Falling a long distance
	[CHAR_SOUND_TWIRL_BOUNCE] = 'taco_boing.ogg', -- Bouncing off of a flower spring
	[CHAR_SOUND_GROUND_POUND_WAH] = 'taco_throwobj.ogg',
	[CHAR_SOUND_HRMM] = 'taco_liftobj.ogg', -- Lifting something
	[CHAR_SOUND_HERE_WE_GO] = 'taco_starget.ogg', -- Star get
	[CHAR_SOUND_SO_LONGA_BOWSER] = 'taco_throwbowser.ogg', -- Throwing Bowser
 	[CHAR_SOUND_OOOF] = 'taco_bonkground.ogg',
 	[CHAR_SOUND_OOOF2] = 'taco_bonkground.ogg',
    [CHAR_SOUND_HELLO] = 'taco_greet.ogg',
    [CHAR_SOUND_PRESS_START_TO_PLAY] = 'taco_pressstart.ogg',
    [CHAR_SOUND_GAME_OVER] = 'taco_gameover.ogg',
--DAMAGE
	[CHAR_SOUND_ATTACKED] = 'taco_damage1.ogg', -- Damaged
	[CHAR_SOUND_PANTING] = 'taco_pant.ogg', -- Low Health
    [CHAR_SOUND_PANTING_COLD] = 'taco_pant.ogg', -- In the cold
	[CHAR_SOUND_ON_FIRE] = 'taco_lava.ogg', -- Burned
--SLEEP SOUNDS
	[CHAR_SOUND_IMA_TIRED] = nil, -- Mario feeling tired
	[CHAR_SOUND_YAWNING] = nil, -- Mario yawning before he sits down to sleep
	[CHAR_SOUND_SNORING1] = 'taco_inhale.ogg', -- Snore Inhale
	[CHAR_SOUND_SNORING2] = 'taco_exhale.ogg', -- Exhale
	[CHAR_SOUND_SNORING3] = nil, -- Sleep talking / mumbling
--COUGHING (USED IN THE GAS MAZE)
	[CHAR_SOUND_COUGHING1] = 'taco_cough.ogg', -- Cough take 1
	[CHAR_SOUND_COUGHING2] = 'taco_cough.ogg', -- Cough take 2
	[CHAR_SOUND_COUGHING3] = 'taco_cough.ogg', -- Cough take 3
--DEATH
	[CHAR_SOUND_DYING] = 'taco_death.ogg', -- Dying from damage
	[CHAR_SOUND_DROWNING] = 'taco_drown.ogg', -- Running out of air underwater
	[CHAR_SOUND_MAMA_MIA] = 'taco_recover.ogg' -- Booted out of level
}

local E_MODEL_TACO_WALUIGI = smlua_model_util_get_id("taco_stand_waluigi_geo")

local E_MODEL_TACO_STAR = smlua_model_util_get_id("taco_star_geo")

local TEX_TACO_STAND_WALUIGI_LIFE_ICON = get_texture_info("taco_stand_waluigi_lives_icon")

local TEX_TACO_STAR = get_texture_info("taco_star")

local TACO_WALUIGI_CAPMODELS = {
    normal = smlua_model_util_get_id("taco_stand_waluigis_cap_geo"),
    wing = smlua_model_util_get_id("taco_stand_waluigis_wing_cap_geo"),
    metal = smlua_model_util_get_id("taco_stand_waluigis_metal_cap_geo"),
    metalWing = smlua_model_util_get_id("taco_stand_waluigis_winged_metal_cap_geo"),
}

local HEALTH_METER_TACO_WALUIGI = {
    label = {
        left = get_texture_info("taco-left"),
        right = get_texture_info("taco-right"),
    },
        pie = {
        TEX_DEFAULT_METER_PIE1,
        TEX_DEFAULT_METER_PIE2,
        TEX_DEFAULT_METER_PIE3,
        TEX_DEFAULT_METER_PIE4,
        TEX_DEFAULT_METER_PIE5,
        TEX_DEFAULT_METER_PIE6,
        TEX_DEFAULT_METER_PIE7,
        TEX_DEFAULT_METER_PIE8,
    }
}

local PALETTE_TACO_WALUIGI =  {
    [PANTS]  = "081021",
    [SHIRT]  = "6500cc",
    [GLOVES] = "FFFFFF",
    [SHOES]  = "FF6300",
    [HAIR]   = "735200",
    [SKIN]   = "F7A563",
    [CAP]    = "6500cc",
    [EMBLEM] = "FFF500",
}

local CSloaded = false
local function on_character_select_load()
    -- Adds the custom character to the Character Select Menu
    CT_TACO_WALUIGI = _G.charSelect.character_add(
        "Taco Stand Waluigi", -- Character Name
        "After losing his and Wario's money at the casino, Waluigi had to sell tacos to afford rent!", -- Description
        "Listed in CS Credits", -- Credits
        "662CAD",           -- Menu Color
        E_MODEL_TACO_WALUIGI,       -- Character Model
        CT_WALUIGI,           -- Override Character 
        TEX_TACO_STAND_WALUIGI_LIFE_ICON, -- Life Icon
        1.1,                  -- Camera Scale
        0                   -- Vertical Offset

    )

    _G.charSelect.credit_add(TEXT_MOD_NAME, "WBmarioo", "Model and Texture Edits")
    _G.charSelect.credit_add(TEXT_MOD_NAME, "mingokrb", "Health Texture Text")
	_G.charSelect.credit_add(TEXT_MOD_NAME, "Kaze", "Model Edits")
	_G.charSelect.credit_add(TEXT_MOD_NAME, "FluffaMario", "Original Model Creator")
	_G.charSelect.credit_add(TEXT_MOD_NAME, "xLuigiGamerx", "Coop Templates")
	
    _G.charSelect.character_add_voice(E_MODEL_TACO_WALUIGI, VOICETABLE_TACO_WALUIGI)
    _G.charSelect.character_add_palette_preset(E_MODEL_TACO_WALUIGI, PALETTE_TACO_WALUIGI)
	_G.charSelect.character_add_caps(E_MODEL_TACO_WALUIGI, TACO_WALUIGI_CAPMODELS)
    _G.charSelect.character_add_health_meter(CT_TACO_WALUIGI, HEALTH_METER_TACO_WALUIGI)
    _G.charSelect.character_add_celebration_star(E_MODEL_TACO_WALUIGI, E_MODEL_TACO_STAR, TEX_TACO_STAR)

    CSloaded = true
end

local function on_character_sound(m, sound)
    if not CSloaded then return end
    if _G.charSelect.character_get_voice(m) == VOICETABLE_TACO_WALUIGI then return _G.charSelect.voice.sound(m, sound) end
end

local function on_character_snore(m)
    if not CSloaded then return end
    if _G.charSelect.character_get_voice(m) == VOICETABLE_TACO_WALUIGI then return _G.charSelect.voice.snore(m) end
end

hook_event(HOOK_ON_MODS_LOADED, on_character_select_load)
hook_event(HOOK_CHARACTER_SOUND, on_character_sound)
hook_event(HOOK_MARIO_UPDATE, on_character_snore)
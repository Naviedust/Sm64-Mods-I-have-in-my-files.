-- name: [CS] SMW
-- description: Super Mario World in CoopDX With Moveset! \nA to Jump, B to Run, Y to Spinjump and X/B To Grab objects ((Default X) Changable with mod menu). \nWith Triangle Blocks included!  \n\n\Made by: Wall_E20\n\n\\#ff7777\\This Pack requires Character Select\nto use as a Library!


local TEXT_MOD_NAME = "[CS] Super Mario World"

-- Stops mod from loading if Character Select isn't on
if not _G.charSelectExists then
    djui_popup_create(
        "\\#ffffdc\\\n" ..
        TEXT_MOD_NAME ..
        "\nRequires the Character Select Mod\nto use as a Library!\n\nPlease turn on the Character Select Mod\nand Restart the Room!",
        6)
    return 0
end

E_MODEL_SMW = smlua_model_util_get_id("smw_geo")
E_MODEL_S_SMW = smlua_model_util_get_id("s_smw_geo")
E_MODEL_SMWRC = smlua_model_util_get_id("smw_recolor_geo")
E_MODEL_S_SMWRC = smlua_model_util_get_id("s_smw_recolor_geo")
TEX_SMW_MARIO_S = get_texture_info("smw-icon-small")
TEX_SMW_MARIO = get_texture_info("smw-icon-big")
--[[
local CAPTABLE_MAR = {
    normal = smlua_model_util_get_id("mariocap_geo"),
    wing = smlua_model_util_get_id("mariowcap_geo"),
    metal = smlua_model_util_get_id("mariomcap_geo"),
    metalWing = smlua_model_util_get_id("mariowcap_geo"),
}
]]
local SMWVOICE = {
    [CHAR_SOUND_OKEY_DOKEY] = "smw_item_get.ogg"
}

local SMW = {
    [CHAR_ANIM_SWIM_PART1] = "SMW_WaterSwim",
    [CHAR_ANIM_SWIM_PART2] = "SMW_WaterSwim",
    [CHAR_ANIM_FLUTTERKICK] = "SMW_WaterIdle",
    [CHAR_ANIM_WATER_IDLE] = "SMW_WaterIdle",
    [CHAR_ANIM_WATER_ACTION_END] = "SMW_WaterIdle",
    [CHAR_ANIM_WATER_DYING] = "SMW_DeadAnim",
    [CHAR_ANIM_A_POSE] = "SMW_Idle",
    [CHAR_ANIM_TWIRL] = "SMW_Spinjump",
    [CHAR_ANIM_START_TWIRL] = "SMW_Spinjump",
    [CHAR_ANIM_IDLE_IN_QUICKSAND] = "SMW_Idle",
    [CHAR_ANIM_MOVE_IN_QUICKSAND] = "SMW_Walk2",
    [CHAR_ANIM_DYING_IN_QUICKSAND] = "SMW_DeadAnim",
    [CHAR_ANIM_WALK_WITH_LIGHT_OBJ] = SMW_ANIM_HOLD_WALK,
    [CHAR_ANIM_RUN_WITH_LIGHT_OBJ] = SMW_ANIM_HOLD_WALK,
    [CHAR_ANIM_SLOW_WALK_WITH_LIGHT_OBJ] = SMW_ANIM_HOLD_WALK,
    [CHAR_ANIM_FIRE_LAVA_BURN] = "SMW_DeadAnim",
    [CHAR_ANIM_TURNING_PART1] = "SMW_Skid",
    [CHAR_ANIM_TURNING_PART2] = "SMW_Skid",
    [CHAR_ANIM_IDLE_WITH_LIGHT_OBJ] = "SMW_IdleHold",
    [CHAR_ANIM_JUMP_WITH_LIGHT_OBJ] = "SMW_JumpHold",
    [CHAR_ANIM_FALL_WITH_LIGHT_OBJ] = "SMW_JumpHold",
    [CHAR_ANIM_SLIDING_ON_BOTTOM_WITH_LIGHT_OBJ] = "SMW_CrouchHold",
    [CHAR_ANIM_RIDING_SHELL] = "SMW_Sit",
    [CHAR_ANIM_START_RIDING_SHELL] = "SMW_Sit",
    [CHAR_ANIM_BEND_KNESS_RIDING_SHELL] = "SMW_Sit",
    [CHAR_ANIM_JUMP_RIDING_SHELL] = "SMW_Sit",
    [CHAR_ANIM_THROW_LIGHT_OBJECT] = "SMW_Kick",
    [CHAR_ANIM_GRAB_HEAVY_OBJECT] = "SMW_IdleHold",
    [CHAR_ANIM_MISSING_CAP] = "CHAR_ANIM_MISSING_CAP",
    [CHAR_ANIM_GROUND_THROW] = "SMW_Kick",
    [CHAR_ANIM_GROUND_KICK] = "SMW_Kick",
    [CHAR_ANIM_PLACE_LIGHT_OBJ] = "SMW_CrouchHold",
    [CHAR_ANIM_FIRST_PERSON] = "SMW_Idle",
    [CHAR_ANIM_THROW_CATCH_KEY] = "SMW_Idle",
    [CHAR_ANIM_LAND_FROM_SINGLE_JUMP] = "SMW_Idle",
    [CHAR_ANIM_WALK_PANTING] = "SMW_Idle",
    [CHAR_ANIM_GENERAL_LAND] = "SMW_Idle",
    [CHAR_ANIM_TAKE_CAP_OFF_THEN_ON] = "SMW_Idle",
    [CHAR_ANIM_STAND_AGAINST_WALL] = "SMW_Idle",
    [CHAR_ANIM_SIDESTEP_LEFT] = "SMW_Idle",
    [CHAR_ANIM_IDLE_HEAD_LEFT] = "SMW_Idle",
    [CHAR_ANIM_IDLE_HEAD_RIGHT] = "SMW_Idle",
    [CHAR_ANIM_IDLE_HEAD_CENTER] = "SMW_Idle",
    [CHAR_ANIM_RUNNING] = "SMW_Walk2",
    [CHAR_ANIM_RUNNING_UNUSED] = SMW_ANIM_RUN,
    [CHAR_ANIM_WALKING] = "SMW_Walk2",
    [CHAR_ANIM_TIPTOE] = "SMW_Walk2",
    [CHAR_ANIM_START_TIPTOE] = "SMW_Walk2",
    [CHAR_ANIM_GENERAL_FALL] = "smw_fall",
    [CHAR_ANIM_SINGLE_JUMP] = "smw_Jump",
    [CHAR_ANIM_CROUCHING] = "SMW_Crouch",
    [CHAR_ANIM_START_CROUCHING] = "SMW_Crouch",
    [CHAR_ANIM_DOUBLE_JUMP_FALL] = "SMW_Spinjump",
    [CHAR_ANIM_DOUBLE_JUMP_RISE] = "SMW_Spinjump",
    [CHAR_ANIM_DIVE] = "SMW_Spinjump",
    [CHAR_ANIM_FORWARD_SPINNING] = "SMW_Spinjump",
    [CHAR_ANIM_BACKWARD_SPINNING] = "SMW_Spinjump",
    [CHAR_ANIM_TRIPLE_JUMP] = "SMW_RunJump",
    [CHAR_ANIM_AIRBORNE_ON_STOMACH] = "SMW_RunJump",
    [CHAR_ANIM_STAR_DANCE] = "SMW_Pacesign",
    --[CHAR_ANIM_SUMMON_STAR] = "SMW_Pacesign",
    [charSelect.CS_ANIM_MENU] = "SMW_Pacesign",
    [CHAR_ANIM_SLIDE] = "SMW_Sit",
    [CHAR_ANIM_SLIDE_DIVE] = "SMW_Sit",
    [CHAR_ANIM_FORWARD_KB] = "smw_fall",
    [CHAR_ANIM_SHOCKED] = "smw_fall",
    [CHAR_ANIM_BACKWARD_KB] = "smw_fall",
    [CHAR_ANIM_BACKWARD_AIR_KB] = "smw_fall",
    [CHAR_ANIM_AIR_FORWARD_KB] = "smw_fall",
    [CHAR_ANIM_FALL_OVER_BACKWARDS] = "smw_fall",
    [CHAR_ANIM_DYING_FALL_OVER] = "smw_fall",
    [CHAR_ANIM_BEING_GRABBED] = "smw_fall",
    [CHAR_ANIM_SUFFOCATING] = "SMW_Dead",
    [CHAR_ANIM_DYING_FALL_OVER] = "SMW_DeadAnim",
    [CHAR_ANIM_FALL_FROM_WATER] = "smw_fall",
    [CHAR_ANIM_IDLE_ON_POLE] = "SMW_Climb",
    [CHAR_ANIM_GRAB_POLE_SHORT] = "SMW_Climb",
    [CHAR_ANIM_GRAB_POLE_SWING_PART1] = "SMW_Climb",
    [CHAR_ANIM_GRAB_POLE_SWING_PART2] = "SMW_Climb",
    [CHAR_ANIM_CLIMB_UP_POLE] = "SMW_Climbing",
    --[CHAR_ANIM_TWIRL_LAND] = "SMW_Idle",
    [CHAR_ANIM_HANG_ON_OWL] = "smw_fall",
    [CHAR_ANIM_HANG_ON_CEILING] = "smw_fall",
    [CHAR_ANIM_MOVE_ON_WIRE_NET_RIGHT] = "smw_fall",
    [CHAR_ANIM_MOVE_ON_WIRE_NET_LEFT] = "smw_fall",
}


local S_SMW = {
    [CHAR_ANIM_SWIM_PART1] = "SMW_WaterSwim",
    [CHAR_ANIM_SWIM_PART2] = "SMW_WaterSwim",
    [CHAR_ANIM_FLUTTERKICK] = "SMW_WaterIdle",
    [CHAR_ANIM_WATER_IDLE] = "SMW_WaterIdle",
    [CHAR_ANIM_WATER_ACTION_END] = "SMW_WaterIdle",
    [CHAR_ANIM_WATER_DYING] = "SMW_DeadAnim",
    [CHAR_ANIM_A_POSE] = "S_SMW_Idle",
    [CHAR_ANIM_IDLE_IN_QUICKSAND] = "SMW_Idle",
    [CHAR_ANIM_MOVE_IN_QUICKSAND] = "SMW_Walk2",
    [CHAR_ANIM_DYING_IN_QUICKSAND] = "SMW_DeadAnim",
    [CHAR_ANIM_TWIRL] = "SMW_Spinjump",
    [CHAR_ANIM_START_TWIRL] = "SMW_Spinjump",
    [CHAR_ANIM_WALK_WITH_LIGHT_OBJ] = SMW_ANIM_HOLD_WALK,
    [CHAR_ANIM_RUN_WITH_LIGHT_OBJ] = SMW_ANIM_HOLD_WALK,
    [CHAR_ANIM_SLOW_WALK_WITH_LIGHT_OBJ] = SMW_ANIM_HOLD_WALK,
    [CHAR_ANIM_FIRE_LAVA_BURN] = "SMW_DeadAnim",
    [CHAR_ANIM_TURNING_PART1] = "SMW_Skid",
    [CHAR_ANIM_TURNING_PART2] = "SMW_Skid",
    [CHAR_ANIM_THROW_CATCH_KEY] = "SMW_Idle",
    [CHAR_ANIM_IDLE_WITH_LIGHT_OBJ] = "SMW_IdleHold",
    [CHAR_ANIM_JUMP_WITH_LIGHT_OBJ] = "SMW_JumpHold",
    [CHAR_ANIM_FALL_WITH_LIGHT_OBJ] = "SMW_JumpHold",
    [CHAR_ANIM_SLIDING_ON_BOTTOM_WITH_LIGHT_OBJ] = "SMW_CrouchHold",
    [CHAR_ANIM_RIDING_SHELL] = "SMW_Sit",
    [CHAR_ANIM_START_RIDING_SHELL] = "SMW_Sit",
    [CHAR_ANIM_BEND_KNESS_RIDING_SHELL] = "SMW_Sit",
    [CHAR_ANIM_JUMP_RIDING_SHELL] = "SMW_Sit",
    [CHAR_ANIM_THROW_LIGHT_OBJECT] = "SMW_Kick",
    [CHAR_ANIM_GRAB_HEAVY_OBJECT] = "SMW_IdleHold",
    --[CHAR_ANIM_MISSING_CAP] = "CHAR_ANIM_MISSING_CAP",
    [CHAR_ANIM_GROUND_THROW] = "SMW_Kick",
    [CHAR_ANIM_GROUND_KICK] = "SMW_Kick",
    [CHAR_ANIM_PLACE_LIGHT_OBJ] = "SMW_CrouchHold",
    [CHAR_ANIM_FIRST_PERSON] = "S_SMW_Idle",
    [CHAR_ANIM_LAND_FROM_SINGLE_JUMP] = "S_SMW_Idle",
    [CHAR_ANIM_TAKE_CAP_OFF_THEN_ON] = "S_SMW_Idle",
    [CHAR_ANIM_GENERAL_LAND] = "S_SMW_Idle",
    [CHAR_ANIM_WALK_PANTING] = "S_SMW_Idle",
    [CHAR_ANIM_IDLE_HEAD_LEFT] = "S_SMW_Idle",
    [CHAR_ANIM_IDLE_HEAD_RIGHT] = "S_SMW_Idle",
    [CHAR_ANIM_IDLE_HEAD_CENTER] = "S_SMW_Idle",
    [CHAR_ANIM_STAND_AGAINST_WALL] = "S_SMW_Idle",
    [CHAR_ANIM_SIDESTEP_LEFT] = "S_SMW_Idle",
    [CHAR_ANIM_RUNNING] = "S_SMW_Walk",
    [CHAR_ANIM_RUNNING_UNUSED] = S_SMW_ANIM_RUN,
    [CHAR_ANIM_WALKING] = "S_SMW_Walk",
    [CHAR_ANIM_TIPTOE] = "S_SMW_Walk",
    [CHAR_ANIM_START_TIPTOE] = "S_SMW_Walk",
    [CHAR_ANIM_GENERAL_FALL] = "S_SMW_Fall",
    [CHAR_ANIM_FORWARD_KB] = "S_SMW_Fall",
    [CHAR_ANIM_BACKWARD_KB] = "S_SMW_Fall",
    [CHAR_ANIM_BACKWARD_AIR_KB] = "S_SMW_Fall",
    [CHAR_ANIM_AIR_FORWARD_KB] = "S_SMW_Fall",
    [CHAR_ANIM_FALL_OVER_BACKWARDS] = "S_SMW_Fall",
    [CHAR_ANIM_SINGLE_JUMP] = "S_SMW_Jump",
    [CHAR_ANIM_CROUCHING] = "S_SMW_Crouch",
    [CHAR_ANIM_START_CROUCHING] = "S_SMW_Crouch",
    [CHAR_ANIM_DOUBLE_JUMP_FALL] = "S_SMW_Spijump",
    [CHAR_ANIM_DOUBLE_JUMP_RISE] = "S_SMW_Spijump",
    [CHAR_ANIM_DIVE] = "S_SMW_Spijump",
    [CHAR_ANIM_FORWARD_SPINNING] = "S_SMW_Spijump",
    [CHAR_ANIM_BACKWARD_SPINNING] = "S_SMW_Spijump",
    [CHAR_ANIM_TRIPLE_JUMP] = "S_SMW_RunJump",
    [CHAR_ANIM_AIRBORNE_ON_STOMACH] = "S_SMW_RunJump",
    [CHAR_ANIM_STAR_DANCE] = "S_SMW_PaceSign",
    --[CHAR_ANIM_SUMMON_STAR] = "S_SMW_PaceSign",
    [charSelect.CS_ANIM_MENU] = "S_SMW_PaceSign",
    [CHAR_ANIM_SLIDE] = "SMW_Sit",
    [CHAR_ANIM_SLIDE_DIVE] = "SMW_Sit",
    [CHAR_ANIM_BEING_GRABBED] = "S_SMW_Fall",
    [CHAR_ANIM_SUFFOCATING] = "SMW_Dead",
    [CHAR_ANIM_DYING_FALL_OVER] = "SMW_DeadAnim",
    [CHAR_ANIM_SHOCKED] = "S_SMW_Fall",
    [CHAR_ANIM_FALL_FROM_WATER] = "S_SMW_Fall",
    [CHAR_ANIM_IDLE_ON_POLE] = "SMW_Climb",
    [CHAR_ANIM_GRAB_POLE_SHORT] = "SMW_Climb",
    [CHAR_ANIM_GRAB_POLE_SWING_PART1] = "SMW_Climb",
    [CHAR_ANIM_GRAB_POLE_SWING_PART2] = "SMW_Climb",
    [CHAR_ANIM_CLIMB_UP_POLE] = "SMW_Climbing",
    --[CHAR_ANIM_TWIRL_LAND] = "SMW_Idle",
    [CHAR_ANIM_HANG_ON_OWL] = "S_SMW_Fall",
    [CHAR_ANIM_HANG_ON_CEILING] = "S_SMW_Fall",
    [CHAR_ANIM_MOVE_ON_WIRE_NET_RIGHT] = "S_SMW_Fall",
    [CHAR_ANIM_MOVE_ON_WIRE_NET_LEFT] = "S_SMW_Fall",
}



local PALETTE_MAR = {
    [PANTS]  = "75C1B0",
    [SHIRT]  = "E23762",
    [GLOVES] = "ffffff",
    [SHOES]  = "66400B",
    [HAIR]   = "000000",
    [SKIN]   = "E2BAA9",
    [CAP]    = "E23762",
    [EMBLEM] = "E23762"
}

local CSloaded = false
local function on_character_select_load()
    CT_SMW = _G.charSelect.character_add("Super Mario World",
        { "Super Mario World's Mario recreated in a 3D World!", "Press A to Jump, Hold B to Run,",
            "Y to Spin Jump and Hold X to Grab!", "Be careful, when you have 4 or less health", "you became small!",
            "Be also careful to lava!", "Grab button can be changed in the Mod Menu" }, "Wall_E20",
        { r = 226, g = 55, b = 98 },
        E_MODEL_SMW, CT_MARIO, TEX_SMW_MARIO, 1)
    --_G.charSelect.header_set_texture()
    --_G.charSelect.character_add_caps(E_MODEL_SMW, CAPTABLE_MAR)
    _G.charSelect.config_character_sounds()
    _G.charSelect.character_add_animations(E_MODEL_SMW, SMW)
    _G.charSelect.character_add_animations(E_MODEL_S_SMW, S_SMW)
    _G.charSelect.character_add_voice(E_MODEL_S_SMW, SMWVOICE)
    _G.charSelect.character_add_voice(E_MODEL_SMW, SMWVOICE)

    charSelect.character_add_costume(CT_SMW, "Super Mario World (Recolor)",
        { "less sprite color accurate... but recolorable!", "Use this for recoloring!", "(this also has default palette)" },
        "Wall_E20", { r = 226, g = 55, b = 98 }, E_MODEL_SMWRC, CT_MARIO, TEX_MARIO, 1)
    _G.charSelect.character_add_animations(E_MODEL_SMWRC, SMW)
    _G.charSelect.character_add_animations(E_MODEL_S_SMWRC, S_SMW)
    --_G.charSelect.character_add_palette_preset(E_MODEL_S_SMWRC, PALETTE_MAR, "Default")
    --_G.charSelect.character_add_palette_preset(E_MODEL_SMWRC, PALETTE_MAR, "Default")

    _G.charSelect.character_add_palette_preset(E_MODEL_S_SMW, PALETTE_MAR, "Default")
    _G.charSelect.character_add_palette_preset(E_MODEL_SMW, PALETTE_MAR, "Default")
end

local function on_character_sound(m, sound)
    if not CSloaded then return end
    if _G.charSelect.character_get_voice(m) == SMWVOICE then return _G.charSelect.voice.sound(m, sound) end
end

local function on_character_snore(m)
    if not CSloaded then return end
    if _G.charSelect.character_get_voice(m) == SMWVOICE then return _G.charSelect.voice.snore(m) end
end


hook_event(HOOK_ON_MODS_LOADED, on_character_select_load)
hook_event(HOOK_CHARACTER_SOUND, on_character_sound)
hook_event(HOOK_MARIO_UPDATE, on_character_snore)



--smol
local function small_modelchange(m)
    if m.playerIndex ~= 0 then return end
    if _G.charSelect.character_get_current_number(m.playerIndex) == CT_SMW then
        if m.health <= 0x500 and m.action ~= ACT_SMW_DAMAGE then
            _G.charSelect.character_edit(CT_SMW, nil, nil, nil, nil, E_MODEL_S_SMW)
        end
        if m.health > 0x500 and m.action ~= ACT_SMW_DAMAGE then
            _G.charSelect.character_edit(CT_SMW, nil, nil, nil, nil, E_MODEL_SMW)
        end
    end
end
hook_event(HOOK_MARIO_UPDATE, small_modelchange)

function update()
    local playerIndex = 1
    gPlayerSyncTable[0].characterType = charSelect.character_get_current_number()
    playerTable = charSelect.character_get_current_table(gPlayerSyncTable[playerIndex].characterType)
end

hook_event(HOOK_UPDATE, update)
--[[
local function setsmall()
    gMarioStates[0].health = 0x4ff
    return true
end
hook_chat_command("smw_small", "- sets smw mario to be small (sets the life to 4)", setsmall)

local function setbig()
    gMarioStates[0].health = 0x8ff
    return true
end
hook_chat_command("smw_big", "- sets smw mario to be big (sets the life to full)", setbig)


local function kill()
    gMarioStates[0].health = 0x00
    return true
end
hook_chat_command("kill", "- aa", kill)
--]]


---modmenu


local function GrabButton(index, value)
    local e = gSMWExtraStates[gMarioStates[0].playerIndex]

    mod_storage_save_bool("SMW_GRABBUTTON", value)


    if value == true then
        djui_chat_message_create("Now you grab objects with B")
        e.b2grab = true
    elseif value == false then
        e.b2grab = false
        djui_chat_message_create("Now you grab objects with X")
    end
end


hook_mod_menu_checkbox("Grab with B Button", mod_storage_load_bool("SMW_GRABBUTTON"), GrabButton)

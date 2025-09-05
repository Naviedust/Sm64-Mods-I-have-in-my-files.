-- name: [CS] \\#4d0000\\Mario85 pack Deluxe edition
-- description: Finally the a scary guy himself  ABOUT DAMN TIME...Player 2 available \n\n\\#ff7777\\This Pack requires Character Select\nto use as a Library!

--[[
 so hey its been a while. . .  why are you here??? this is amature code work here at best! 
]]

local E_MODEL_CUSTOM_MODEL = smlua_model_util_get_id("MX_geo")

local TEX_CUSTOM_ICON = get_texture_info("MX85-icon")

local TEXT_MOD_NAME = "MX"

local VOICETABLE_MX = {
    [CHAR_SOUND_ATTACKED] = 'bold.ogg',
    [CHAR_SOUND_DOH] = 'Bump.ogg',
    [CHAR_SOUND_DROWNING] = 'static.ogg',
    [CHAR_SOUND_DYING] = 'DIE.ogg',
    [CHAR_SOUND_GROUND_POUND_WAH] = 'Bump.ogg',
    [CHAR_SOUND_HAHA] = 'WAHOO.ogg',
    [CHAR_SOUND_HAHA_2] = 'YAHOOO.ogg',
    [CHAR_SOUND_HERE_WE_GO] = 'not far.ogg',
    [CHAR_SOUND_HOOHOO] = 'MXjump.ogg',
    [CHAR_SOUND_MAMA_MIA] = 'bricked.ogg',
    [CHAR_SOUND_OKEY_DOKEY] = 'bricked.ogg',
    [CHAR_SOUND_ON_FIRE] = 'static.ogg',
    [CHAR_SOUND_OOOF] = 'Bump.ogg',
    [CHAR_SOUND_OOOF2] = 'Bump.ogg',
    [CHAR_SOUND_PUNCH_HOO] = 'bricked.ogg',
    [CHAR_SOUND_PUNCH_WAH] = 'Bump.ogg',
    [CHAR_SOUND_PUNCH_YAH] = 'Bump.ogg',
    [CHAR_SOUND_SO_LONGA_BOWSER] = 'not far.ogg',
    [CHAR_SOUND_TWIRL_BOUNCE] = 'bricked.ogg',
    [CHAR_SOUND_WAAAOOOW] = 'Bump.ogg',
    [CHAR_SOUND_WAH2] = 'Bump.ogg',
    [CHAR_SOUND_WHOA] = 'Bump.ogg',
    [CHAR_SOUND_YAHOO] = 'YAHOOO.ogg',
    [CHAR_SOUND_YAHOO_WAHA_YIPPEE] = 'MXjump.ogg',
    [CHAR_SOUND_YAH_WAH_HOO] = 'MXjump.ogg',
    [CHAR_SOUND_YAWNING] = 'DIE.ogg',
}
   
local PALETTE_MX= {
    [PANTS]  = "000000",
    [SHIRT]  = "000000",
    [GLOVES] = "FFFFFF",
    [SHOES]  = "000000",
    [HAIR]   = "000000",
    [SKIN]   = "FFFFFF",
    [CAP]    = "330000",
    [EMBLEM] = "FFFFFF",
}





if _G.charSelectExists then
    CT_MX = _G.charSelect.character_add("MX", {"The false hero finally joins cast", "WAHOOOOOOOOOOO!!", "A CSport of the guy from a haunted PC port. . .funny"}, "Creator: Steven. Ported by: Dremy_Bowser",  {r = 700, g =000 , b = 000}, E_MODEL_CUSTOM_MODEL, CT_MARIO, TEX_CUSTOM_ICON)
    _G.charSelect.character_add_caps(E_MODEL_CUSTOM_MODEL, CAPTABLE_MX)
    _G.charSelect.character_add_palette_preset( E_MODEL_CUSTOM_MODEL, PALETTE_MX)
    -- the following must be hooked for each character added
    _G.charSelect.character_add_voice(E_MODEL_CUSTOM_MODEL, VOICETABLE_MX)
    hook_event(HOOK_CHARACTER_SOUND, function (m, sound)
        if _G.charSelect.character_get_voice(m) == VOICETABLE_MX then return _G.charSelect.voice.sound(m, sound) end
    end)
    hook_event(HOOK_MARIO_UPDATE, function (m)
        if _G.charSelect.character_get_voice(m) == VOICETABLE_MX then return _G.charSelect.voice.snore(m) end
    end)
else
    djui_popup_create("\\#ffffdc\\\n"..TEXT_MOD_NAME.."\nRequires the Character Select Mod\nto use as a Library!\n\nPlease turn on the Character Select Mod\nand Restart the Room!", 6)
end 


local TEX_CUSTOM_ICON = get_texture_info("Lucas85-icon")
local E_MODEL_CUSTOM_MODEL = smlua_model_util_get_id("Lucas85_geo")


local VOICETABLE_LUCAS85 = {
    [CHAR_SOUND_ATTACKED] = 'NES-Hit.ogg',
    [CHAR_SOUND_DOH] = 'NES-Bump.ogg',
    [CHAR_SOUND_DROWNING] = 'NES-Die.ogg',
    [CHAR_SOUND_DYING] = 'NES-Die.ogg',
    [CHAR_SOUND_GROUND_POUND_WAH] = 'NES-Squish.ogg',
    [CHAR_SOUND_HAHA] = 'NES-1up.ogg',
    [CHAR_SOUND_HAHA_2] = 'NES-1up.ogg',
    [CHAR_SOUND_HERE_WE_GO] = 'NES-Flagpole.ogg',
    [CHAR_SOUND_HOOHOO] = 'NES-Jump.ogg',
    [CHAR_SOUND_MAMA_MIA] = 'NES-Warp.ogg',
    [CHAR_SOUND_OKEY_DOKEY] = 'NES-1up.ogg',
    [CHAR_SOUND_ON_FIRE] = 'NES-Enemy_Fire.ogg',
    [CHAR_SOUND_OOOF] = 'NES-Hit.ogg',
    [CHAR_SOUND_OOOF2] = 'NES-Hit.ogg',
    [CHAR_SOUND_PUNCH_HOO] = 'NES-Kick.ogg',
    [CHAR_SOUND_PUNCH_WAH] = 'NES-Thwomp.ogg',
    [CHAR_SOUND_PUNCH_YAH] = 'NES-Thwomp.ogg',
    [CHAR_SOUND_SO_LONGA_BOWSER] = 'NES-Bowser_Die.ogg',
    [CHAR_SOUND_TWIRL_BOUNCE] = 'NES-Item.ogg',
    [CHAR_SOUND_WAAAOOOW] = 'NES-Vine.ogg',
    [CHAR_SOUND_WAH2] = 'NES-Kick.ogg',
    [CHAR_SOUND_WHOA] = 'NES-Item.ogg',
    [CHAR_SOUND_YAHOO] = 'NES-Jump.ogg',
    [CHAR_SOUND_YAHOO_WAHA_YIPPEE] = 'NES-Jump.ogg',
    [CHAR_SOUND_YAH_WAH_HOO] = 'NES-Big_Jump.ogg',
    [CHAR_SOUND_YAWNING] = 'NES-Pause.ogg',
}


local PALETTE_LUCAS85 = {
    [PANTS]  = "316300",
    [SHIRT]  = "FFFFFF",
    [GLOVES] = "FFFFFF",
    [SHOES]  = "000000",
    [HAIR]   = "000000",
    [SKIN]   = "eb9f23",
    [CAP]    = "FFFFFF",
    [EMBLEM] = "FFFFFF",
}



if _G.charSelectExists then
    CT_LUCAS85 = _G.charSelect.character_add("Lucas", {"The byte sized survivor enters the fray", "This might not be Luigi. . .","The Lost Soul", "Still believes innocence gets him far" }, "Creator: ChibiTheMarioGamer  Ported by: Dremy_Bowser", {r = 000, g = 200, b = 000}, E_MODEL_CUSTOM_MODEL, CT_LUIGI, TEX_CUSTOM_ICON)
    _G.charSelect.character_add_caps(E_MODEL_CUSTOM_MODEL, CAPTABLE_CHAR)
    _G.charSelect.character_add_palette_preset(E_MODEL_CUSTOM_MODEL, PALETTE_LUCAS85)
    -- the following must be hooked for each character added
    _G.charSelect.character_add_voice(E_MODEL_CUSTOM_MODEL, VOICETABLE_LUCAS85)
    hook_event(HOOK_CHARACTER_SOUND, function (m, sound)
        if _G.charSelect.character_get_voice(m) == VOICETABLE_LUCAS85 then return _G.charSelect.voice.sound(m, sound) end
    end)
    hook_event(HOOK_MARIO_UPDATE, function (m)
        if _G.charSelect.character_get_voice(m) == VOICETABLE_LUCAS85 then return _G.charSelect.voice.snore(m) end
    end)
end

CSloaded = true
Mario85CSloaded = true
CHARS_85 = {
    [CT_MX] = 1,
    [CT_LUCAS85] = 1,
}


gPlayerSyncTable[0].movesetActive = true

function moveset_active(m)
    return gPlayerSyncTable[0].movesetActive and  charSelect.character_get_current_number() == CT_MX
end

function no_fall_damage(m)
    if not moveset_active(m) then return end

    m.peakHeight = m.pos.y
end
hook_event(HOOK_MARIO_UPDATE, no_fall_damage)

local can_press_x = 0

function x_pressed(m)
    if not moveset_active(m) then return end-- WAHOOOOOOOOOOO!!
    if m.action == ACT_STAR_DANCE_EXIT
    or m.action == ACT_STAR_DANCE_NO_EXIT
    or m.action == ACT_STAR_DANCE_WATER
    or m.action == ACT_DEATH_EXIT
    or m.action == ACT_DEATH_EXIT_LAND
    or m.action == ACT_DEATH_ON_BACK
    or m.action == ACT_DEATH_ON_STOMACH
    or m.action == ACT_FALLING_DEATH_EXIT
    or m.action == ACT_QUICKSAND_DEATH
    or m.action == ACT_SPECIAL_DEATH_EXIT then return end
    if m.action & ACT_GROUP_MASK == ACT_GROUP_SUBMERGED then return end
    if m.playerIndex ~= 0 then return end
    if m.controller.buttonPressed & X_BUTTON ~= 0 then
        if x_press_counter > 0 then
            set_jumping_action(m, ACT_WALL_KICK_AIR, 0)
            x_press_counter = x_press_counter - 1
        end
    end

    if (m.action & ACT_FLAG_AIR) == 0 then
        x_press_counter = 3
    end
end

hook_event(HOOK_MARIO_UPDATE, x_pressed)


-- hmm yeah mustve been a left over of me initially messing around to see what happened 
-- im such a writing genius B)

ACT_DASH = allocate_mario_action(ACT_GROUP_MOVING|ACT_FLAG_MOVING|ACT_FLAG_ATTACKING|ACT_FLAG_RIDING_SHELL)

function actuall_run(m) 
    if not moveset_active(m) then return end
    if m.controller.buttonDown & Y_BUTTON ~= 0 then
    mario_set_forward_vel(m, 85) -- Innocence doesn't get you far...
    end
    if m.action == ACT_DASH and m.input & INPUT_A_PRESSED ~= 0 then
        return set_mario_action(m, ACT_JUMP, 0)
    end

    if m.action == ACT_DASH and  m.input & INPUT_Z_PRESSED ~= 0 then
        return set_mario_action(m, ACT_LONG_JUMP, 0)
    end

    if m.action == ACT_DASH and  m.input & INPUT_B_PRESSED ~= 0 then
        return set_mario_action(m,ACT_MX_ROLL, 0)
    end
end
hook_event(HOOK_MARIO_UPDATE, actuall_run)

function act_dash(m)
    perform_ground_step(m)
    update_walking_speed(m)

    play_character_sound_if_no_flag(m, CHAR_SOUND_HAHA, MARIO_MARIO_SOUND_PLAYED)

    m.forwardVel = 0
    if m.input & INPUT_ZERO_MOVEMENT ~= 0 then
        return set_mario_action(m, ACT_IDLE, 0)
    end
    smlua_anim_util_set_animation(m.marioObj, "MX_ANIM_BRICK_BREAKER")
    m.marioObj.header.gfx.animInfo.animAccel = 65536 * (5)
    play_step_sound(m, 15, 35)
end
hook_mario_action(ACT_DASH, act_dash, INT_KICK)

function check_dash(m)
    if not moveset_active(m)
    or m.action == ACT_BUBBLED
    or m.action == ACT_STAR_DANCE_EXIT
    or m.action == ACT_STAR_DANCE_NO_EXIT
    or m.action == ACT_STAR_DANCE_WATER
    or m.action == ACT_DEATH_EXIT
    or m.action == ACT_DEATH_EXIT_LAND
    or m.action == ACT_DEATH_ON_BACK
    or m.action == ACT_DEATH_ON_STOMACH
    or m.action == ACT_FALLING_DEATH_EXIT
    or m.action == ACT_QUICKSAND_DEATH
    or m.action == ACT_SPECIAL_DEATH_EXIT
    or m.action & ACT_GROUP_MASK == ACT_GROUP_SUBMERGED then return end
    if m.pos.y == m.floorHeight then
        if m.controller.buttonPressed & Y_BUTTON ~= 0 and m.action ~= ACT_DASH and m.pos.y == m.floorHeight and
            (m.action & ACT_GROUP_MASK) ~= ACT_GROUP_SUBMERGED then
            set_mario_action(m, ACT_DASH, 0)
        end
    end
end
hook_event(HOOK_MARIO_UPDATE, check_dash)

--- @param m string
-- this is the function for enabling or disabling moveset
local function movesettoggle_command(m)
    m = tonumber(m) or 0
    if m==85 then
        gPlayerSyncTable[0].movesetActive = true
        djui_chat_message_create(' \\#f00\\WAHHOOOO\\#fff\\!!!!')
        djui_popup_create(" \\#f00\\You are MX", 1)
        return true
    elseif m==64 then
        gPlayerSyncTable[0].movesetActive = false
        djui_chat_message_create('\\#900\\See you next time. . ')
        djui_popup_create("\\#900\\You are no longer MX", 1)
        return true
    end
    return false
end
hook_chat_command('M', "[85|64] turn moveset \\#00C7FF\\on \\#dcdcdc\\or \\#A02200\\off\\#dcdcdc\\.", movesettoggle_command)

function ground_pound_jump(m)
    if not moveset_active(m) then return end
    if m.action == ACT_GROUND_POUND_LAND and (m.input & INPUT_A_PRESSED) ~= 0 then
        set_mario_action(m, ACT_TRIPLE_JUMP, 0)
    end
end
hook_event(HOOK_MARIO_UPDATE, ground_pound_jump)

-- Boss character BS --

hook_event(HOOK_ALLOW_HAZARD_SURFACE, function(m) return not moveset_active(m) end)

function single_jump(m)
    if not moveset_active(m) then return end
    if m.action == ACT_DOUBLE_JUMP then
        m.action = ACT_JUMP
    end
end
hook_event(HOOK_MARIO_UPDATE, single_jump)


function pound_shake(m)
    if not moveset_active(m) then return end
    if m.action == ACT_GROUND_POUND_LAND then
        set_camera_shake_from_hit(SHAKE_MED_DAMAGE)
    end
end
hook_event(HOOK_MARIO_UPDATE, pound_shake)

function air_recovery(m)
    if not moveset_active(m) then return end
    if m.action == ACT_BACKWARD_AIR_KB or m.action == ACT_FORWARD_AIR_KB then
        local randomtime = math.random(80, 140) -- thank you Birdikek!!!!!!!!!
        if m.marioObj.oTimer >= randomtime then
            return set_mario_action(m, ACT_IDLE, 0)
        end
    end
end
hook_event(HOOK_MARIO_UPDATE, air_recovery)

gStateExtras = {}
for i = 0, (MAX_PLAYERS - 1) do
    gStateExtras[i] = {}
    local m = gMarioStates[i]
    local e = gStateExtras[i]
end

gEventTable     = {}
-- why this id  what action even is this
-- this is for like the slide punch if you press the left de pad he just goes zooom
_G.ACT_MARIO_PUNCH = allocate_mario_action(ACT_FLAG_MOVING | ACT_FLAG_ATTACKING) -- get back here!!!!
function act_mario_punch(m)
    if m.health == 0xFF then return end
    play_character_sound_if_no_flag(m, CHAR_SOUND_HAHA, MARIO_MARIO_SOUND_PLAYED)

    common_slide_action(m, ACT_WALKING, ACT_FLAG_ATTACKING, MARIO_ANIM_FIRST_PUNCH)
    set_anim_to_frame(m, 25)

    m.slideVelX = m.slideVelX * 1.3
    m.slideVelZ = m.slideVelZ * 1.3
    update_sliding(m, -1)

    if m.actionTimer > 20 then
        return set_mario_action(m, ACT_WALKING, 85)
    end
    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_jumping_action(m, ACT_JUMP, 0)
    end

    m.actionTimer = m.actionTimer + 1
    return 0
end
hook_mario_action(ACT_MARIO_PUNCH, act_mario_punch, INT_KICK)

function check_mario_punch(m)
    if not moveset_active(m) then return end
    if m.health == 0xFF then return end
    if m.action & ACT_GROUP_MASK == ACT_GROUP_SUBMERGED then return end
    local hScale = 1.0
    if (m.controller.buttonPressed & L_JPAD) ~= 0 and (m.action & ACT_FLAG_MOVING) ~= 0 then
        return set_mario_action(m, ACT_MARIO_PUNCH, 0)
    end
    if (m.action & ACT_FLAG_AIR) ~= 0 then
        m.vel.y = m.vel.y - 0.1
    end
    if (m.action & ACT_FLAG_MOVING) ~= 0 then
        hScale = hScale * 1.4
    end
    m.vel.x = m.vel.x * hScale
    m.vel.z = m.vel.z * hScale
end
hook_event(HOOK_MARIO_UPDATE, check_mario_punch)

function jump_boosts(m)
    if not moveset_active(m) then return end
    if m.action == ACT_LONG_JUMP then
        m.vel.y = m.vel.y + 3
    elseif m.action == ACT_EMERGE_FROM_PIPE then
        m.vel.y = m.vel.y + 10
    end
    if m.action == ACT_JUMP
    or m.action == ACT_DOUBLE_JUMP
    or m.action == ACT_TRIPLE_JUMP
    or m.action == ACT_BACKFLIP
    or m.action == ACT_SIDE_FLIP
    or m.action == ACT_WALL_KICK_AIR then
        m.vel.y = m.vel.y + 4
    end
end
hook_event(HOOK_ON_SET_MARIO_ACTION, jump_boosts)

function floaty_jumps(m)
    if not moveset_active(m) then return end
    if m.action == ACT_JUMP
    or m.action == ACT_DOUBLE_JUMP
    or m.action == ACT_TRIPLE_JUMP
    or m.action == ACT_BACKFLIP
    or m.action == ACT_SIDE_FLIP
    or m.action == ACT_DIVE
    or m.action == ACT_JUMP_KICK
    or m.action == ACT_BACKWARD_ROLLOUT
    or m.action == ACT_FORWARD_ROLLOUT
    or m.action == ACT_WATER_JUMP
    or m.action == ACT_WALL_KICK_AIR then
        m.vel.y = m.vel.y + 0.7
    end
end
hook_event(HOOK_MARIO_UPDATE, floaty_jumps)

function mario_update_local(m)
    local p  = gNetworkPlayers[m.playerIndex]
    local np = gNetworkPlayers[m.playerIndex]
    local s  = gPlayerSyncTable[m.playerIndex]

    if not moveset_active(m) then return end
    if m.action == ACT_GROUND_POUND_LAND and gServerSettings.playerInteractions ~= PLAYER_INTERACTIONS_NONE then
        queue_rumble_data_mario(m, 5, 80)
        play_character_sound_if_no_flag(m, CHAR_SOUND_MAMA_MIA, MARIO_MARIO_SOUND_PLAYED)
        set_mario_action(m, ACT_GROUND_POUND_LAND, 0)
        if m.action == ACT_BUTT_STUCK_IN_GROUND then
            m.actionTimer = m.actionTimer + 1
        end

        if m.action == ACT_GROUND_POUND_LAND and m.actionTimer >= 9 then
            set_mario_action(m, ACT_BUTT_SLIDE_STOP, 0)
        end
    end
end
hook_event(HOOK_MARIO_UPDATE, mario_update_local)

ANGLE_QUEUE_SIZE = 9
SPIN_TIMER_SUCCESSFUL_INPUT = 4

gMarioStateExtras = {}
for i = 0, (MAX_PLAYERS - 1) do
    gMarioStateExtras[i] = {}
    local m = gMarioStates[i]
    local e = gMarioStateExtras[i]
    e.angleDeltaQueue = {}
    for j = 0, (ANGLE_QUEUE_SIZE - 1) do e.angleDeltaQueue[j] = 0 end
    e.rotAngle = 0
    e.boostTimer = 0

    e.stickLastAngle = 0
    e.spinDirection = 0
    e.spinBufferTimer = 0
    e.spinInput = 0
    e.lastIntendedMag = 0

    e.lastPos = {}
    e.lastPos.x = m.pos.x
    e.lastPos.y = m.pos.y
    e.lastPos.z = m.pos.z

    e.fakeSavedAction = 0
    e.fakeSavedPrevAction = 0
    e.fakeSavedActionTimer = 0
    e.fakeWroteAction = 0
    e.fakeSaved = false

    e.savedWallSlideHeight = 0
    e.savedWallSlide = false
end

function limit_angle(a)
    return (a + 0x8000) % 0x10000 - 0x8000
end

local allocate_mario_action, atan2s, sins, coss, mario_update_moving_sand, mario_update_windy_ground, mario_floor_is_slope, mario_set_forward_vel, set_mario_action, queue_rumble_data_mario, set_jumping_action, play_mario_sound, play_sound, set_mario_animation, common_slide_action, set_anim_to_frame, check_fall_damage_or_get_stuck, play_sound_and_spawn_particles, mario_bonk_reflection, play_mario_landing_sound_once, common_air_action_step, perform_air_step, should_get_stuck_in_ground, play_mario_heavy_landing_sound, check_fall_damage, set_camera_shake_from_hit, drop_and_set_mario_action, stationary_ground_step, check_common_action_exits, stopping_step, mario_drop_held_object, perform_water_step, perform_water_full_step, vec3f_copy, vec3s_set, approach_f32, is_anim_at_end, float_surface_gfx, set_swimming_at_surface_particles, apply_water_current, update_air_without_turn, play_mario_landing_sound, lava_boost_on_wall, check_kick_or_dive_in_air, update_sliding, mario_check_object_grab, mario_grab_used_object, analog_stick_held_back, approach_s32, apply_slope_accel, should_begin_sliding, begin_braking_action, set_jump_from_landing, check_ground_dive_or_punch, anim_and_audio_for_walk, perform_ground_step, push_or_sidle_wall, check_ledge_climb_down, tilt_body_walking, anim_and_audio_for_hold_walk, anim_and_audio_for_heavy_walk, align_with_floor, set_mario_anim_with_accel, play_step_sound =
    allocate_mario_action, atan2s, sins, coss, mario_update_moving_sand, mario_update_windy_ground, mario_floor_is_slope,
    mario_set_forward_vel, set_mario_action, queue_rumble_data_mario, set_jumping_action, play_mario_sound, play_sound,
    set_mario_animation, common_slide_action, set_anim_to_frame, check_fall_damage_or_get_stuck,
    play_sound_and_spawn_particles, mario_bonk_reflection, play_mario_landing_sound_once, common_air_action_step,
    perform_air_step, should_get_stuck_in_ground, play_mario_heavy_landing_sound, check_fall_damage,
    set_camera_shake_from_hit, drop_and_set_mario_action, stationary_ground_step, check_common_action_exits,
    stopping_step, mario_drop_held_object, perform_water_step, perform_water_full_step, vec3f_copy, vec3s_set,
    approach_f32, is_anim_at_end, float_surface_gfx, set_swimming_at_surface_particles, apply_water_current,
    update_air_without_turn, play_mario_landing_sound, lava_boost_on_wall, check_kick_or_dive_in_air, update_sliding,
    mario_check_object_grab, mario_grab_used_object, analog_stick_held_back, approach_s32, apply_slope_accel,
    should_begin_sliding, begin_braking_action, set_jump_from_landing, check_ground_dive_or_punch,
    anim_and_audio_for_walk, perform_ground_step, push_or_sidle_wall, check_ledge_climb_down, tilt_body_walking,
    anim_and_audio_for_hold_walk, anim_and_audio_for_heavy_walk, align_with_floor, set_mario_anim_with_accel,
    play_step_sound

local math_sqrt, math_min, math_max, math_floor = math.sqrt, math.min, math.max, math.floor

_G.ACT_MX_ROLL = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING | ACT_FLAG_BUTT_OR_STOMACH_SLIDE | ACT_FLAG_ATTACKING)
_G.ACT_MX_ROLL_AIR = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_FLAG_ATTACKING)
function update_roll_sliding_angle(m, accel, lossFactor)
    floor = m.floor
    slopeAngle = atan2s(floor.normal.z, floor.normal.x)
    steepness = math_sqrt(floor.normal.x * floor.normal.x + floor.normal.z * floor.normal.z)

    m.slideVelX = m.slideVelX + accel * steepness * sins(slopeAngle)
    m.slideVelZ = m.slideVelZ + accel * steepness * coss(slopeAngle)

    m.slideVelX = m.slideVelX * lossFactor
    m.slideVelZ = m.slideVelZ * lossFactor

    m.slideYaw = atan2s(m.slideVelZ, m.slideVelX)

    facingDYaw = limit_angle(m.faceAngle.y - m.slideYaw)
    newFacingDYaw = facingDYaw

    if newFacingDYaw > 0 and newFacingDYaw <= 0x8000 then
        newFacingDYaw = newFacingDYaw - 0x800
        if newFacingDYaw < 0 then newFacingDYaw = 0 end
    elseif newFacingDYaw >= -0x8000 and newFacingDYaw < 0 then
        newFacingDYaw = newFacingDYaw + 0x800
        if newFacingDYaw > 0 then newFacingDYaw = 0 end
    end

    m.faceAngle.y = limit_angle(m.slideYaw + newFacingDYaw)

    m.vel.x = m.slideVelX
    m.vel.y = 0.0
    m.vel.z = m.slideVelZ

    mario_update_moving_sand(m)
    mario_update_windy_ground(m)

    m.forwardVel = math_sqrt(m.slideVelX * m.slideVelX + m.slideVelZ * m.slideVelZ)
    if m.forwardVel > 100.0 then
        m.slideVelX = m.slideVelX * 100.0 / m.forwardVel
        m.slideVelZ = m.slideVelZ * 100.0 / m.forwardVel
    end
end

function update_roll_sliding(m, stopSpeed)
    stopped = 0

    intendedDYaw = m.intendedYaw - m.slideYaw
    forward = coss(intendedDYaw)
    sideward = sins(intendedDYaw)


    if forward < 0.0 and m.forwardVel >= 0.0 then
        forward = forward * (0.5 + 0.5 * m.forwardVel / 100.0)
    end

    accel        = 4.0
    lossFactor   = 0.994

    oldSpeed     = math_sqrt(m.slideVelX * m.slideVelX + m.slideVelZ * m.slideVelZ)
    angleChange  = (m.intendedMag / 32.0) * 0.6
    modSlideVelX = m.slideVelZ * angleChange * sideward * 0.05
    modSlideVelZ = m.slideVelX * angleChange * sideward * 0.05

    m.slideVelX  = m.slideVelX + modSlideVelX
    m.slideVelZ  = m.slideVelZ - modSlideVelZ

    newSpeed     = math_sqrt(m.slideVelX * m.slideVelX + m.slideVelZ * m.slideVelZ)

    if oldSpeed > 0.0 and newSpeed > 0.0 then
        m.slideVelX = m.slideVelX * oldSpeed / newSpeed
        m.slideVelZ = m.slideVelZ * oldSpeed / newSpeed
    end

    update_roll_sliding_angle(m, accel, lossFactor)

    if m.playerIndex == 0 and mario_floor_is_slope(m) == 0 and m.forwardVel * m.forwardVel < stopSpeed * stopSpeed then
        mario_set_forward_vel(m, 0.0)
        stopped = 1
    end

    return stopped
end

function act_mx_roll(m)
    if not moveset_active(m) then return set_mario_action(m, ACT_FREEFALL, 0) end
    local e = gMarioStateExtras[m.playerIndex]

    MAX_NORMAL_ROLL_SPEED = 70.0
    ROLL_BOOST_GAIN = 15.0
    ROLL_CANCEL_LOCKOUT_TIME = 10
    BOOST_LOCKOUT_TIME = 20

    if m.actionTimer == 0 then
        if m.prevAction ~= ACT_MX_ROLL_AIR then
            e.rotAngle = 0
            e.boostTimer = 0
        end
    elseif m.actionTimer >= ROLL_CANCEL_LOCKOUT_TIME or m.actionArg == 1 then
        if (m.input & INPUT_Z_DOWN) == 0 then
            return set_mario_action(m, ACT_WALKING, 0)
        end
    end

    if (m.input & INPUT_B_PRESSED) ~= 0 then
        queue_rumble_data_mario(m, 5, 80)
        return set_jumping_action(m, ACT_FORWARD_ROLLOUT, 0)
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_jumping_action(m, ACT_LONG_JUMP, 0)
    end

    if (m.controller.buttonPressed & L_TRIG) ~= 0 and m.actionTimer > 0 then
        m.vel.y = 19.0
        play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0)

        if e.boostTimer >= BOOST_LOCKOUT_TIME then
            e.boostTimer = 0

            if m.forwardVel < MAX_NORMAL_ROLL_SPEED then
                mario_set_forward_vel(m, math_min(m.forwardVel + ROLL_BOOST_GAIN, MAX_NORMAL_ROLL_SPEED))
            end

            m.particleFlags = m.particleFlags | PARTICLE_HORIZONTAL_STAR

            play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)
        end

        return set_mario_action(m, ACT_MX_ROLL_AIR, m.actionArg)
    end

    set_mario_animation(m, MARIO_ANIM_FORWARD_SPINNING)

    if update_roll_sliding(m, 10.0) ~= 0 then
        return set_mario_action(m, ACT_CROUCH_SLIDE, 0)
    end

    common_slide_action(m, ACT_CROUCH_SLIDE, ACT_MX_ROLL_AIR, MARIO_ANIM_FORWARD_SPINNING)

    e.rotAngle = e.rotAngle + (0x80 * m.forwardVel)
    if e.rotAngle > 0x10000 then
        e.rotAngle = e.rotAngle - 0x10000
    end
    set_anim_to_frame(m, 10 * e.rotAngle / 0x10000)

    e.boostTimer = e.boostTimer + 1

    m.actionTimer = m.actionTimer + 1

    return 0
end
hook_mario_action(ACT_MX_ROLL, act_mx_roll, INT_KICK)

function act_mx_roll_air(m)
    e = gMarioStateExtras[m.playerIndex]
    MAX_NORMAL_ROLL_SPEED = 50.0
    ROLL_AIR_CANCEL_LOCKOUT_TIME = 15

    if m.actionTimer == 0 then
        if m.prevAction ~= ACT_MX_ROLL then
            e.rotAngle   = 0
            e.boostTimer = 0
        end
    end

    if (m.input & INPUT_Z_DOWN) == 0 and m.actionTimer >= ROLL_AIR_CANCEL_LOCKOUT_TIME then
        return set_mario_action(m, ACT_FREEFALL, 0)
    end

    set_mario_animation(m, MARIO_ANIM_FORWARD_SPINNING)

    air_step = perform_air_step(m, 0)
    if air_step == AIR_STEP_LANDED then
        if check_fall_damage_or_get_stuck(m, ACT_HARD_BACKWARD_GROUND_KB) == 0 then
            play_sound_and_spawn_particles(m, SOUND_ACTION_TERRAIN_STEP, 0)
            return set_mario_action(m, ACT_MX_ROLL, m.actionArg)
        end
    elseif air_step == AIR_STEP_HIT_WALL then
        queue_rumble_data_mario(m, 5, 40)
        mario_bonk_reflection(m, false)
        m.faceAngle.y = m.faceAngle.y + 0x8000

        if m.vel.y > 0.0 then
            m.vel.y = 0.0
        end

        m.particleFlags = m.particleFlags | PARTICLE_VERTICAL_STAR
        return set_mario_action(m, ACT_BACKWARD_AIR_KB, 0)
    end

    e.rotAngle = e.rotAngle + 0x80 * m.forwardVel
    if e.rotAngle > 0x10000 then
        e.rotAngle = e.rotAngle - 0x10000
    end

    set_anim_to_frame(m, 10 * e.rotAngle / 0x10000)

    e.boostTimer = e.boostTimer + 1
    m.actionTimer = m.actionTimer + 1

    return false
end
hook_mario_action(ACT_MX_ROLL_AIR, act_mx_roll_air, INT_KICK)

function update_roll(m)
    if not moveset_active(m) then return end
    if m.action == ACT_DIVE_SLIDE then
        if (m.input & INPUT_ABOVE_SLIDE) == 0 then
            if (m.input & INPUT_Z_DOWN) ~= 0 and m.actionTimer < 2 then
                return set_mario_action(m, ACT_MX_ROLL, 1)
            end
        end
        m.actionTimer = m.actionTimer + 1
    end

    if m.action == ACT_LONG_JUMP_LAND then
        if (m.input & INPUT_Z_DOWN) ~= 0 and m.forwardVel > 15.0 and m.actionTimer < 1 then
            play_mario_landing_sound_once(m, SOUND_ACTION_TERRAIN_LANDING)
            return set_mario_action(m, ACT_MX_ROLL, 1)
        end
    end

    if m.action == ACT_CROUCHING then
        if (m.controller.buttonPressed & L_TRIG) ~= 0 then
            m.vel.y = 19.0
            mario_set_forward_vel(m, 32.0)
            play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0)

            play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)

            return set_mario_action(m, ACT_MX_ROLL_AIR, 0)
        end
    end

    if m.action == ACT_CROUCH_SLIDE then
        if (m.controller.buttonPressed & L_TRIG) ~= 0 then
            m.vel.y = 19.0
            mario_set_forward_vel(m, math_max(32, m.forwardVel))
            play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0)

            play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)

            return set_mario_action(m, ACT_MX_ROLL_AIR, 0)
        end
    end

    if m.action == ACT_GROUND_POUND_LAND then
        if (m.controller.buttonPressed & L_TRIG) ~= 0 then
            mario_set_forward_vel(m, 60)

            play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)

            return set_mario_action(m, ACT_MX_ROLL, 0)
        end
    end
end
hook_event(HOOK_MARIO_UPDATE, update_roll)



function resistance(m)
    if not moveset_active(m) then return end
    if m.hurtCounter > 1 then
        m.hurtCounter = 1
    end
end
hook_event(HOOK_MARIO_UPDATE, resistance)

function mario_update(m)
    if not moveset_active(m) then return end
    if m.action == ACT_JUMP then
        set_mario_animation(m, CHAR_ANIM_RUNNING_UNUSED)
    end
end
hook_event(HOOK_MARIO_UPDATE, mario_update)



function hold_fast_walking(m)
    if not moveset_active(m) then return end

    local hScale = 4

    if m.action == ACT_HOLD_WALKING then
        m.vel.x = m.vel.x * hScale
        m.vel.z = m.vel.z * hScale
    end
end
hook_event(HOOK_BEFORE_PHYS_STEP, hold_fast_walking)

function lighter_objects(m)
    if not moveset_active(m) then return end

    -- turn heavy objects into light
    if m.action == ACT_HOLD_HEAVY_IDLE then
        return set_mario_action(m, ACT_HOLD_IDLE, 0)
    end

end
hook_event(HOOK_MARIO_UPDATE, lighter_objects)

function faster_ground_pound(m) 
    if not moveset_active(m) then return end

    if m.action == ACT_GROUND_POUND then
        m.vel.y = m.vel.y * 1.8
    end
end
hook_event(HOOK_MARIO_UPDATE, faster_ground_pound)

function metal_speed(m)
    if not moveset_active(m) then return end

    if m.forwardVel >= 60 then
        m.flags = m.flags | MARIO_METAL_CAP
    else
        m.flags = m.flags & ~MARIO_METAL_CAP
    end
end
hook_event(HOOK_BEFORE_MARIO_UPDATE, metal_speed)

function char_before_phys_step(m)
    if   not moveset_active(m) then
        return
    end

    if m.action == ACT_BUBBLED then
        return
    end

    if gEventTable[m.character.type] == nil then
        return
    end

    if gEventTable[m.character.type].before_phys_step == nil then
        return
    end

    gEventTable[m.character.type].before_phys_step(m)
end

function char_on_set_action(m)
    if  not moveset_active(m) then
        return
    end

    if m.action == ACT_BUBBLED then
        return
    end

    if gEventTable[m.character.type] == nil then
        return
    end

    if gEventTable[m.character.type].on_set_action == nil then
        return
    end

    gEventTable[m.character.type].on_set_action(m)
end

function char_update(m)
    if  not moveset_active(m)  then
        return
    end

    if m.action == ACT_BUBBLED then
        return
    end

    if gEventTable[m.character.type] == nil then
        return
    end

    if gEventTable[m.character.type].update == nil then
        return
    end

    gEventTable[m.character.type].update(m)
end
hook_event(HOOK_MARIO_UPDATE, char_update)
hook_event(HOOK_ON_SET_MARIO_ACTION, char_on_set_action)
hook_event(HOOK_BEFORE_PHYS_STEP, char_before_phys_step)

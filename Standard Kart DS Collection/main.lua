-- name: Standard Kart DS Collection v1.0.0
-- incompatible:
-- description: Press L to spawn/unspawn a Kart \n\nDeveloped by \n\n\\#ffffff\\https::\\#ff6600\\Vi\\#ff8800\\ande\\#ffe200\\gras}\\#ffffff\\, Birdekek and \\#1892f5\\jzzle\\#ffffff\\ \n\nsome code from Shine Thief(EmilyEmmi), Birdekek, Caec, Arena(Djslin0) and ganewatch \n\n\The HUD Menu are from ANTONBLAST64(Sharen) \n\nEspecial Thanks to EmilyEmmi helping with the code and Birdekek helping with animations and some things
---
-- i'm new at coding so... eventually i will improve my code skill..
---
define_custom_obj_fields({
    oIsKart = 'f32',
    oVelDMG = 'f32',
    oKartOwner = 'u32',
    oColor = "f32",
})

ACT_KART_STAND_WATER =
allocate_mario_action(
ACT_GROUP_SUBMERGED | ACT_FLAG_MOVING | ACT_FLAG_SWIMMING | ACT_FLAG_SWIMMING_OR_FLYING | ACT_FLAG_WATER_OR_TEXT
)
ACT_KART_FALL_WATER =
allocate_mario_action(
ACT_GROUP_SUBMERGED | ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_MOVING | ACT_FLAG_SWIMMING | ACT_FLAG_SWIMMING_OR_FLYING | ACT_FLAG_WATER_OR_TEXT
)
ACT_KART_JUMP_WATER =
allocate_mario_action(
ACT_GROUP_SUBMERGED | ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_CONTROL_JUMP_HEIGHT | ACT_FLAG_SWIMMING | ACT_FLAG_SWIMMING_OR_FLYING | ACT_FLAG_WATER_OR_TEXT
)
ACT_KART_HITTED_WATER =
allocate_mario_action(
ACT_GROUP_SUBMERGED | ACT_FLAG_INTANGIBLE | ACT_FLAG_INVULNERABLE | ACT_GROUP_STATIONARY | ACT_FLAG_SWIMMING | ACT_FLAG_SWIMMING_OR_FLYING | ACT_FLAG_WATER_OR_TEXT
)
ACT_KART_HOLDING_WATER =
allocate_mario_action(
ACT_GROUP_SUBMERGED | ACT_FLAG_INTANGIBLE | ACT_FLAG_INVULNERABLE | ACT_GROUP_STATIONARY | ACT_FLAG_SWIMMING | ACT_FLAG_SWIMMING_OR_FLYING | ACT_FLAG_WATER_OR_TEXT
)
gKartStates = {}
for i = 0, (MAX_PLAYERS - 1) do
    gKartStates[i] = {}
    local s = gKartStates[i]
    s.shellcooldown = 0
    s.shellammo = 10
    s.shellreacharging = 0
    s.notthrowshellpls = false
    --- For the Engine Sounds ---
    s.idle = 0
    s.notidle = 0
    s.velrandom = 0
    s.yaho = false  
    -------------------------
    gPlayerSyncTable[i].inkart = false -- If the Player is in the kart
    gPlayerSyncTable[i].notspawned = true -- If the Kart is not Spawned to prevent bugs
    gPlayerSyncTable[i].montandocarrito = false
    gPlayerSyncTable[i].activador = false
    gPlayerSyncTable[i].coinspeed = 0
    gPlayerSyncTable[i].kartselect = 1 -- Number of Kart
    gPlayerSyncTable[i].playerdisconected = false
    gPlayerSyncTable[i].randomize = 0
    gPlayerSyncTable[i].animtimer = 0
    gPlayerSyncTable[i].timingTimer = true
    gPlayerSyncTable[i].TurnTimer = 0
    gPlayerSyncTable[i].islanding = true
end
gPlayerSyncTable[0].kartset = E_MODEL_KART
---
gGlobalSyncTable.ispermitted = false
gGlobalSyncTable.speedcc = 1 -- Kart Speed 
gGlobalSyncTable.kartinteracts = false -- Enable Kart Interaction between Players
gGlobalSyncTable.coinamount = 0 -- Coin Amount
gGlobalSyncTable.autojump = false
gGlobalSyncTable.accurateMKDSSpeed = false -- Changes speed to be accurate to MKDS.
gGlobalSyncTable.shellshotmode = false -- Shell Shooter Modifier
---
mkds = get_texture_info('mkds')
TEX_SHELL = get_texture_info("shell")
TEX_COIN = get_texture_info("coin")
---
ACT_KART_STAND = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING)
ACT_KART_FALL = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_MOVING)
ACT_KART_JUMP = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_CONTROL_JUMP_HEIGHT)
ACT_KART_HITTED = allocate_mario_action( ACT_FLAG_INTANGIBLE | ACT_FLAG_INVULNERABLE | ACT_GROUP_STATIONARY)
ACT_KART_HOLDING = allocate_mario_action(ACT_GROUP_STATIONARY)
---
-- Kart Models --
E_MODEL_KART = smlua_model_util_get_id("kart_geo")
E_MODEL_SHYGUYK = smlua_model_util_get_id("kart_shyguy_geo")
E_MODEL_MARIOK = smlua_model_util_get_id("kart_mario_geo")
E_MODEL_LUIGIK = smlua_model_util_get_id("kart_luigi_geo")
E_MODEL_TOADK = smlua_model_util_get_id("kart_toad_geo")
E_MODEL_WARIOK = smlua_model_util_get_id("kart_wario_geo")
E_MODEL_WALUIGIK = smlua_model_util_get_id("kart_waluigi_geo")
---
E_MODEL_PEACHK = smlua_model_util_get_id("kart_peach_geo")
E_MODEL_DAISYK = smlua_model_util_get_id("kart_daisy_geo")
E_MODEL_BOWSERK = smlua_model_util_get_id("kart_bowser_geo")
E_MODEL_DKK = smlua_model_util_get_id("kart_dk_geo")
E_MODEL_YOSHIK = smlua_model_util_get_id("kart_yoshi_geo")
E_MODEL_DRYK = smlua_model_util_get_id("kart_dry_geo")
E_MODEL_ROBK = smlua_model_util_get_id("kart_rob_geo")
E_MODEL_ROSALINAK = smlua_model_util_get_id("kart_rosalina_geo")
E_MODEL_TOADETTEK = smlua_model_util_get_id("kart_toadette_geo")
E_MODEL_KOPAK = smlua_model_util_get_id("kart_koopa_geo")
E_MODEL_DBOWSERK = smlua_model_util_get_id("kart_dbowser_geo")
E_MODEL_PAULINEK = smlua_model_util_get_id("kart_pauline_geo")
E_MODEL_LAKITUK = smlua_model_util_get_id("kart_lakitu_geo")
E_MODEL_PLAYERK = smlua_model_util_get_id("kart_player_geo")

--localize functions to improve performance
local
hook_chat_command, network_player_set_description, hook_on_sync_table_change, network_is_server,
hook_event, djui_popup_create, network_get_player_text_color_string, play_sound,
play_character_sound, djui_chat_message_create, djui_hud_set_resolution, djui_hud_set_font,
djui_hud_set_color, djui_hud_render_rect, djui_hud_print_text, djui_hud_get_screen_width, djui_hud_get_screen_height,
djui_hud_measure_text, tostring, warp_to_level, warp_to_start_level, stop_cap_music, dist_between_objects,
math_random, math_ceil, table_insert, set_camera_mode, spawn_non_sync_object,set_mario_action,clamp,obj_mark_for_deletion,spawn_mist_particles,
djui_chat_message_create,obj_set_gfx_pos,obj_set_pos,network_player_from_global_index,tonumber,
smlua_anim_util_set_animation,obj_get_nearest_object_with_behavior_id,set_anim_to_frame,set_mario_particle_flags
=
hook_chat_command, network_player_set_description, hook_on_sync_table_change, network_is_server,
hook_event, djui_popup_create, network_get_player_text_color_string, play_sound,
play_character_sound, djui_chat_message_create, djui_hud_set_resolution, djui_hud_set_font,
djui_hud_set_color, djui_hud_render_rect, djui_hud_print_text, djui_hud_get_screen_width, djui_hud_get_screen_height,
djui_hud_measure_text, tostring, warp_to_level, warp_to_start_level, stop_cap_music, dist_between_objects,
math.random, math.ceil, table.insert, set_camera_mode, spawn_non_sync_object,set_mario_action,clamp,obj_mark_for_deletion,spawn_mist_particles,
djui_chat_message_create,obj_set_gfx_pos,obj_set_pos,network_player_from_global_index,tonumber,
smlua_anim_util_set_animation,obj_get_nearest_object_with_behavior_id,set_anim_to_frame,set_mario_particle_flags
---
unlck = false
---
for mod in pairs(gActiveMods) do
     local m = gMarioStates[0]
     local sMario = gPlayerSyncTable[m.playerIndex]
    if gActiveMods[mod].name:find("Flood Expanded") then
      if m.health <= 0xff then
        set_mario_spectator(m)
        sMario.inkart = false
      end
    end
end

function hittp(obj) -- idk what is this doing here
    local np = network_player_from_global_index(obj.oKartOwner)
    local m = gMarioStates[np.localIndex]
    local player = nearest_mario_state_to_object(obj)
    if player ~= nil and obj_check_hitbox_overlap(obj, player.marioObj) and player.playerIndex ~= m.playerIndex then
        return true
    end
    return false
end

function convert_s16(num)
    local min = -32768
    local max = 32767
    while (num < min) do
        num = max + (num - min)
    end
    while (num > max) do
        num = min + (num - max)
    end
    return num
end

-- Some things from Arena
local function attacked(obj, m, pos, radius)
    local np = network_player_from_global_index(obj.oKartOwner - 1)
    local cm = m
    if m.playerIndex == 0 and np.localIndex ~= 0 then
        cm = lag_compensation_get_local_state(np)
    end

    local mPos1 = { x = cm.pos.x, y = cm.pos.y + 50,  z = cm.pos.z }
    local mPos2 = { x = cm.pos.x, y = cm.pos.y + 150, z = cm.pos.z }
    local ret = (vec3f_dist(pos, mPos1) < radius or vec3f_dist(pos, mPos2) < radius)
    return ret
end

function global_index_hurts_mario_state(globalIndex, m)
    if globalIndex == gNetworkPlayers[m.playerIndex].globalIndex then
        return false
    end
    local npAttacker = network_player_from_global_index(globalIndex)
    if npAttacker == nil then
        return false
    end
    local sAttacker = gPlayerSyncTable[npAttacker.localIndex]
    local sVictim = gPlayerSyncTable[m.playerIndex]

    return sAttacker.team ~= sVictim.team
end

--- @param m MarioState
function active_player(m)
    local np = gNetworkPlayers[m.playerIndex]
    if m.playerIndex == 0 then
        return 1
    end
    if not np.connected then
        return 0
    end
    if np.currCourseNum ~= gNetworkPlayers[0].currCourseNum then
        return 0
    end
    if np.currActNum ~= gNetworkPlayers[0].currActNum then
        return 0
    end
    if np.currLevelNum ~= gNetworkPlayers[0].currLevelNum then
        return 0
    end
    if np.currAreaIndex ~= gNetworkPlayers[0].currAreaIndex then
        return 0
    end
    return is_player_active(m)
end

--- @param m MarioState
function is_invuln_or_intang(m)
    local invuln = ((m.action & ACT_FLAG_INVULNERABLE) ~= 0) or (m.invincTimer ~= 0)
    local intang = ((m.action & ACT_FLAG_INTANGIBLE) ~= 0)
    return invuln or intang
end
--- @param m MarioState
function mario_health_float(m)
    return clamp((m.health - 255) / (2176 - 255), 0, 1)
end

function clamp(val, min, max)
    if val < min then return min end
    if val > max then return max end
    return val
end

--------------------------------------------------------------------------------------------------
--- @param m MarioState
function mario_update(m)
    local np = gNetworkPlayers[0]
    local sMario = gPlayerSyncTable[m.playerIndex]


-- THIS SOLVES SOME MODEL ERRORS -----------------------------------------------------------------
if sMario.kartselect == 1 then
    sMario.kartset = E_MODEL_MARIOK
elseif sMario.kartselect == 2 then
    sMario.kartset = E_MODEL_LUIGIK
elseif sMario.kartselect == 3 then
    sMario.kartset = E_MODEL_TOADK
elseif sMario.kartselect == 4 then
    sMario.kartset = E_MODEL_WARIOK
elseif sMario.kartselect == 5 then
    sMario.kartset = E_MODEL_WALUIGIK
elseif sMario.kartselect == 6 then
    sMario.kartset = E_MODEL_SHYGUYK
elseif sMario.kartselect == 7 then
    sMario.kartset = E_MODEL_PEACHK
elseif sMario.kartselect == 8 then
    sMario.kartset = E_MODEL_DAISYK
elseif sMario.kartselect == 9 then
    sMario.kartset = E_MODEL_YOSHIK
elseif sMario.kartselect == 10 then
    sMario.kartset = E_MODEL_BOWSERK
elseif sMario.kartselect == 11 then
    sMario.kartset = E_MODEL_DKK
elseif sMario.kartselect == 12 then
    sMario.kartset = E_MODEL_DRYK
elseif sMario.kartselect == 13 then
    sMario.kartset = E_MODEL_ROBK
elseif sMario.kartselect == 14 then
    sMario.kartset = E_MODEL_TOADETTEK
elseif sMario.kartselect == 15 then
    sMario.kartset = E_MODEL_ROSALINAK
elseif sMario.kartselect == 16 then
    sMario.kartset = E_MODEL_KOPAK
elseif sMario.kartselect == 17 then
    sMario.kartset = E_MODEL_DBOWSERK
elseif sMario.kartselect == 18 then
    sMario.kartset = E_MODEL_PAULINEK
elseif sMario.kartselect == 19 then
    sMario.kartset = E_MODEL_LAKITUK
elseif sMario.kartselect == 20 then
    sMario.kartset = E_MODEL_PLAYERK
end


---------------------------------------------------------------------------------------------------
-- "Double Dash" mode i guess... --
---------------------------------------------------------------------------------------------------

            -- Mario Driver is Nearest to Ride
 local kartspw = obj_get_first_with_behavior_id(id_bhvKart)
local KART = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvKart)
 if KART ~= nil and gGlobalSyncTable.speedcc == 1 then
 if dist_between_objects(m.marioObj, KART) <= 250 and (m.controller.buttonDown & D_JPAD) ~= 0 and kartspw.oKartOwner ~= gNetworkPlayers[m.playerIndex].globalIndex and sMario.inkart == false and (m.action ~= ACT_KART_STAND and m.action ~= ACT_KART_FALL and m.action ~= ACT_KART_JUMP and m.action ~= ACT_KART_HITTED and m.action ~= ACT_KART_STAND_WATER and m.action ~= ACT_KART_FALL_WATER and m.action ~= ACT_KART_JUMP_WATER and m.action ~= ACT_KART_HITTED_WATER) then
    sMario.montandocarrito = true
    if (m.action & ACT_FLAG_SWIMMING_OR_FLYING) == 0 then
    set_mario_action(m, ACT_KART_HOLDING, 0)
    elseif (m.action & ACT_FLAG_SWIMMING_OR_FLYING) ~= 0 then
    set_mario_action(m, ACT_KART_HOLDING_WATER, 0)
    end
 else
   sMario.montandocarrito = false
 end
 else    sMario.montandocarrito = false
 end


 local m2 = nearest_mario_state_to_object(m.marioObj)
-- some codes from ganewatch
if m2 ~= nil and dist_between_objects(m.marioObj, m2.marioObj) <= 250 and KART ~= nil and m.action ~= ACT_BACKWARD_ROLLOUT and (m.action == ACT_KART_HOLDING or m.action == ACT_KART_HOLDING_WATER) and (m.action ~= ACT_KART_STAND and m.action ~= ACT_KART_FALL and m.action ~= ACT_KART_JUMP and m.action ~= ACT_KART_HITTED and m.action ~= ACT_KART_STAND_WATER and m.action ~= ACT_KART_FALL_WATER and m.action ~= ACT_KART_JUMP_WATER and m.action ~= ACT_KART_HITTED_WATER) and (m2 ~= nil and m2.action ~= ACT_KART_HITTED) and (m2.action ~= ACT_KART_HOLDING) and gGlobalSyncTable.speedcc == 1 then
   sMario.inkart = false
   m.faceAngle.y = m2.faceAngle.y
   local armHeight = 0
   local armLength = -60
   local armTheta = -100
   local SpawnTheta = ((m2.faceAngle.y + armTheta) / 0x8000) * math.pi
   local XOffset =  math.sin(SpawnTheta) * armLength
    local ZOffset =  math.cos(SpawnTheta) * armLength
    m.pos.x = m2.pos.x + XOffset  + m2.vel.x
    m.pos.y = m2.pos.y + armHeight + m2.vel.y
    m.pos.z = m2.pos.z + ZOffset + m2.vel.z
    m.marioObj.header.gfx.angle.y = m2.faceAngle.y
    sMario.activador = true
    nowdead = false
    vec3f_to_object_pos(m.marioObj, m2.pos)
  obj_set_gfx_pos(m.marioObj, m2.pos.x + XOffset  + m2.vel.x/15, m2.pos.y + armHeight + m2.vel.y, m2.pos.z + ZOffset + m2.vel.z/15)
  obj_set_pos(m.marioObj, m2.pos.x + XOffset  + m2.vel.x/15, m2.pos.y + armHeight + m2.vel.y, m2.pos.z + ZOffset + m2.vel.z/15)
 elseif sMario.montandocarrito == false and sMario.activador == true or m2 ~= nil and m2.action == ACT_KART_HITTED and sMario.activador == true or sMario.activador == true and m2.action == ACT_KART_HOLDING then
  m.vel.y = 20
 m.forwardVel = -30
  m.flags = m.flags & ~(ACT_FLAG_INTANGIBLE | ACT_FLAG_INVULNERABLE)
  set_mario_action(m, ACT_BACKWARD_ROLLOUT, 0)
   sMario.activador = false
   nowdead = true
 end


-- mGfx.pos.x + XOffset, mGfx.pos.y + armHeight, mGfx.pos.z + ZOffset,


    if sMario.inkart == true and (m.action ~= ACT_KART_STAND_WATER and m.action ~= ACT_KART_FALL_WATER and m.action ~= ACT_KART_JUMP_WATER and m.action ~= ACT_KART_HITTED_WATER) and m.action & ACT_GROUP_CUTSCENE == 0 and m.action & ACT_FLAG_SWIMMING_OR_FLYING ~= 0 then
        local waterActions =
        m.action == ACT_WATER_PLUNGE or m.action == ACT_WATER_IDLE or m.action == ACT_FLUTTER_KICK or
        m.action == ACT_SWIMMING_END or
        m.action == ACT_WATER_ACTION_END or
        m.action == ACT_HOLD_WATER_IDLE or
        m.action == ACT_HOLD_WATER_JUMP or
        m.action == ACT_HOLD_WATER_ACTION_END or
        (m.action & ACT_FLAG_METAL_WATER) ~= 0 or
        m.action == ACT_BREASTSTROKE
        if waterActions then
            if m.vel.y <= -25 then
                set_mario_particle_flags(m, PARTICLE_WATER_SPLASH, false)
            end
            return set_mario_action(m, ACT_KART_FALL_WATER, 0)
        end
        if m.action == ACT_KART_FALL_WATER and (m.controller.buttonDown & Z_TRIG) ~= 0 then
            m.vel.y = -50.0
            set_mario_particle_flags(m, PARTICLE_PLUNGE_BUBBLE, false)
            m.marioObj.header.gfx.scale.y = 1.5
            m.marioObj.header.gfx.scale.z = 0.7
            m.marioObj.header.gfx.scale.x = 0.7
            return set_mario_action(m, ACT_KART_FALL_WATER, 2)
        end
    end

    
    if (m.playerIndex == 0) then
        kart(m)
    end
end
hook_event(HOOK_MARIO_UPDATE, mario_update)

--- @param m MarioState
function kart_speed(m) -- Speed
    if m.action == ACT_KART_STAND and gGlobalSyncTable.speedcc == 1 then
        if gGlobalSyncTable.accurateMKDSSpeed == true then
            m.vel.x = m.vel.x * 2.80
            m.vel.z = m.vel.z * 2.80
        else
            m.vel.x = m.vel.x * 1.40
            m.vel.z = m.vel.z * 1.40
        end
    end

    if m.action == ACT_KART_STAND and gGlobalSyncTable.speedcc == 2 then
        if gGlobalSyncTable.accurateMKDSSpeed == true then
            m.vel.x = m.vel.x * 3.00
            m.vel.z = m.vel.z * 3.00
        else
            m.vel.x = m.vel.x * 1.50
            m.vel.z = m.vel.z * 1.50
        end
    end
    
    if m.action == ACT_KART_STAND and gGlobalSyncTable.speedcc == 3 then
        if gGlobalSyncTable.accurateMKDSSpeed == true then
            m.vel.x = m.vel.x * 3.20
            m.vel.z = m.vel.z * 3.20
        else
            m.vel.x = m.vel.x * 1.60
            m.vel.z = m.vel.z * 1.60
        end
    end

    if m.action == ACT_KART_STAND and gGlobalSyncTable.speedcc == 4 then
        if gGlobalSyncTable.accurateMKDSSpeed == true then
            m.vel.x = m.vel.x * 3.60
            m.vel.z = m.vel.z * 3.60
        else
            m.vel.x = m.vel.x * 1.80
            m.vel.z = m.vel.z * 1.80
        end
    end
end
hook_event(HOOK_BEFORE_PHYS_STEP, kart_speed)

--- @param m MarioState
function kart(m)
    local s = gKartStates[m.playerIndex]
    local np = gNetworkPlayers[0]   
    local sMario = gPlayerSyncTable[m.playerIndex]
    local playerIndex = m.playerIndex

    if (playerIndex ~= 0) then
        return
    end


    pause_menu(m)

--- LAKITU KART FLOATING SKILL ---
    if sMario.kartselect == 19 and sMario.inkart == true and m.action ~= ACT_LAVA_BOOST then
        if (m.controller.buttonDown & A_BUTTON) ~= 0 then
            if m.vel.y < -30 then
                local interaction = determine_interaction(m, m.marioObj)
                if interaction ~= INT_GROUND_POUND then
                    m.vel.y = -25
                elseif m.vel.y < -70 then
                    m.vel.y = -70
                end
            elseif m.vel.y ~= 0 then
                m.vel.y = m.vel.y + 2.50
            end
        end
    end
------------------------------------------

   -- For the coin mode ..

   if m.playerIndex == 0 then
   if sMario.coinspeed > 10 then
   sMario.coinspeed = 10
   elseif   sMario.coinspeed < 0 then
   sMario.coinspeed = 0
   end
   end


 -- Engine Sounds from MK DS --

if (m.action == ACT_KART_STAND and m.controller.rawStickX == 0 and m.controller.rawStickY == 0 ) then
    m.forwardVel = m.forwardVel + 1.15
    if m.forwardVel > 0.05 then
        m.forwardVel = (m.forwardVel / 1.15)
    end
    if s.idle == 0 then
    network_play(sDecelerate, m.pos,  0.30, m.playerIndex)
    s.idle = 1
    end
    if m.actionTimer % 22 == 0 then
        network_play(sIdle, m.pos,  0.30, m.playerIndex)
    end
else
    s.idle = 0
end

if (m.action == ACT_KART_STAND ) and (m.controller.rawStickX ~= 0 or m.controller.rawStickY ~= 0) then
    if s.notidle == 0 then
    network_play(sAccelerate, m.pos,  0.30, m.playerIndex)
    s.notidle = 1
    end
else
    s.notidle = 0
end

if (m.action == ACT_KART_STAND or m.action == ACT_KART_JUMP) and m.forwardVel >= 28 then
    if m.actionTimer % 11 == 0 then
        network_play(sMediumvel, m.pos, 0.30, m.playerIndex)
    end
end


if sMario.inkart == true or (m.action == ACT_KART_STAND or m.action == ACT_KART_JUMP or m.action == ACT_KART_HITTED ) and m.action & ACT_FLAG_SWIMMING_OR_FLYING == 0 then
    local waterActions =
    m.action == ACT_WATER_PLUNGE or m.action == ACT_WATER_IDLE or m.action == ACT_FLUTTER_KICK or
    m.action == ACT_SWIMMING_END or
    m.action == ACT_WATER_ACTION_END or
    m.action == ACT_HOLD_WATER_IDLE or
    m.action == ACT_HOLD_WATER_JUMP or
    m.action == ACT_HOLD_WATER_ACTION_END or
   (m.action & ACT_FLAG_METAL_WATER) ~= 0 or
    m.action == ACT_BREASTSTROKE
    if not waterActions then
        if (m.action == ACT_FORWARD_AIR_KB 
        or m.action == ACT_FORWARD_GROUND_KB 
        or m.action == ACT_HARD_FORWARD_AIR_KB 
        or m.action == ACT_HARD_FORWARD_GROUND_KB 
        or m.action == ACT_SOFT_FORWARD_GROUND_KB
        or m.action == ACT_BACKWARD_AIR_KB 
        or m.action == ACT_BACKWARD_GROUND_KB 
        or m.action == ACT_HARD_BACKWARD_AIR_KB 
        or m.action == ACT_HARD_BACKWARD_GROUND_KB 
        or m.action == ACT_SOFT_BACKWARD_GROUND_KB) then
    set_mario_action(m, ACT_KART_HITTED, 0)
    end
    end
end

if sMario.inkart == true or (m.action == ACT_KART_STAND_WATER or m.action == ACT_KART_JUMP_WATER or m.action == ACT_KART_HITTED_WATER) and m.action & ACT_FLAG_SWIMMING_OR_FLYING ~= 0 then
    local waterActions =
           m.action == ACT_FORWARD_WATER_KB
        or m.action == ACT_BACKWARD_WATER_KB   
        or m.action == ACT_BACKWARD_AIR_KB 
    if waterActions then
    set_mario_action(m, ACT_KART_HITTED_WATER, 0)
    end
end


-- Lose Coins --

if m.playerIndex == 0 then
    if m.action == ACT_KART_HITTED or m.action == ACT_KART_HITTED_WATER then
    if m.actionTimer % 1 == 0 then
        sMario.randomize = math.random(40)
    end
    
    if sMario.randomize == 10 then
    if sMario.coinspeed >= 1 then
        sMario.coinspeed = sMario.coinspeed - 1
        spawn_sync_object(
            id_bhvCoinS,
            E_MODEL_COINS,
            m.pos.x, m.pos.y + 200, m.pos.z,
            function(o)
                o.oForwardVel = 10
                obj_scale_xyz(o, 1,1,1)
                o.oFaceAngleYaw = o.oMoveAngleYaw
            end
        )
    end
    end
end

end

-- Shell CoolDown and Shell Spawning -- 

local s = gKartStates[m.playerIndex]
s.shellcooldown = s.shellcooldown - 1
s.shellreacharging = s.shellreacharging + 1

if gGlobalSyncTable.shellshotmode == false then
    s.shellammo = 10
    s.notthrowshellpls = false
    s.shellreacharging = 0
    s.shellcooldown = 0
end

if s.shellammo <= 0 then
    s.notthrowshellpls = true
elseif s.shellammo == 10 then 
    s.shellreacharging = 0
    s.notthrowshellpls = false
end

if s.shellreacharging % 10 == 0 and s.notthrowshellpls == true then
    s.shellammo = s.shellammo + 1
end

if sMario.inkart == true and gGlobalSyncTable.shellshotmode == true then
if (m.controller.buttonPressed & B_BUTTON) ~= 0 and s.shellcooldown <= 0 and s.notthrowshellpls == false then
    s.shellcooldown = 20
    s.shellammo = s.shellammo -1
    spawn_mist_particles()
    spawn_sync_object(
        id_bhvGreenShellK,
        E_MODEL_KOOPA_SHELL,
        m.pos.x, m.pos.y, m.pos.z,
        function(o)
            o.oForwardVel = 120 + m.forwardVel
            obj_scale_xyz(o, 1,1,1)
            o.oKartOwner = gNetworkPlayers[m.playerIndex].globalIndex
            o.oFaceAngleYaw = o.oMoveAngleYaw
        end
    )
end
end

if (m.action & ACT_FLAG_ON_POLE) ~= 0 and sMario.inkart == true then
    sMario.inkart = false
    set_mario_action(m, ACT_HARD_FORWARD_GROUND_KB, 0)
end

---------------------------------------------------------------------------------------------------
-- Kart Models --
---------------------------------------------------------------------------------------------------

    local kartmodel = E_MODEL_KART

    if sMario.kartselect == 1 then
        kartmodel = E_MODEL_MARIOK
        sMario.kartset = E_MODEL_MARIOK
    elseif sMario.kartselect == 2 then
        kartmodel = E_MODEL_LUIGIK 
        sMario.kartset = E_MODEL_LUIGIK
    elseif sMario.kartselect == 3 then
        kartmodel = E_MODEL_TOADK
        sMario.kartset = E_MODEL_TOADK
    elseif sMario.kartselect == 4 then
        kartmodel = E_MODEL_WARIOK
        sMario.kartset = E_MODEL_WARIOK
    elseif sMario.kartselect == 5 then
        kartmodel = E_MODEL_WALUIGIK
        sMario.kartset = E_MODEL_WALUIGIK
    elseif sMario.kartselect == 6 then
        kartmodel = E_MODEL_SHYGUYK
        sMario.kartset = E_MODEL_SHYGUYK
    elseif sMario.kartselect == 7 then
        kartmodel = E_MODEL_PEACHK
        sMario.kartset = E_MODEL_PEACHK
    elseif sMario.kartselect == 8 then
        kartmodel = E_MODEL_DAISYK
        sMario.kartset = E_MODEL_DAISYK
    elseif sMario.kartselect == 9 then
        kartmodel = E_MODEL_YOSHIK
        sMario.kartset = E_MODEL_YOSHIK
    elseif sMario.kartselect == 10 then
        kartmodel = E_MODEL_BOWSERK
        sMario.kartset = E_MODEL_BOWSERK
    elseif sMario.kartselect == 11 then
        kartmodel = E_MODEL_DKK
        sMario.kartset = E_MODEL_DKK
    elseif sMario.kartselect == 12 then
        kartmodel = E_MODEL_DRYK
        sMario.kartset = E_MODEL_DRYK
    elseif sMario.kartselect == 13 then
        kartmodel = E_MODEL_ROBK 
        sMario.kartset = E_MODEL_ROBK
    elseif sMario.kartselect == 14 then
        kartmodel = E_MODEL_TOADETTEK 
        sMario.kartset = E_MODEL_TOADETTEK
    elseif sMario.kartselect == 15 then
        kartmodel = E_MODEL_ROSALINAK
        sMario.kartset = E_MODEL_ROSALINAK
    elseif sMario.kartselect == 16 then
        kartmodel = E_MODEL_KOPAK
        sMario.kartset = E_MODEL_KOPAK
    elseif sMario.kartselect == 17 then
        kartmodel = E_MODEL_DBOWSERK
        sMario.kartset = E_MODEL_DBOWSERK
    elseif sMario.kartselect == 18 then
        kartmodel = E_MODEL_PAULINEK
        sMario.kartset = E_MODEL_PAULINEK
    elseif sMario.kartselect == 19 then
        kartmodel = E_MODEL_LAKITUK
        sMario.kartset = E_MODEL_LAKITUK
    elseif sMario.kartselect == 20 then
        kartmodel = E_MODEL_PLAYERK
        sMario.kartset = E_MODEL_PLAYERK
    end
    
-----------------------------------------------------------------
-----------------------------------------------------------------

if m.action == ACT_IDLE or m.action == ACT_FORWARD_ROLLOUT or m.action == ACT_DOUBLE_JUMP or m.action == ACT_WATER_IDLE or m.action == ACT_WATER_PUNCH then
    sMario.inkart = false
end

if sMario.inkart == true and (m.action ~= ACT_KART_STAND and m.action ~= ACT_KART_FALL and m.action ~= ACT_KART_JUMP and m.action ~= ACT_KART_HITTED) and m.action & ACT_GROUP_CUTSCENE == 0 and m.action & ACT_FLAG_AIR == 0 and m.action & ACT_FLAG_SWIMMING_OR_FLYING == 0
  then
    set_mario_action(m, ACT_KART_STAND,0)
end

if sMario.inkart == true and m.action == ACT_GRAB_POLE_FAST or m.action == ACT_GRAB_POLE_SLOW then
    set_mario_action(m, ACT_FORWARD_AIR_KB,0)
    sMario.inkart = false
end


-----------------------------------------------------------------
-- Summon Kart --        
-----------------------------------------------------------------
for i = 0, (MAX_PLAYERS-1) do
local m = gMarioStates[i]
local sMario = gPlayerSyncTable[i]
if (m.playerIndex == 0) then
if sMario.inkart == false then

    if m.controller.buttonPressed & L_TRIG ~= 0 and (m.action & ACT_FLAG_RIDING_SHELL == 0) and m.action & ACT_GROUP_CUTSCENE == 0 and m.action ~= ACT_WATER_PUNCH and m.action ~= ACT_FORWARD_ROLLOUT then
        spawn_mist_particles()
            sMario.inkart = true
             spawn_sync_object(
                id_bhvKart,
                kartmodel,
                m.pos.x,m.pos.y,m.pos.z,
                function(obj)
                    obj.oFaceAnglePitch = 0
                    obj.oFaceAngleRoll = 0
                    obj.oAction = 0
                    obj.oIsKart = 1
                    obj.oColor = np.globalIndex
                    obj.oKartOwner = gNetworkPlayers[m.playerIndex].globalIndex + 1
                end
            )
            if m.action & ACT_FLAG_SWIMMING_OR_FLYING ~= 0 then
            set_mario_action(m, ACT_KART_JUMP_WATER,0)
            elseif m.action & ACT_FLAG_SWIMMING_OR_FLYING == 0 then
            set_mario_action(m, ACT_KART_JUMP,0)
            end
        end
    end
end
end
end
--------------------------------------------------------------------------------------
-- Initialize Players --
--------------------------------------------------------------------------------------
--- @param m MarioState
function player_initialize(m)
	syncTable = gPlayerSyncTable[m.playerIndex]
    syncTable.playerdisconected = false
end
--------------------------------------------------------------------------------------

-- Kart BHV --

--------------------------------------------------------------------------------------

function bhv_kart_init(obj)
    obj.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    obj.oWallHitboxRadius = 120
    obj.oGravity = -4
    obj.oBounciness = -0.5
    obj.oDragStrength = 1
    obj.oFriction = 10
    obj.oBuoyancy = 2
    obj.oVelDMG = 0
    obj.hitboxRadius = 0
    obj.hitboxHeight = 0
    obj.hitboxDownOffset = 0
    network_init_object(obj, true, {
        'oColor',
        })
end


function bhv_kart_loop(obj,directHitLocal) -- Arena Based}
    local index = network_local_index_from_global(obj.oKartOwner - 1)
    if not index then
        obj_mark_for_deletion(obj)
        return
    end
    local m = gMarioStates[index]

    if index ~= 0 and is_player_active(m) == 0 then
        obj_mark_for_deletion(obj)
        return
    end

    local sMario = gPlayerSyncTable[index]
    sMario.inkart = true
    if sMario.islanding == true then
        cur_obj_align_gfx_with_floor()
    end

    obj.globalPlayerIndex = obj.oColor

if obj.oTimer >= 1 then

    if (m.action ~= ACT_KART_STAND and m.action ~= ACT_KART_FALL and m.action ~= ACT_KART_JUMP and m.action ~= ACT_KART_HITTED and m.action ~= ACT_KART_STAND_WATER and m.action ~= ACT_KART_FALL_WATER and m.action ~= ACT_KART_JUMP_WATER and m.action ~= ACT_KART_HITTED_WATER
    and m.action == ACT_FORWARD_AIR_KB 
    and m.action == ACT_FORWARD_GROUND_KB 
    and m.action == ACT_HARD_FORWARD_AIR_KB 
    and m.action == ACT_HARD_FORWARD_GROUND_KB 
    and m.action == ACT_SOFT_FORWARD_GROUND_KB
    and m.action == ACT_BACKWARD_AIR_KB 
    and m.action == ACT_BACKWARD_GROUND_KB 
    and m.action == ACT_HARD_BACKWARD_AIR_KB 
    and m.action == ACT_HARD_BACKWARD_GROUND_KB 
    and m.action == ACT_SOFT_BACKWARD_GROUND_KB 
    and m.action == ACT_FORWARD_WATER_KB
    and m.action == ACT_BACKWARD_WATER_KB) then
        sMario.inkart = false
        spawn_mist_particles()
        obj_mark_for_deletion(obj)
        return
    end


    for mod in pairs(gActiveMods) do
       if gActiveMods[mod].name:find("Flood Expanded") then
         if m.health <= 0xff then
           sMario.inkart = false
           obj_mark_for_deletion(obj)
         end
       end
   end
   

    local player = m.marioObj
    if player then
        obj_copy_pos(obj, player)
    end
    
    if player then
        obj.oFaceAngleYaw = player.oMoveAngleYaw
    end
    
    local sMario = gPlayerSyncTable[m.playerIndex]
    obj_set_model_extended(obj, sMario.kartset)
    obj.oFaceAnglePitch = m.marioObj.header.gfx.angle.x + (m.marioBodyState.torsoAngle.x * 0.5)
    obj.oFaceAngleYaw = m.marioObj.header.gfx.angle.y + (m.marioBodyState.torsoAngle.y * 0.5)
    obj.oFaceAngleRoll = m.marioObj.header.gfx.angle.z + (m.marioBodyState.torsoAngle.z * 0.5)

    if m.action == ACT_FORWARD_ROLLOUT or m.action == ACT_WATER_PUNCH then
        spawn_mist_particles()
        obj_mark_for_deletion(obj)
    end

    local DeathActions = 
  (m.action == ACT_DEATH_EXIT_LAND
or m.action == ACT_DEATH_EXIT
or m.action == ACT_DEATH_ON_BACK 
or m.action == ACT_DEATH_ON_STOMACH
or m.action == ACT_FALLING_DEATH_EXIT
or m.action == ACT_SPECIAL_DEATH_EXIT 
or m.action == ACT_WATER_DEATH or m.action & ACT_GROUP_CUTSCENE ~= 0)
if DeathActions then
    sMario.inkart = false
    obj_mark_for_deletion(obj)
end

    if active_player(m) and m.marioBodyState.updateTorsoTime == gMarioStates[0].marioBodyState.updateTorsoTime and m.action ~= ACT_DISAPPEARED and m.action ~= ACT_IN_CANNON then
        if (m.action & ACT_FLAG_ON_POLE) == 0 and m.action ~= ACT_JUMBO_STAR_CUTSCENE then
            if gPlayerSyncTable[m.playerIndex].inkart == true then
                obj.oPosX = m.pos.x
                obj.oPosY = m.pos.y
                obj.oPosZ = m.pos.z
            else
                vec3f_to_object_pos(obj, m.pos)
            end
        else
            vec3f_to_object_pos(obj, m.marioBodyState.torsoPos)
        end
    else
        vec3f_to_object_pos(obj, m.pos)
    end

    if _G.ShineThief then
        STplayerspectating = _G.ShineThief.get_spectator(m.playerIndex)
    end

end
    
----- KART ATTACK -----
if obj.oIsKart== 1 and  m.forwardVel >=  27 and gGlobalSyncTable.kartinteracts == true and gServerSettings.playerInteractions == PLAYER_INTERACTIONS_PVP and sMario.montandocarrito == false and not STplayerspectating then
    local np = network_player_from_global_index(obj.oKartOwner - 1)
    local m = gMarioStates[np.localIndex]
    if (m.playerIndex ~= 0)   then
        obj.oInteractType = INTERACT_DAMAGE
        obj.oIntangibleTimer = 0
        local index = network_local_index_from_global(obj.oKartOwner - 1)
        local m1 = gMarioStates[index]
        local m = gMarioStates[0]
        local np = gNetworkPlayers[index]
        local sMario = gPlayerSyncTable[0]
        local a = { x = obj.oPosX, y = obj.oPosY, z = obj.oPosZ }
        if _G.ShineThief then
            validAttackshinet = (((global_index_hurts_mario_state(obj.oKartOwner, m) and _G.ShineThief.get_team(np.playerIndex) == 0 or np.globalIndex ~= obj.oKartOwner and _G.ShineThief.get_team(np.globalIndex) == 0)) or (_G.ShineThief.get_team(m1.playerIndex) ~= _G.ShineThief.get_team(m.playerIndex) and _G.ShineThief.get_team(m1.playerIndex) ~= 0)) and not _G.ShineThief.get_spectator(m.playerIndex) and not _G.ShineThief.star_active(m.playerIndex)
        else
            validAttack = ((global_index_hurts_mario_state(obj.oKartOwner, m) or np.globalIndex ~= obj.oKartOwner ))
        end
        local radius =  200

        if np.globalIndex == obj.oKartOwner then radius = 200 end
        if (validAttack or validAttackshinet) and attacked(obj, m, a, radius) and mario_health_float(m) > 0 and active_player(m) and not is_invuln_or_intang(m) then
            obj.oDamageOrCoinValue = 3
            if directHitLocal then
                obj.oDamageOrCoinValue = 3
            end
            interact_damage(m, INTERACT_DAMAGE, obj)
    
            -- knockback
            local ownerNp = network_player_from_global_index(obj.oKartOwner)
            local cm = m
            if np.globalIndex ~= obj.oKartOwner then
                cm = lag_compensation_get_local_state(ownerNp)
            end
            local vel = {
                x = cm.pos.x - obj.oPosX,
                y = 70,
                z = cm.pos.z - obj.oPosZ,
            }
            vec3f_normalize(vel)
            vel.y = 10
            vec3f_normalize(vel)
            vec3f_mul(vel, 0)
            m.forwardVel =  0
            m.invincTimer = 100
            -- In Water -- ------------------------------------------------------------------
            if sMario.inkart == false and m.action & ACT_FLAG_SWIMMING_OR_FLYING ~= 0  then
                m.vel.y = 20
                m.forwardVel =  -30
            set_mario_action(m, ACT_BACKWARD_WATER_KB, 0)
            elseif sMario.inkart == true and m.action & ACT_FLAG_SWIMMING_OR_FLYING ~= 0 then
                m.vel.y = 70
                m.forwardVel =  -30
            set_mario_action(m, ACT_KART_HITTED_WATER, 0)
            -- Not in Water -- --------------------------------------------------------------
            elseif sMario.inkart == false and m.action & ACT_FLAG_SWIMMING_OR_FLYING == 0 then
                m.vel.y = 70
                m.forwardVel =  -30
            set_mario_action(m, ACT_BACKWARD_AIR_KB, 0)
            elseif sMario.inkart == true and m.action & ACT_FLAG_SWIMMING_OR_FLYING == 0 then
                m.vel.y = 70
                m.forwardVel =  -30
            set_mario_action(m, ACT_KART_HITTED, 0)
            end
            ----------------------------------------------------------------------------------
            m.knockbackTimer = 20
            m.vel.y = 70
            m.faceAngle.y = atan2s(vel.z, vel.x) + 0x8000
        end    
    end
  end
end
id_bhvKart = hook_behavior(nil, OBJ_LIST_DESTRUCTIVE, true, bhv_kart_init, bhv_kart_loop)

--- @param m MarioState
function update_kart_speed(m)
    local maxTargetSpeed = 0
    local targetSpeed = 0
    local sMario = gPlayerSyncTable[m.playerIndex]


   


    if (m.floor ~= nil and m.floor.type == SURFACE_SLOW) then
        maxTargetSpeed = 45.0
    else
        maxTargetSpeed = 45.0
    end

    if m.intendedMag < 24 then
        targetSpeed = m.intendedMag
    else
        targetSpeed = maxTargetSpeed
    end

    if (m.quicksandDepth > 10.0) then
        targetSpeed = targetSpeed * (6.25 / m.quicksandDepth)
    end

    if (m.forwardVel <= 0.0) then
        m.forwardVel = m.forwardVel + 0.17
    elseif (m.forwardVel <= targetSpeed) then
        m.forwardVel = m.forwardVel + (2.1 - m.forwardVel / targetSpeed)
        elseif (m.floor ~= nil and m.floor.normal.y >= 0.65) then
        m.forwardVel = m.forwardVel - 1.0
    end

    if m.forwardVel > 400 then
        m.forwardVel = 400
    end

    properKartAngle = approach_s32(convert_s16(m.intendedYaw - m.faceAngle.y), 0, 0x5E8 / clamp(m.forwardVel / 30, 0.75, 9999), 0x5E8 / clamp(m.forwardVel / 30, 0.75, 9999))

    m.faceAngle.y = m.intendedYaw - properKartAngle

    if properKartAngle < 0 then
        if sMario.timingTimer == true then
            sMario.TurnTimer = 50
            sMario.timingTimer = false
        end
        sMario.TurnTimer = clamp(sMario.TurnTimer - 4, 1, 9999)
        if m.character.type == 0 then
            smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN")
            set_anim_to_frame(m, sMario.TurnTimer)
        end
        if m.character.type == 1 or m.character.type == 3 then
            smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN2")
            set_anim_to_frame(m, sMario.TurnTimer)
        end
        if m.character.type == 4 then
            smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN3")
            set_anim_to_frame(m, sMario.TurnTimer)
        end
        if m.character.type == 2 then
            smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN4")
            set_anim_to_frame(m, sMario.TurnTimer)
        end
    end

    if properKartAngle > 0 then
        if sMario.timingTimer == true then
            sMario.TurnTimer = 50
            sMario.timingTimer = false
        end
        sMario.TurnTimer = sMario.TurnTimer + 4
        if m.character.type == 0 then
            smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN")
            set_anim_to_frame(m, sMario.TurnTimer)
        end
        if m.character.type == 1 or m.character.type == 3 then
            smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN2")
            set_anim_to_frame(m, sMario.TurnTimer)
        end
        if m.character.type == 4 then
            smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN3")
            set_anim_to_frame(m, sMario.TurnTimer)
        end
        if m.character.type == 2 then
            smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN4")
            set_anim_to_frame(m, sMario.TurnTimer)
        end
    end

        --local currentAnim = smlua_anim_util_get_current_animation_name(m.marioObj)
    if properKartAngle == 0 then
        sMario.timingTimer = true
        if sMario.TurnTimer < 50 then
            sMario.TurnTimer = clamp(sMario.TurnTimer + 4, 0, 50)
        elseif sMario.TurnTimer > 50 then
            sMario.TurnTimer = clamp(sMario.TurnTimer - 4, 50, 100)
        end
        if  (m.input & INPUT_NONZERO_ANALOG) == 0 then
            if m.character.type == 0 then
                smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN")
                set_anim_to_frame(m, 50)
            end
            if m.character.type == 1 or m.character.type == 3 then
                smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN2")
                set_anim_to_frame(m, 50)
            end
            if m.character.type == 4 then
                smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN3")
                set_anim_to_frame(m, 50)
            end
            if m.character.type == 2 then
                smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN4")
                set_anim_to_frame(m, 50)
            end
        end
        set_anim_to_frame(m, sMario.TurnTimer)
    end

    m.actionTimer = m.actionTimer + 1

    apply_slope_accel(m)
end

function kart_update_air(m)
    local sidewaysSpeed = 0.0
    local dragThreshold = 0
    local intendedDYaw = 0
    local intendedMag = 0

    if (check_horizontal_wind(m)) == 0 then
        dragThreshold = 64.0

        if (m.input & INPUT_NONZERO_ANALOG) ~= 0 then
            intendedDYaw = m.intendedYaw - m.faceAngle.y
            intendedMag = m.intendedMag / 32.0
            m.forwardVel = m.forwardVel + intendedMag * coss(intendedDYaw) * 1.5
            if m.forwardVel > dragThreshold then
                m.forwardVel = m.forwardVel - 1.5
            end
            sidewaysSpeed = intendedMag * sins(intendedDYaw) * dragThreshold
        else
            m.forwardVel = approach_f32(m.forwardVel, 0.0, 1, 1)
        end

        if (m.forwardVel > dragThreshold) then
            m.forwardVel = m.forwardVel
        end
        if (m.forwardVel < -20.0) then
            m.forwardVel = m.forwardVel + 2.0
        end

        m.slideVelX = m.forwardVel * sins(m.faceAngle.y)
        m.slideVelZ = m.forwardVel * coss(m.faceAngle.y)

        m.slideVelX = m.slideVelX + sidewaysSpeed * sins(m.faceAngle.y + 0x4000)
        m.slideVelZ = m.slideVelZ + sidewaysSpeed * coss(m.faceAngle.y + 0x4000)

        m.vel.x = approach_f32(m.vel.x, m.slideVelX, 1, 1)
        m.vel.z = approach_f32(m.vel.z, m.slideVelZ, 1, 1)
    end
end


-- Based In Yoshi Ride by steven --
--- @param m MarioState
function act_in_kart(m)
local s = gKartStates[m.playerIndex]
local sMario = gPlayerSyncTable[m.playerIndex]
sMario.inkart = true
sMario.islanding = true
update_kart_speed(m)
local maxSpeed = sMario.coinspeed
if m.actionTimer % 150 == 0 then
velrandom = math.random(0,10)
end


if m.forwardVel <= -30 then
    m.forwardVel = m.forwardVel + 10
end

    -- Mario Driver is Nearest to evade invisible Kart Bug
    local spawned = false
    local kartspw = obj_get_first_with_behavior_id(id_bhvKart)
    while kartspw ~= nil do
        if kartspw.oKartOwner == gNetworkPlayers[m.playerIndex].globalIndex + 1 then
            spawned = true
            break
        end
        kartspw = obj_get_next_with_same_behavior_id(kartspw)
    end
   if not spawned  and active_player(m) and sMario.playerdisconected == false and (m.action == ACT_KART_STAND or m.action == ACT_KART_FALL or m.action == ACT_KART_JUMP or m.action == ACT_KART_HITTED or m.action == ACT_KART_STAND_WATER or m.action == ACT_KART_FALL_WATER or m.action == ACT_KART_JUMP_WATER or m.action == ACT_KART_HITTED_WATER ) then
    sMario.inkart = false
    m.vel.y = 30
    set_mario_action(m, ACT_FORWARD_ROLLOUT, 1)
   end

local stepResult = perform_ground_step(m)

if sMario.islanding == true then
    cur_obj_align_gfx_with_floor()
end

if stepResult == GROUND_STEP_LEFT_GROUND then
    sMario.islanding = false
    return set_mario_action(m, ACT_KART_FALL, 1)
elseif stepResult == GROUND_STEP_NONE then
    sMario.islanding = true

if (m.input & INPUT_NONZERO_ANALOG) ~= 0 then

    if s.velrandom == 1 then
        s.yaho = false
        maxSpeed = maxSpeed + 32
    elseif s.velrandom == 2 then
        if s.yaho == false then
        play_character_sound(m, CHAR_SOUND_YAHOO_WAHA_YIPPEE)
        s.yaho = true
        end
        maxSpeed = maxSpeed + 38
    elseif s.velrandom == 3 then
        s.yaho = false
        maxSpeed = maxSpeed + 31
    elseif s.velrandom == 4 then
        s.yaho = false
        maxSpeed = maxSpeed + 34
    else
        s.yaho = false
        maxSpeed = maxSpeed + 33
    end

    if _G.ShineThief then
    if _G.ShineThief.mushroom_active(m.playerIndex) ~= 0 then
        if s.yaho == false then
            play_character_sound(m, CHAR_SOUND_YAHOO_WAHA_YIPPEE)
            s.yaho = true
        end
        maxSpeed = maxSpeed + 50
    end
    end

    if m.forwardVel >= maxSpeed then
    m.forwardVel = m.forwardVel - 2
    elseif m.forwardVel <= maxSpeed then
        m.forwardVel = m.forwardVel + 1
    elseif m.forwardVel >= maxSpeed + 5 then
        m.forwardVel = maxSpeed
    end
end

if (m.input & INPUT_A_PRESSED) ~= 0 then
    sMario.islanding = false
    return set_mario_action(m, ACT_KART_JUMP, 0)
end

if (m.controller.buttonPressed & L_TRIG) ~= 0 then
    sMario.inkart = false
    m.vel.y = 30
    set_mario_action(m, ACT_FORWARD_ROLLOUT, 1)
end
end
end

--- @param m MarioState
function act_kart_fall(m)
    local sMario = gPlayerSyncTable[m.playerIndex]
    sMario.inkart = true
    sMario.islanding = false
    local stepResult = perform_air_step(m, 0)
    if stepResult == AIR_STEP_LANDED then
        sMario.islanding =  true
        set_mario_action(m, ACT_KART_STAND, 0)
    end

    if gGlobalSyncTable.autojump == true then
    if sMario.kartselect ~= 19 then
    m.vel.y = m.vel.y + 2.40
    end

    if m.actionTimer == 0 then
        m.vel.y = 20
        m.forwardVel = m.forwardVel + 10
    end
    end

    if m.character.type == 0 then
        smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN")
        set_anim_to_frame(m, 50)
    end
    if m.character.type == 1 or m.character.type == 3 then
        smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN2")
        set_anim_to_frame(m, 50)
    end
    if m.character.type == 4 then
        smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN3")
        set_anim_to_frame(m, 50)
    end
    if m.character.type == 2 then
        smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN4")
        set_anim_to_frame(m, 50)
    end
    m.actionTimer = m.actionTimer + 1
end

--- @param m MarioState
function act_kart_jump(m)
    local sMario = gPlayerSyncTable[m.playerIndex]
    sMario.inkart = true
    sMario.islanding = false
    kart_update_air(m)
    update_air_with_turn(m)
    if m.actionTimer == 0 then
        play_character_sound(m, CHAR_SOUND_PUNCH_WAH)
        if sMario.kartselect == 19 then
            m.vel.y = 25
        else
            m.vel.y = 40
        end
    end

    if m.forwardVel <= -30 then
        m.forwardVel = m.forwardVel + 15
    end

    local stepResult = perform_air_step(m, 0)


    if stepResult == AIR_STEP_LANDED then
        set_mario_action(m, ACT_KART_STAND, 0)
    end

    if m.character.type == 0 then
        smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN")
        set_anim_to_frame(m, 50)
    end
    if m.character.type == 1 or m.character.type == 3 then
        smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN2")
        set_anim_to_frame(m, 50)
    end
    if m.character.type == 4 then
        smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN3")
        set_anim_to_frame(m, 50)
    end
    if m.character.type == 2 then
        smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN4")
        set_anim_to_frame(m, 50)
    end
    m.actionTimer = m.actionTimer + 1
end
--- @param m MarioState
function act_hitted(m)
    smlua_anim_util_set_animation(m.marioObj, "ACT_HURTING")
    local sMario = gPlayerSyncTable[m.playerIndex]
    sMario.inkart = true
    if m.actionTimer == 0 then
        smlua_anim_util_set_animation(m.marioObj, "ACT_HURTING")
        m.vel.y = 30
        play_character_sound(m, CHAR_SOUND_ATTACKED)
    end
    
    m.faceAngle.y = m.faceAngle.y - 0x1000

    local stepResult = perform_air_step(m, 0)

    if stepResult == AIR_STEP_LANDED then
        sMario.islanding = true
        cur_obj_align_gfx_with_floor()
    elseif stepResult ~= AIR_STEP_LANDED then 
        sMario.islanding = false
    end

if stepResult == AIR_STEP_LANDED then    
    sMario.islanding = true
    if m.actionTimer >= 40 then
        sMario.inkart = true
        m.invincTimer = 60
        m.forwardVel = 0
        set_mario_action(m, ACT_KART_STAND, 0)
    end
end





    m.actionTimer = m.actionTimer + 1
end



-- IN WATER --
--- @param m MarioState
function act_in_kart_water(m)
    cur_obj_align_gfx_with_floor()
    local sMario = gPlayerSyncTable[m.playerIndex]
    sMario.inkart = true
    sMario.islanding = true


    if m.forwardVel <= -30 then
        m.forwardVel = m.forwardVel + 10
    end

    if sMario.islanding == true then
        cur_obj_align_gfx_with_floor()
    end


    if m.character.type == 0 then
        smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN")
        set_anim_to_frame(m, 50)
    end
    if m.character.type == 1 or m.character.type == 3 then
        smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN2")
        set_anim_to_frame(m, 50)
    end
    if m.character.type == 4 then
        smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN3")
        set_anim_to_frame(m, 50)
    end
    if m.character.type == 2 then
        smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN4")
        set_anim_to_frame(m, 50)
    end
    m.actionTimer = m.actionTimer + 1
    update_kart_speed(m)

  -- Mario Driver is Nearest to evade invisible Kart Bug
  local spawned = false
  local kartspw = obj_get_first_with_behavior_id(id_bhvKart)
  while kartspw ~= nil do
      if kartspw.oKartOwner == gNetworkPlayers[m.playerIndex].globalIndex + 1 then
          spawned = true
          break
      end
      kartspw = obj_get_next_with_same_behavior_id(kartspw)
  end
 if not spawned  and active_player(m) and sMario.playerdisconected == false and (m.action == ACT_KART_STAND or m.action == ACT_KART_FALL or m.action == ACT_KART_JUMP or m.action == ACT_KART_HITTED or m.action == ACT_KART_STAND_WATER or m.action == ACT_KART_FALL_WATER or m.action == ACT_KART_JUMP_WATER or m.action == ACT_KART_HITTED_WATER ) then
  sMario.inkart = false
  m.vel.y = 30
  set_mario_action(m, ACT_FORWARD_ROLLOUT, 1)
 end
    
    local stepResult = perform_ground_step(m)
    
    if stepResult == GROUND_STEP_LEFT_GROUND then
        sMario.islanding = false
        return set_mario_action(m, ACT_KART_FALL_WATER, 1)
    elseif stepResult == GROUND_STEP_NONE then
        sMario.islanding = true
    end
    local maxSpeed = 0
    local velrandom = 0
    if m.actionTimer % 150 == 0 then
        velrandom = math.random(0,5)
    end
        
        if (m.input & INPUT_NONZERO_ANALOG) ~= 0 then
        
            if velrandom == 1 then
                yaho = false
                maxSpeed = maxSpeed + 28
            elseif velrandom == 2 then
                if yaho == false then
                play_character_sound(m, CHAR_SOUND_YAHOO_WAHA_YIPPEE)
                yaho = true
                end
                maxSpeed = maxSpeed + 37
            elseif velrandom == 3 then
                yaho = false
                maxSpeed = maxSpeed + 30
            elseif velrandom == 4 then
                yaho = false
                maxSpeed = maxSpeed + 35
            else
                yaho = false
                maxSpeed = maxSpeed + 32
            end
        
            if m.forwardVel >= maxSpeed then
            m.forwardVel = maxSpeed
            end
        end
        
    
    if (m.input & INPUT_A_PRESSED) ~= 0 then
        sMario.islanding = false
        return set_mario_action(m, ACT_KART_JUMP_WATER, 0)
    end
    
    if (m.controller.buttonPressed & L_TRIG) ~= 0 then
        sMario.inkart = false
        if m.action & ACT_FLAG_SWIMMING_OR_FLYING ~= 0 then
            set_mario_action(m, ACT_WATER_PUNCH,0)
        elseif m.action & ACT_FLAG_SWIMMING_OR_FLYING == 0 then
            m.vel.y = 30
            set_mario_action(m, ACT_FORWARD_ROLLOUT, 1)
        end
    end
    end

    --- @param m MarioState
    function act_kart_fall_water(m)
        cur_obj_align_gfx_with_floor()
        local sMario = gPlayerSyncTable[m.playerIndex]
        sMario.inkart = true
        sMario.islanding = false



        local stepResult = perform_air_step(m, 0)
        update_air_without_turn(m)
        if stepResult == AIR_STEP_LANDED then
            sMario.islanding = true
            set_mario_action(m, ACT_KART_STAND_WATER, 0)
        end
    
    
        if m.character.type == 0 then
            smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN")
            set_anim_to_frame(m, 50)
        end
        if m.character.type == 1 or m.character.type == 3 then
            smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN2")
            set_anim_to_frame(m, 50)
        end
        if m.character.type == 4 then
            smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN3")
            set_anim_to_frame(m, 50)
        end
        if m.character.type == 2 then
            smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN4")
            set_anim_to_frame(m, 50)
        end
        m.actionTimer = m.actionTimer + 1
    end
    
    function act_kart_jump_water(m)
        local sMario = gPlayerSyncTable[m.playerIndex]
        sMario.inkart = true
        sMario.islanding = false

        if m.actionTimer == 0 then
            play_character_sound(m, CHAR_SOUND_PUNCH_WAH)
            m.vel.y = 40
        end

        if m.forwardVel <= -30 then
            m.forwardVel = m.forwardVel + 15
        end
    
        local stepResult = perform_air_step(m, 0)
    
    
        if stepResult == AIR_STEP_LANDED then
            set_mario_action(m, ACT_KART_STAND_WATER, 0)
        end
    
        if m.character.type == 0 then
            smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN")
            set_anim_to_frame(m, 50)
        end
        if m.character.type == 1 or m.character.type == 3 then
            smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN2")
            set_anim_to_frame(m, 50)
        end
        if m.character.type == 4 then
            smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN3")
            set_anim_to_frame(m, 50)
        end
        if m.character.type == 2 then
            smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN4")
            set_anim_to_frame(m, 50)
        end
        m.actionTimer = m.actionTimer + 1
    end

    --- @param m MarioState
    function act_hitted_water(m)
        smlua_anim_util_set_animation(m.marioObj, "ACT_HURTING")
        local sMario = gPlayerSyncTable[m.playerIndex]
        sMario.inkart = true
        sMario.islanding = false




        if m.actionTimer == 0 then
            m.invincTimer = 140
            m.vel.y = 30
            play_character_sound(m, CHAR_SOUND_ATTACKED)
        end
        m.faceAngle.y = m.faceAngle.y - 0x1000
    
        local stepResult = perform_air_step(m, 0)

        if stepResult == AIR_STEP_LANDED then
            sMario.islanding = true
            sMario.inkart = true
            cur_obj_align_gfx_with_floor()
        elseif stepResult ~= AIR_STEP_LANDED then 
            sMario.islanding = false
            sMario.inkart = true
        end
    
    if stepResult == AIR_STEP_LANDED then    
        sMario.islanding = true
        if m.actionTimer >= 40 then
            m.invincTimer = 60
            m.forwardVel = 0
            set_mario_action(m, ACT_KART_STAND_WATER, 0)
        end
    end
    
    

        if m.character.type == 0 then
            smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN")
            set_anim_to_frame(m, 50)
        end
        if m.character.type == 1 or m.character.type == 3 then
            smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN2")
            set_anim_to_frame(m, 50)
        end
        if m.character.type == 4 then
            smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN3")
            set_anim_to_frame(m, 50)
        end
        if m.character.type == 2 then
            smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN4")
            set_anim_to_frame(m, 50)
        end
        m.actionTimer = m.actionTimer + 1
    end

-- Holding Kart Actions --
--- @param m MarioState
function act_holding(m)
    local sMario = gPlayerSyncTable[m.playerIndex]
    if m.character.type == 0 then
        smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN")
        set_anim_to_frame(m, 50)
    end
    if m.character.type == 1 or m.character.type == 3 then
        smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN2")
        set_anim_to_frame(m, 50)
    end
    if m.character.type == 4 then
        smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN3")
        set_anim_to_frame(m, 50)
    end
    if m.character.type == 2 then
        smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN4")
        set_anim_to_frame(m, 50)
    end
    m.actionTimer = m.actionTimer + 1
    if sMario.montandocarrito == false then
        m.vel.y = 30
        set_mario_action(m, ACT_FORWARD_ROLLOUT, 0)
    end
end

--- @param m MarioState
function act_holding_water(m)
    local sMario = gPlayerSyncTable[m.playerIndex]
    if m.character.type == 0 then
        smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN")
        set_anim_to_frame(m, 50)
    end
    if m.character.type == 1 or m.character.type == 3 then
        smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN2")
        set_anim_to_frame(m, 50)
    end
    if m.character.type == 4 then
        smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN3")
        set_anim_to_frame(m, 50)
    end
    if m.character.type == 2 then
        smlua_anim_util_set_animation(m.marioObj, "ACT_KART_PAN4")
        set_anim_to_frame(m, 50)
    end
    m.actionTimer = m.actionTimer + 1
    if sMario.montandocarrito == false then
        m.vel.y = 30
        set_mario_action(m, ACT_WATER_IDLE, 0)
    end
end

function on_entrance()
    for i=0, MAX_PLAYERS - 1 do
    local m = gMarioStates[0]
    local sMario = gPlayerSyncTable[m.playerIndex]
    sMario.inkart = false
    sMario.coinspeed = gGlobalSyncTable.coinamount
    end
end

--- @param m MarioState
function marditokartmuerete(m)
    local sMario = gPlayerSyncTable[m.playerIndex]
    sMario.playerdisconected = true
end

function wrapAround(value, maxValue)
    return value % (maxValue + 1)
end


_G.KartC = {
    kart_hitted = function (index)
        return gMarioStates[index].action == ACT_KART_HITTED or false
    end,
    kart_hitted_water = function (index)
        return gMarioStates[index].action == ACT_KART_HITTED_WATER or false
    end,
    kart_select = function (index,kart)
    gPlayerSyncTable[index].kartselect = kart
    end,
    kart_ridding = function (index)
        return gMarioStates[index].action == ACT_KART_STAND or false
    end,
}

--------------------------------------------------------------------------------------
-- Initialize Player Hook --
--------------------------------------------------------------------------------------

hook_event(HOOK_ON_PLAYER_CONNECTED, player_initialize)
hook_mario_action(ACT_KART_STAND, {every_frame = act_in_kart})
hook_mario_action(ACT_KART_FALL, {every_frame = act_kart_fall})
hook_mario_action(ACT_KART_JUMP, {every_frame = act_kart_jump})
hook_mario_action(ACT_KART_HITTED, {every_frame = act_hitted})
hook_mario_action(ACT_KART_HOLDING, {every_frame = act_holding})
hook_mario_action(ACT_KART_STAND_WATER, {every_frame = act_in_kart_water})
hook_mario_action(ACT_KART_FALL_WATER, {every_frame = act_kart_fall_water})
hook_mario_action(ACT_KART_JUMP_WATER, {every_frame = act_kart_jump_water})
hook_mario_action(ACT_KART_HITTED_WATER, {every_frame = act_hitted_water})
hook_mario_action(ACT_KART_HOLDING_WATER, {every_frame = act_holding_water})
hook_event(HOOK_ON_PLAYER_DISCONNECTED, marditokartmuerete)
hook_event(HOOK_ON_LEVEL_INIT, on_entrance)


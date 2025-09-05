-- name: ramp mod

local ACT_RAMP_CLIMB = allocate_mario_action(ACT_FLAG_AIR | ACT_GROUP_AIRBORNE)
local MODEL_SMW_RAMP = smlua_model_util_get_id("smw_ramp_geo")
local COL_SMW_RAMP = smlua_collision_util_get("smw_ramp_collision")

gPlayerSyncTable[0].slowDownTimer = 0
gPlayerSyncTable[0].animFrame = 0

local gRampSpawnEntries = {
    { x = 3533,  y = 545,   z = -5719, level = LEVEL_CASTLE_GROUNDS, area = 1,  angle = 16384 },
    { x = -2077, y = -2866, z = -4833, level = LEVEL_VCUTM,          area = 1,  angle = 0 },
    { x = 2100,  y = 4403,  z = 119,   level = 19,                   area = 1,  angle = -16384 },
    --{ x = 0, y = 0, z = 0, level = LEVEL_, area = {1, 2} },
    --ssl
    { x = 305,   y = 4429,  z = -1075, level = 8,                    area = 2,  angle = -140 },
    --castle
    { x = 1228,  y = -1689, z = -311,  level = 6,                    area = 3,  angle = 16384 },
    { x = -206,  y = 2253,  z = 6977,  level = 6,                    area = 2,  angle = -32532 },
    { x = -2439,  y = 2253,  z = 5894,  level = 6,                    area = 2,  angle = 16558 },
    { x = 2031,  y = 2253,  z = 5871,  level = 6,                    area = 2,  angle = -16334 },
    { x = 2138,  y = 307,  z = -1555,  level = 6,                    area = 1,  angle = 8403 },
    { x = 2141,  y = 307,  z = 1097,  level = 6,                    area = 1,  angle = 24247 },
    --rr
    { x = -4679, y = -1782, z = -162,  level = 15,                   area = 1,  angle = -16384 },
    { x = -5603, y = -1782, z = -162,  level = 15,                   area = 1,  angle = 16384 },
    { x = -6727, y = -1782, z = -91,   level = 15,                   area = 1,  angle = -16384 },
    --bob
    { x = -6457, y = 0,     z = 4146,  level = 9,                    area = 1,  angle = -0 },
    --ccm
    { x = 2682,  y = -4351, z = 3581,  level = 5,                    area = 1,  angle = 8356 },
    { x = 323,   y = -3206, z = -2628, level = 5,                    area = 1,  angle = 32532 },
    --bbh
    { x = -210,  y = -205,  z = 2200,  level = 4,                    area = 1,  angle = 813 },
    --hmc
    { x = -4978, y = 1843,  z = -7756, level = 7,                    area = 1,  angle = -229 },
    { x = 1484,  y = 615,   z = 7630,  level = 7,                    area = 1,  angle = 16992 },
    { x = 1744,  y = -921,  z = -4718, level = 7,                    area = 1,  angle = 16370 },
    --ss
    { x = 2077,  y = 1024,  z = 710,   level = 10,                   area = 1,  angle = 26818 },
    --wdw
    { x = 2234,  y = -2560, z = 3240,  level = 11,                   area = 2,  angle = -16280 },
    --thi (big)
    { x = -3320, y = -833,  z = -4700, level = 13,                   area = 1,  angle = 16360 },
    { x = -2866, y = 1205,  z = -670,  level = 13,                   area = 1,  angle = -16370 },
    { x = -2360, y = 1690,  z = -430,  level = 13,                   area = 1,  angle = -16370 },
    --ttc
    { x = -1840, y = -3490, z = 1020,  level = 14,                   area = 1,  angle = 24664 },
    { x = -932,  y = -1453, z = -1885, level = 14,                   area = 1,  angle = 24886 },
    { x = -1890, y = 1065,  z = -975,  level = 14,                   area = 1,  angle = 7530 },
    --bits
    { x = -6080, y = -1330, z = -796,  level = 21,                   area = 1,  angle = 16319 },
    --wf
    { x = 2555,  y = 256,   z = 4148,  level = 24,                   area = 1,  angle = 102 },
}

local function limit_angle(a)
    return (a + 0x8000) % 0x10000 - 0x8000
end

---@param m MarioState
local function act_ramp_climb(m)
    local me = gPlayerSyncTable[m.playerIndex]
    if (m.input & INPUT_A_PRESSED) ~= 0 then
        m.vel.y = 52.0
        m.faceAngle.y = limit_angle(m.faceAngle.y + 0x8000)
        return set_mario_action(m, ACT_JUMP, 0)
    end

    if me.animFrame < m.marioObj.header.gfx.animInfo.curAnim.loopEnd then
        me.animFrame = me.animFrame + 7
    else
        me.animFrame = 0
    end

    if me.slowDownTimer < 15 then
        me.slowDownTimer = me.slowDownTimer + 1 / 15
    end

    if m.controller.stickMag ~= 0 then
        me.slowDownTimer = me.slowDownTimer - 1 / 9
    else
        me.slowDownTimer = me.slowDownTimer + 1 / 6
    end

    local wallangle = atan2s(m.wallNormal.z, m.wallNormal.x) + 0x8000

    if me.slowDownTimer > 5 then
        m.vel.y = 25 - me.slowDownTimer
    else
        m.vel.y = 25
    end

    m.particleFlags = m.particleFlags | PARTICLE_DUST

    --Face directly towards wall to make sure we're latched on
    m.faceAngle.y = wallangle
    mario_set_forward_vel(m, 1)

    --Perform air step
    local air_step = perform_air_step(m, AIR_STEP_CHECK_LEDGE_GRAB)
    if air_step == AIR_STEP_LANDED then
        m.faceAngle.y = m.faceAngle.y
        me.slowDownTimer = 0
        return set_mario_action(m, ACT_FREEFALL_LAND, 0)
    elseif not m.wall then
        m.faceAngle.y = m.faceAngle.y
        me.slowDownTimer = 0
        mario_set_forward_vel(m, 10)
        if _G.charSelect.character_get_current_number(m.playerIndex) == CT_SMW then
            m.vel.y = 45
            m.forwardVel = 10
        else
            m.vel.y = 35
        end
        return set_mario_action(m, ACT_FREEFALL, 0)
    end

    if me.slowDownTimer >= 15 then
        me.slowDownTimer = 0
        --m.faceAngle.y = m.faceAngle.y - 0x8000
        return set_mario_action(m, ACT_FREEFALL, 0)
    end

    --m.faceAngle.y = wallangle - 0x4000
    --mario_set_forward_vel(m, m.controller.stickX / 10)

    --Climbing animation
    if _G.charSelect.character_get_current_number(m.playerIndex) == CT_SMW then
        if m.heldObj ~= nil then
            set_character_animation(m, CHAR_ANIM_RUN_WITH_LIGHT_OBJ)
        else
            set_character_animation(m, CHAR_ANIM_RUNNING_UNUSED)
        end
    else
        set_character_animation(m, CHAR_ANIM_RUNNING)
    end
    set_anim_to_frame(m, me.animFrame)

    m.marioObj.header.gfx.angle.x = 0xC000
    m.marioObj.header.gfx.angle.y = m.faceAngle.y
    -- m.marioObj.header.gfx.pos.z = m.marioObj.header.gfx.pos.z + 64
    m.marioObj.header.gfx.pos.x = m.marioObj.header.gfx.pos.x + (50 * sins(m.faceAngle.y))
    m.marioObj.header.gfx.pos.z = m.marioObj.header.gfx.pos.z + (50 * coss(m.faceAngle.y))
end

---@param o Object
local function bhv_ramp_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.hitboxHeight = 140
    o.hitboxRadius = 90
    o.collisionData = COL_SMW_RAMP
    o.oIntangibleTimer = 0
    cur_obj_scale(0.5)
end

---@param o Object
local function bhv_ramp_loop(o)
    load_object_collision_model()
end

---@param m MarioState
local function do_wall_climb_upd(m)
    if m.playerIndex ~= 0 then return end
    local nRamp = obj_get_nearest_object_with_behavior_id(m.marioObj, bhvSMWRamp)
    if nRamp and obj_check_hitbox_overlap(m.marioObj, nRamp) and m.forwardVel > 0 then
        if m.wall then
            set_mario_action(m, ACT_RAMP_CLIMB, 0)
        end
    end
end

local function spawn_ramps(type, lvl, areaIdx, nodeId)
    for id = 1, #gRampSpawnEntries do
        if gRampSpawnEntries[id].level == gNetworkPlayers[0].currLevelNum then
            if gRampSpawnEntries[id].area == gNetworkPlayers[0].currAreaIndex then
                local spawnId = gRampSpawnEntries[id]
                local obj = spawn_non_sync_object(bhvSMWRamp,
                    MODEL_SMW_RAMP,
                    spawnId.x,
                    spawnId.y,
                    spawnId.z,
                    nil)
                obj.oFaceAngleYaw = gRampSpawnEntries[id].angle
            end
        end
    end
end

hook_event(HOOK_MARIO_UPDATE, do_wall_climb_upd)
hook_event(HOOK_ON_WARP, spawn_ramps)
hook_event(HOOK_ON_LEVEL_INIT, spawn_ramps)
hook_mario_action(ACT_RAMP_CLIMB, act_ramp_climb)

bhvSMWRamp = hook_behavior(nil, OBJ_LIST_SURFACE, true, bhv_ramp_init, bhv_ramp_loop, "bhvSMWRamp")

--dead

---bottom text
--local e = gSMWExtraStates[m.playerIndex]


local DEAD = audio_sample_load("smw_lost_a_life.ogg")



ACT_SMW_DEAD = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_AIR | ACT_FLAG_STATIONARY | ACT_FLAG_INTANGIBLE |
    ACT_FLAG_INVULNERABLE | ACT_FLAG_CUSTOM_ACTION | ACT_FLAG_PAUSE_EXIT)


local function act_smw_death(m)
    --if m.playerIndex ~= 0 then return end

    local e = gSMWExtraStates[m.playerIndex]

    mario_drop_held_object(m)

    e.smw_died = true
    m.faceAngle.y = m.area.camera.yaw
    m.marioObj.header.gfx.angle.y = m.faceAngle.y
    m.invincTimer = 0
    m.marioBodyState.eyeState = 11

    if m.actionArg <= 0 then
        m.actionArg = m.actionArg + 1
    end

    if m.actionArg == 1 then
        m.actionTimer = m.actionTimer + 1
    end


    if m.actionTimer == 1 then
        e.isbubbled = false
        m.pos.y = m.pos.y + 1
        m.vel.y = 0
        m.vel.x = 0
        m.vel.z = 0
        m.forwardVel = 0
    end
    if m.actionTimer == 1 then
        anim = CHAR_ANIM_SUFFOCATING
        audio_sample_play(DEAD, m.pos, 3)
        enable_time_stop_if_alone()
        if mario_can_bubble(m) then
            sound_reset_background_music_default_volume(get_current_background_music())
        else
            sound_set_background_music_default_volume(get_current_background_music(), 0)
        end
    end
    if m.actionTimer == 1 then
        e.keepairmoment = m.pos.y
    end
    if m.actionTimer > 1 and m.actionTimer < 15 then
        m.pos.y = e.keepairmoment
    end
    if m.actionTimer == 15 then
        anim = CHAR_ANIM_DYING_FALL_OVER
        m.pos.y = m.pos.y + 1
        m.vel.y = 60
    end
    if m.actionTimer > 15 then
        if m.pos.y == m.floorHeight then
            m.marioObj.header.gfx.node.flags = GRAPH_RENDER_INVISIBLE
            e.oneframe = e.oneframe - 1
            if e.oneframe == 0 then
                m.particleFlags = m.particleFlags | PARTICLE_MIST_CIRCLE
            end
        end
    end

    if m.vel.y > 0 and not (m.actionTimer > 2 and m.actionTimer < 15) then
        m.vel.y = m.vel.y - 2
    else
        m.vel.y = m.vel.y + 2
    end

    if m.actionTimer == 79 and mario_can_bubble(m) then
        e.isbubbled = true
        sound_reset_background_music_default_volume(get_current_background_music())
        m.actionArg = m.actionArg + 1
        m.marioObj.header.gfx.node.flags = GRAPH_RENDER_ACTIVE
    end

    if m.actionTimer >= 80 then
        e.isbubbled = false
        m.actionArg = m.actionArg + 1
        m.actionTimer = 0
        disable_time_stop()
        level_trigger_warp(m, WARP_OP_EXIT)
        if (m.numLives > -1) then
            m.numLives = m.numLives - 1
        end
    end
    set_character_animation(m, anim)
    perform_air_step(m, AIR_STEP_NONE)
end
hook_mario_action(ACT_SMW_DEAD, { every_frame = act_smw_death })

local function allowwater(m)
    local e = gSMWExtraStates[m.playerIndex]
    if _G.charSelect.character_get_current_number(m.playerIndex) == CT_SMW then
        if m.action == ACT_SMW_DEAD then
            if (m.prevAction & ACT_FLAG_SWIMMING) ~= 0 then
                return false
            else
                return true
            end
        end
    end
end

hook_event(HOOK_ALLOW_FORCE_WATER_ACTION, allowwater)


local function allow_hazard_surface(m)
    local e = gSMWExtraStates[m.playerIndex]
    local lavaF = m.floor and m.floor.type == SURFACE_BURNING or m.floor and m.floor.type == 45 or
        m.floor and m.floor.type == 35
    local lavaW = m.wall and m.wall.type == SURFACE_BURNING
    if (lavaF or lavaW) and m.pos.y == m.floorHeight then
        e.lava = true
    else
        e.lava = false
    end
    if m.action == ACT_LAVA_BOOST then
        e.lava = true
    else
        e.lava = false
    end
end

hook_event(HOOK_ALLOW_HAZARD_SURFACE, allow_hazard_surface)



local function update_on_death(m)
    local e = gSMWExtraStates[m.playerIndex]
    if m.playerIndex ~= 0 then return end
    if _G.charSelect.character_get_current_number(m.playerIndex) == CT_SMW then
        if e.lava == true then
            e.IsSmall = true
            m.health = 0x000
        end
        if e.smw_died == false and m.health < 0x100 then --and not m.action == ACT_SMW_DAMAGE or  m.action == ACT_SMW_DAMAGE_WATER then
            e.smw_dead = true
            set_mario_action(m, ACT_SMW_DEAD, 0)
        end
        if e.smw_died == true and m.health > 0x100 then
            e.isbubbled = false
            e.oneframe = 1
            e.smw_died = false
        end
        if m.action ~= ACT_SMW_DEAD then
            sound_reset_background_music_default_volume(get_current_background_music())
        end
        if m.action == ACT_BUBBLED then
            e.smw_dead = true
        end
        if m.numLives <= -1 then
            level_trigger_warp(m, WARP_OP_GAME_OVER)
            m.numLives = 4
        end
        if e.isbubbled == true then
            mario_set_bubbled(m)
            sound_reset_background_music_default_volume(get_current_background_music())
            m.marioObj.header.gfx.node.flags = GRAPH_RENDER_ACTIVE
        end
    end
end
hook_event(HOOK_MARIO_UPDATE, update_on_death)


local function update_bubbled(m)
    local e = gSMWExtraStates[m.playerIndex]
    if _G.charSelect.character_get_current_number(m.playerIndex) == CT_SMW then
        if m.action == ACT_BUBBLED then
            m.marioBodyState.eyeState = 11
            smlua_anim_util_set_animation(m.marioObj, "SMW_DeadAnim")
            sound_reset_background_music_default_volume(get_current_background_music())
            m.marioObj.header.gfx.node.flags = GRAPH_RENDER_ACTIVE
        end
        --[[
        if m.action == ACT_BUBBLED or m.action == ACT_SMW_DEAD and e.isbubbled == true  and not mario_can_bubble(m) then
                    level_trigger_warp(m, WARP_OP_EXIT)
        end--]]
    end
end

hook_event(HOOK_MARIO_UPDATE, update_bubbled)

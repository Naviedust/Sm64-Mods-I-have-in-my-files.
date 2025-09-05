gPlayerSyncTable[0].damageframe = 30

local DAMAGE = audio_sample_load("smw_powerdown.ogg")
local POWER = audio_sample_load("smw_power-up.ogg")

-- made so that i can change mario's model in animations
local function changemodel(m)
    if m.playerIndex ~= 0 then return end
    local e = gSMWExtraStates[m.playerIndex]
    if e.IsSmall == true then
        if _G.charSelect.character_get_current_costume() == 2 then
            _G.charSelect.character_edit(CT_SMW, nil, nil, nil, nil, E_MODEL_S_SMWRC, nil, TEX_SMW_MARIO_S)
        else
            _G.charSelect.character_edit(CT_SMW, nil, nil, nil, nil, E_MODEL_S_SMW, nil, TEX_SMW_MARIO_S)
        end
    else
        if _G.charSelect.character_get_current_costume() == 2 then
            _G.charSelect.character_edit(CT_SMW, nil, nil, nil, nil, E_MODEL_SMWRC, nil, TEX_SMW_MARIO)
        else
            _G.charSelect.character_edit(CT_SMW, nil, nil, nil, nil, E_MODEL_SMW, nil, TEX_SMW_MARIO)
        end
    end
end


hook_event(HOOK_MARIO_UPDATE, changemodel)


---damage invicibility so he doesnt die
local function hurt(m)
    if _G.charSelect.character_get_current_number(m.playerIndex) == CT_SMW then
        if m.hurtCounter > 0 then
            m.invincTimer = 50
        end
    end
end
hook_event(HOOK_MARIO_UPDATE, hurt)


ACT_SMW_DAMAGE = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_INVULNERABLE | ACT_FLAG_CUSTOM_ACTION)


local function act_smw_damage(m)
    local e = gSMWExtraStates[m.playerIndex]
    --e.ded_encrease = true
    e.IsSmall = true
    e.is_damage = true

    mario_stop_riding_object(m)
    if (m.prevAction & ACT_FLAG_AIR) ~= 0 then
        set_character_animation(m, CHAR_ANIM_GENERAL_FALL)
    else
        set_character_animation(m, CHAR_ANIM_FIRST_PERSON)
    end

    if m.actionTimer == 0 then
        m.pos.y = m.pos.y + 1
        enable_time_stop_if_alone()
        m.actionTimer = m.actionTimer + 1
        audio_sample_play(DAMAGE, m.pos, 5)
        queue_rumble_data_mario(m, 3, 50);
    end



    m.invincTimer = 0
    gPlayerSyncTable[m.playerIndex].damageframe = gPlayerSyncTable[m.playerIndex].damageframe - 1

    if gPlayerSyncTable[m.playerIndex].damageframe <= 0 then
        if (m.prevAction & ACT_FLAG_AIR) ~= 0 then
            disable_time_stop()
            set_mario_action(m, ACT_FREEFALL, 0)
        else
            disable_time_stop()
            set_mario_action(m, ACT_IDLE, 0)
        end
        gPlayerSyncTable[m.playerIndex].damageframe = 30
        m.invincTimer = 50
    end
end

hook_mario_action(ACT_SMW_DAMAGE, { every_frame = act_smw_damage })


ACT_SMW_POWER = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_INVULNERABLE | ACT_FLAG_CUSTOM_ACTION)

local function act_smw_power(m)
    local e = gSMWExtraStates[m.playerIndex]
    e.IsSmall = false
    e.is_damage = false
    mario_stop_riding_object(m)

    if (m.prevAction & ACT_FLAG_AIR) ~= 0 then
        set_character_animation(m, CHAR_ANIM_GENERAL_FALL)
    else
        set_character_animation(m, CHAR_ANIM_FIRST_PERSON)
    end

    if m.actionTimer == 0 then
        m.pos.y = m.pos.y + 1
        enable_time_stop_if_alone()
        m.actionTimer = m.actionTimer + 1
        audio_sample_play(POWER, m.pos, 5)
        queue_rumble_data_mario(m, 3, 50);
    end



    m.invincTimer = 0

    gPlayerSyncTable[m.playerIndex].damageframe = gPlayerSyncTable[m.playerIndex].damageframe - 1

    if gPlayerSyncTable[m.playerIndex].damageframe <= 0 then
        if (m.prevAction & ACT_FLAG_AIR) ~= 0 then
            set_mario_action(m, ACT_FREEFALL, 0)
            disable_time_stop()
        else
            set_mario_action(m, ACT_IDLE, 0)
            disable_time_stop()
        end
        if m.prevAction == ACT_EXIT_AIRBORNE then
            set_mario_action(m, ACT_EXIT_LAND_SAVE_DIALOG, 0)
        end
        gPlayerSyncTable[m.playerIndex].damageframe = 30
        m.invincTimer = 50
    end
end

hook_mario_action(ACT_SMW_POWER, { every_frame = act_smw_power })

---waterdamage--

ACT_SMW_DAMAGE_WATER = allocate_mario_action(ACT_GROUP_SUBMERGED | ACT_FLAG_SWIMMING | ACT_FLAG_WATER_OR_TEXT |
    ACT_FLAG_SHORT_HITBOX | ACT_FLAG_CUSTOM_ACTION | ACT_FLAG_SWIMMING_OR_FLYING | ACT_FLAG_INVULNERABLE)


local function act_smw_damage_water(m)
    local e = gSMWExtraStates[m.playerIndex]
    --e.ded_encrease = true
    e.IsSmall = true
    e.is_damage = true
    mario_stop_riding_object(m)

    if (m.prevAction & ACT_FLAG_AIR) ~= 0 then
        set_character_animation(m, CHAR_ANIM_GENERAL_FALL)
    else
        set_character_animation(m, CHAR_ANIM_FIRST_PERSON)
    end

    if m.actionTimer == 0 then
        m.pos.y = m.pos.y + 1
        enable_time_stop_if_alone()
        m.actionTimer = m.actionTimer + 1
        audio_sample_play(DAMAGE, m.pos, 5)
        queue_rumble_data_mario(m, 3, 50);
    end



    m.invincTimer = 0
    gPlayerSyncTable[m.playerIndex].damageframe = gPlayerSyncTable[m.playerIndex].damageframe - 1

    if gPlayerSyncTable[m.playerIndex].damageframe <= 0 then
        if (m.prevAction & ACT_FLAG_AIR) ~= 0 then
            disable_time_stop()
            set_mario_action(m, ACT_FREEFALL, 0)
        elseif (m.prevAction & ACT_FLAG_RIDING_SHELL) ~= 0 then
            set_mario_action(m, ACT_RIDING_SHELL_FALL, 0)
            disable_time_stop()
        else
            disable_time_stop()
            set_mario_action(m, ACT_IDLE, 0)
        end
        gPlayerSyncTable[m.playerIndex].damageframe = 30
        m.invincTimer = 50
    end
end

hook_mario_action(ACT_SMW_DAMAGE_WATER, { every_frame = act_smw_damage_water })


ACT_SMW_POWER_WATER = allocate_mario_action(ACT_GROUP_SUBMERGED | ACT_FLAG_SWIMMING | ACT_FLAG_WATER_OR_TEXT |
    ACT_FLAG_SHORT_HITBOX | ACT_FLAG_CUSTOM_ACTION | ACT_FLAG_SWIMMING_OR_FLYING | ACT_FLAG_INVULNERABLE)

local function act_smw_power_water(m)
    local e = gSMWExtraStates[m.playerIndex]
    e.IsSmall = false
    e.is_damage = false
    mario_stop_riding_object(m)

    if (m.prevAction & ACT_FLAG_AIR) ~= 0 then
        set_character_animation(m, CHAR_ANIM_GENERAL_FALL)
    else
        set_character_animation(m, CHAR_ANIM_FIRST_PERSON)
    end

    if m.actionTimer == 0 then
        m.pos.y = m.pos.y + 1
        enable_time_stop_if_alone()
        m.actionTimer = m.actionTimer + 1
        audio_sample_play(POWER, m.pos, 5)
        queue_rumble_data_mario(m, 3, 50);
    end



    m.invincTimer = 0

    gPlayerSyncTable[m.playerIndex].damageframe = gPlayerSyncTable[m.playerIndex].damageframe - 1

    if gPlayerSyncTable[m.playerIndex].damageframe <= 0 then
        if m.prevAction == ACT_EXIT_AIRBORNE then
            disable_time_stop()
            set_mario_action(m, ACT_EXIT_LAND_SAVE_DIALOG, 0)
        else
            if (m.prevAction & ACT_FLAG_AIR) ~= 0 then
                disable_time_stop()
                set_mario_action(m, ACT_FREEFALL, 0)
            elseif (m.prevAction & ACT_FLAG_SWIMMING) ~= 0 then
                set_mario_action(m, ACT_SMW_WATER, 0)
                disable_time_stop()
            else
                set_mario_action(m, ACT_IDLE, 0)
                disable_time_stop()
            end
        end
        gPlayerSyncTable[m.playerIndex].damageframe = 30
        m.invincTimer = 50
    end
end

hook_mario_action(ACT_SMW_POWER_WATER, { every_frame = act_smw_power_water })




local function damageaction(m)
    local e = gSMWExtraStates[m.playerIndex]
    if m.playerIndex ~= 0 then return end
    if _G.charSelect.character_get_current_number(m.playerIndex) == CT_SMW then
        if (e.IsSmall == false) and m.health <= (5 << 8) then
            if (m.action & ACT_FLAG_WATER_OR_TEXT) ~= 0 or (m.action & ACT_FLAG_SWIMMING_OR_FLYING) ~= 0 or (m.action & ACT_FLAG_SWIMMING) ~= 0 then
                set_mario_action(m, ACT_SMW_DAMAGE_WATER, 0)
            else
                set_mario_action(m, ACT_SMW_DAMAGE, 0)
            end
        end

        if (e.IsSmall == true) and m.health > (5 << 8) then
            if (m.action & ACT_FLAG_WATER_OR_TEXT) ~= 0 or (m.action & ACT_FLAG_SWIMMING_OR_FLYING) ~= 0 or (m.action & ACT_FLAG_SWIMMING) ~= 0 then
                set_mario_action(m, ACT_SMW_POWER_WATER, 0)
            else
                set_mario_action(m, ACT_SMW_POWER, 0)
            end
        end

        if gPlayerSyncTable[m.playerIndex].damageframe == 1 or gPlayerSyncTable[m.playerIndex].damageframe == 11 or gPlayerSyncTable[m.playerIndex].damageframe == 14 or gPlayerSyncTable[m.playerIndex].damageframe == 16 or gPlayerSyncTable[m.playerIndex].damageframe == 17 or gPlayerSyncTable[m.playerIndex].damageframe == 18 or (gPlayerSyncTable[m.playerIndex].damageframe > 18 and not gPlayerSyncTable[m.playerIndex].damageframe == 30)
        then
            if e.is_damage == true then
                m.marioObj.header.gfx.scale.y = 1.4
            else
                m.marioObj.header.gfx.scale.y = 0.7
            end
        end
        if gPlayerSyncTable[m.playerIndex].damageframe == 29 or gPlayerSyncTable[m.playerIndex].damageframe == 28 or gPlayerSyncTable[m.playerIndex].damageframe == 27 or gPlayerSyncTable[m.playerIndex].damageframe == 26 or gPlayerSyncTable[m.playerIndex].damageframe == 25 or gPlayerSyncTable[m.playerIndex].damageframe == 24 or gPlayerSyncTable[m.playerIndex].damageframe == 23 or gPlayerSyncTable[m.playerIndex].damageframe == 22 or gPlayerSyncTable[m.playerIndex].damageframe == 21 or gPlayerSyncTable[m.playerIndex].damageframe == 20 then
            if e.is_damage == true then
                m.marioObj.header.gfx.scale.y = 1.4
            else
                m.marioObj.header.gfx.scale.y = 0.7
            end
        end

        if gPlayerSyncTable[m.playerIndex].damageframe == 2 or gPlayerSyncTable[m.playerIndex].damageframe == 3 or gPlayerSyncTable[m.playerIndex].damageframe == 6 or gPlayerSyncTable[m.playerIndex].damageframe == 8 or gPlayerSyncTable[m.playerIndex].damageframe == 9
        then
            if e.is_damage == true then
                m.marioObj.header.gfx.scale.y = 1
            else
                m.marioObj.header.gfx.scale.y = 1
            end
        end

        if gPlayerSyncTable[m.playerIndex].damageframe == 4 or gPlayerSyncTable[m.playerIndex].damageframe == 5 or gPlayerSyncTable[m.playerIndex].damageframe == 7 or gPlayerSyncTable[m.playerIndex].damageframe == 10 or gPlayerSyncTable[m.playerIndex].damageframe == 12 or gPlayerSyncTable[m.playerIndex].damageframe == 13 or gPlayerSyncTable[m.playerIndex].damageframe == 15
        then
            if e.is_damage == true then
                m.marioObj.header.gfx.scale.y = 1.3
            else
                m.marioObj.header.gfx.scale.y = 0.8
            end
        end
        --[[
        if (gPlayerSyncTable[m.playerIndex].damageframe ~= 30) and (m.action ~= ACT_SMW_DAMAGE) or (m.action ~= ACT_SMW_POWER) then
            gPlayerSyncTable[m.playerIndex].damageframe = 30
        end]]
        if not (m.action == ACT_SMW_DAMAGE or m.action == ACT_SMW_DAMAGE_WATER or m.action == ACT_SMW_POWER or m.action == ACT_SMW_POWER_WATER) then
            gPlayerSyncTable[m.playerIndex].damageframe = 30
        end
    end
end
hook_event(HOOK_MARIO_UPDATE, damageaction)

local function before_mar_upd8(m)
    local e = gSMWExtraStates[m.playerIndex]

    if _G.charSelect.character_get_current_number(m.playerIndex) == CT_SMW then
        if m.action == ACT_DEATH_EXIT or m.action == ACT_SPECIAL_DEATH_EXIT or m.action == ACT_FALLING_DEATH_EXIT then
            e.IsSmall = true
            m.health = 0x1FF
        end
        if m.action == ACT_EXIT_AIRBORNE or m.action == ACT_FALLING_EXIT_AIRBORNE then
            e.IsSmall = false
            e.smw_died = false
            m.health = 0x880
        end
        if m.action == ACT_BUBBLED or m.action == ACT_QUICKSAND_DEATH then
            m.health = 0x1FF
            e.smw_died = true
            e.IsSmall = true
        end
    end
end
hook_event(HOOK_BEFORE_MARIO_UPDATE, before_mar_upd8)

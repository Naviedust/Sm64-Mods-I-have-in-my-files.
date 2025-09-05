--------------
--water time--
--------------


--e.

SWIM = audio_sample_load("smw_swimming.ogg")

ACT_SMW_WATER = allocate_mario_action(ACT_GROUP_SUBMERGED | ACT_FLAG_SWIMMING | ACT_FLAG_WATER_OR_TEXT |
    ACT_FLAG_SHORT_HITBOX | ACT_FLAG_CUSTOM_ACTION | ACT_FLAG_SWIMMING_OR_FLYING)

local function act_smw_water(m)
    local e = gSMWExtraStates[m.playerIndex]
    local val = m.intendedMag / 1.5;
    m.marioBodyState.handState = MARIO_HAND_FISTS
    --do not make mario loose hp when in water
    m.health = m.health + 1
    m.forwardVel = 0

check_drop(m)

    m.vel.y = m.vel.y - 1.3
    if m.vel.y <= -15 then
        m.vel.y = -15
    end

    if is_anim_past_end(m) ~= 0 then
        if m.heldObj ~= nil then
            set_character_animation(m, CHAR_ANIM_WATER_IDLE)
        else
            set_character_animation(m, CHAR_ANIM_WATER_IDLE)
        end
    end
    if (m.input & INPUT_NONZERO_ANALOG) ~= 0 then
        if m.marioObj.header.gfx.animInfo.animID == CHAR_ANIM_SWIM_PART1 or m.marioObj.header.gfx.animInfo.animID == CHAR_ANIM_SWIM_WITH_OBJ_PART1 then

        else
            if m.heldObj ~= nil then
                set_character_animation(m, CHAR_ANIM_WATER_IDLE)
            else
                set_character_animation(m, CHAR_ANIM_FLUTTERKICK)
            end
        end

        m.faceAngle.y = m.intendedYaw -
            approach_s32(convert_s16(m.intendedYaw - m.faceAngle.y), 0, 0x800 - e.fakeforwardvel * 2,
                0x800 - e.fakeforwardvel * 2)
        if e.fakeforwardvel <= 18 then
            e.fakeforwardvel = e.fakeforwardvel + 1.5
        else
            e.fakeforwardvel = e.fakeforwardvel - 0.7
        end
    else
        e.fakeforwardvel = e.fakeforwardvel - 0.6
        if e.fakeforwardvel <= 0 then
            e.fakeforwardvel = 0
        end
    end
    m.vel.x = e.fakeforwardvel * sins(m.faceAngle.y) * coss(m.faceAngle.x)
    m.vel.z = e.fakeforwardvel * coss(m.faceAngle.y) * coss(m.faceAngle.x)
    if (m.flags & MARIO_METAL_CAP) ~= 0 then
        return set_mario_action(m, ACT_METAL_WATER_FALLING, 1)
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        audio_sample_play(SWIM, m.pos, 1)
        m.vel.y = m.vel.y + 25
        if m.heldObj ~= nil then
            set_character_animation(m, CHAR_ANIM_WATER_IDLE)
        else
            set_character_animation(m, CHAR_ANIM_SWIM_PART1)
        end
    end

    --walkunderwater
    if m.pos.y == m.floorHeight then
        if m.vel.y < 0 then
            m.vel.y = 0
        end
        if e.fakeforwardvel == 0 then
            if m.heldObj ~= nil then
                set_character_animation(m, CHAR_ANIM_WATER_IDLE)
            else
                set_character_animation(m, CHAR_ANIM_FIRST_PERSON)
            end
        else
            if m.heldObj ~= nil then
                set_character_animation(m, CHAR_ANIM_WATER_IDLE)
            else
                set_character_animation(m, CHAR_ANIM_WALKING)
            end
            e.timer = e.timer + 2
            e.animframe = e.timer
            set_anim_to_frame(m, e.animframe)
            if is_anim_past_frame(m, 78) ~= 0 then
                e.timer = 0
            end
        end
        if (m.input & INPUT_NONZERO_ANALOG ~= 0) then
            if (e.fakeforwardvel <= 0.0) then
                e.fakeforwardvel = e.fakeforwardvel + 1.0
            else
                e.fakeforwardvel = e.fakeforwardvel - 1.0
            end

            if (e.fakeforwardvel > 25) then
                e.fakeforwardvel = 25.0
            end
            if (m.controller.buttonDown & Z_TRIG) ~= 0 then
                set_mario_action(m, ACT_SMW_CROUCH_WATER, 0)
            end
            if (m.input & INPUT_A_PRESSED) ~= 0 then
                if m.heldObj ~= nil then
                    set_character_animation(m, CHAR_ANIM_SWIM_PART1)
                else
                    set_character_animation(m, CHAR_ANIM_SWIM_PART1)
                end
            end
        else
            e.fakeforwardvel = e.fakeforwardvel - 1.0
        end
    end
    if e.fakeforwardvel < 0 then
        e.fakeforwardvel = 0
    end
    if (m.input & INPUT_A_PRESSED ~= 0) and m.pos.y >= m.waterLevel - 100 then
        m.pos.y = m.pos.y + 1.5
        set_mario_action(m, ACT_SMW_JUMP, 0)
    end

    if m.vel.y > 25 then
        m.vel.y = 25
    end
    perform_water_step(m)
end

hook_mario_action(ACT_SMW_WATER, { every_frame = act_smw_water })

ACT_SMW_CROUCH_WATER = allocate_mario_action(ACT_GROUP_SUBMERGED | ACT_FLAG_SWIMMING | ACT_FLAG_WATER_OR_TEXT |
    ACT_FLAG_SHORT_HITBOX | ACT_FLAG_CUSTOM_ACTION | ACT_FLAG_SWIMMING_OR_FLYING)

local function act_smw_crouch_water(m)
    local e = gSMWExtraStates[m.playerIndex]
    m.vel.x = 0
    m.vel.z = 0
    e.fakeforwardvel = 0
    if m.heldObj ~= nil then
        set_character_animation(m, CHAR_ANIM_PLACE_LIGHT_OBJ)
    else
        set_character_animation(m, CHAR_ANIM_CROUCHING)
    end
    if (m.input & INPUT_A_PRESSED) ~= 0 then
        set_mario_action(m, ACT_SMW_WATER, 0)
        audio_sample_play(SWIM, m.pos, 1)
        m.vel.y = m.vel.y + 25

        if m.heldObj ~= nil then
            set_character_animation(m, CHAR_ANIM_SWIM_PART1)
        else
            set_character_animation(m, CHAR_ANIM_SWIM_PART1)
        end
    end
    if (m.controller.buttonDown & Z_TRIG) == 0 then
        set_mario_action(m, ACT_SMW_WATER, 0)
    end

    perform_water_step(m)
end

hook_mario_action(ACT_SMW_CROUCH_WATER, { every_frame = act_smw_crouch_water })

local function smw_water(m)
    local e = gSMWExtraStates[m.playerIndex]
    if _G.charSelect.character_get_current_number(m.playerIndex) == CT_SMW then
        if m.action == ACT_WATER_IDLE or m.action == ACT_WATER_ACTION_END or m.action == ACT_BREASTSTROKE or m.action == ACT_FLUTTER_KICK or m.action == ACT_WATER_PLUNGE or m.action == ACT_FORWARD_WATER_KB or m.action == ACT_BACKWARD_WATER_KB or m.action == ACT_HOLD_WATER_IDLE or m.action == ACT_HOLD_WATER_ACTION_END then
            m.action = ACT_SMW_WATER
            m.marioBodyState.handState = MARIO_HAND_FISTS
        end
    end
end
hook_event(HOOK_MARIO_UPDATE, smw_water)

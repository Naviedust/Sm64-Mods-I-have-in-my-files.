-- yes, custom moveset
--
local KICK = audio_sample_load("smw_kick.ogg")

local somari = false
--function used for built in support for some external mods
local function modsupport()
    for key, value in pairs(gActiveMods) do
        if ((value.name == "\\#7a5b1b\\Somari \\#aee1fe\\64: \\#fe8c0f\\DASH!") and string.match(value.incompatible, "romhack")) then
            somari = true
        end
    end
end


local servermodsync = false

--- @param m MarioState
--Called when a player connects
local function on_player_connected(m)
    -- only run on server
    if not network_is_server() then
        return
    end
    if servermodsync == false then --only run this once
        modsupport()               --mod check for host since on_join doesn't work for them
        servermodsync = true
    end
end

--Called when the local player finishes the join process (if the player isn't the host)
local function on_join()
    modsupport() --mod check for any player that isn't the host
end

hook_event(HOOK_ON_PLAYER_CONNECTED, on_player_connected) -- hook for player joining
hook_event(HOOK_JOINED_GAME, on_join)                     -- Called when the local player finishes the join process (if the player isn't the host)





_G.ACT_SMW_IDLE = allocate_mario_action(ACT_GROUP_STATIONARY | ACT_FLAG_IDLE | ACT_FLAG_ALLOW_FIRST_PERSON |
    ACT_FLAG_STATIONARY |
    ACT_FLAG_CUSTOM_ACTION)

local function act_smw_idle(m)
    check_throw_ground(m)

    if (m.input & INPUT_FIRST_PERSON ~= 0) then
        set_mario_action(m, ACT_FIRST_PERSON, 0)
    end

    if (m.controller.buttonPressed & Y_BUTTON ~= 0) then
        set_mario_action(m, ACT_SPIN_JUMP, 0);
    end

    if (m.controller.buttonPressed & A_BUTTON ~= 0) then
        set_mario_action(m, ACT_SMW_JUMP, 0)
    end

    if (m.controller.buttonDown & Z_TRIG ~= 0) then
        set_mario_action(m, ACT_SMW_CROUCH, 0)
    end
    if (m.input & INPUT_NONZERO_ANALOG ~= 0) then
        m.faceAngle.y = m.intendedYaw
        set_mario_action(m, ACT_SMW_WALKING, 0)
    end

    if (perform_ground_step(m) == GROUND_STEP_LEFT_GROUND) then
        set_mario_action(m, ACT_SMW_FALL, 0)
    else
        stationary_ground_step(m);
    end

    if m.heldObj ~= nil then
        set_character_animation(m, CHAR_ANIM_IDLE_WITH_LIGHT_OBJ);
    else
        set_character_animation(m, CHAR_ANIM_FIRST_PERSON);
    end
    if (should_begin_sliding(m) ~= 0) then
        set_mario_action(m, ACT_SMW_SLIDE, 0);
    end
end

hook_mario_action(ACT_SMW_IDLE, act_smw_idle)



ACT_SMW_WALKING = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_ALLOW_FIRST_PERSON | ACT_FLAG_MOVING |
    ACT_FLAG_CUSTOM_ACTION)


local function act_smw_walking(m)
    local startPos = m.pos;
    local startYaw = m.faceAngle.y;
    --~=


    local nRamp = obj_get_nearest_object_with_behavior_id(m.marioObj, bhvSMWRamp)

    check_throw_ground(m)

    local maxTargetSpeed;
    local targetSpeed;

    if (m.floor ~= nil and m.floor.type == SURFACE_SLOW) then
        maxTargetSpeed = 23
    else
        maxTargetSpeed = 31
    end

    targetSpeed = m.intendedMag < maxTargetSpeed and m.intendedMag or maxTargetSpeed;


    if (m.quicksandDepth > 10) then
        targetSpeed = targetSpeed * (6.25 / m.quicksandDepth)
    end

    if (m.controller.buttonDown & B_BUTTON ~= 0) then
        if somari == false then
            if m.forwardVel <= 55 then
                m.forwardVel = m.forwardVel + 1.5
            else
                m.forwardVel = m.forwardVel - 0.7
            end
        else
            if m.forwardVel < 55 then
                m.forwardVel = m.forwardVel + 1.5
            else
                m.forwardVel = m.forwardVel + 1.5
            end
        end
    else
        -- Acceleration
        if m.forwardVel <= 25 then
            m.forwardVel = m.forwardVel + 1.5
        else
            m.forwardVel = m.forwardVel - 0.7
        end
        -- Limit the maxand min speed
        if m.forwardVel > 70 then
            m.forwardVel = 70
        elseif m.forwardVel < -100 then
            m.forwardVel = -100
        end
    end


    m.marioObj.oMarioWalkingPitch = 0
    --[[
    if (m.forwardVel > 48.0) then
        m.forwardVel = 48.0;
    end
    ]]

    m.faceAngle.x = 0

    m.faceAngle.y = m.intendedYaw -
        approach_s32(convert_s16(m.intendedYaw - m.faceAngle.y), 0, 0x800 - m.forwardVel * 2, 0x800 - m.forwardVel * 2);
    apply_slope_accel(m);

    if (should_begin_sliding(m) ~= 0) then
        return set_mario_action(m, ACT_SMW_SLIDE, 0);
    end

    if (m.input & INPUT_A_PRESSED ~= 0) then
        return set_jump_from_landing(m);
    end

    if (m.controller.buttonPressed & Y_BUTTON ~= 0) then
        --djui_chat_message_create("walk's")
        return set_mario_action(m, ACT_SPIN_JUMP, 0);
    end

    if (m.input & INPUT_ZERO_MOVEMENT ~= 0) then
        m.forwardVel = approach_f32(m.forwardVel, 0.0, 2, 2)
        if m.forwardVel == 0.0 then
            return set_mario_action(m, ACT_SMW_IDLE, 0);
        end
    end


    if (m.input & INPUT_Z_PRESSED ~= 0) then
        return set_mario_action(m, ACT_SMW_CROUCH_SLIDE, 0);
    end
    if m.heldObj == nil then
        if (analog_stick_held_back(m) ~= 0 and m.forwardVel >= 16.0) then
            return set_mario_action(m, ACT_SMW_TURNING, 0);
        end
    end



    m.actionState = 0;
    interact_w_door(m)
    vec3f_copy(startPos, m.pos);
    update_smw_speed_ref(m);

    local stepResult = perform_ground_step(m)
    if (stepResult == GROUND_STEP_LEFT_GROUND) then
        set_mario_action(m, ACT_SMW_FALL, 0);
    elseif (stepResult == GROUND_STEP_NONE) then
        smw_anim_and_audio_for_walk(m);
        if ((m.intendedMag - m.forwardVel) > 16.0) then
            set_mario_particle_flags(m, PARTICLE_DUST, false);
        end
    elseif (stepResult == GROUND_STEP_HIT_WALL) then
        if nRamp ~= nil and dist_between_objects(m.marioObj, nRamp) < 150 then
            if m.heldObj ~= nil then
                set_character_anim_with_accel(m, CHAR_ANIM_RUN_WITH_LIGHT_OBJ, 200000)
            else
                set_character_anim_with_accel(m, CHAR_ANIM_RUNNING, 200000)
            end
        else
            m.forwardVel = 0
            if m.heldObj ~= nil then
                set_character_anim_with_accel(m, CHAR_ANIM_RUN_WITH_LIGHT_OBJ, 200000)
            else
                set_character_anim_with_accel(m, CHAR_ANIM_RUNNING, 200000)
            end
        end
    end
    return 0;
end

hook_mario_action(ACT_SMW_WALKING, { every_frame = act_smw_walking, gravity = nil })

local jumpsound = audio_sample_load("smw_jump.ogg")

ACT_SMW_JUMP = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR  |
    ACT_FLAG_CUSTOM_ACTION | ACT_FLAG_CONTROL_JUMP_HEIGHT)


local function act_smw_jump(m)
    check_throw_air(m)
    m.vel.y = m.vel.y - 1

    if m.heldObj ~= nil then
        ACT_LAND_ACTION = ACT_SMW_WALKING
        CHAR_ANIM_JUMP = CHAR_ANIM_JUMP_WITH_LIGHT_OBJ
    else
        ACT_LAND_ACTION = ACT_SMW_WALKING
        CHAR_ANIM_JUMP = CHAR_ANIM_SINGLE_JUMP
    end

    if (m.controller.buttonDown & Z_TRIG) ~= 0 then
        if m.heldObj ~= nil then
            ACT_LAND_ACTION = ACT_SMW_CROUCH
            CHAR_ANIM_JUMP = CHAR_ANIM_PLACE_LIGHT_OBJ
        else
            ACT_LAND_ACTION = ACT_SMW_CROUCH
            CHAR_ANIM_JUMP = CHAR_ANIM_CROUCHING
        end
    end
    if (m.vel.y < 0) and not (m.controller.buttonDown & Z_TRIG ~= 0) then
        if m.heldObj ~= nil then
            CHAR_ANIM_JUMP = CHAR_ANIM_FALL_WITH_LIGHT_OBJ
        else
            CHAR_ANIM_JUMP = CHAR_ANIM_GENERAL_FALL
        end
    end
    if (m.forwardVel >= 34) and (m.controller.buttonDown & B_BUTTON ~= 0) and not (m.controller.buttonDown & Z_TRIG ~= 0) then
        if m.heldObj ~= nil then
            CHAR_ANIM_JUMP = CHAR_ANIM_JUMP_WITH_LIGHT_OBJ
        else
            CHAR_ANIM_JUMP = CHAR_ANIM_TRIPLE_JUMP
        end
    end
    if m.actionTimer < 1 and m.action == ACT_SMW_JUMP then
        audio_sample_play(jumpsound, gMarioStates[0].pos, 1)
    end


    if m.actionTimer < 1 then
        m.vel.y = 50 + (m.forwardVel / 4)
        m.actionTimer = m.actionTimer + 1
    end

    common_air_action_step2(m, ACT_LAND_ACTION, CHAR_ANIM_JUMP, AIR_STEP_NONE)
end

hook_mario_action(ACT_SMW_JUMP, { every_frame = act_smw_jump })



ACT_SMW_FALL = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR  |
    ACT_FLAG_CUSTOM_ACTION)



local function act_smw_fall(m)
    check_throw_air(m)
    if m.heldObj ~= nil then
        ACT_LAND_ACTION = ACT_SMW_WALKING
        CHAR_ANIM = CHAR_ANIM_FALL_WITH_LIGHT_OBJ
    else
        ACT_LAND_ACTION = ACT_SMW_WALKING
        CHAR_ANIM = CHAR_ANIM_GENERAL_FALL
    end

    if m.actionTimer < 1 then
        m.actionTimer = m.actionTimer + 1
    end
    common_air_action_step2(m, ACT_LAND_ACTION, CHAR_ANIM, AIR_STEP_NONE)
end


hook_mario_action(ACT_SMW_FALL, { every_frame = act_smw_fall })


ACT_SMW_CROUCH = allocate_mario_action(ACT_GROUP_STATIONARY | ACT_FLAG_IDLE  |
    ACT_FLAG_CUSTOM_ACTION | ACT_FLAG_SHORT_HITBOX)
local function smw_act_crouching(m)
    check_drop(m)
    if (m.input & INPUT_A_PRESSED ~= 0) then
        return set_jumping_action(m, ACT_SMW_JUMP, 0);
    end
    if (m.input & INPUT_OFF_FLOOR ~= 0) then
        return set_mario_action(m, ACT_SMW_FALL, 0);
    end
    if (m.input & INPUT_ABOVE_SLIDE ~= 0) then
        return set_mario_action(m, ACT_SMW_SLIDE, 0);
    end
    if (m.input & INPUT_FIRST_PERSON ~= 0) then
        return set_mario_action(m, ACT_SMW_IDLE, 0);
    end
    if (m.input & INPUT_Z_DOWN == 0) then
        if m.heldObj ~= nil then
            return set_mario_action(m, ACT_SMW_HOLD_IDLE, 0);
        else
            return set_mario_action(m, ACT_SMW_IDLE, 0);
        end
    end
    stationary_ground_step(m);

    if m.heldObj ~= nil then
        set_character_animation(m, CHAR_ANIM_PLACE_LIGHT_OBJ);
    else
        set_character_animation(m, CHAR_ANIM_CROUCHING);
    end

    perform_ground_step(m);
end

hook_mario_action(ACT_SMW_CROUCH, { every_frame = smw_act_crouching })

ACT_SMW_CROUCH_SLIDE = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING  |
    ACT_FLAG_CUSTOM_ACTION | ACT_FLAG_SHORT_HITBOX)

local function act_smw_crouch_slide(m)
    check_drop(m)
    if (m.input & INPUT_ABOVE_SLIDE) ~= 0 then
        return set_mario_action(m, ACT_SMW_SLIDE, 0);
    end


    if m.heldObj ~= nil then
        anim = CHAR_ANIM_PLACE_LIGHT_OBJ
    else
        anim = CHAR_ANIM_CROUCHING
    end

    if (m.controller.buttonPressed & Y_BUTTON) ~= 0 then
        if not (m.input & INPUT_Z_DOWN ~= 0) then
            return set_mario_action(m, ACT_SPIN_JUMP, 0);
        else
        end
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_jumping_action(m, ACT_SMW_JUMP, 0);
    end

    if (m.input & INPUT_FIRST_PERSON) ~= 0 then
        return set_mario_action(m, ACT_SMW_WALKING, 0);
    end
    cancel = common_slide_action_with_jump(m, ACT_SMW_CROUCH, ACT_SMW_JUMP, ACT_SMW_FALL, anim)
    return cancel;
end

hook_mario_action(ACT_SMW_CROUCH_SLIDE, { every_frame = act_smw_crouch_slide })

ACT_SMW_TURNING = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING  |
    ACT_FLAG_CUSTOM_ACTION)

local function act_smw_turning(m)
    if (m.input & INPUT_ABOVE_SLIDE) ~= 0 then
        return set_mario_action(m, ACT_SMW_SLIDE, 0);
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_jumping_action(m, ACT_SMW_JUMP, 0);
    end

    if (m.input & INPUT_ZERO_MOVEMENT) ~= 0 then
        return set_mario_action(m, ACT_SMW_WALKING, 0);
    end

    if (apply_slope_decel(m, 2.0)) ~= 0 then
        return begin_walking_action(m, 8.0, ACT_FINISH_TURNING_AROUND, 0);
    end
    if m.actionTimer <= 3 then
        set_mario_particle_flags(m, PARTICLE_DUST, false)
    end
    if (perform_ground_step(m)) == GROUND_STEP_LEFT_GROUND then
        set_mario_action(m, ACT_SMW_FALL, 0)
    end

    if (m.forwardVel >= 18.0) then
        set_character_animation(m, CHAR_ANIM_TURNING_PART1);
    else
        set_character_animation(m, CHAR_ANIM_TURNING_PART2);
        if (is_anim_at_end(m)) ~= 0 then
            if (m.forwardVel > 0.0) then
                begin_walking_action(m, m.forwardVel, ACT_WALKING, 0);
            else
                begin_walking_action(m, 8.0, ACT_WALKING, 0);
            end
        end
    end
end

hook_mario_action(ACT_SMW_TURNING, { every_frame = act_smw_turning })

SPINBOUNCE = audio_sample_load("smw_stomp2.ogg")
TWIRL = audio_sample_load("smw_spin_jump.ogg")
BOUNCE = audio_sample_load("smw_stomp_no_damage.ogg")

local function spinbounce(o, target)
    local m = gMarioStates[0]
    if (m.controller.buttonDown & Y_BUTTON) ~= 0 then
        m.vel.y = 50
    else
        m.vel.y = 30
    end
    m.particleFlags = m.particleFlags | PARTICLE_MIST_CIRCLE | PARTICLE_HORIZONTAL_STAR
    spawn_mist_particles()
    obj_mark_for_deletion(target)
    audio_sample_play(SPINBOUNCE, m.pos, 1)
end
local function spinbonk(o, target)
    local m = gMarioStates[0]
    m.invincTimer = 5
    if (m.controller.buttonDown & Y_BUTTON) ~= 0 then
        m.vel.y = 50
    else
        m.vel.y = 30
    end
    m.particleFlags = m.particleFlags | PARTICLE_HORIZONTAL_STAR
    audio_sample_play(BOUNCE, m.pos, 1)
end

local Target = {
    [id_bhvGoomba] = spinbounce,
    [id_bhvRedCoin] = spinbounce,
    [id_bhvBobomb] = spinbounce,
    [id_bhvKoopa] = spinbounce,
    [id_bhvKoopaShell] = spinbounce,
    [id_bhvFlyGuy] = spinbounce,
    [id_bhvMontyMole] = spinbounce,
    [id_bhvSpindrift] = spinbounce,
    [id_bhvPokey] = spinbounce,
    [id_bhvSkeeter] = spinbounce,
    [id_bhvMoneybag] = spinbounce,
    [id_bhvSnufit] = spinbounce,
    [id_bhvSwoop] = spinbounce,
    [id_bhvFirePiranhaPlant] = spinbounce,
    [id_bhvEnemyLakitu] = spinbounce,
}


local target2 = {
    [id_bhvSmallBully] = spinbonk,
    [id_bhvToadMessage] = spinbonk,
    [id_bhvBigBully] = spinbonk,
    [id_bhvChainChomp] = spinbonk,
    [id_bhvBowser] = spinbonk,
    [id_bhvWaterAirBubble] = spinbonk,
    [id_bhvFlame] = spinbonk,
    [id_bhvFlameBowser] = spinbonk,
    [id_bhvFlameBouncing] = spinbonk,
    [id_bhvFlamethrowerFlame] = spinbonk,
    [id_bhvBulletBill] = spinbonk,
    [id_bhvBoo] = spinbonk,
    [id_bhvEyerokHand] = spinbonk,
    [id_bhvMrI] = spinbonk,
    [id_bhvMrIParticle] = spinbonk,
    [id_bhvPiranhaPlant] = spinbonk,
    [id_bhvFirePiranhaPlant] = spinbonk,
    [id_bhvSmallPiranhaFlame] = spinbonk,
    [id_bhvSmallChillBully] = spinbonk,
    [id_bhvBigChillBully] = spinbonk,
    [id_bhvHomingAmp] = spinbonk,
    [id_bhvCirclingAmp] = spinbonk,
}



ACT_SPIN_JUMP = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_SHORT_HITBOX | ACT_GROUND_POUND)

--- @parameter m marioState
local function act_spin_jump(m)
    mario_drop_held_object(m)
    local mo = m.marioObj
    local attackDist = 200

    local targetDist2 = 1200
    local attackDist2 = 1000

    for key, hit_effect in pairs(Target) do
        if (m.playerIndex == 0) then
            local otherObj = cur_obj_nearest_object_with_behavior(get_behavior_from_id(key))
            if otherObj ~= nil and not (key == id_bhvMario and otherObj.globalPlayerIndex == obj.globalPlayerIndex) then
                if obj_check_hitbox_overlap(mo, otherObj) and dist_between_objects(mo, otherObj) < attackDist2 then
                    hit_effect(mo, otherObj)
                end
            end
        end
    end

    for key, hit_effect in pairs(target2) do
        if (m.playerIndex == 0) then
            local otherObj = cur_obj_nearest_object_with_behavior(get_behavior_from_id(key))
            if otherObj ~= nil and not (key == id_bhvMario and otherObj.globalPlayerIndex == obj.globalPlayerIndex) then
                if obj_check_hitbox_overlap(mo, otherObj) and dist_between_objects(mo, otherObj) < attackDist2 then
                    hit_effect(mo, otherObj)
                end
            end
        end
    end
    if m.actionTimer < 1 and m.action == ACT_SPIN_JUMP then
        audio_sample_play(TWIRL, m.pos, 1)
        m.pos.y = m.pos.y + 1
        m.vel.y = 40 + (m.forwardVel / 4)
    end
    common_air_action_step2(m, ACT_SPIN_JUMP_LAND, CHAR_ANIM_DOUBLE_JUMP_RISE, AIR_STEP_NONE)
    smlua_anim_util_set_animation(m.marioObj, "SMW_Spinjump")
    m.actionTimer = m.actionTimer + 1
end

hook_mario_action(ACT_SPIN_JUMP, act_spin_jump, INT_GROUND_POUND)


---spinjumpland because int_groundpound...


ACT_SPIN_JUMP_LAND = allocate_mario_action(ACT_FLAG_STATIONARY | ACT_FLAG_ATTACKING |
    ACT_FLAG_CUSTOM_ACTION)

local function act_land_spin_jump(m)
    --djui_chat_message_create("set to idle")
    queue_rumble_data_mario(m, 3, 50);
    if (m.input & INPUT_ZERO_MOVEMENT ~= 0) then
        if m.heldObj ~= nil then
            set_mario_action(m, ACT_SMW_HOLD_IDLE, 0)
        else
            set_mario_action(m, ACT_SMW_IDLE, 0)
        end
    else
        set_mario_action(m, ACT_SMW_WALKING, 0)
    end
    if (m.controller.buttonPressed & Y_BUTTON ~= 0) then
        return set_mario_action(m, ACT_SPIN_JUMP, 0);
    end
    set_character_animation(m, CHAR_ANIM_FIRST_PERSON)
end

hook_mario_action(ACT_SPIN_JUMP_LAND, act_land_spin_jump, INT_GROUND_POUND)

--[[
local nospinj = {
    [ACT_DISAPPEARED] = true,
    [ACT_STAR_DANCE_EXIT] = true,
    [ACT_STAR_DANCE_NO_EXIT] = true,
    [ACT_STAR_DANCE_WATER] = true,
    [ACT_CREDITS_CUTSCENE] = true,
    [ACT_DEATH_EXIT_LAND] = true,
    [ACT_SQUISHED] = true,
    [ACT_IN_CANNON] = true,
    [ACT_TELEPORT_FADE_OUT] = true,
    [ACT_TELEPORT_FADE_IN] = true,
    [ACT_SPIN_JUMP_LAND] = true,
    [ACT_SMW_LV_END] = true,
    [ACT_SMW_LV_END_SHORT] = true,
}

local function spinjump(m)
    if m.playerIndex ~= 0 then return end
    if _G.charSelect.character_get_current_number(m.playerIndex) == CT_SMW then
        if (m.controller.buttonPressed & Y_BUTTON) ~= 0 and (nospinj[m.action] ~= true) and ((m.action & ACT_FLAG_AIR) == 0) and ((m.action & ACT_FLAG_WATER_OR_TEXT) == 0) and ((m.action & ACT_FLAG_METAL_WATER) == 0) and ((m.action & ACT_GROUP_CUTSCENE) == 0) then
            set_mario_action(m, ACT_SPIN_JUMP, 0)
        end
    end
end
--]]

local function smwupdate(m)
    --    djui_chat_message_create(tostring(gMarioStates[0].faceAngle.y))
    local e = gSMWExtraStates[m.playerIndex]
    --if m.playerIndex ~= 0 then return end
    if _G.charSelect.character_get_current_number(m.playerIndex) == CT_SMW then
        -- m.marioObj.oMarioWalkingPitch = 0
        m.peakHeight = m.pos.y
        if m.marioObj.header.gfx.animInfo.animID == CHAR_ANIM_GENERAL_FALL or m.marioObj.header.gfx.animInfo.animID == CHAR_ANIM_FALL_WITH_LIGHT_OBJ then
            m.marioBodyState.eyeState = 9
        end
        if m.marioObj.header.gfx.animInfo.animID == CHAR_ANIM_CROUCHING or m.marioObj.header.gfx.animInfo.animID == CHAR_ANIM_START_CROUCHING then
            m.marioBodyState.eyeState = 10
        end
        if m.marioObj.header.gfx.animInfo.animID == CHAR_ANIM_RUNNING and (m.controller.buttonDown & B_BUTTON ~= 0) and m.heldObj == nil then
            if m.forwardVel >= 44 then
                smlua_anim_util_set_animation(m.marioObj, SMW_ANIM_RUN)
                m.marioBodyState.handState = MARIO_HAND_OPEN
            end
            if m.forwardVel >= 44 and e.IsSmall == true then
                smlua_anim_util_set_animation(m.marioObj, S_SMW_ANIM_RUN)
                m.marioBodyState.handState = MARIO_HAND_OPEN
            end
        end
        if m.marioObj.header.gfx.animInfo.animID == CHAR_ANIM_TRIPLE_JUMP then
            m.marioBodyState.handState = MARIO_HAND_OPEN
        end
        if m.marioObj.header.gfx.animInfo.animID == CHAR_ANIM_STAR_DANCE or m.marioObj.header.gfx.animInfo.animID == charSelect.CS_ANIM_MENU then
            m.marioBodyState.handState = MARIO_HAND_PEACE_SIGN
        end
        if (obj_has_behavior_id(m.heldObj, id_bhvBowser) ~= 0) then
            m.marioBodyState.grabPos = GRAB_POS_BOWSER
            m.angleVel.y = m.forwardVel * 100
        else
            m.marioBodyState.grabPos = GRAB_POS_HEAVY_OBJ
        end
        if m.action == ACT_SHOCKED or m.action == ACT_WATER_SHOCKED then
            m.hurtCounter = 4
        end
        if (m.flags & MARIO_METAL_CAP) ~= 0 then
            m.marioBodyState.eyeState = 1
        end
        if m.prevAction == ACT_DECELERATING or m.prevAction == ACT_HOLD_DECELERATING then
            if m.action == ACT_PUSHING_DOOR or m.action == ACT_PULLING_DOOR then
                if dist_between_objects(m.marioObj, obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvDoorWarp)) < 150 then
                    m.action = ACT_SMW_ENTRING_DOOR
                else
                    m.action = ACT_SMW_IDLE
                end
            end
        end
        if (m.controller.buttonPressed & U_JPAD ~= 0) then
            interact_w_pole(m)
        end
    end
end

hook_event(HOOK_MARIO_UPDATE, smwupdate)


--hook_event(HOOK_MARIO_UPDATE, spinjump)

----holding actions---

ACT_SMW_HOLD_IDLE = allocate_mario_action(ACT_GROUP_STATIONARY | ACT_FLAG_IDLE | ACT_FLAG_STATIONARY |
    ACT_FLAG_CUSTOM_ACTION)
local function act_smw_hold_idle(m)
    check_throw_ground(m)
    if (m.controller.buttonPressed & Y_BUTTON ~= 0) then
        return set_mario_action(m, ACT_SPIN_JUMP, 0);
    end
    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_jumping_action(m, ACT_SMW_JUMP, 0);
    end
    if (m.input & INPUT_NONZERO_ANALOG) ~= 0 then
        return set_mario_action(m, ACT_SMW_WALKING, 0);
    end
    if (m.input & INPUT_Z_DOWN) ~= 0 then
        return set_mario_action(m, ACT_SMW_CROUCH, 0);
    end
    stationary_ground_step(m);
    set_character_animation(m, CHAR_ANIM_IDLE_WITH_LIGHT_OBJ);
end

hook_mario_action(ACT_SMW_HOLD_IDLE, { every_frame = act_smw_hold_idle })


ACT_SMW_KICK = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_THROWING | ACT_FLAG_ATTACKING |
    ACT_FLAG_CUSTOM_ACTION)

local function act_smw_kick(m)
    m.actionTimer = m.actionTimer + 1
    mario_throw_held_object(m);
    queue_rumble_data_mario(m, 3, 50);
    if m.actionTimer >= 15 then
        if (m.prevAction & ACT_FLAG_AIR) ~= 0 then
            act = ACT_SMW_IDLE
            set_mario_action(m, ACT_SMW_IDLE, 0)
        else
            act = ACT_SMW_FALL
            set_mario_action(m, ACT_SMW_FALL, 0)
        end
    end

    if (m.controller.buttonPressed & Y_BUTTON ~= 0) then
        return set_mario_action(m, ACT_SPIN_JUMP, 0);
    end
    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_jumping_action(m, ACT_SMW_JUMP, 0);
    end

    common_slide_action_with_jump(m, ACT_SMW_WALKING, ACT_SMW_JUMP, ACT_SMW_FALL, CHAR_ANIM_GROUND_THROW)
    set_character_animation(m, CHAR_ANIM_GROUND_THROW)
end

hook_mario_action(ACT_SMW_KICK, { every_frame = act_smw_kick })

ACT_SMW_KICK_AIR = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_AIR | ACT_FLAG_THROWING | ACT_FLAG_ATTACKING |
    ACT_FLAG_CUSTOM_ACTION)

local function act_smw_kick_air(m)
    m.actionTimer = m.actionTimer + 1

    mario_throw_held_object(m);

    if m.actionTimer >= 15 then
        if (m.prevAction & ACT_FLAG_AIR) ~= 0 then
            act = ACT_SMW_FALL
            set_mario_action(m, ACT_SMW_FALL, 0)
        else
            act = ACT_SMW_IDLE
            set_mario_action(m, ACT_SMW_IDLE, 0)
        end
    end
    common_air_action_step2(m, act, CHAR_ANIM_GROUND_THROW, AIR_STEP_NONE)
    set_character_animation(m, CHAR_ANIM_GROUND_THROW)
end

hook_mario_action(ACT_SMW_KICK_AIR, act_smw_kick_air)

ACT_SMW_PICK = allocate_mario_action(ACT_GROUP_MOVING |
    ACT_FLAG_CUSTOM_ACTION)

local function act_smw_pick(m)
    m.actionTimer = m.actionTimer + 1
    if m.actionTimer == 10 then
        if (m.prevAction & ACT_FLAG_AIR) ~= 0 then
            act = ACT_SMW_FALL
            set_mario_action(m, ACT_SMW_FALL, 0)
        else
            act = ACT_SMW_HOLD_IDLE
            set_mario_action(m, ACT_SMW_HOLD_IDLE, 0)
        end
    end
    common_slide_action_with_jump(m, ACT_SMW_CROUCH, ACT_SMW_JUMP, ACT_SMW_FALL, CHAR_ANIM_PLACE_LIGHT_OBJ)
end

hook_mario_action(ACT_SMW_PICK, { every_frame = act_smw_pick })

ACT_SMW_PICK_STILL = allocate_mario_action(ACT_GROUP_MOVING |
    ACT_FLAG_CUSTOM_ACTION)

local function act_smw_pick_still(m)
    if m.forwardVel ~= 0 then
        set_mario_action(m, ACT_SMW_PICK, 0)
    end
    set_character_animation(m, CHAR_ANIM_PLACE_LIGHT_OBJ)
    m.actionTimer = m.actionTimer + 1
    if m.actionTimer == 10 then
        act = ACT_SMW_HOLD_IDLE
        set_mario_action(m, ACT_SMW_HOLD_IDLE, 0)
    end
    perform_ground_step(m)
end

hook_mario_action(ACT_SMW_PICK_STILL, { every_frame = act_smw_pick_still })



ACT_SMW_ENTRING_DOOR = allocate_mario_action(ACT_GROUP_STATIONARY | ACT_FLAG_IDLE | ACT_FLAG_STATIONARY |
    ACT_FLAG_CUSTOM_ACTION)
local function act_smw_door(m)
    level_trigger_warp(m, WARP_OP_WARP_DOOR)
    set_character_animation(m, CHAR_ANIM_FIRST_PERSON)
end

hook_mario_action(ACT_SMW_ENTRING_DOOR, { every_frame = act_smw_door })

ACT_SMW_POLE = allocate_mario_action(ACT_FLAG_MOVING |ACT_FLAG_ON_POLE | ACT_FLAG_CUSTOM_ACTION)
local function act_smw_pole(m)
    local cameraAngle = m.area.camera.yaw
    local marioObj = m.marioObj

    m.faceAngle.y = cameraAngle + 0x8000


    if (m.usedObj == nil) then m.usedObj = cur_obj_find_nearest_pole() end
    if (m.usedObj == nil) then return false end


    if ((m.input & INPUT_Z_PRESSED) ~= 0 or m.health < 0x100) then
        m.forwardVel = -2.0
        set_mario_action(m, ACT_SMW_FALL, 0);
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        m.faceAngle.y = m.faceAngle.y
        set_mario_action(m, ACT_SMW_JUMP, 0)
    end
    if (m.input & INPUT_NONZERO_ANALOG) ~= 0 then
        set_character_animation(m, CHAR_ANIM_CLIMB_UP_POLE)
    else
        marioObj.oMarioPoleYawVel = 0;
        set_character_animation(m, CHAR_ANIM_IDLE_ON_POLE)
    end

    if (m.controller.stickY > 16.0) then
        poleTop = m.usedObj.hitboxHeight - 100.0
        poleBehavior = virtual_to_segmented(0x13, m.usedObj.behavior)

        if (marioObj.oMarioPolePos < poleTop - 0.4) then
            marioObj.oMarioPoleYawVel = marioObj.oMarioPoleYawVel - m.controller.stickY * 2
            if (marioObj.oMarioPoleYawVel > 0x1000) then
                marioObj.oMarioPoleYawVel = 0x1000;
            end

            -- m.faceAngle.y = m.faceAngle.y + marioObj.oMarioPoleYawVel
            marioObj.oMarioPolePos = math.abs(marioObj.oMarioPolePos - marioObj.oMarioPoleYawVel / 20)

            if (m.usedObj.behavior == obj_has_behavior(m.usedObj, bhvTree)) then
                --//! The Shifting Sand Land palm tree check is done climbing up in
                --// add_tree_leaf_particles, but not here, when climbing down.
                if (m.pos.y - m.floorHeight > 100.0) then
                    set_mario_particle_flags(m, PARTICLE_LEAF, FALSE)
                end
            end
            reset_rumble_timers(m)
        else
            marioObj.oMarioPoleYawVel = 0;
            set_character_animation(m, CHAR_ANIM_IDLE_ON_POLE)
        end
    end

    if (m.controller.stickY < -16.0) then
        marioObj.oMarioPoleYawVel = marioObj.oMarioPoleYawVel - m.controller.stickY * 2
        if (marioObj.oMarioPoleYawVel > 0x1000) then
            marioObj.oMarioPoleYawVel = 0x1000;
        end

        marioObj.oMarioPolePos = marioObj.oMarioPolePos - marioObj.oMarioPoleYawVel / 0x100

        if (m.usedObj.behavior == obj_has_behavior(m.usedObj, bhvTree)) then
            --//! The Shifting Sand Land palm tree check is done climbing up in
            --// add_tree_leaf_particles, but not here, when climbing down.
            if (m.pos.y - m.floorHeight > 100.0) then
                set_mario_particle_flags(m, PARTICLE_LEAF, FALSE)
            end
        end
        reset_rumble_timers(m)
    else
        marioObj.oMarioPoleYawVel = 0;
    end

    if (set_pole_position(m, 0.0) == POLE_NONE) then
        set_character_animation(m, CHAR_ANIM_IDLE_ON_POLE)
    end
end
hook_mario_action(ACT_SMW_POLE, { every_frame = act_smw_pole })

ACT_SMW_SLIDE = allocate_mario_action(ACT_FLAG_MOVING | ACT_FLAG_BUTT_OR_STOMACH_SLIDE | ACT_FLAG_ATTACKING)


local function act_smw_slide(m)
    check_throw_air(m)
    if (m.controller.buttonPressed & Y_BUTTON ~= 0) then
        return set_mario_action(m, ACT_SPIN_JUMP, 0);
    end
    common_slide_action_with_jump(m, ACT_SMW_WALKING, ACT_SMW_JUMP, ACT_SMW_FALL, CHAR_ANIM_SLIDE)
end

hook_mario_action(ACT_SMW_SLIDE, act_smw_slide)

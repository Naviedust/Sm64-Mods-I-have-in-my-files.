gSMWExtraStates = {}

local function smw_reset_extra_states(index)
    if index == nil then index = 0 end
    gSMWExtraStates[index] = {
        animframe = 0,
        fakeforwardvel = 0,
        timer = 0,
        is_damage = true,
        IsSmall = false,
        keepairmoment = 0,
        oneframe = 1,
        isbubbled = false,
        smw_died = false,
        lava = false,
        damageframe = 30,
        b2grab = mod_storage_load_bool("SMW_GRABBUTTON")
    }
end

for i = 0, MAX_PLAYERS - 1 do
    smw_reset_extra_states(i)
end
local KICK = audio_sample_load("smw_kick.ogg")

function check_throw_ground(m)
    local e = gSMWExtraStates[m.playerIndex]
    if m.heldObj ~= nil then
        if e.b2grab == true then
            if (m.controller.buttonDown & B_BUTTON == 0) then
                mario_throw_held_object(m)
                audio_sample_play(KICK, m.pos, 1)
                set_mario_action(m, ACT_SMW_KICK, 0)
            end
        elseif e.b2grab == false then
            if (m.controller.buttonDown & X_BUTTON == 0) then
                mario_throw_held_object(m)
                audio_sample_play(KICK, m.pos, 1)
                set_mario_action(m, ACT_SMW_KICK, 0)
            end
        end
    end
end

function check_drop(m)
    local e = gSMWExtraStates[m.playerIndex]
    if m.heldObj ~= nil then
        if e.b2grab == true then
            if (m.controller.buttonDown & B_BUTTON == 0) then
                mario_drop_held_object(m);
            end
        elseif e.b2grab == false then
            if (m.controller.buttonDown & X_BUTTON == 0) then
                mario_drop_held_object(m);
            end
        end
    end
end

function check_throw_air(m)
    local e = gSMWExtraStates[m.playerIndex]
    if m.heldObj ~= nil then
        if e.b2grab == true then
            if (m.controller.buttonDown & B_BUTTON == 0) then
                mario_throw_held_object(m)
                audio_sample_play(KICK, m.pos, 1)
                set_mario_action(m, ACT_SMW_KICK_AIR, 0)
            end
        elseif e.b2grab == false then
            if (m.controller.buttonDown & X_BUTTON == 0) then
                mario_throw_held_object(m)
                audio_sample_play(KICK, m.pos, 1)
                set_mario_action(m, ACT_SMW_KICK_AIR, 0)
            end
        end
    end
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

function virtual_to_segmented(segment, addr)
    return addr
end

function segmented_to_virtual(addr)
    return addr;
end

function s16(x)
    x = (math.floor(x) & 0xFFFF)
    if x >= 32768 then return x - 65536 end
    return x
end

function interact_w_door(m)
    local wdoor = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvDoorWarp)
    local door = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvDoor)
    local sdoor = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvStarDoor)

    if door ~= nil and dist_between_objects(m.marioObj, door) < 150 then
        interact_door(m, 0, door)
        --djui_chat_message_create("door.")
        if door.oAction == 0 then
            if (should_push_or_pull_door(m, door) & 1) ~= 0 then
                door.oInteractStatus = 0x00010000
            else
                door.oInteractStatus = 0x00020000
            end
        end
    elseif sdoor ~= nil and dist_between_objects(m.marioObj, sdoor) < 150 then
        interact_door(m, 0, sdoor)
        --djui_chat_message_create("star door.")
        if sdoor.oAction == 0 then
            if (should_push_or_pull_door(m, sdoor) & 1) ~= 0 then
                sdoor.oInteractStatus = 0x00010000
            else
                sdoor.oInteractStatus = 0x00020000
            end
        end
    elseif wdoor ~= nil and dist_between_objects(m.marioObj, wdoor) < 150 then
        interact_warp_door(m, 0, wdoor)
        set_mario_action(m, ACT_DECELERATING, 0)
        --djui_chat_message_create("warp door.")
        if wdoor.oAction == 0 then
            if (should_push_or_pull_door(m, wdoor) & 1) ~= 0 then
                wdoor.oInteractStatus = 0x00010000
            else
                wdoor.oInteractStatus = 0x00020000
            end
        end
    end
end

function interact_w_pole(m)
    local tree = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvTree)
    local pole = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvPoleGrabbing)

    if tree ~= nil and dist_between_objects(m.marioObj, tree) < 150 then
        set_mario_action(m, ACT_SMW_FALL, 0)
    end
    if pole ~= nil and dist_between_objects(m.marioObj, pole) < 150 then
        set_mario_action(m, ACT_SMW_FALL, 0)
    end
end

function update_smw_speed_ref(m)
    local maxTargetSpeed = 0.0;
    local targetSpeed = 0.0;


    if (m.floor ~= nil and m.floor.type == SURFACE_SLOW) then
        maxTargetSpeed = 30.0;
    else
        maxTargetSpeed = 40.0;
    end

    if (m.intendedMag < maxTargetSpeed) then
        targetSpeed = m.intendedMag
    else
        targetSpeed = maxTargetSpeed
    end

    if (m.quicksandDepth > 10.0) then
        targetSpeed = targetSpeed * (6.25 / m.quicksandDepth);
    end

    if (m.forwardVel <= 0.0) then
        m.forwardVel = m.forwardVel + 1.1;
    elseif (m.forwardVel <= targetSpeed) then
        m.forwardVel = m.forwardVel + 1.1 - m.forwardVel / 43.0;
    elseif (m.floor ~= nil and m.floor.normal.y >= 0.95) then
        m.forwardVel = m.forwardVel - 1.0;
    end

    m.faceAngle.y = m.intendedYaw - approach_s32(s16(m.intendedYaw - m.faceAngle.y), 0, 0x800, 0x800);
    apply_slope_accel(m);
end

local function s32(x)
    x = (math.floor(x) & 0xFFFFFFFF)
    if x >= 2147483648 then return x - 4294967296 end
    return x
end

function smw_anim_and_audio_for_walk(m)
    local val14 = 0
    local marioObj = m.marioObj
    local val0C = true
    local targetPitch = 0
    local val04 = 0.0

    if (m.intendedMag > m.forwardVel) then
        val04 = m.intendedMag
    else
        val04 = m.forwardVel
    end
    if (val04 < 4.0) then
        val04 = 4.0
    end
    if (m.quicksandDepth > 50) then
        val14 = s32(val04 / 4.0 * 0x10000)
        set_character_anim_with_accel(m, CHAR_ANIM_MOVE_IN_QUICKSAND, val14)
        m.actionState = 0
    else
        while (val0C) do
            if (m.actionState == 0) then
                if (val04 > 8.0) then
                    m.actionState = 2
                else
                    --! (Speed Crash) If Mario's speed is more than 2^17.
                    val14 = s32(val04 / 4.0 * 0x10000)
                    if (val14 < 0x1000) then
                        val14 = 0x1000
                    end
                    if m.heldObj ~= nil then
                        set_character_anim_with_accel(m, CHAR_ANIM_RUN_WITH_LIGHT_OBJ, val14)
                    else
                        set_character_anim_with_accel(m, CHAR_ANIM_START_TIPTOE, val14)
                    end
                    if (is_anim_past_frame(m, 23)) then
                        m.actionState = 2
                    end

                    val0C = false
                end
            elseif (m.actionState == 1) then
                if (val04 > 8.0) then
                    m.actionState = 2
                else
                    --! (Speed Crash) If Mario's speed is more than 2^17.
                    val14 = s32(val04 / 4.0 * 0x10000)
                    if (val14 < 0x1000) then
                        val14 = 0x1000
                    end
                    if m.heldObj ~= nil then
                        set_character_anim_with_accel(m, CHAR_ANIM_RUN_WITH_LIGHT_OBJ, val14)
                    else
                        set_character_anim_with_accel(m, CHAR_ANIM_TIPTOE, val14)
                    end

                    val0C = false
                end
            elseif (m.actionState == 2) then
                if (val04 < 5.0) then
                    m.actionState = 1
                elseif (val04 > 22.0) then
                    m.actionState = 3
                else
                    --! (Speed Crash) If Mario's speed is more than 2^17.
                    val14 = s32(val04 / 4.0 * 0x10000)
                    if m.heldObj ~= nil then
                        set_character_anim_with_accel(m, CHAR_ANIM_RUN_WITH_LIGHT_OBJ, val14)
                    else
                        set_character_anim_with_accel(m, CHAR_ANIM_WALKING, val14)
                    end

                    val0C = false
                end
            elseif (m.actionState == 3) then
                if (val04 < 18.0) then
                    m.actionState = 2
                else
                    --! (Speed Crash) If Mario's speed is more than 2^17.
                    val14 = s32(val04 / 4.0 * 0x10000)
                    if m.heldObj ~= nil then
                        set_character_anim_with_accel(m, CHAR_ANIM_RUN_WITH_LIGHT_OBJ, val14)
                    else
                        set_character_anim_with_accel(m, CHAR_ANIM_RUNNING, val14)
                    end

                    val0C = false
                end
            else
                val0C = false
            end
        end
    end

    m.marioObj.oMarioWalkingPitch = s16(approach_s32(m.marioObj.oMarioWalkingPitch, targetPitch, 0x800, 0x800))
    m.marioObj.header.gfx.angle.x = m.marioObj.oMarioWalkingPitch
end

function common_air_action_step2(m, landAction, animation, stepArg)
    if m.heldObj ~= nil then
        landAction = ACT_SMW_HOLD_IDLE
    else
        if m.action == ACT_SPIN_JUMP then
            landAction = ACT_SPIN_JUMP_LAND
        else
            landAction = ACT_SMW_WALKING
        end
    end
    update_air_without_turn(m);

    stepResult = perform_air_step(m, stepArg);
    if (m.action == ACT_BUBBLED and stepResult == AIR_STEP_HIT_LAVA_WALL) then
        stepResult = AIR_STEP_HIT_WALL;
    end

    if stepResult ==
        AIR_STEP_NONE then
        set_character_animation(m, animation);
    end

    if stepResult == AIR_STEP_LANDED then
        if check_fall_damage_or_get_stuck(m, ACT_HARD_BACKWARD_GROUND_KB) == 0 then
            set_mario_action(m, landAction, 0)
        end
    end
    if (stepResult == AIR_STEP_HIT_WALL) then
        mario_set_forward_vel(m, 0.0);
        set_character_animation(m, animation);
    end

    if stepResult == AIR_STEP_GRABBED_LEDGE then
        set_character_animation(m, CHAR_ANIM_IDLE_ON_LEDGE);
        drop_and_set_mario_action(m, ACT_LEDGE_GRAB, 0);
    end

    if stepResult == AIR_STEP_GRABBED_CEILING then
        set_mario_action(m, ACT_START_HANGING, 0);
    end

    if stepResult == AIR_STEP_HIT_LAVA_WALL then
        lava_boost_on_wall(m);
    end


    return stepResult;
end

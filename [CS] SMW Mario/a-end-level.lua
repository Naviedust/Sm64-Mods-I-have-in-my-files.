--ending level moment


local END = audio_sample_load("smw_course_clear.ogg")
local END_SHORT = audio_sample_load("smw_end.ogg")
local WARP = audio_sample_load("smw_goal_iris-out.ogg")
local END_CASTLE = audio_sample_load("smw_castle_clear.ogg")


ACT_SMW_LV_END = allocate_mario_action(ACT_GROUP_STATIONARY | ACT_FLAG_IDLE | ACT_FLAG_STATIONARY | ACT_FLAG_INTANGIBLE |
    ACT_FLAG_INVULNERABLE | ACT_FLAG_CUSTOM_ACTION | ACT_FLAG_PAUSE_EXIT)


local function act_smw_level_end(m)

    mario_drop_held_object(m)

    if m.actionArg <= 0 then
        m.actionTimer = m.actionTimer + 1
    end



    if m.actionTimer == 1 then
        if gNetworkPlayers[0].currLevelNum == LEVEL_BOWSER_1 or gNetworkPlayers[0].currLevelNum == LEVEL_BOWSER_2 or gNetworkPlayers[0].currLevelNum == LEVEL_BOWSER_3 then
            audio_sample_play(END_CASTLE, m.pos, 1)
        else
            audio_sample_play(END, m.pos, 1)
        end
        anim = CHAR_ANIM_FIRST_PERSON
    end

    m.faceAngle.y = m.area.camera.yaw
    m.marioObj.header.gfx.angle.y = m.faceAngle.y

    if m.actionTimer == 220 then
        anim = CHAR_ANIM_STAR_DANCE
    end

    if m.actionTimer == 270 then
        if gNetworkPlayers[0].currLevelNum == LEVEL_BOWSER_3 then
            level_trigger_warp(m, WARP_OP_CREDITS_START)
        else
            level_trigger_warp(m, WARP_OP_STAR_EXIT)
        end
        m.actionTimer = m.actionTimer + 1
        m.actionArg = m.actionArg + 1
        audio_sample_play(WARP, m.pos, 1)
    end
    set_character_animation(m, anim)
    stop_background_music(get_current_background_music())
    stop_and_set_height_to_floor(m);
end

hook_mario_action(ACT_SMW_LV_END, { every_frame = act_smw_level_end })


ACT_SMW_LV_END_SHORT = allocate_mario_action(ACT_GROUP_STATIONARY | ACT_FLAG_IDLE | ACT_FLAG_STATIONARY |
    ACT_FLAG_INTANGIBLE |
    ACT_FLAG_INVULNERABLE | ACT_FLAG_CUSTOM_ACTION | ACT_FLAG_PAUSE_EXIT)



local function act_smw_level_end_short(m)
    local e = gSMWExtraStates[m.playerIndex]


    mario_drop_held_object(m)
        m.actionTimer = m.actionTimer + 1

    if m.actionTimer == 1 then
        audio_sample_play(END_SHORT, m.pos, 1)
    end

    m.faceAngle.y = m.area.camera.yaw
    m.marioObj.header.gfx.angle.y = m.faceAngle.y

    if m.actionTimer >= 85 then
        anim2 = CHAR_ANIM_STAR_DANCE
    else
        anim2 = CHAR_ANIM_FIRST_PERSON
    end

    if m.actionTimer == 105 then

        if (gBehaviorValues.ShowStarDialog) then
            if m.playerIndex == 0 then
                local dialogId = (gLastCompletedStarNum == 7)
                    and gBehaviorValues.dialogs.HundredCoinsDialog
                    or gBehaviorValues.dialogs.CollectedStarDialog
                create_dialog_box_with_response(dialogId)
            end
        end
        set_mario_action(m, ACT_IDLE, 0)
        disable_time_stop()
    end
    set_character_animation(m, anim2)
    stop_and_set_height_to_floor(m);
end

hook_mario_action(ACT_SMW_LV_END_SHORT, { every_frame = act_smw_level_end_short })

--[[
local function win()
    gMarioStates[0].action = ACT_SMW_LV_END_SHORT
    return true
end
hook_chat_command("smw_win", "- plays smw's win action", win)
--]]
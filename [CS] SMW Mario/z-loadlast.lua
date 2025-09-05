local smwActions = {
    [ACT_WALKING] = ACT_SMW_WALKING,
    [ACT_HOLD_WALKING] = ACT_SMW_WALKING,

    [ACT_HOLD_IDLE] = ACT_SMW_HOLD_IDLE,
    [ACT_HOLD_JUMP] = ACT_SMW_JUMP,
    --jump
    [ACT_JUMP] = ACT_SMW_JUMP,
    [ACT_BACKFLIP] = ACT_SMW_JUMP,
    [ACT_BACKWARD_ROLLOUT] = ACT_SMW_JUMP,
    [ACT_FORWARD_ROLLOUT] = ACT_SMW_JUMP,
    [ACT_STEEP_JUMP] = ACT_SMW_JUMP,
    [ACT_LONG_JUMP] = ACT_SMW_JUMP,
    --slide
    [ACT_STOMACH_SLIDE] = ACT_SMW_SLIDE,
    [ACT_BEGIN_SLIDING] = ACT_SMW_SLIDE,
    [ACT_DIVE_SLIDE] = ACT_SMW_SLIDE,
    --idle
    [ACT_IDLE] = ACT_SMW_IDLE,
    [ACT_DOUBLE_JUMP_LAND] = ACT_SMW_IDLE,
    [ACT_COUGHING] = ACT_SMW_IDLE,
    [ACT_JUMP_LAND_STOP] = ACT_SMW_IDLE,
    [ACT_START_SLEEPING] = ACT_SMW_IDLE,
    [ACT_SPAWN_SPIN_LANDING] = ACT_SMW_IDLE,
    [ACT_SPAWN_NO_SPIN_LANDING] = ACT_SMW_IDLE,
    [ACT_HOLD_FREEFALL_LAND] = ACT_SMW_IDLE,
    [ACT_SHIVERING] = ACT_SMW_IDLE,
    [ACT_JUMP_LAND] = ACT_SMW_IDLE,
    [ACT_FREEFALL_LAND] = ACT_SMW_IDLE,
    [ACT_PUNCHING] = ACT_SMW_IDLE,
    [ACT_STOP_CROUCHING] = ACT_SMW_IDLE,
    [ACT_STOMACH_SLIDE_STOP] = ACT_SMW_IDLE,
    [ACT_BUTT_SLIDE_STOP] = ACT_SMW_IDLE,
    [ACT_LAVA_BOOST_LAND] = ACT_SMW_IDLE,
    --[ACT_STAR_DANCE_NO_EXIT] = ACT_SMW_IDLE,
    [ACT_TRIPLE_JUMP_LAND] = ACT_SMW_IDLE,
    [ACT_TRIPLE_JUMP_LAND_STOP] = ACT_SMW_IDLE,
    --crouch
    [ACT_CROUCHING] = ACT_SMW_CROUCH,
    [ACT_START_CROUCHING] = ACT_SMW_CROUCH,
    [ACT_START_CRAWLING] = ACT_SMW_CROUCH,
    [ACT_CROUCH_SLIDE] = ACT_SMW_CROUCH_SLIDE,
    --fall
    [ACT_WALL_KICK_AIR] = ACT_SMW_FALL,
    [ACT_HARD_FORWARD_AIR_KB] = ACT_SMW_FALL,
    [ACT_HARD_BACKWARD_AIR_KB] = ACT_SMW_FALL,
    [ACT_DIVE] = ACT_SMW_FALL,
    [ACT_GROUND_POUND] = ACT_SMW_FALL,
    [ACT_GROUND_BONK] = ACT_SMW_FALL,
    [ACT_SPAWN_SPIN_AIRBORNE] = ACT_SMW_FALL,
    [ACT_FREEFALL] = ACT_SMW_FALL,
    [ACT_BACKWARD_AIR_KB] = ACT_SMW_FALL,
    [ACT_FORWARD_AIR_KB] = ACT_SMW_FALL,
    [ACT_BACKWARD_GROUND_KB] = ACT_SMW_FALL,
    [ACT_FORWARD_GROUND_KB] = ACT_SMW_FALL,
    [ACT_SOFT_BACKWARD_GROUND_KB] = ACT_SMW_FALL,
    [ACT_SOFT_FORWARD_GROUND_KB] = ACT_SMW_FALL,
    [ACT_SOFT_BONK] = ACT_SMW_FALL,

    [ACT_MOVE_PUNCHING] = ACT_DECELERATING,

    --spinjump
    [ACT_DOUBLE_JUMP] = ACT_SPIN_JUMP,
    [ACT_TRIPLE_JUMP] = ACT_SPIN_JUMP,

    [ACT_PICKING_UP] = ACT_SMW_HOLD_IDLE,

    [ACT_STAR_DANCE_EXIT] = ACT_SMW_LV_END,
    [ACT_JUMBO_STAR_CUTSCENE] = ACT_SMW_LV_END,
    [ACT_STAR_DANCE_NO_EXIT] = ACT_SMW_LV_END_SHORT,

    [ACT_STANDING_DEATH] = ACT_SMW_DEAD,
    [ACT_DROWNING] = ACT_SMW_DEAD,
    [ACT_DEATH_ON_STOMACH] = ACT_SMW_DEAD,
    [ACT_ELECTROCUTION] = ACT_SMW_DEAD,
    [ACT_SUFFOCATION] = ACT_SMW_DEAD,

    [ACT_HOLDING_POLE] = ACT_SMW_POLE,
    [ACT_CLIMBING_POLE] = ACT_SMW_POLE,
}
local function smw_acts(m, action)
    if _G.charSelect.character_get_current_number(m.playerIndex) == CT_SMW then
        if smwActions[action] then
            return smwActions[action]
        end
    end
end

hook_event(HOOK_BEFORE_SET_MARIO_ACTION, smw_acts)




-- failstate if mario gets set in one action
local SMWCanActions = {
    [ACT_DISAPPEARED] = true,
    [ACT_IDLE] = true,
    [ACT_CREDITS_CUTSCENE] = true,
    [ACT_SQUISHED] = true,
    [ACT_IN_CANNON] = true,
    [ACT_TELEPORT_FADE_OUT] = true,
    [ACT_TELEPORT_FADE_IN] = true,
    [ACT_PULLING_DOOR] = true,
    [ACT_PUSHING_DOOR] = true,
    [ACT_DECELERATING] = true,
    [ACT_DROWNING] = true,
    [ACT_AIR_THROW] = true,
    [ACT_SHOT_FROM_CANNON] = true,
    [ACT_BUTT_SLIDE] = true,
    [ACT_STOMACH_SLIDE] = true,
    [ACT_BUTT_SLIDE_AIR] = true,
    [ACT_FALL_AFTER_STAR_GRAB] = true,
    [ACT_STAR_DANCE_WATER] = true,
    [ACT_FIRST_PERSON] = true,
    [ACT_RIDING_SHELL_GROUND] = true,
    [ACT_RIDING_SHELL_FALL] = true,
    [ACT_RIDING_SHELL_JUMP] = true,
    [ACT_BEGIN_SLIDING] = true,
    [ACT_GRABBED] = true,
    [ACT_THROWN_FORWARD] = true,
    [ACT_THROWN_BACKWARD] = true,
    [ACT_WATER_SHELL_SWIMMING] = true,
    [ACT_RIDING_SHELL_FALL] = true,
    [ACT_RIDING_SHELL_JUMP] = true,
    [ACT_RIDING_SHELL_GROUND] = true,
    [ACT_BUBBLED] = true,
    [ACT_HOLD_DECELERATING] = true,
    [ACT_CREDITS_CUTSCENE] = true,
    [ACT_END_PEACH_CUTSCENE] = true,
    [ACT_GRAB_POLE_FAST] = true,
    [ACT_GRAB_POLE_SLOW] = true,
    [ACT_TWIRLING] = true,
}
local function onlysmw(m, action)
    if _G.charSelect.character_get_current_number(m.playerIndex) == CT_SMW then
        if m.playerIndex ~= 0 then
        else
            if (SMWCanActions[m.action] ~= true) and ((m.action & ACT_FLAG_CUSTOM_ACTION) == 0) and ((m.action & ACT_FLAG_METAL_WATER) == 0) and ((m.action & ACT_GROUP_CUTSCENE) == 0) and not _G.charSelect.is_menu_open() then
                if ((m.action & ACT_FLAG_AIR) ~= 0) then
                    set_mario_action(m, ACT_SMW_FALL, 0)
                elseif ((m.action & ACT_FLAG_SWIMMING) ~= 0) then
                    set_mario_action(m, ACT_SMW_WATER, 0)
                elseif ((m.action & ACT_FLAG_IDLE) ~= 0) then
                    set_mario_action(m, ACT_SMW_WALKING, 0)
                end
            end
        end
    end
end
hook_event(HOOK_MARIO_UPDATE, onlysmw)

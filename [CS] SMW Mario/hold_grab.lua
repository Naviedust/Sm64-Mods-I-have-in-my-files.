--thanks to Altiami and other people on coop dx discord server for this!
---@type Vec3f
storedMarioPos = { x = 0.0, y = 0.0, z = 0.0 }

---@param interactingMarioState MarioState
---@param interactedObject Object
---@param interactionType InteractionType
---@return boolean
local function on_allow_interact(interactingMarioState, interactedObject, interactionType)
    if interactionType ~= INTERACT_GRABBABLE or interactingMarioState == nil or interactedObject == nil then
        return
    end

    ---@type number
    local minDistance = interactedObject.hitboxRadius + interactingMarioState.marioObj.hitboxRadius + 5.0
    ---@type number
    local offsetX = interactingMarioState.pos.x - interactedObject.oPosX
    ---@type number
    local offsetZ = interactingMarioState.pos.z - interactedObject.oPosZ
    ---@type number
    local distance = math.sqrt(offsetX * offsetX + offsetZ * offsetZ)

    if distance < minDistance then
        vec3f_copy(storedMarioPos, interactingMarioState.pos)
    end

    return
end

---@param interactingMarioState MarioState
---@param interactedObject Object
---@param interactionType InteractionType
---@param interactionInterrupted boolean
local function on_interact(interactingMarioState, interactedObject, interactionType, interactionInterrupted)
    local e = gSMWExtraStates[interactingMarioState.playerIndex]
    -- interaction cases not cared about

    if
        interactionType ~= INTERACT_GRABBABLE or
        interactingMarioState == nil or
        interactedObject == nil or
        interactingMarioState.playerIndex ~= 0 or
        interactedObject.oInteractionSubtype & INT_SUBTYPE_KICKABLE ~= 0 and
        interactedObject.oInteractStatus & INT_STATUS_WAS_ATTACKED ~= 0 or
        interactionInterrupted
    then
        return
    end
    if e.b2grab == true then
        if interactingMarioState.controller.buttonDown & B_BUTTON ~= 0 and
            interactedObject.oInteractionSubtype & INT_SUBTYPE_NOT_GRABBABLE == 0
        then
            vec3f_copy(interactingMarioState.pos, storedMarioPos)
            interactingMarioState.interactObj = interactedObject
            interactingMarioState.input = interactingMarioState.input | INPUT_INTERACT_OBJ_GRABBABLE
            if interactedObject.oSyncID ~= 0 then
                network_send_object(interactedObject, false)
            end
        end
    end
    if e.b2grab == false then
        if interactingMarioState.controller.buttonDown & X_BUTTON ~= 0 and
            interactedObject.oInteractionSubtype & INT_SUBTYPE_NOT_GRABBABLE == 0
        then
            vec3f_copy(interactingMarioState.pos, storedMarioPos)
            interactingMarioState.interactObj = interactedObject
            interactingMarioState.input = interactingMarioState.input | INPUT_INTERACT_OBJ_GRABBABLE
            if interactedObject.oSyncID ~= 0 then
                network_send_object(interactedObject, false)
            end
        end
    end
end





---comment
---@param updatingMarioState MarioState
local function on_mario_update(updatingMarioState)
    local e = gSMWExtraStates[updatingMarioState.playerIndex]
    if _G.charSelect.character_get_current_number(updatingMarioState.playerIndex) == CT_SMW then
        if e.b2grab == true then
            if updatingMarioState.controller.buttonDown & B_BUTTON ~= 0 and mario_check_object_grab(updatingMarioState) ~= 0 then
                mario_grab_used_object(updatingMarioState)
                if updatingMarioState.heldObj ~= nil then
                    if (updatingMarioState.prevAction & ACT_FLAG_SWIMMING) ~= 0 then
                        set_mario_action(updatingMarioState, ACT_SMW_WATER, 0)
                    else
                        set_mario_action(updatingMarioState, ACT_SMW_PICK_STILL, 0)
                    end
                    updatingMarioState.actionState = 1
                end
            end
        end
        if e.b2grab == false then
            if updatingMarioState.controller.buttonDown & X_BUTTON ~= 0 and mario_check_object_grab(updatingMarioState) ~= 0 then
                mario_grab_used_object(updatingMarioState)
                if updatingMarioState.heldObj ~= nil then
                    if (updatingMarioState.prevAction & ACT_FLAG_SWIMMING) ~= 0 then
                        set_mario_action(updatingMarioState, ACT_SMW_WATER, 0)
                    else
                        set_mario_action(updatingMarioState, ACT_SMW_PICK_STILL, 0)
                    end
                    updatingMarioState.actionState = 1
                end
            end
        end
    end
end


hook_event(HOOK_ALLOW_INTERACT, on_allow_interact)
hook_event(HOOK_ON_INTERACT, on_interact)
hook_event(HOOK_MARIO_UPDATE, on_mario_update)

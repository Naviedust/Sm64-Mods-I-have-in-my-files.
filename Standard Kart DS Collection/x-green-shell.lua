local cur_obj_update_floor, interact_damage,object_step_without_floor_orient = cur_obj_update_floor, interact_damage, object_step_without_floor_orient


--- @param m MarioState
local function active_player(m)
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


-- Some things from Arena
local function attacked(obj, m, pos, radius)
    local np = network_player_from_global_index(obj.oKartOwner)
    local cm = m
    if m.playerIndex == 0 and np.localIndex ~= 0 then
        cm = lag_compensation_get_local_state(np)
    end

    local mPos1 = { x = cm.pos.x, y = cm.pos.y + 50,  z = cm.pos.z }
    local mPos2 = { x = cm.pos.x, y = cm.pos.y + 150, z = cm.pos.z }
    local ret = (vec3f_dist(pos, mPos1) < radius or vec3f_dist(pos, mPos2) < radius)
    return ret
end

function bhv_green_init(obj)
    --obj.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    obj.oGravity = 2
    obj.oDragStrength = 1
    obj.oAction = 0
    obj.oBuoyancy = 1
    obj.oFriction = 1
    obj.oBounciness = 10
    obj.oVelX = obj.oForwardVel*sins(obj.oFaceAngleYaw)
    obj.oVelZ = obj.oForwardVel*coss(obj.oFaceAngleYaw)
    network_init_object(obj, true, {'oAction'})
end

function bhv_green_loop(obj, directHitLocal)
    local np = network_player_from_global_index(obj.oKartOwner)
    if np == nil then
        obj_mark_for_deletion(obj)
        return
    end


    local m = gMarioStates[np.localIndex]
    if active_player(m) == 0 then
        obj_mark_for_deletion(obj)
        return
    end


    local sMario = gPlayerSyncTable[m.playerIndex]
 if obj.oTimer == 0 then
    obj_copy_pos(obj,m.marioObj)
 end

    local stepResult = object_step_without_floor_orient()
    obj.oAnimState = obj.oAnimState + 1
    if stepResult & OBJ_MOVE_LANDED ~= 0 then
        cur_obj_update_floor()
        if obj.oFloorType == SURFACE_DEATH_PLANE or obj.oFloorType == SURFACE_VERTICAL_WIND then
            obj_mark_for_deletion(obj)
        else
            obj.oVelY = math.random(10,25)
        end
    end


    if _G.ShineThief then
        STplayerspectating = _G.ShineThief.get_spectator(m.playerIndex)
    end

----- KART ATTACK -----
if obj.oTimer >= 10 and gServerSettings.playerInteractions == PLAYER_INTERACTIONS_PVP and sMario.montandocarrito == false and not STplayerspectating then
        obj.oIntangibleTimer = 0
        local index = network_local_index_from_global(obj.oKartOwner) or 1
        local m1 = gMarioStates[index]
        local m = gMarioStates[0]
        local np = gNetworkPlayers[index]
        local sMario = gPlayerSyncTable[0]
        local a = { x = obj.oPosX, y = obj.oPosY, z = obj.oPosZ }
        if _G.ShineThief then
            validAttackshinet = (((network_player_from_global_index(obj.oKartOwner) or global_index_hurts_mario_state(obj.oKartOwner, m) and _G.ShineThief.get_team(np.playerIndex) == 0 or np.globalIndex ~= obj.oKartOwner and _G.ShineThief.get_team(np.globalIndex) == 0)) or (_G.ShineThief.get_team(m1.playerIndex) ~= _G.ShineThief.get_team(m.playerIndex) and _G.ShineThief.get_team(m1.playerIndex) ~= 0)) and not _G.ShineThief.get_spectator(m.playerIndex) and not _G.ShineThief.star_active(m.playerIndex)
        else
            validAttack = network_player_from_global_index(obj.oKartOwner) or global_index_hurts_mario_state(obj.oKartOwner, m) or np.globalIndex ~= obj.oKartOwner
        end
        local radius =  150

        if np.globalIndex == obj.oKartOwner then radius = 150 end
        if (validAttack or validAttackshinet) and attacked(obj, m, a, radius) and mario_health_float(m) > 0 and active_player(m) and not is_invuln_or_intang(m) then
            obj.oDamageOrCoinValue = 1
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
                m.vel.y = 20
                m.forwardVel =  -30
            set_mario_action(m, ACT_KART_HITTED_WATER, 0)
            -- Not in Water -- --------------------------------------------------------------
            elseif sMario.inkart == false and m.action & ACT_FLAG_SWIMMING_OR_FLYING == 0 then
                m.vel.y = 20
                m.forwardVel =  -30
            set_mario_action(m, ACT_BACKWARD_AIR_KB, 0)
            elseif sMario.inkart == true and m.action & ACT_FLAG_SWIMMING_OR_FLYING == 0 then
                m.vel.y = 20
                m.forwardVel =  -30
            set_mario_action(m, ACT_KART_HITTED, 0)
            end
            ----------------------------------------------------------------------------------
            m.knockbackTimer = 20
            m.vel.y = 10
            m.faceAngle.y = atan2s(vel.z, vel.x) + 0x8000
        end    
  end

  if obj.oAction == 1 then
    obj_mark_for_deletion(obj)
  end

if obj.oTimer > 200 then
    obj_mark_for_deletion(obj)
end

if (obj.oInteractStatus & INT_STATUS_INTERACTED) ~= 0 then
    obj.oAction = 1
    obj_mark_for_deletion(obj)
end

    vec3f_set(obj.header.gfx.pos, obj.oPosX, obj.oPosY, obj.oPosZ)
    obj.header.gfx.angle.y = obj.oFaceAngleYaw + get_network_area_timer()*0x1000
end

id_bhvGreenShellK = hook_behavior(nil, OBJ_LIST_DESTRUCTIVE, true, bhv_green_init, bhv_green_loop)

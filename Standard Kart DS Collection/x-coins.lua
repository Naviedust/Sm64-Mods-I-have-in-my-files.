-- Coin Behavior -- 
E_MODEL_COINS = smlua_model_util_get_id("coin_geo")

define_custom_obj_fields({
    oCollectedTimer = 'u32',
    oCollected = 'u32',
})

function bhv_coin_init(o)
    local hitbox = get_temp_object_hitbox()
    hitbox.interactType = INTERACT_WATER_RING
    hitbox.radius = 100
    hitbox.height = 100
    obj_set_hitbox(o, hitbox)

    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oGravity = 2
    o.oBounciness = 130
    o.oBuoyancy = 1
    o.oAction = 0
    o.oFriction = 0.8
    o.oFaceAnglePitch = 0
    o.oFaceAngleRoll = 0
    o.oAnimState = -1
    o.oInteractStatus = 0
    o.oCollected = 0
    o.oCollectedTimer = 0
    network_init_object(o, true, {})
end

function bhv_coin_loop(o)
    local m = nearest_mario_state_to_object(o)
    local sMario = gPlayerSyncTable[m.playerIndex]
    local a   = { x = o.oPosX, y = o.oPosY, z = o.oPosZ }
    local dir = { x = o.oVelX, y = o.oVelY, z = o.oVelZ }
    local info = collision_find_surface_on_ray(
        a.x, a.y, a.z,
        dir.x, dir.y, dir.z)
    local floorHeight = find_floor_height(o.oPosX, o.oPosY + 100, o.oPosZ)
    o.oCollected = 0
    if o.oFloorType == SURFACE_DEATH_PLANE and (o.oPosY - o.oFloorHeight < 2048) then -- return if fallen
        obj_mark_for_deletion(o)
        spawn_mist_particles_with_sound(SOUND_OBJ_ENEMY_DEATH_HIGH)
    elseif o.oFloorType == HAZARD_TYPE_LAVA_FLOOR and info.surface ~= nil then -- return if in quicksand or lava
        obj_mark_for_deletion(o)
        spawn_mist_particles_with_sound(SOUND_OBJ_ENEMY_DEATH_HIGH)
    end
    
-- Action 0
if o.oAction == 0 then
    cur_obj_become_intangible()
    cur_obj_update_floor()
    o.oCollected = 0
    o.oFaceAngleYaw = o.oFaceAngleYaw + 0x900

    if o.oAction == 0 and ( o.oTimer == 2 ) then
        o.oMoveAngleYaw = math.random(0, 0xFFFF) 
        o.oVelY = 30
        cur_obj_change_action(1)
    end

    
-- Action 1
elseif o.oAction == 1  then -- bouncing on ground
    if o.oTimer == 0 and o.oTimer < 2 then
        cur_obj_enable_rendering_and_become_tangible(o)
        cur_obj_become_intangible()
    elseif o.oTimer == 2 and o.oTimer < 4 then
        cur_obj_disable_rendering_and_become_intangible(o)
    elseif o.oTimer == 4 and o.oTimer < 6 then
        cur_obj_enable_rendering_and_become_tangible(o)
        cur_obj_become_intangible()
    elseif o.oTimer == 6 and o.oTimer < 8 then
        cur_obj_disable_rendering_and_become_intangible(o)
    elseif o.oTimer == 8 and o.oTimer < 10 then
        cur_obj_enable_rendering_and_become_tangible(o)
        cur_obj_become_intangible()
    elseif o.oTimer == 10 and o.oTimer < 12 then
        cur_obj_disable_rendering_and_become_intangible(o)
    elseif o.oTimer == 12 and o.oTimer < 14 then
        cur_obj_enable_rendering_and_become_tangible(o)
        cur_obj_become_intangible()
    elseif o.oTimer == 14 and o.oTimer < 16 then
        cur_obj_disable_rendering_and_become_intangible(o)
    elseif o.oTimer == 16 and o.oTimer < 18 then
        cur_obj_enable_rendering_and_become_tangible(o)
        cur_obj_become_intangible()
    elseif o.oTimer == 18 and o.oTimer < 20 then
        cur_obj_disable_rendering_and_become_intangible(o)
    elseif o.oTimer == 20 and o.oTimer < 22 then
        cur_obj_enable_rendering_and_become_tangible(o)
        cur_obj_become_intangible()
    elseif o.oTimer == 22 and o.oTimer < 24 then
        cur_obj_disable_rendering_and_become_intangible(o)
    elseif o.oTimer == 24 and o.oTimer < 26 then
        cur_obj_enable_rendering_and_become_tangible(o)
        cur_obj_become_intangible()
    elseif o.oTimer == 26 and o.oTimer < 28 then
        cur_obj_disable_rendering_and_become_intangible(o)
    elseif o.oTimer == 28 and o.oTimer < 30 then
        cur_obj_enable_rendering_and_become_tangible(o)
        cur_obj_become_intangible()
    elseif o.oTimer == 30 and o.oTimer < 32 then
        cur_obj_disable_rendering_and_become_intangible(o)
    elseif o.oTimer == 32 and o.oTimer < 34 then
        cur_obj_enable_rendering_and_become_tangible(o)
        cur_obj_become_intangible()
    elseif o.oTimer == 34 and o.oTimer < 36 then
        cur_obj_disable_rendering_and_become_intangible(o)
    elseif o.oTimer == 36 and o.oTimer < 38 then
        cur_obj_enable_rendering_and_become_tangible(o)
        cur_obj_become_intangible()
    elseif o.oTimer == 38 and o.oTimer < 40 then
        cur_obj_disable_rendering_and_become_intangible(o)
    elseif o.oTimer == 40 and o.oTimer < 42 then
        cur_obj_enable_rendering_and_become_tangible(o)
        cur_obj_become_intangible()
    elseif o.oTimer == 42 and o.oTimer < 44 then
        cur_obj_disable_rendering_and_become_intangible(o)
    elseif o.oTimer == 40 and o.oTimer < 42 then
        cur_obj_enable_rendering_and_become_tangible(o)
        cur_obj_become_intangible()
    elseif o.oTimer == 42 and o.oTimer < 44 then
        cur_obj_disable_rendering_and_become_intangible(o)
    elseif o.oTimer == 44 and o.oTimer < 46 then
        cur_obj_enable_rendering_and_become_tangible(o)
        cur_obj_become_intangible()
    elseif o.oTimer == 46 and o.oTimer < 48 then
        cur_obj_disable_rendering_and_become_intangible(o)
    elseif o.oTimer == 48 and o.oTimer < 50 then
        cur_obj_enable_rendering_and_become_tangible(o)
        cur_obj_become_intangible()
    elseif o.oTimer == 50 and o.oTimer < 52 then
        cur_obj_disable_rendering_and_become_intangible(o)
    elseif o.oTimer == 52 and o.oTimer < 54 then
        cur_obj_enable_rendering_and_become_tangible(o)
        cur_obj_become_intangible()
    elseif o.oTimer == 54 and o.oTimer < 56 then
        cur_obj_disable_rendering_and_become_intangible(o)
    elseif o.oTimer == 56 and o.oTimer < 58 then
        cur_obj_enable_rendering_and_become_tangible(o)
    end
    local prevY = o.oPosY
    local stepResult = object_step_without_floor_orient()
    cur_obj_update_floor()


    o.oFaceAngleYaw = o.oFaceAngleYaw + 0x900

    if o.oTimer >= 60 then -- 2 seconds before being able to pick up
        cur_obj_become_tangible()
    end

-- Action 2
elseif o.oAction == 2 then
    o.oPosX = m.pos.x
    o.oPosY = m.pos.y + 170
    o.oPosZ = m.pos.z
    o.oCollectedTimer = o.oCollectedTimer  + 1
    o.oFaceAngleYaw = o.oFaceAngleYaw + 0x1100
    if o.oCollectedTimer == 5 and o.oCollected == 0 then

        o.oCollected = o.oCollected + 2
    elseif o.oCollectedTimer >= 10 then
        obj_mark_for_deletion(o)
    end

end

if (o.oInteractStatus & INT_STATUS_INTERACTED) ~= 0 and o.oAction ~= 2 then
    network_play(sCoinSound, m.pos, 1, m.playerIndex)
    sMario.coinspeed = sMario.coinspeed + 1
    cur_obj_change_action(2)
end

    
end
id_bhvCoinS = hook_behavior(nil, OBJ_LIST_GENACTOR, true, bhv_coin_init, bhv_coin_loop)



function hud_coin_amount()
    djui_hud_set_font(FONT_MENU)
    local scale = 1.00
    local tex = TEX_COIN
    local x = 1040
    local y = 140
    local background = 0.0
    djui_hud_render_texture( tex ,x - 70,y,scale,scale) 
    djui_hud_print_text(string.format("x %.0f", gPlayerSyncTable[0].coinspeed), x, y, scale)
end

function hud_shell_ammo()
    local m = gMarioStates[0]
    local s = gKartStates[m.playerIndex]
    djui_hud_set_font(FONT_MENU)
    local scale = 1.00
    local tex = TEX_SHELL
    local x2 = 1080
    local y2 = 210
    djui_hud_render_texture( tex ,x2 - 110,y2,scale,scale) 
    djui_hud_print_text(string.format( "x %.0f", s.shellammo), x2 - 35 , y2, scale)
end

function hud_coin_above_players(m)
    local tex = TEX_COIN
    djui_hud_set_resolution(RESOLUTION_N64); djui_hud_set_font(FONT_MENU);
    local out = { x = m.marioObj.header.gfx.pos.x , y = m.pos.y + 250, z = m.marioObj.header.gfx.pos.z }
    local scale = 0.20 - (vec3f_dist(m.pos, gMarioStates[m.playerIndex].pos))/16384
    djui_hud_world_pos_to_screen_pos(out, out)

    if scale > 0 then
    djui_hud_render_texture( tex ,out.x - 13,out.y,scale,scale) 
    djui_hud_print_text(string.format("x %.0f", gPlayerSyncTable[m.playerIndex].coinspeed), out.x, out.y, scale)
    end
end

function on_hud_render()
    if gGlobalSyncTable.shellshotmode == true then
        hud_shell_ammo()
    end
    if gGlobalSyncTable.coinamount ~= 0 then
    for i=0,15 do
        if gNetworkPlayers[i].currActNum == gNetworkPlayers[0].currActNum and gNetworkPlayers[i].currAreaIndex == gNetworkPlayers[0].currAreaIndex and gNetworkPlayers[i].currLevelNum == gNetworkPlayers[0].currLevelNum then
            hud_coin_above_players(gMarioStates[i])
        end
    end
    end

end

hook_event(HOOK_ON_HUD_RENDER, on_hud_render)
-- name: \\#FF80FF\\Hide & Seek DX v1.1
-- incompatible: gamemode
-- description: \\#FF80FF\\Hide and Seek DX\n\n\\#FFFFFF\\A full rewrite of the Hide and Seek mode that improves stability, design, and game flow.\n\nFEATURES:\n- Revamped HUD\n- Single-Level Mode\n- Full-Game Mode\n- ROM Hack Support\n- All Levels Unlocked\n  \\#FF8080\\(Save file will be overwritten!)\n\n\\#FFFFFF\\CREDITS:\n- Written by Dan\n- Super Keeberghrh and djoslin0 (Original Hide and Seek)\n- Sunk (Star Cutscene Fix, Complete Save)\n- Sunk and Blocky (Automatic Doors)\n- EmeraldLockdown (Cannon Toggle)\n- EmilyEmmi (HMC Elevator Fix, DDD Submarine)\n- birdekek (HUD Name Processing)\n- LittleFox64 (Support)
-- pausable: false

--GAME SETTINGS
intermissionTimer = 30 * 10
disperseTimer = 30 * 20
disperseTimerFree = 30 * 30
activeTimerFree = 30 * 180

--GLOBALS
gGlobalSyncTable.gameState = 0
gGlobalSyncTable.timer = intermissionTimer
gGlobalSyncTable.forceLevel = true
gGlobalSyncTable.level = 1
gGlobalSyncTable.allLevels = false
gGlobalSyncTable.playerList = false

seekerCount = 0
hiderCount = 0
players = {}

local function update()

    seekerCount = 0
    hiderCount = 0
    players = {}

    for i=0,(MAX_PLAYERS-1) do
        if gNetworkPlayers[i].connected then
            if gPlayerSyncTable[i].seeker then
                seekerCount = seekerCount + 1
                network_player_set_description(gNetworkPlayers[i], "Seeker", 255, 128, 128, 255)
            else
                hiderCount = hiderCount + 1
                network_player_set_description(gNetworkPlayers[i], "Hider", 128, 128, 255, 255)
            end
            table.insert(players, gPlayerSyncTable[i])
        end
    end

    -- Reset Exits Out of Active Game
    if gGlobalSyncTable.gameState ~= 3 then
        canExit = true
    end

    -- Infinite Lives
    gMarioStates[0].numLives = 100

    -- Force several camera configs
    camera_config_enable_collisions(true)
    rom_hack_cam_set_collisions(1)
    camera_romhack_set_zoomed_in_dist(900)
    camera_romhack_set_zoomed_out_dist(1400)
    camera_romhack_set_zoomed_in_height(300)
    camera_romhack_set_zoomed_out_height(450)

    -- Toggle Player List Depending on Gamemode
    if gGlobalSyncTable.forceLevel or gGlobalSyncTable.playerList then
        gServerSettings.enablePlayerList = 1
    else
        gServerSettings.enablePlayerList = 0
    end

    -- Countdown Sound
    if gGlobalSyncTable.timer <= 150 and math.fmod(gGlobalSyncTable.timer, 30) == 0 then
        play_sound_with_freq_scale(SOUND_GENERAL_COIN_DROP, gMarioStates[0].marioObj.header.gfx.cameraToObject, 0.25)
    end

    -- TTC Stop Time
    set_ttc_speed_setting(TTC_SPEED_STOPPED)

    -- Force Players in Level
    if gGlobalSyncTable.forceLevel and gNetworkPlayers[0].currLevelNum ~= levels[gGlobalSyncTable.level][1] then
        warp_to_level(levels[gGlobalSyncTable.level][1], levels[gGlobalSyncTable.level][2], levels[gGlobalSyncTable.level][3])
        gMarioStates[0].health = 0x800
    elseif not gGlobalSyncTable.forceLevel and gGlobalSyncTable.gameState == 1 and gGlobalSyncTable.timer < 30 then
        warp_to_start_level()
    end

    -- Skip Level Intro Text Box
    if
        (gMarioStates[0].action == ACT_SPAWN_NO_SPIN_AIRBORNE or
        gMarioStates[0].action == ACT_SPAWN_NO_SPIN_LANDING or 
        gMarioStates[0].action == ACT_SPAWN_SPIN_AIRBORNE or
        gMarioStates[0].action == ACT_SPAWN_SPIN_LANDING) and
        gMarioStates[0].pos.y < gMarioStates[0].floorHeight + 10
    then
        set_mario_action(gMarioStates[0], ACT_FREEFALL, 0)
    end

    if network_is_server() then
        core_update()
    end

end

function core_update()

    if #players < 2 then
        gGlobalSyncTable.gameState = 0
    elseif gGlobalSyncTable.gameState == 0 then
        gGlobalSyncTable.gameState = 1
        gGlobalSyncTable.timer = intermissionTimer
    elseif gGlobalSyncTable.timer > 0 then
        gGlobalSyncTable.timer = gGlobalSyncTable.timer - 1
    end

    --Intermission
    if gGlobalSyncTable.gameState == 1 then

        if gGlobalSyncTable.timer > intermissionTimer then
            gGlobalSyncTable.timer = intermissionTimer
        --Start Disperse Phase
        elseif gGlobalSyncTable.timer < 1 then

            --Reset Roles
            for i=0,(MAX_PLAYERS-1) do
                if gNetworkPlayers[i].connected then
                    gPlayerSyncTable[i].seeker = false
                end
            end

            --Determine Seekers
            local randomIndex = math.random(#players)
            players[randomIndex].seeker = true
            if #players > 4 then
                while players[randomIndex].seeker do
                    randomIndex = math.random(#players)
                end
                players[randomIndex].seeker = true
            end
            if #players > 10 then
                while players[randomIndex].seeker do
                    randomIndex = math.random(#players)
                end
                players[randomIndex].seeker = true
            end

            --Set Disperse Timer
            if gGlobalSyncTable.forceLevel then
                gGlobalSyncTable.timer = disperseTimer
            else
                gGlobalSyncTable.timer = disperseTimerFree
            end
            
            --Change Level
            if gGlobalSyncTable.forceLevel then
                if gGlobalSyncTable.level >= #levels then
                    gGlobalSyncTable.level = 1
                else
                    gGlobalSyncTable.level = gGlobalSyncTable.level + 1
                end
                while not gGlobalSyncTable.allLevels and not levels[gGlobalSyncTable.level][6] do
                    if gGlobalSyncTable.level >= #levels then
                        gGlobalSyncTable.level = 1
                    else
                        gGlobalSyncTable.level = gGlobalSyncTable.level + 1
                    end
                end
            end
            

            packet_receive({packet = "SPLASH", message = "Hide!"})
            network_send(true, {packet = "SPLASH", message = "Hide!"})

            gGlobalSyncTable.gameState = 2

        end
        
    --Disperse Phase
    elseif gGlobalSyncTable.gameState == 2 then

        --Forfeit if Seeker(s) Disconnect
        if seekerCount < 1 then
            gGlobalSyncTable.timer = intermissionTimer
            gGlobalSyncTable.gameState = 1
            packet_receive({packet = "SPLASH", message = "Forfeit..."})
            network_send(true, {packet = "SPLASH", message = "Forfeit..."})
        end

        --Make Disconnected Indexes into Seekers
        for i=0,(MAX_PLAYERS-1) do
            if not gNetworkPlayers[i].connected then
                gPlayerSyncTable[i].seeker = true
            end
        end

        --Start Round
        if gGlobalSyncTable.timer > disperseTimerFree then
            gGlobalSyncTable.timer = disperseTimerFree
        elseif gGlobalSyncTable.timer < 1 then
            if gGlobalSyncTable.forceLevel then
                gGlobalSyncTable.timer = levels[gGlobalSyncTable.level][5]*30
            else
                gGlobalSyncTable.timer = activeTimerFree
            end
            gGlobalSyncTable.gameState = 3
            packet_receive({packet = "SPLASH", message = "Begin!"})
            network_send(true, {packet = "SPLASH", message = "Begin!"})
        end

    --Active
    elseif gGlobalSyncTable.gameState == 3 then

        --Make Disconnected Indexes into Seekers
        for i=0,(MAX_PLAYERS-1) do
            if not gNetworkPlayers[i].connected then
                gPlayerSyncTable[i].seeker = true
            end
        end

        if gGlobalSyncTable.timer > 12000 then
            gGlobalSyncTable.timer = 12000
        elseif gGlobalSyncTable.timer < 1 or hiderCount < 1 or seekerCount < 1 then
            
            --End Round
            gGlobalSyncTable.timer = intermissionTimer
            gGlobalSyncTable.gameState = 1
            
            if hiderCount < 1 then
                packet_receive({packet = "SPLASH", message = "Seekers Win!"})
                network_send(true, {packet = "SPLASH", message = "Seekers Win!"})
            elseif seekerCount < 1 then
                packet_receive({packet = "SPLASH", message = "Forfeit..."})
                network_send(true, {packet = "SPLASH", message = "Forfeit..."})
            else
                packet_receive({packet = "SPLASH", message = "Hiders Win!"})
                network_send(true, {packet = "SPLASH", message = "Hiders Win!"})
            end

        end

    end

end

hook_event(HOOK_UPDATE, update)
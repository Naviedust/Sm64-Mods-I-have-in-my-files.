splashMessage = "Hide!"
splashR, splashG, splashB = true, false, true
splashTimer = 0

local initMessageTimer = 300
local row = 0
local seekerVision = 128
local locations = {}
local timerMessages = {
    "Next Round in ",
    "Releasing Seekers in ",
    "Time: "
}

local function on_hud_render()

    --HIDE NORMAL HUD
    hud_hide()

    --RENDER HEALTH METER
    djui_hud_set_color(255, 255, 255, 255)
    hud_render_power_meter(gMarioStates[0].health, djui_hud_get_screen_width() - 256, 0, 256, 256)
    
    -- Startup Message
    if initMessageTimer > 0 and network_is_server() then
        djui_hud_set_color(0, 0, 0, 192)
        djui_hud_render_rect(0, 0, djui_hud_get_screen_width(), djui_hud_get_screen_height())
        fancy_text("Hide and Seek DX", "middle", 0, djui_hud_get_screen_height()/2-120, 3, 255, 128, 255, 255, false, false, false, false)
        fancy_text("Use /mode, /levels, and /playerlist to customize your game.", "middle", 0, djui_hud_get_screen_height()/2-30, 2, 255, 255, 255, 255, false, false, false, false)
        fancy_text("This message will disappear in " .. math.floor(initMessageTimer / 30) + 1, "middle", 0, djui_hud_get_screen_height()/2 + 30, 1, 255, 255, 255, 255, false, false, false, false)
        initMessageTimer = initMessageTimer - 1
    end

    --STARTING SEEKER
    if gGlobalSyncTable.gameState == 2 and gPlayerSyncTable[0].seeker then
            
        djui_hud_set_color(0, 0, 0, seekerVision)
        djui_hud_render_rect(0, 0, djui_hud_get_screen_width(), djui_hud_get_screen_height())
        djui_hud_set_color(255, 255, 255, 255)
        fancy_text("You are a Starting Seeker.", "middle", 0, djui_hud_get_screen_height()/2 - 136, 3, 255, 255, 255, 255)
        fancy_text("Please wait to be released.", "middle", 0, djui_hud_get_screen_height()/2 - 8, 3, 255, 255, 255, 255)
        
        if seekerVision < 255 then
            seekerVision = seekerVision + 1
        end

    else
        seekerVision = 128
    end

    -- Player List
    row = 0
    djui_hud_set_color(0, 0, 0, 192)

    rectWidth = 120
    for i=0, MAX_PLAYERS-1 do
        if gNetworkPlayers[i].connected and djui_hud_measure_text(shorten_name(string_without_hex(gNetworkPlayers[i].name))) > rectWidth then
            rectWidth = djui_hud_measure_text(shorten_name(string_without_hex(gNetworkPlayers[i].name)))
        end
    end
    djui_hud_render_rect(0, 0, rectWidth+16, #players*30 + 150)

    fancy_text("Players: " .. #players, "left", 4, row, 1, 255, 255, 255, 255, false, false, false, false)
    row = row + 60

    fancy_text("Hiders: " .. hiderCount, "left", 4, row, 1, 255, 255, 255, 255, false, false, false, false)
    row = row + 30
    for i=0, MAX_PLAYERS-1 do
        if gNetworkPlayers[i].connected and not gPlayerSyncTable[i].seeker then
            local r, g, b = hex_to_rgb(network_get_player_text_color_string(i))
            fancy_text(shorten_name(string_without_hex(gNetworkPlayers[i].name)), "left", 4, row, 1, r, g, b, 255, false, false, false, false)
            row = row + 30
        end
    end
    row = row + 30

    fancy_text("Seekers: " .. seekerCount, "left", 4, row, 1, 255, 255, 255, 255)
    row = row + 30
    for i=0, MAX_PLAYERS-1 do
        if gNetworkPlayers[i].connected and gPlayerSyncTable[i].seeker then
            local r, g, b = hex_to_rgb(network_get_player_text_color_string(i))
            fancy_text(shorten_name(string_without_hex(gNetworkPlayers[i].name)), "left", 4, row, 1, r, g, b, 255, false, false, false, false)
            row = row + 30
        end
    end
    row = row + 30

    -- Full-Game Course List
    if not gGlobalSyncTable.forceLevel and gPlayerSyncTable[0].seeker then

        locations = {}
        rect2Width = 0
        
        for i=0, MAX_PLAYERS-1 do
            if gNetworkPlayers[i].connected and not gPlayerSyncTable[i].seeker then
                local iLevel = tostring(get_level_name(gNetworkPlayers[i].currCourseNum, gNetworkPlayers[i].currLevelNum, gNetworkPlayers[i].currAreaIndex))
                local dup = false
                for j=0, #locations do
                    if locations[j] == iLevel then
                        dup = true
                    end
                end
                if not dup then
                    table.insert(locations, iLevel)
                    if djui_hud_measure_text(iLevel) > rect2Width then
                        rect2Width = djui_hud_measure_text(iLevel)
                    end
                end
            end
        end

        table.sort(locations)
        local inLocation = ""

        for i=1, #locations do
            if locations[i] == tostring(get_level_name(gNetworkPlayers[0].currCourseNum, gNetworkPlayers[0].currLevelNum, gNetworkPlayers[0].currAreaIndex)) then
                inLocation = tostring(get_level_name(gNetworkPlayers[0].currCourseNum, gNetworkPlayers[0].currLevelNum, gNetworkPlayers[0].currAreaIndex))
            end
        end

        if inLocation == "" then
            djui_hud_set_color(64 + 64 * math.sin(gGlobalSyncTable.timer/2), 0, 0, 192)
        else
            djui_hud_set_color(0, 0, 0, 192)
        end
        
        djui_hud_render_rect(rectWidth+16, 0, rect2Width+8, #locations*30)

        for i=1, #locations do
            if locations[i] == inLocation then
                fancy_text(locations[i], "left", rectWidth+20, (i-1)*30, 1, 128, 255, 128, 255, false, false, true, false)
            else
                fancy_text(locations[i], "left", rectWidth+20, (i-1)*30, 1, 255, 255, 255, 255, false, true, false, false)
            end
        end

    end

    -- Mode and Timer
    if gGlobalSyncTable.timer < 900 and gGlobalSyncTable.gameState == 3 then
        fancy_text(timerMessages[gGlobalSyncTable.gameState] .. math.floor(gGlobalSyncTable.timer / 30) + 1, "middle", 0, 30, 2, 255, 255, 255, 255, true, true, false, false)
    elseif gGlobalSyncTable.gameState ~= 0 then
        fancy_text(timerMessages[gGlobalSyncTable.gameState] .. math.floor(gGlobalSyncTable.timer / 30) + 1, "middle", 0, 30, 2, 255, 255, 255, 255, true, false, false, false)
    else
        fancy_text("Waiting for More Players...", "middle", 0, 30, 2, 255, 255, 255, 255, true, false, false, false)
    end

    if gGlobalSyncTable.forceLevel then
        if gGlobalSyncTable.allLevels then
            djui_hud_set_color(0, 0, 0, 128)
            fancy_text("Single-Level Mode (All Levels)", "middle", 0, 0, 1, 255, 255, 0, 255, true, false, false, false)
        else
            djui_hud_set_color(0, 0, 0, 128)
            fancy_text("Single-Level Mode (Standard)", "middle", 0, 0, 1, 255, 255, 0, 255, true, false, false, false)
        end
    else
        djui_hud_set_color(0, 0, 0, 128)
        fancy_text("Full-Game Mode", "middle", 0, 0, 1, 0, 255, 255, 255, true, false, false, false)
    end

    -- Splash Text
    if splashTimer > 0 and not (gPlayerSyncTable[0].seeker and splashMessage == "Hide!") then
        fancy_text(splashMessage, "middle", 0, 188, 4, 255, 255, 255, 255, true, splashR, splashG, splashB)
        splashTimer = splashTimer - 1
    end

    -- Cannon Text
    if gMarioStates[0].action == ACT_IN_CANNON and gMarioStates[0].actionState == 2 then
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_print_text("Shooting in " .. math.floor((90-cannonTimer) / 30) + 1, center_text("Shooting in " .. math.floor((90-cannonTimer) / 30) + 1, 3), djui_hud_get_screen_height()-120, 3) 
    end

    -- WIP
    -- djui_hud_set_color(0, 0, 0, 192)
    -- fancy_text("Player List is now a host option! Update releases tomorrow!", "right", 0, djui_hud_get_screen_height()-30, 1, 255, 255, 255, 255, true, false, false, false)

    -- Exit
    if not gPlayerSyncTable[0].seeker and not canExit then
        fancy_text("You've used your exit for this round!", "right", 0, djui_hud_get_screen_height()-60, 1, 255, 255, 255, 255, true, true, false, false)
        fancy_text("You cannot exit again. If you die, you become a seeker!", "right", 0, djui_hud_get_screen_height()-30, 1, 255, 255, 255, 255, true, true, false, false)
    end

end

function fancy_text(message, margin, xpos, ypos, size, r, g, b, a, rect, rectR, rectG, rectB)
    
    if margin == "middle" then
        xpos = center_text(message, size)
    elseif margin == "right" then
        xpos = right_text(message, size)
    end

    if rect then
        djui_hud_set_color(sine_color(rectR), sine_color(rectG), sine_color(rectB), 192)
        djui_hud_render_rect(xpos-4*size, ypos, (djui_hud_measure_text(message)+8)*size, 30*size)
    end

    djui_hud_set_color(0, 0, 0, 255)
    djui_hud_print_text(message, xpos+size*2, ypos+size*2, size)
    djui_hud_set_color(r, g, b, a)
    djui_hud_print_text(message, xpos, ypos, size)
    
end

function center_text(message, size)
    return djui_hud_get_screen_width()/2 - (djui_hud_measure_text(message) * size)/2
end

function right_text(message, size)
    return djui_hud_get_screen_width() - (djui_hud_measure_text(message) * size)
end

function sine_color(colorBool)
    if colorBool then
        return 128 + 127 * math.sin(gGlobalSyncTable.timer/2)
    end
    return 0
end

function shorten_name(name)
    if string.len(name) > 12 then
        return string.sub(name, 0, 12) .. "..."
    end
    return name
end

function string_without_hex(name)
    local s = ''
    local inSlash = false
    for i = 1, #name do
        local c = name:sub(i,i)
        if c == '\\' then
            inSlash = not inSlash
        elseif not inSlash then
            s = s .. c
        end
    end
    return s
end

function hex_to_rgb(hex)
	-- remove the # and the \\ from the hex so that we can convert it properly
	hex = hex:gsub('#','')
	hex = hex:gsub('\\','')

    -- sanity check
	if string.len(hex) == 6 then
		return tonumber('0x'..hex:sub(1,2)), tonumber('0x'..hex:sub(3,4)), tonumber('0x'..hex:sub(5,6))
	else
		return 0, 0, 0
	end
end

hook_event(HOOK_ON_HUD_RENDER, on_hud_render)

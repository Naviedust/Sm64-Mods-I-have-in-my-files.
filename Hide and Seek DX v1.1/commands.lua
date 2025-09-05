local function command_switch_mode()

    if gGlobalSyncTable.gameState < 2 then

        gGlobalSyncTable.forceLevel = not gGlobalSyncTable.forceLevel
        gGlobalSyncTable.gameState = 1
        gGlobalSyncTable.timer = intermissionTimer

        if gGlobalSyncTable.forceLevel then
            packet_receive({packet = "SPLASH", message = "Single-Level Mode"})
            network_send(true, {packet = "SPLASH", message = "Single-Level Mode"})
        else
            packet_receive({packet = "SPLASH", message = "Full-Game Mode"})
            network_send(true, {packet = "SPLASH", message = "Full-Game Mode"})
        end
    
    else
        djui_chat_message_create("You can only change modes during intermission. This is to prevent abuse of this command.")
    end

    return true

end

local function command_all_levels()

    gGlobalSyncTable.allLevels = not gGlobalSyncTable.allLevels
    if gGlobalSyncTable.allLevels then
        djui_chat_message_create("All Levels Enabled")
    else
        djui_chat_message_create("Switched to Standard Levels Only")
    end
    return true

end

local function command_player_list()

    gGlobalSyncTable.playerList = not gGlobalSyncTable.playerList
    if gGlobalSyncTable.playerList then
        djui_chat_message_create("Player List Enabled for Full-Game Mode")
    else
        djui_chat_message_create("Player List Disabled for Full-Game Mode")
    end
    return true

end

if network_is_server() then
    hook_chat_command("mode", "- Switch Gamemodes", command_switch_mode)
    hook_chat_command("levels", "- Toggle Blacklisted Levels", command_all_levels)
    hook_chat_command("playerlist", "- Toggle Player List for Full-Game Mode", command_player_list)
end
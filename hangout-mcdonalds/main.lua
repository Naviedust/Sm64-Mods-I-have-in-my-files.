-- name: Hangout - \\#FFCC00\\McDonald's\\#FFFFFF\\
-- description: This mod adds a custom McDonald's map to your server! This map is completely isolated from the game itself, which allows it to co-exist alongside whatever you're running!\nThis mod gives a basic way to enter the map through a simple command (/mcd), but feel free to modify it to make your own way to it!\n\nMap by chillyzone

-- register the level here
LEVEL_HANGOUT_MCDONALDS = 100
level_register('level_hangout_mcdonalds_entry', COURSE_NONE, 'McDonalds', 'hangout_mcdonalds', 28000, 0x08, 0x08, 0x08)
local level_hangout_mcdonalds = smlua_level_util_get_info_from_short_name('hangout_mcdonalds')
level_hangout_mcdonalds.levelNum = LEVEL_HANGOUT_MCDONALDS
E_MODEL_MCDONALDCRATE = smlua_model_util_get_id("mcd_crate_geo")

function mcdinit()
    local p = gNetworkPlayers[0]
    if p.currLevelNum == LEVEL_HANGOUT_MCDONALDS then
        area_get_warp_node(0x00).node.destLevel = gLevelValues.entryLevel
    end
end

function mcd_warp()
    if gNetworkPlayers[0] then
        warp_to_level(LEVEL_HANGOUT_MCDONALDS, 1, 0)
        return true
    end
end

hook_event(HOOK_ON_LEVEL_INIT, mcdinit)
hook_chat_command("mcd", "Warps you to McDonalds", mcd_warp)
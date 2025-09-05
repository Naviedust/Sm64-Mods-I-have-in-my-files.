if network_is_server() then
---
---
---

local k = {
    {name = "Coin Amount", value = gGlobalSyncTable.coinamount, type = "slide", configExtra = {0, 10}, desc = "Coin amount for each Player. More Coins more velocity", save = "Kart"},
    {name = "Speed Set", value = gGlobalSyncTable.speedcc, type = "multi", configExtra = {"50cc", "100cc","150cc","200cc"}, desc = "This option modifies the velocity of all Karts", save = "Speedcc"},
    {name = "Kart Interact", value = gGlobalSyncTable.kartinteracts, type = "toggle", configExtra = nil, desc = "Enables Kart Collision", save = "Interact"},
    {name = "Accurate MKDS Speed", value = gGlobalSyncTable.accurateMKDSSpeed, type = "toggle", configExtra = nil, desc = "Makes speed accurate to MKDS", save = "MKDSSpeed"},
    {name = "Shell Shotter Modifier", value = gGlobalSyncTable.accurateMKDSSpeed, type = "toggle", configExtra = nil, desc = "Everyone can throws Shells in B!", save = "ShellMode"},
    {name = "AutoJump", value = gGlobalSyncTable.autojump, type = "toggle", configExtra = nil, desc = "Auto-Jump", save = "AutoJump"},
}

local menuOpen = false
local selectedSetting = 1
local menuInput = 0
local stickCD = 0
local stickCDDeminish = 1.4
local curPage = 1
local pages = {{contents = {1, #k}}}

local optionXOffset = 0
local optionYOffset = 0
local smoothPos = 0
local smoothR, smoothG, smoothB = 0, 0, 0
local menuScreenFade = 0
local bobTime = 0
local pageXOffset = 0

local settingSavedTimer = 0
local settingSavedFade = 0

local get_centered_offset = function(txt, scale)
    return (djui_hud_measure_text(txt) / 2) * scale
end

local print_shadowed_text = function(txt, x, y, scale, r, g, b, a)
    djui_hud_set_color(0, 0, 0, a * 0.6)
    djui_hud_print_text(txt, x + 3, y + 3, scale + 0.01)

    djui_hud_set_color(r, g, b, a)
    djui_hud_print_text(txt, x, y, scale)
end

local print_shaking_text = function(txt, x, y, scale, intensity, r, g, b, a)
    for i = 1, string.len(txt) do
        local xShake = intensity * math.random()
        local yShake = intensity * math.random()
        local subTxt = string.sub(txt, 1, i - 1)

        print_shadowed_text(string.sub(txt, i, i), x + xShake + djui_hud_measure_text(subTxt) * scale, y + yShake, scale, r, g, b, a)
    end
end

local draw_detailed_rect = function(x, y, w, h, r, g, b, a)
    djui_hud_set_color(0, 0, 255, a * 0.6)
    djui_hud_render_rect(x + 3, y + 3, w + 10, h + 10)

    djui_hud_set_color(50, 50, 100, a)
    djui_hud_render_rect(x - 5, y - 5, w + 10, h + 10)

    djui_hud_set_color(100, 100, 255, a)
    djui_hud_render_rect(x, y, w, h)
end

local draw_golden_detailed_rect = function(x, y, w, h, r, g, b, a)
    djui_hud_set_color(100, 100, 255, a * 0.6)
    djui_hud_render_rect(x + 3, y + 3, w + 1, h + 16)

    djui_hud_set_color(50, 50, 255, a)
    djui_hud_render_rect(x - 8, y - 8, w + 16, h + 16)

    djui_hud_set_color(150, 150, 255, a)
    djui_hud_render_rect(x, y, w, h)
end

local get_left_edge = function()
    local aspectRatio = djui_hud_get_screen_width() / djui_hud_get_screen_height()
    local width = djui_hud_get_screen_width()
    local height = djui_hud_get_screen_height()

    return width / 2 - height / 2 * aspectRatio
end

local get_right_edge = function()
    local aspectRatio = djui_hud_get_screen_width() / djui_hud_get_screen_height()
    local width = djui_hud_get_screen_width()
    local height = djui_hud_get_screen_height()

    return width / 2 + height / 2 * aspectRatio
end

local config_menu = function()
    local m = gMarioStates[0]

    if menuOpen then
        menuScreenFade = approach_f32(menuScreenFade, 1, 0.1, 0.1)
    else
        menuScreenFade = approach_f32(menuScreenFade, 0, 0.2, 0.2)
    end

    if settingSavedTimer <= 0 then
        settingSavedFade = approach_f32(settingSavedFade, 0, 0x40, 0x40)
    else
        settingSavedFade = approach_f32(settingSavedFade, 0xFF, 0x20, 0x20)
        settingSavedTimer = settingSavedTimer - 1
    end

    djui_hud_set_font(FONT_MENU)
    djui_hud_set_resolution(RESOLUTION_DJUI)
    djui_hud_set_rotation(0, 0, 0)

    bobTime = bobTime + 1

    if menuScreenFade > 0 then
        djui_hud_set_font(FONT_MENU)

        local text = "Kart General Configuration Menu"
        local pageText
        local controlText = "Start/B = Quit Menu - L/R = Change Page - Up/Down D-pad/Joystick = Select Option - Left/Right D-pad/Joystick = Change Option"
        local screenCenter = djui_hud_get_screen_width() / 2
        local bobbing = 1.7 * math.sin(bobTime * 0.038)

        djui_hud_set_render_behind_hud(false)

        local screenH = djui_hud_get_screen_height()
        local screenW = djui_hud_get_screen_width()
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_render_texture(mkds, 0, 0, screenW / 58, screenH / 58)

        djui_hud_set_color(255, 255, 255, 0 * menuScreenFade)
        djui_hud_render_texture(mkds, 0, 0, djui_hud_get_screen_width() + 4, djui_hud_get_screen_height() + 4)
        print_shaking_text(text, screenCenter - get_centered_offset(text,1), 1 + bobbing, 1, 0.6, 0xFF, 0xFF, 0xFF, 0xFF * menuScreenFade)
        djui_hud_set_font(FONT_MENU)

        for i = #pages, 2, -1 do
            table.remove(pages, i)
        end
        pages[1].contents[2] = #k

        local a = 0
        for j = 1, #k do
            if 170 + 70 * (j - a - 1) > djui_hud_get_screen_height() - 140 and j > 1 then
                pages[#pages].contents[2] = j - 1
                a = j - 1
                pages[#pages + 1] = {contents = {j, #k}}
            end
        end

        if curPage > #pages then
            curPage = #pages
        end

        pageText = string.format("< L        %d/%d        R >", curPage, #pages)
        print_shadowed_text(pageText, screenCenter - get_centered_offset(pageText, 1.4) + 220, 88 + bobbing, 0.50, 0xFF, 0xFF, 0xFF, 0xFF * menuScreenFade)

        if selectedSetting < pages[curPage].contents[1] then
            selectedSetting = pages[curPage].contents[1]
        end

        if selectedSetting > pages[curPage].contents[2] then
            selectedSetting = pages[curPage].contents[2]
        end

        if menuInput & U_JPAD ~= 0 then
            selectedSetting = selectedSetting - 1
            play_sound(SOUND_MENU_CHANGE_SELECT, m.marioObj.header.gfx.cameraToObject)
            optionYOffset = -6

            if selectedSetting < pages[curPage].contents[1] then
                selectedSetting = pages[curPage].contents[2]
            end

            smoothPos = 0
            smoothR = 0
            smoothG = 0
            smoothB = 0
            stickCDDeminish = 1.4
        end

        if menuInput & D_JPAD ~= 0 then
            selectedSetting = selectedSetting + 1
            play_sound(SOUND_MENU_CHANGE_SELECT, m.marioObj.header.gfx.cameraToObject)
            optionYOffset = 6

            if selectedSetting > pages[curPage].contents[2] then
                selectedSetting = pages[curPage].contents[1]
            end

            smoothPos = 0
            smoothR = 0
            smoothG = 0
            smoothB = 0
            stickCDDeminish = 1.4
        end

        if menuInput & L_TRIG ~= 0 and #pages > 1 then
            curPage = curPage - 1
            play_sound(SOUND_MENU_CHANGE_SELECT, m.marioObj.header.gfx.cameraToObject)
            pageXOffset = -7

            if curPage < 1 then
                curPage = #pages
            end
        end

        if menuInput & R_TRIG ~= 0 and #pages > 1 then
            curPage = curPage + 1
            play_sound(SOUND_MENU_CHANGE_SELECT, m.marioObj.header.gfx.cameraToObject)
            pageXOffset = 7

            if curPage > #pages then
                curPage = 1
            end
        end

        if menuInput & (B_BUTTON | START_BUTTON) ~= 0 then
            menuOpen = false
            play_sound(SOUND_MENU_HAND_DISAPPEAR, m.marioObj.header.gfx.cameraToObject)
            selectedSetting = 1
            curPage = 1
            settingSavedTimer = 50

            gGlobalSyncTable.coinamount = k[1].value
            gGlobalSyncTable.speedcc = k[2].value
            gGlobalSyncTable.kartinteracts = k[3].value
            gGlobalSyncTable.accurateMKDSSpeed = k[4].value
            gGlobalSyncTable.shellshotmode = k[5].value 
            gGlobalSyncTable.autojump = k[6].value 

            for i = 1, #k do
                mod_storage_save(k[i].save, tostring(k[i].value))
            end
        end

        optionXOffset = approach_f32(optionXOffset, 0, 1, 1)
        optionYOffset = approach_f32(optionYOffset, 0, 1, 1)

        pageXOffset = approach_f32(pageXOffset, 0, 1, 1)

        djui_hud_set_color(0, 0, 0x100, 0x60 * menuScreenFade)
        djui_hud_render_rect(0, djui_hud_get_screen_height() - 80 + bobbing, djui_hud_get_screen_width(), 80 - bobbing)

        if type(k[selectedSetting].desc) == "string" then
            print_shaking_text(k[selectedSetting].desc, screenCenter - get_centered_offset(k[selectedSetting].desc, 0.6) + 05,
            djui_hud_get_screen_height() - 55 + bobbing, 0.6, 0.6, 0xFF, 0xFF, 0xFF, 0xFF * menuScreenFade)
        end

        print_shadowed_text(controlText, screenCenter - get_centered_offset(controlText, 0.6) + 490, djui_hud_get_screen_height() - 80 + bobbing, 0.3,
        0xFF, 0xFF, 0xFF, 0xFF * menuScreenFade)

        for i = pages[curPage].contents[1], pages[curPage].contents[2] do
            local x = get_left_edge() + 80
            local maxRectWidth = get_right_edge() - 80 - x
            local height = 50
            local y = 170 + 70 * (i - pages[curPage].contents[1]) + bobbing

            if selectedSetting == i then
                x = x + optionXOffset
                y = y + optionYOffset
                draw_golden_detailed_rect(x, y, maxRectWidth, height, 0xFF, 0x40, 0, 0xFF * menuScreenFade)
                print_shaking_text(k[i].name, x + 7, y, 0.6, 0.6, 0xFF, 0xFF, 0xFF, 0xFF * menuScreenFade)

                djui_hud_set_rotation(-0x4000, 0.5, 0)

                djui_hud_set_color(0, 0, 0, 0xFF * 0.6)
                djui_hud_render_texture(gTextures.arrow_up, x - 27 + bobbing, y + 28, 5, 5)
                djui_hud_set_color(0xFF, 0xFF, 0xFF, 0xFF)
                djui_hud_render_texture(gTextures.arrow_up, x - 30 + bobbing, y + 25, 5, 5)

                djui_hud_set_color(0, 0, 0, 0xFF * 0.6)
                djui_hud_render_texture(gTextures.arrow_down, x + maxRectWidth + 33 - bobbing, y + 28, 5, 5)
                djui_hud_set_color(0xFF, 0xFF, 0xFF, 0xFF)
                djui_hud_render_texture(gTextures.arrow_down, x + maxRectWidth + 30 - bobbing, y + 25, 5, 5)

                djui_hud_set_rotation(0, 0, 0)
            else
                draw_detailed_rect(x, y, maxRectWidth, height, 0x50, 0x50, 0x50, 0xFF * menuScreenFade)
                print_shadowed_text(k[i].name, x + 7, y, 0.6, 0xFF, 0xFF, 0xFF, 0xFF * menuScreenFade)
            end

            if k[i].type == "toggle" then
                local x2 = maxRectWidth - 105
                local rectWidth2 = get_right_edge() - 105 - x2
                local h = 15
                local r, g, b, pos
                local usingPos, usingR, usingG, usingB

                if k[i].value then
                    r, g, b, pos = 0, 0xFF, 0, x2 - h
                else
                    r, g, b, pos = 0xFF, 0, 0, rectWidth2 + x2 - h
                end

                if selectedSetting == i then
                    x2 = x2 + optionXOffset
                    pos = pos + optionXOffset

                    if smoothPos == 0 then
                        smoothPos = pos
                    else
                        smoothPos = approach_f32(smoothPos, pos, 40, 40)
                    end

                    if smoothPos < x2 - h then
                        smoothPos = x2 - h
                    elseif smoothPos > rectWidth2 + x2 - h then
                        smoothPos = rectWidth2 + x2 - h
                    end

                    if smoothR + smoothG + smoothB == 0 then
                        smoothR, smoothG, smoothB = r, g, b
                    else
                        smoothR = approach_f32(smoothR, r, 0x80, 0x80)
                        smoothG = approach_f32(smoothG, g, 0x80, 0x80)
                        smoothB = approach_f32(smoothB, b, 0x80, 0x80)
                    end

                    usingPos, usingR, usingG, usingB = smoothPos, smoothR, smoothG, smoothB

                    if menuInput & (A_BUTTON | L_JPAD | R_JPAD) ~= 0 then
                        k[i].value = not k[i].value
                        play_sound(SOUND_MENU_REVERSE_PAUSE, m.marioObj.header.gfx.cameraToObject)

                        optionXOffset = k[i].value and -6 or 6
                    end
                else
                    r, g, b = 0x80, 0x80, 0x80
                    usingPos, usingR, usingG, usingB = pos, r, g, b
                end

                djui_hud_set_color(0, 0, 0, 0x99 * menuScreenFade)
                djui_hud_render_rect(usingPos + 3, (y + h / 2) + 3, h * 2 + 6, h * 2 + 6)

                draw_detailed_rect(x2, y + h, rectWidth2, h, 0x50, 0x50, 0x50, 0xFF * menuScreenFade)

                djui_hud_set_color(usingR * 0.5, usingG * 0.5, usingB * 0.5, 0xFF * menuScreenFade)
                djui_hud_render_rect(usingPos - 3, (y + h / 2) - 3, h * 2 + 6, h * 2 + 6)

                djui_hud_set_color(usingR, usingG, usingB, 0xFF * menuScreenFade)
                djui_hud_render_rect(usingPos, y + h / 2, h * 2, h * 2)

            elseif k[i].type == "slide" then
                local x2 = maxRectWidth - 165
                local rectWidth2 = get_right_edge() - 105 - x2
                local h = 15
                local number = "(" .. k[i].value .. ")"
                local r, g, b = 0x80, 0x80, 0x80

                if selectedSetting == i then
                    r, g, b = 0xFF, 0xFF, 0xFF
                    print_shaking_text(number, x2 - 20 - get_centered_offset(number, 1.5) * 2, y, 0.6, 0.6, r, g, b, 0xFF * menuScreenFade)

                    x2 = x2 + optionXOffset
                    if menuInput & L_JPAD ~= 0 then
                        if stickCDDeminish <= -3.2 then
                            k[i].value = k[i].value - 5
                        else
                            k[i].value = k[i].value - 1
                        end

                        if k[i].value < k[i].configExtra[1] then
                            k[i].value = k[i].configExtra[1]
                        end

                        play_sound(SOUND_MENU_REVERSE_PAUSE, m.marioObj.header.gfx.cameraToObject)

                        if stickCDDeminish > -3.2 then
                            stickCDDeminish = stickCDDeminish - 0.1
                        end

                        optionXOffset = -4
                    elseif menuInput & R_JPAD ~= 0 then
                        if stickCDDeminish <= -3.2 then
                            k[i].value = k[i].value + 5
                        else
                            k[i].value = k[i].value + 1
                        end

                        if k[i].value > k[i].configExtra[2] then
                            k[i].value = k[i].configExtra[2]
                        end

                        play_sound(SOUND_MENU_REVERSE_PAUSE, m.marioObj.header.gfx.cameraToObject)

                        if stickCDDeminish > -3.2 then
                            stickCDDeminish = stickCDDeminish - 0.1
                        end

                        optionXOffset = 4
                    end
                else
                    print_shadowed_text(number, x2 - 20 - get_centered_offset(number, 1.5) * 2, y, 0.6, r, g, b, 0xFF * menuScreenFade)
                end

                draw_detailed_rect(x2, y + h, rectWidth2, h, 0x50, 0x50, 0x50, 0xFF * menuScreenFade)

                djui_hud_set_color(r, g, b, 0xFF * menuScreenFade)
                djui_hud_render_rect(x2, y + h, rectWidth2 * (k[i].value - k[i].configExtra[1]) /
                (k[i].configExtra[2] - k[i].configExtra[1]), h)

            elseif k[i].type == "multi" then
                local x2 = x + maxRectWidth - 25
                local txt2 = k[i].configExtra[k[i].value]
                local r, g, b = 0x80, 0x80, 0x80

                if selectedSetting == i then
                    txt2 = "< " .. k[i].configExtra[k[i].value] .. " >"
                    r, g, b = 0xFF, 0xFF, 0xFF

                    print_shaking_text(txt2, x2 - get_centered_offset(txt2, 1.5) * 2, y, 0.6, 0.6, r, g, b, 0xFF * menuScreenFade)

                    if menuInput & L_JPAD ~= 0 then
                        k[i].value = k[i].value - 1
                        play_sound(SOUND_MENU_REVERSE_PAUSE, m.marioObj.header.gfx.cameraToObject)

                        if k[i].value < 1 then
                            k[i].value = #k[i].configExtra
                        end

                        optionXOffset = -6

                    elseif menuInput & R_JPAD ~= 0 then
                        k[i].value = k[i].value + 1
                        play_sound(SOUND_MENU_REVERSE_PAUSE, m.marioObj.header.gfx.cameraToObject)

                        if k[i].value > #k[i].configExtra then
                            k[i].value = 1
                        end

                        optionXOffset = 6
                    end
                else
                    print_shadowed_text(txt2, x2 - get_centered_offset(txt2, 1.5) * 2, y, 0.6, r, g, b, 0xFF * menuScreenFade)
                end
            end
        end
    end
end

hook_event(HOOK_ON_HUD_RENDER, function()
    config_menu()
end)

hook_event(HOOK_BEFORE_MARIO_UPDATE, function(m)
    if m.playerIndex ~= 0 then
        return
    end

    menuInput = 0

    if menuOpen then
        menuInput = m.controller.buttonPressed
        m.controller.buttonPressed = 0
        m.controller.stickX = 0
        m.controller.stickY = 0
        m.controller.stickMag = 0

        if stickCD > -2 then
            stickCD = stickCD - 1
        else
            stickCDDeminish = 1.4
        end

        if stickCD <= 0 then
            if m.controller.rawStickY > 18 then
                menuInput = menuInput | U_JPAD
                stickCD = math.max(0, 5 * math.min(1, stickCDDeminish))
            elseif m.controller.rawStickY < -18 then
                menuInput = menuInput | D_JPAD
                stickCD = math.max(0, 5 * math.min(1, stickCDDeminish))
            end

            if m.controller.rawStickX < -18 then
                menuInput = menuInput | L_JPAD
                stickCD = math.max(0, 5 * math.min(1, stickCDDeminish))
            elseif m.controller.rawStickX > 18 then
                menuInput = menuInput | R_JPAD
                stickCD = math.max(0, 5 * math.min(1, stickCDDeminish))
            end
        end
    end
end)



-- To lock something down, just put an if loop around it, for example

-- function start()
--     if gGlobalSyncTable.ispermitted == true then
--         *code here*
--     else
--         djui_chat_message_create("This command, or function is locked down.")
--     end
-- end

hook_chat_command("kartconf", "Open the Menu", function()
    if network_is_server() then
    menuOpen = true
    play_sound(SOUND_MENU_HAND_APPEAR, gMarioStates[0].marioObj.header.gfx.cameraToObject)
    end
    return true
end)

end
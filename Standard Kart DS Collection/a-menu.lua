

local math_max, math_abs, math_min, math_floor, approach_f32, smlua_anim_util_get_current_animation_name, smlua_anim_util_set_animation, set_anim_to_frame = 

math.max, math.abs, math.min, math.floor, approach_f32, smlua_anim_util_get_current_animation_name, smlua_anim_util_set_animation, set_anim_to_frame



if mod_storage_load("Kart") ~= nil then
    gGlobalSyncTable.coinamount = tonumber(mod_storage_load("Kart"))
end

if mod_storage_load("NKarts") ~= nil then
    gPlayerSyncTable[0].kartselect = tonumber(mod_storage_load("NKarts"))
end

if mod_storage_load("Speedcc") ~= nil then
    gGlobalSyncTable.speedcc = tonumber(mod_storage_load("Speedcc"))
end

if mod_storage_load("Interact") == "false" then
    gGlobalSyncTable.kartinteracts = false
end

if mod_storage_load("Interact") == "ShellMode" then
    gGlobalSyncTable.shellshotmode = false
end


deg_to_hex = function(x)
    return x * 0x10000 / 360
end

hex_to_deg = function(x)
    return x * 360 / 0x10000
end

clamp = function(x, min, max)
    return math_min(max, math_max(min, x))
end

lerp = function(min, max, percent)
    return min + (max - min) * percent
end

s16 = function(x)
    x = (math_floor(x) & 0xFFFF)
    if x >= 32768 then return x - 65536 end
    return x
end

add_clutch_combo = function(m)
    if m.playerIndex == 0 then
        clutchCombo = clutchCombo + 1
        clutchComboTimer = CLUTCH_COMBO_DURATION
    end
end

reset_clutch_combo = function(m)
    if m.playerIndex == 0 then
        clutchCombo = 0
        clutchComboTimer = 0
    end
end
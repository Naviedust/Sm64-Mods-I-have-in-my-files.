-- name: COMIN' IN HOT! Ground Pound
-- description: COMIN' IN HOT! The Nether. WATER BUCKET! RELEASE! Flint and Steel! Ender Pearl. CHICKEN JOCKEY! Big ol' Red Ones! These guys? They're the Villagers!

local mario_cih = false

local mario_cih = function(_, value)
    gPlayerSyncTable[0].marioCIH = value
end

hook_mod_menu_checkbox("Mario Voiceline", false, mario_cih)

hook_event(HOOK_ON_SET_MARIO_ACTION, function (m)

    if gPlayerSyncTable[0].marioCIH == true and m.action == ACT_GROUND_POUND then
        audio_sample_play(MARIO_COMININHOT, m.pos, 2)
    elseif m.action == ACT_GROUND_POUND then
        audio_sample_play (JACK_COMININHOT, m.pos, 2)
    end
    if m.action == ACT_BUTT_STUCK_IN_GROUND then
        set_mario_action(m, ACT_HEAD_STUCK_IN_GROUND, 0)
    end
end)

hook_event(HOOK_MARIO_UPDATE, function (m)
    if m.marioObj.header.gfx.animInfo.animID == MARIO_ANIM_GROUND_POUND then
        smlua_anim_util_set_animation(m.marioObj, "comininhot")

    end
        
    if m.marioObj.header.gfx.animInfo.animID == MARIO_ANIM_START_GROUND_POUND then
        smlua_anim_util_set_animation(m.marioObj, "comininhotstart")

    end

    if m.marioObj.header.gfx.animInfo.animID == MARIO_ANIM_GROUND_POUND_LANDING then
        smlua_anim_util_set_animation(m.marioObj, "comininhotend")

    end

    if m.marioObj.header.gfx.animInfo.animID == MARIO_ANIM_STOP_SLIDE then
        smlua_anim_util_set_animation(m.marioObj, "comininhotgetup")

    end

    -- not sure if the triple jump groundpound is even used but might as well set it anyway lmao
    if m.marioObj.header.gfx.animInfo.animID == MARIO_ANIM_TRIPLE_JUMP_GROUND_POUND then
        smlua_anim_util_set_animation(m.marioObj, "comininhot")

    end

end)

hook_event(HOOK_CHARACTER_SOUND, function(m, sound)
    if m.playerIndex ~= 0 then return end

    if sound == CHAR_SOUND_GROUND_POUND_WAH then
        return 0
    end
end)

MARIO_COMININHOT = audio_sample_load("MarCIH.ogg")
JACK_COMININHOT = audio_sample_load("JackCIH.ogg")


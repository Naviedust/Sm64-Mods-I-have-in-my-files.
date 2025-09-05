-- name: Goku Apparition
-- description: Goku heard you're very strong. \n\Every 2 and a half Minutes there's a 25% chance he appears to a random player. \n\Image made by molnwza007_dg531mc in Devianart. \n\Mod by SonicDark

gGlobalSyncTable.goku_timer = 0
SOUND_FIRST_NOTE = audio_sample_load("clash_of_gods_first_note.mp3")
E_MODEL_GOKU     = smlua_model_util_get_id("goku_geo")

function goku_apparition()
    gGlobalSyncTable.player_random_target = math.random(0, network_player_connected_count() - 1)
    m = gMarioStates[gGlobalSyncTable.player_random_target]
    gGlobalSyncTable.goku_timer = gGlobalSyncTable.goku_timer + 1
    gGlobalSyncTable.apparition_chance = math.random(1, 4)
    if gGlobalSyncTable.goku_timer == 4500 then
        if gGlobalSyncTable.apparition_chance == 1 then
            audio_sample_play(SOUND_FIRST_NOTE, m.pos, 2.5)
            spawn_sync_object(id_bhvGokuApparition, E_MODEL_GOKU, m.pos.x, m.pos.y, m.pos.z, goku_apparition)
            gGlobalSyncTable.goku_timer = 0
        end
        gGlobalSyncTable.goku_timer = 0
    end
end

hook_event(HOOK_UPDATE, goku_apparition)

function goku_apparition_init(o)
    o.oFaceAngleYaw = m.faceAngle.y
    o.oFaceAnglePitch = 0
    o.oFaceAngleRoll = 0
end

function goku_apparition_loop(o)
    o.oTimer = o.oTimer + 1
    if o.oTimer == 120 then
        obj_mark_for_deletion(o)
    end
end

id_bhvGokuApparition = hook_behavior(nil, OBJ_LIST_LEVEL, false, goku_apparition_init, goku_apparition_loop)
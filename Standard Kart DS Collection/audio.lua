-- Audio system made by Cooliokid 956 (Great Kingdom Offical)
-- Give him credit Viandegras.
-- ok pendejko, ggrasias colio kid ay yomio

currentlyPlaying = nil

---@param a BassAudio
function stream_play(a)
    if currentlyPlaying then audio_stream_stop(currentlyPlaying) end
    audio_stream_play(a, true, 1)
    currentlyPlaying = a
end
function stream_stop_all()
    currentlyPlaying = nil
end
gSamples = {
    audio_sample_load("1desacelerando.mp3"),
    audio_sample_load("2idle.mp3"),
    audio_sample_load("3acelerando.mp3"),
    audio_sample_load("4mediavel.mp3"),
    audio_sample_load("5altavel.mp3"),
    audio_sample_load("coinsnd.mp3"),
}

sDecelerate = 1
sIdle = 2
sAccelerate = 3
sMediumvel = 4
sAltvel = 5
sCoinSound = 6

function local_play(id, pos, vol)
    m = gMarioStates[0]
    local distancecalculations = dist_between_object_and_point(m.marioObj, pos.x, pos.y, pos.z)
    local temppos = {x=pos.x, y=pos.y + (distancecalculations * 6), z=pos.z}
    audio_sample_play(gSamples[id], temppos, (is_game_paused() and 0 or vol))
end
function network_play(id, pos, vol, i)
    local_play(id, pos, vol)
    network_send(true, {id = id, x = pos.x, y = pos.y, z = pos.z, vol = vol, i = network_global_index_from_local(i)})
end
function stop_all_samples()
    for _, audio in pairs(gSamples) do
        audio_sample_stop(audio)
    end
end

hook_event(HOOK_ON_PACKET_RECEIVE, function (data)
    if is_player_active(gMarioStates[network_local_index_from_global(data.i)]) ~= 0 then
        local_play(data.id, {x=data.x, y=data.y, z=data.z}, data.vol)
    end
end)
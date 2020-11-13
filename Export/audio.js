// import HowlPackage from "./howler.min.js";
// import {
//     Howl
// } = HowlPackage;
// }
// from "./howler.min.js";

/**
 * @type {Object.<string, Howl>} players
 */
let players = {};
let is_muted = false;

function get_name(player_name, audio_name) {
    return `${player_name}/${audio_name}`
}

/**
 * 
 * @param {string} name 
 * @param {Object.<string, string>} paths
 * @param {Object.<string, boolean>} config 
 */
function new_audio_player(name, paths, config) {
    for (i in paths) {
        players[get_name(name, i)] = new Howl({
            src: [paths[i]],
            autoplay: ("loop" in config) ? config["autoplay"] : false,
            loop: ("loop" in config) ? config["loop"] : false,
            preload: true
        });
    }
}

/**
 * 
 * @param {string} name
 * @param {string} audio_name
 * @param {boolean} continue_playing
 */
function play_audio(name, audio_name, continue_playing) {
    let n = get_name(name, audio_name);
    if (n in players) {
        if (!continue_playing)
            players[n].seek(0);
        players[n].play();
    }
}

/**
 * 
 * @param {string} name 
 * @param {string} audio_name
 */
function stop_audio(name, audio_name) {
    let n = get_name(name, audio_name);
    if (n in players) {
        players[n].stop();
    }
}

/**
 * 
 * @param {string} name 
 * @param {string} audio_name
 */
function pause_audio(name, audio_name) {
    let n = get_name(name, audio_name);
    if (n in players) {
        players[n].pause();
    }
}


/**
 * 
 * @param {string} name 
 * @param {string} audio_name
 */
function is_playing(name, audio_name) {
    let n = get_name(name, audio_name);
    return (n in players) ? players[n].playing() : false;
}

function mute_unmute(mute = null) {
    if (mute !== null) {
        is_muted = mute;
    } else {
        is_muted = !is_muted;
    }
    for (let i in players) {
        players[i].mute(is_muted);
    }
}

window.addEventListener("message", (event) => {
    if (event.data.type === 'mute') {
        mute_unmute(event.data.mute);
    }
});
import {
    Howl,
    Howler
} from "howler";

/**
 * @type {Object.<string, Howl>} players
 */
let players = {};

/**
 * 
 * @param {string} name 
 * @param {string} paths
 * @param {Object.<string, any>} config 
 */
function new_audio_player(name, paths, config) {
    players[name] = new Howl({
        src: [paths],
        autoplay: ("loop" in config) ? config["autoplay"] : false,
        loop: ("loop" in config) ? config["loop"] : false,
        preload: true,
        mute: true
    });
}

/**
 * 
 * @param {string} name
 * @param {number} index
 * @param {boolean} continue_playing
 */
function play_audio(name, index, continue_playing) {
    if (name in players){
        if (!continue_playing)
            players[name].seek(0);
        players[name].play(index);
    }
}

/**
 * 
 * @param {string} name 
 * @param {number} index 
 */
function stop_audio(name, index) {
    if (name in players){
        players[name].stop(index);
    }
}

/**
 * 
 * @param {string} name 
 * @param {number} index 
 */
function pause_audio(name, index) {
    if (name in players) {
        players[name].pause(index);
    }
}


/**
 * 
 * @param {string} name 
 * @param {number} index 
 */
function is_playing(name, index) {
    return (name in players) ? players[name].playing(index) : false;
}
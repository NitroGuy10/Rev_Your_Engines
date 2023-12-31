extends Node

const DEFAULT_ROAD_SPEED = 300

var road_speed = 0
var score = -1
var wipeout = false
var outta_gas = false
var gameover_screen = true
var resetting = false
var reset_countdown = -1

var play_music = false
var play_sfx = true

func deltaLerp(initial, final, lerp_amount, delta, base = 0.1):
	# https://youtu.be/yGhfUcPjXuE?t=1014
	var t = 1 - pow(base, delta * lerp_amount)
	return lerp(initial, final, t)
	

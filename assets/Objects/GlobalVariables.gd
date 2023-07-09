extends Node

const DEFAULT_ROAD_SPEED = 300

var road_speed = 300
var wipeout = false
var outta_gas = false
var gameover_screen = false
var resetting = false
var reset_countdown = -1

func deltaLerp(initial, final, lerp_amount, delta, base = 0.1):
	# https://youtu.be/yGhfUcPjXuE?t=1014
	var t = 1 - pow(base, delta * lerp_amount)
	return lerp(initial, final, t)
	

extends Node2D

onready var globals = get_node("/root/GlobalVariables")
var gameover_scene = preload("res://assets/Objects/Gameover.tscn")
var position_slot = 1

var is_wipeout_spinning = false
var wipeout_velocity = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

#func _physics_process(delta):
func _process(delta):
	$ExhaustParticles.initial_velocity = globals.road_speed
	
	
	if not (globals.wipeout or globals.gameover_screen or globals.outta_gas or (globals.resetting and globals.reset_countdown == 2)):
		if Input.is_action_just_pressed("ui_up"):
			position_slot = max(0, position_slot - 1)
	#		rotation = -0.5
		elif Input.is_action_just_pressed("ui_down"):
			position_slot = min(2, position_slot + 1)
	#		rotation = 0.5
		position.y = globals.deltaLerp(position.y, 150 + (105 * position_slot), 0.9999, delta, 0.0000001)
	if is_wipeout_spinning:
		$Sprite.rotate(30 * delta)
		# https://youtu.be/yGhfUcPjXuE?t=609
		wipeout_velocity += 2000 * delta * 0.5
		position.y += wipeout_velocity * delta
		position.x += 400 * delta
		wipeout_velocity += 2000 * delta * 0.5
	
	if globals.resetting:
		if globals.reset_countdown == 2:
			$SmokeParticles.emitting = false
			position.x -= globals.road_speed * delta
			position_slot = 1
		elif globals.reset_countdown == 1:
			$ExhaustParticles.emitting = true
			$Sprite.rotation = 0
			position.x = globals.deltaLerp(position.x, 164, 0.9999, delta, 0.001)
		elif globals.reset_countdown == 0:
			position.x = 164


func _on_Area2D_area_entered(area):
	if not (globals.wipeout or globals.gameover_screen or globals.resetting):
		if area.get_parent().causes_wipeout:
			globals.wipeout = true
			globals.outta_gas = false
			globals.road_speed = 200
			get_parent().position.x = 20
			
			is_wipeout_spinning = true
			wipeout_velocity = -500
		if area.get_parent().is_food and not globals.outta_gas:
			area.get_parent().queue_free()
			get_parent().fuel_percent = 100
	elif area.name == "BottomBoundary":
		is_wipeout_spinning = false
		$ExhaustParticles.emitting = false
		$SmokeParticles.emitting = true
		get_parent().position.y = 20
		globals.gameover_screen = true
		globals.wipeout = false
		
		for i in range(0, 5):
			var wipeout_text = gameover_scene.instance()
			wipeout_text.time_offset = 0.4 * i
			get_parent().add_child(wipeout_text)
		
		

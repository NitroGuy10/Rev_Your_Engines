extends Node2D

onready var globals = get_node("/root/GlobalVariables")
var obstacle_scene = preload("res://assets/Objects/Obstacle.tscn")
var gameover_scene = preload("res://assets/Objects/Gameover.tscn")
var gameover_text_scene = preload("res://assets/Objects/GameoverText.tscn")

var ROAD_ACCEL = 0.1
var ideal_road_speed = -999
var prev_ideal_road_speed = -999
var prev_delta = -999

var last_food = 0

var fuel_percent = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	$ObstacleTimer.start()
	randomize()
	
	ideal_road_speed = globals.road_speed
	prev_ideal_road_speed = globals.road_speed
	prev_delta = 0.1666667  # Estimate for 60fps; doesn't really matter


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = globals.deltaLerp(position, Vector2(0, 0), 0.95, delta)
	$FuelMeter.fill_percent = fuel_percent
	
	if not globals.outta_gas and not globals.resetting and not globals.gameover_screen and not globals.wipeout and fuel_percent < 0:
		$Player/ExhaustParticles.emitting = false
		globals.outta_gas = true
		globals.score = round(globals.road_speed - globals.DEFAULT_ROAD_SPEED)
	if globals.outta_gas and not globals.gameover_screen and not globals.wipeout and globals.road_speed < 10:
		globals.gameover_screen = true
		globals.outta_gas = false
		for i in range(0, 5):
			var outta_gas_text = gameover_scene.instance()
			outta_gas_text.base_size = 12
			outta_gas_text.get_node("AnimatedSprite").frame = 1
			outta_gas_text.time_offset = 0.4 * i
			add_child(outta_gas_text)
		var gameover_text = gameover_text_scene.instance()
		gameover_text.get_node("ScoreLabel").text = "Score: " + str(globals.score)
		add_child(gameover_text)
		
	if globals.wipeout or globals.gameover_screen or globals.outta_gas:
		globals.road_speed = globals.deltaLerp(globals.road_speed, 0, 0.9, delta)
		fuel_percent = 0
	if globals.gameover_screen:
		if Input.is_action_just_pressed("ui_accept"):
			globals.resetting = true
			globals.gameover_screen = false
			globals.reset_countdown = 2
			$ResetTimer.start()
	elif globals.resetting:
		if globals.reset_countdown == 2:
			globals.road_speed = globals.deltaLerp(globals.road_speed, 2000, 0.9, delta)
		if globals.reset_countdown == 1:
			globals.road_speed = globals.deltaLerp(globals.road_speed, globals.DEFAULT_ROAD_SPEED, 0.9, delta)
			fuel_percent = min(100, fuel_percent + 120 * delta)
		elif globals.reset_countdown == 0:
			globals.road_speed = globals.DEFAULT_ROAD_SPEED
			fuel_percent = 100
	elif globals.outta_gas:
		pass
	else:
		fuel_percent -= 10 * delta
		
		# https://youtu.be/yGhfUcPjXuE?t=609
		ideal_road_speed += ROAD_ACCEL
		globals.road_speed += ((ideal_road_speed - prev_ideal_road_speed ) / prev_delta) * delta
		
		prev_ideal_road_speed = ideal_road_speed
		prev_delta = delta
		
		$ObstacleTimer.wait_time = max(0.5, 2 - (globals.road_speed / 600))


func _on_ObstacleTimer_timeout():
	if not (globals.gameover_screen or globals.resetting or globals.wipeout or globals.outta_gas):
		var is_food = (randi() % 5) == 0
		if last_food == 4:
			is_food = true
		else:
			last_food += 1
		if is_food:
			last_food = 0
		
		if (randi() % 3) == 0:  # Spawn two obstacles
			var obstacle_instance = obstacle_scene.instance()
			var obstacle_instance2 = obstacle_scene.instance()
			obstacle_instance.position.x = 1060
			obstacle_instance2.position.x = 1060
			var position_slot = randi() % 3
			obstacle_instance.position.y = 150 + (105 * position_slot)
			obstacle_instance2.position.y = 150 + (105 * ((position_slot + 1) % 3))
			var obstacle_type_index = randi() % obstacle_instance.NUM_OBSTACLE_TYPES
			# If there is food, it will always be the first obstacle instance
			if is_food:
				obstacle_type_index = obstacle_instance.NUM_OBSTACLE_TYPES + (randi() % obstacle_instance.NUM_FOOD_TYPES)
				obstacle_instance.is_food = true
				obstacle_instance.causes_wipeout = false
			var obstacle_type_index2 = randi() % obstacle_instance.NUM_OBSTACLE_TYPES
			obstacle_instance.obstacle_type = obstacle_instance.OBSTACLE_TYPES[obstacle_type_index]
			obstacle_instance.get_node("AnimatedSprite").frame = obstacle_type_index
			obstacle_instance2.obstacle_type = obstacle_instance.OBSTACLE_TYPES[obstacle_type_index2]
			obstacle_instance2.get_node("AnimatedSprite").frame = obstacle_type_index2
			$Obstacles.add_child(obstacle_instance)
			$Obstacles.add_child(obstacle_instance2)
		else:
			var obstacle_instance = obstacle_scene.instance()
			obstacle_instance.position.x = 1060
			var position_slot = randi() % 3
			obstacle_instance.position.y = 150 + (105 * position_slot)
			var obstacle_type_index = randi() % obstacle_instance.NUM_OBSTACLE_TYPES
			if is_food:
				obstacle_type_index = obstacle_instance.NUM_OBSTACLE_TYPES + (randi() % obstacle_instance.NUM_FOOD_TYPES)
				obstacle_instance.is_food = true
				obstacle_instance.causes_wipeout = false
			obstacle_instance.obstacle_type = obstacle_instance.OBSTACLE_TYPES[obstacle_type_index]
			obstacle_instance.get_node("AnimatedSprite").frame = obstacle_type_index
			$Obstacles.add_child(obstacle_instance)


func _on_ResetTimer_timeout():
	globals.reset_countdown -= 1
	if globals.reset_countdown == -1:
		$ResetTimer.stop()
		globals.resetting = false

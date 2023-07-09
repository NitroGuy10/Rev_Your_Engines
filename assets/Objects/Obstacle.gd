extends Node2D

onready var globals = get_node("/root/GlobalVariables")
const OBSTACLE_TYPES = ["pothole", "oil_spill", "cone", "burger", "milkshake", "pie"]
const NUM_OBSTACLE_TYPES = 3
const NUM_FOOD_TYPES = 3

var obstacle_type = "pothole"
var causes_wipeout = true
var is_food = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta):
func _process(delta):
	$AnimatedSprite.position.x -= globals.road_speed * delta
	
	if position.x < -30:
		queue_free()
	else:
		$Area2D.position.x -= globals.road_speed * delta

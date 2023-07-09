extends Node2D

onready var globals = get_node("/root/GlobalVariables")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

func _process(delta):
	if globals.resetting:
		if globals.reset_countdown == 2:
			position.x -= globals.road_speed * delta
		elif globals.reset_countdown == 1:
			queue_free()

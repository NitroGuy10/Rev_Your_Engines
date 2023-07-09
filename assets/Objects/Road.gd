extends Node2D

onready var globals = get_node("/root/GlobalVariables")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Sprite.position.x < -135:
		$Sprite.position.x += 135 * 2
	else:
		$Sprite.position.x -= globals.road_speed * delta

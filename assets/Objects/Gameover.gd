extends Node2D

onready var globals = get_node("/root/GlobalVariables")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var time = 0
var time_offset = 0

var despawning = false
var despawn_velocity = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta * 5
	var sine = sin(time + time_offset)
	
	$AnimatedSprite.modulate = Color(1, (162 - sine * 83) / 255, 0)
	$AnimatedSprite.rotation = cos(time + time_offset) / 25
	
	if globals.resetting:
		despawning = true
	
	if despawning:
		despawn_velocity -= 20 * delta
		$AnimatedSprite.scale.x += despawn_velocity * delta
		$AnimatedSprite.scale.y += despawn_velocity * delta
		
		if $AnimatedSprite.scale.x < 0.001:
			queue_free()
	else:
		$AnimatedSprite.scale.x = 15 + sine * 2
		$AnimatedSprite.scale.y = 15 + sine * 2

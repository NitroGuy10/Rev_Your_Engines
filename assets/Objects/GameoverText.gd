extends Node2D

onready var globals = get_node("/root/GlobalVariables")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func assign_button_sprites():
	if globals.play_music:
		$SoundControls/MusicSprite.frame = 0
	else:
		$SoundControls/MusicSprite.frame = 1
	if globals.play_sfx:
		$SoundControls/SoundSprite.frame = 0
	else:
		$SoundControls/SoundSprite.frame = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	assign_button_sprites()

func _process(delta):
	if globals.resetting:
		if globals.reset_countdown == 2:
			position.x -= globals.road_speed * delta
		elif globals.reset_countdown == 1:
			queue_free()


func _on_MusicButton_pressed():
	globals.play_music = not globals.play_music
	assign_button_sprites()


func _on_SoundButton_pressed():
	globals.play_sfx = not globals.play_sfx
	assign_button_sprites()

extends Control
@onready var subtitle = $Map/Subtitle
var atlas_tex : AtlasTexture
var frame = 0
var frame_size = Vector2(800, 450)
var frames_per_row = 1   
var total_frames = 2    
var frame_time = 0.5     # seconds per frame
var time_accum = 0.0 

@export var game_scene : PackedScene
@export var credits_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	if subtitle == null:
		print("Text node not found!")
	else:
		atlas_tex = subtitle.texture as AtlasTexture
	
	


func _process(delta):
	time_accum += delta
	if time_accum >= frame_time:
		
		time_accum = 0.0
		frame = (frame + 1) % total_frames
		
		_update_frame()

func _update_frame():
	var x = (frame % frames_per_row) * frame_size.x
	var y = int(frame / frames_per_row) * frame_size.y
	atlas_tex.region = Rect2(Vector2(x, y), frame_size)


func _on_button_pressed():
	print("Scene changed!")
	get_tree().change_scene_to_file("res://scenes/MainGame.tscn")


func _on_credits_pressed():
	print("Scene Changed!")
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

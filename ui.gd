extends Control
@onready var crosshair = $Crosshair
var atlas_tex : AtlasTexture
var frame = 0
var frame_size = Vector2(128, 128)
var frames_per_row = 5   
var total_frames = 25    
var frame_time = 0.08     # seconds per frame
var time_accum = 0.0

func _ready():
	atlas_tex = crosshair.texture as AtlasTexture

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

extends Control
@onready var crosshair = $Crosshair
var atlas_tex : AtlasTexture
@onready var timer_label = $Panel/ColorRect/TimerLabel
@onready var health_label = $HealthBar/Label

@export var secondsTimer : Timer
@export var minutesTimer: Timer
var seconds : int = 60 
var minutes : int = 29
var wave : int = 1
var max_wave : int = 30

var frame = 0
var frame_size = Vector2(128, 128)
var frames_per_row = 5   
var total_frames = 25    
var frame_time = 0.08     # seconds per frame
var time_accum = 0.0



func _ready():
	atlas_tex = crosshair.texture as AtlasTexture
	secondsTimer.start()
	minutesTimer.start()
	print(timer_label.text)
	pass
	
	

func _process(delta):
	health_label.text = (str(PlayerVariables.player_health) + "/100")
	
	
	time_accum += delta
	if time_accum >= frame_time:
		
		time_accum = 0.0
		frame = (frame + 1) % total_frames
		
		#_update_frame()

func _update_frame():
	var x = (frame % frames_per_row) * frame_size.x
	var y = int(frame / frames_per_row) * frame_size.y
	atlas_tex.region = Rect2(Vector2(x, y), frame_size)
	
	
func _on_seconds_timer_timeout() -> void:
	seconds -= 1
	if minutes >= 10:
		if seconds >= 10:
			print(str(minutes),":", str(seconds))
			timer_label.text = (str(minutes) + ":" + str(seconds))
		elif seconds < 10:
			print(str(minutes),":", "0" + str(seconds))
			timer_label.text = (str(minutes) + ":" + "0" + str(seconds))
	elif minutes < 10:
		if seconds >= 10:
			print("0" + str(minutes),":", str(seconds))
			timer_label.text = ("0" + str(minutes) + ":" + str(seconds))
		elif seconds < 10:
			print("0" + str(minutes),":", "0" + str(seconds))
			timer_label.text = ("0" + str(minutes) + ":" + "0" + str(seconds))
	

func _on_minutes_timer_timeout() -> void:
	minutes -= 1 
	seconds = 60  
	

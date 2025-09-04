extends Node3D

signal current_wave

@onready var player = $VentoPlayer
@export var secondsTimer : Timer
@export var minutesTimer: Timer 
var seconds : int = 60 
var minutes : int = 29
var wave : int = 1
var max_wave : int = 30
func _ready():
	secondsTimer.start()
	minutesTimer.start()
	pass

func _on_seconds_timer_timeout() -> void:
	seconds -= 1
	if minutes >= 10:
		if seconds >= 10:
			print(str(minutes),":", str(seconds))
		elif seconds < 10:
			print(str(minutes),":", "0" + str(seconds))
	elif minutes < 10:
		if seconds >= 10:
			print("0" + str(minutes),":", str(seconds))
		elif seconds < 10:
			print("0" + str(minutes),":", "0" + str(seconds))
	

func _on_minutes_timer_timeout() -> void:
	minutes -= 1 
	seconds = 60  
	wave = max_wave - minutes
	print(wave)
	current_wave.emit(wave)
	
	
####
func _physics_process(delta: float) -> void:
	get_tree().call_group("enemy", "update_target_location", player.global_transform.origin)



			

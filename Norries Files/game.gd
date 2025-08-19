extends Node
@export var secondsTimer : Timer
@export var minutesTimer: Timer 
var seconds : int = 60 
var minutes : int = 29
func _ready():
	secondsTimer.start()
	minutesTimer.start()
func _on_countdown_timer_timeout() -> void:
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
	

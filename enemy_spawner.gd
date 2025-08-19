extends Node3D

@export var yeti_scene: PackedScene
@export var spawnpoints : Node3D
@onready var mob_spawns: int = spawnpoints.get_child_count()
var type = "Yeti"

func _ready() -> void:
	prepare_spawn()

func _on_yeti_timer_timeout() -> void:
	#if yeti_scene:
	pass
		#var yeti_instance = yeti_scene.instantiate()
		#add_child(yeti_instance)


func prepare_spawn():
	var mob_amount = 10
	var mob_wait_time: float = 2.0
	print ("mob amount ", mob_amount)
	var mob_spawn_rounds = mob_amount/mob_spawns
	spawn_type(type, mob_spawn_rounds, mob_wait_time)

func spawn_type(type, mob_spawn_rounds, mob_wait_time):
	if type == "Yeti":
		var yeti_spawn1 = $"../Spawnpoints/Spawn1"
		var yeti_spawn2 = $"../Spawnpoints/Spawn2"
		var yeti_spawn3 = $"../Spawnpoints/Spawn3"
		var yeti_spawn4 = $"../Spawnpoints/Spawn4"
		for i in mob_spawn_rounds:
			print("i")
			var yeti1 = yeti_scene.instantiate()
			yeti1.global_position = yeti_spawn1.global_position
			var yeti2 = yeti_scene.instantiate()
			yeti2.global_position = yeti_spawn2.global_position
			var yeti3 = yeti_scene.instantiate()
			yeti3.global_position = yeti_spawn3.global_position
			var yeti4 = yeti_scene.instantiate()
			yeti4.global_position = yeti_spawn4.global_position
			add_child(yeti1)
			add_child(yeti2)
			add_child(yeti3)
			add_child(yeti4)
			mob_spawn_rounds -= 1
			await get_tree().create_timer(mob_wait_time).timeout
			
		

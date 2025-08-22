extends Node3D

@export var player: CharacterBody3D
@export var yeti_scene: PackedScene
@export var spawnpoints : Node3D
@onready var mob_spawns: int = spawnpoints.get_child_count()
var type = "Yeti"
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	prepare_spawn()

func _on_yeti_timer_timeout() -> void:
	#if yeti_scene:
	pass
		#var yeti_instance = yeti_scene.instantiate()
		#add_child(yeti_instance)


func prepare_spawn():
	var mob_amount = 4
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

		for i in range(4):
			var yeti1 = yeti_scene.instantiate()
			var spawn = rng.randi_range(1,4)
			add_child(yeti1)
			if spawn == 1:
				yeti1.global_position = yeti_spawn1.global_position
			elif spawn == 2:
				yeti1.global_position = yeti_spawn2.global_position
			elif spawn == 3:
				yeti1.global_position = yeti_spawn3.global_position
			elif spawn == 4:
				yeti1.global_position = yeti_spawn4.global_position
			#assign them!!!
			player.highlight_enemy.connect(Callable(yeti1, "_on_player_highlight_enemy"))
			player.deal_damage.connect(Callable(yeti1, "_on_player_deal_damage"))			
			await get_tree().create_timer(mob_wait_time).timeout
			
		

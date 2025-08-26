extends Node3D
var current_wave = null
var area = null
@export var player: CharacterBody3D


@export var yeti_scene: PackedScene
@export var yeti_ranger_scene : PackedScene

@export var spawnpoints : Node3D
@onready var mob_spawns: int = spawnpoints.get_child_count()
var type = "Yeti"
var rng = RandomNumberGenerator.new()


func _process(delta: float) -> void:
	print(current_wave)
	if Input.is_action_just_pressed("debug_m_key"):
		_on_current_wave_changed(1)
	

func _on_current_wave_changed(wave) -> void:
	current_wave = wave
	if current_wave < 10:
		area = 1 
	elif current_wave < 20:
		area = 2 
	elif current_wave > 20: 
		area = 3 
	prepare_spawn(current_wave)


func _on_yeti_timer_timeout() -> void:
	#if yeti_scene:
	pass
		#var yeti_instance = yeti_scene.instantiate()
		#add_child(yeti_instance)

func prepare_spawn(current_wave):
	if current_wave == 1:
		spawn_logic(30, "Yeti", 0.75, "Yeti Ranger", 0.25, null, 0, null, 0, area)
	elif current_wave == 2:
		spawn_logic(50, "Yeti", 0.75, "Yeti Ranger", 0.25, null, 0, null, 0, area)
	elif current_wave == 3: 
		spawn_logic(50, "Yeti", 0.75, "Yeti Ranger", 0.25, null, 0, null, 0, area)
	elif current_wave == 4: 
		spawn_logic(50, "Yeti", 0.75, "Yeti Ranger", 0.25, null, 0, null, 0, area)
	elif current_wave == 5: 
		spawn_logic(50, "Yeti", 0.75, "Yeti Ranger", 0.25, null, 0, null, 0, area)
		
	else:
		print("what")

func spawn_logic(mob_amount, mob1_type, mob1_weight, mob2_type, mob2_weight, mob3_type, mob3_weight, mob4_type, mob4_weight, area):
	var wave = current_wave
	var spawn_location_amount = null
	
	var spawn1
	var spawn2 
	var spawn3 
	var spawn4
	if area == 1:
		spawn1 = $"../Spawnpoints/Spawn1"
		spawn2 = $"../Spawnpoints/Spawn2"
		spawn3 = $"../Spawnpoints/Spawn3"
		spawn4 = $"../Spawnpoints/Spawn4"
		spawn_location_amount = 4
	else:
		"HUH"
	
	var mob1 = assign_mob(mob1_type)
	var mob2 = assign_mob(mob2_type)
	var mob3 = assign_mob(mob3_type)
	var mob4 = assign_mob(mob4_type)
	
	var mob1_amount = floor(mob_amount * mob1_weight)
	var mob2_amount = floor(mob_amount * mob2_weight)
	var mob3_amount = floor(mob_amount * mob3_weight)
	var mob4_amount = floor(mob_amount * mob4_weight)
	
	var mob_wait_time : float = mob_amount/60
	print(mob_wait_time)
	
	while current_wave == wave:
		var mob_spawned = rng.randi_range(1,4)
		if mob_spawned == 1:
			if mob1_amount != 0:
				add_child(mob1)
				player.highlight_enemy.connect(Callable(mob1, "_on_player_highlight_enemy"))
				player.deal_damage.connect(Callable(mob1, "_on_player_deal_damage"))
				var spawn = rng.randi_range(1,spawn_location_amount)
				if spawn == 1:
					mob1.global_position = spawn1.global_position
				elif spawn == 2:
					mob1.global_position = spawn2.global_position
				elif spawn == 3:
					mob1.global_position = spawn3.global_position
				elif spawn == 4:
					mob1.global_position = spawn4.global_position
				await get_tree().create_timer(mob_wait_time).timeout
		if mob_spawned == 2:			
			if mob2_amount != 0:
				add_child(mob2)
				player.highlight_enemy.connect(Callable(mob2, "_on_player_highlight_enemy"))
				player.deal_damage.connect(Callable(mob2, "_on_player_deal_damage"))
				var spawn = rng.randi_range(1,spawn_location_amount)
				if spawn == 1:
					mob2.global_position = spawn1.global_position
				elif spawn == 2:
					mob2.global_position = spawn2.global_position
				elif spawn == 3:
					mob2.global_position = spawn3.global_position
				elif spawn == 4:
					mob2.global_position = spawn4.global_position
				await get_tree().create_timer(mob_wait_time).timeout
		if mob_spawned == 3:			
			if mob3_amount != 0:
				add_child(mob3)
				player.highlight_enemy.connect(Callable(mob3, "_on_player_highlight_enemy"))
				player.deal_damage.connect(Callable(mob3, "_on_player_deal_damage"))
				var spawn = rng.randi_range(1,spawn_location_amount)
				if spawn == 1:
					mob3.global_position = spawn1.global_position
				elif spawn == 2:
					mob3.global_position = spawn2.global_position
				elif spawn == 3:
					mob3.global_position = spawn3.global_position
				elif spawn == 4:
					mob3.global_position = spawn4.global_position
				await get_tree().create_timer(mob_wait_time).timeout
		if mob_spawned == 4:		
			if mob4_amount != 0:
				add_child(mob4)
				player.highlight_enemy.connect(Callable(mob3, "_on_player_highlight_enemy"))
				player.deal_damage.connect(Callable(mob3, "_on_player_deal_damage"))
				var spawn = rng.randi_range(1,spawn_location_amount)
				if spawn == 1:
					mob4.global_position = spawn1.global_position
				elif spawn == 2:
					mob4.global_position = spawn2.global_position
				elif spawn == 3:
					mob4.global_position = spawn3.global_position
				elif spawn == 4:
					mob4.global_position = spawn4.global_position
				await get_tree().create_timer(mob_wait_time).timeout
					
			else:
				pass
			
	
	

func assign_mob(mob_type):
	if mob_type == "Yeti":
		return yeti_scene.instantiate() 
	elif mob_type == "Yeti Ranger":
		return yeti_ranger_scene.instantiate()
	else:
		return null

# deprecated 
		

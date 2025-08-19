extends CharacterBody3D
var max_health := 40.0
var health := max_health
const SPEED = 2.0
const TURN_SPEED = 4.0
const GRAVITY = 9.8
@onready var mesh = $MeshInstance3D

@export var white_material: Material
@export var red_material: Material
@onready var shader_material = mesh.material_overlay

@onready var navigation_agent : NavigationAgent3D = $NavigationAgent3D
@onready  var target : CharacterBody3D = $"../player"


func _physics_process(delta: float) -> void:
	var current_location = global_transform.origin
	var next_location = navigation_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	velocity = new_velocity
	move_and_slide()
	
	
	
func update_target_location(target_location):
	navigation_agent.set_target_position(target_location)





func _process(delta: float) -> void:
	if health <= 0:
		self.queue_free()
	
		
func _on_player_deal_damage(hit, damage) -> void:
	if hit == self:
		print("meow meow meow i have been hit!!!")
		health -= damage
		var brightness = clamp(health / max_health, 0.0, 1.0)
		shader_material.set_shader_parameter("outline_brightness", brightness)
			


func _on_player_highlight_enemy(hit) -> void:
	if hit == self:
		print("I am being highlighted.")
		shader_material.set_shader_parameter("outline_onoff", 1.0)
	else:
		shader_material.set_shader_parameter("outline_onoff", 0.0)
		

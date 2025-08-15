extends CharacterBody3D
var max_health := 100.0
var health := max_health
const SPEED = 5.0
const TURN_SPEED = 4.0
const GRAVITY = 9.8
@onready var mesh = $MeshInstance3D

@export var white_material: Material
@export var red_material: Material
@onready var shader_material = mesh.material_overlay

@onready var navigation_agent : NavigationAgent3D = $NavigationAgent3D
var player = null

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y = GRAVITY * delta
	else:
		velocity.y -= 2
	
	navigation_agent.set_target_position(player.global_position)
	
	if navigation_agent.is_navigation_finished():
		
		print("done")
		return
	
	var next_position: Vector3 = navigation_agent.get_next_path_position()
	print(next_position)
	velocity = global_position.direction_to(next_position) * SPEED
	move_and_slide()
	





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
		

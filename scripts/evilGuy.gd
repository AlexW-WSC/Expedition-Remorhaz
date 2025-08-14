extends CharacterBody3D
var health = 1000
const SPEED = 5.0
@onready var player = get_node("/root/Node3D/player")
@onready var mesh = $MeshInstance3D

@export var white_material: Material
@export var red_material: Material
func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()


func _process(delta: float) -> void:
	if health <= 0:
		self.queue_free()
		
func _on_player_deal_damage(hit, damage) -> void:
	if hit == self:
		print("meow meow meow i have been hit!!!")
		health -= damage
		mesh.material_override = red_material
		await get_tree().create_timer(0.1).timeout
		mesh.material_override = white_material
			
			

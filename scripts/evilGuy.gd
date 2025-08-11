extends CharacterBody3D

const SPEED = 5.0
@onready var player = get_node("/root/Node3D/player")

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	
	var player_pos = player.global_transform.origin
	velocity.x = move_toward(player_pos.x,0, SPEED * delta)
	velocity.z = move_toward(player_pos.z, 0, SPEED * delta)

	move_and_slide()

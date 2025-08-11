extends CharacterBody3D


const SPEED = (100 / 20)
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 500
func _process(delta: float) -> void:
	
	if $ability1Cooldown.time_left == 0:
		$ability1CooldownDisplay.hide()
	else:
		$ability1CooldownDisplay.show()
		$ability1CooldownDisplay.text = str(round($ability1Cooldown.time_left))
	

var ability1Usable = true
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle Abilities
	if Input.is_action_just_pressed("q") and ability1Usable == true:
		print("Rawr Ability1")
		velocity.y = JUMP_VELOCITY
		ability1Usable = false
		$ability1Cooldown.start()
		
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / SENSITIVITY
		$cameraPivot.rotation.x -= event.relative.y / SENSITIVITY
		$cameraPivot.rotation.x = clamp($cameraPivot.rotation.x,deg_to_rad(-80),deg_to_rad(80))


func _on_ability_1_cooldown_timeout() -> void:
	ability1Usable = true

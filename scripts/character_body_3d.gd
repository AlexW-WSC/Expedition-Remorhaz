extends CharacterBody3D

signal deal_damage
@warning_ignore("unused_signal")
signal highlight_enemy

const SPEED = (100 / 20)
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 500
var max_bullets_in_mag = 6
var bullets_in_mag = 6
var ability_1_usable = true

var last_highlighted = null
#timers 
@export var ability_1_cooldown_timer: Timer 
@export var reload_timer: Timer
#labels
@export var ability_1_cooldown_display: Label
@export var bullet_display: Label

@export var crosshair_raycast: RayCast3D

@onready var target = self

func reload_weapon():
	if bullets_in_mag != max_bullets_in_mag:
		reload_timer.start()
		await reload_timer.timeout
		await get_tree().create_timer(0.1).timeout
		bullets_in_mag = max_bullets_in_mag
		ability_1_usable = true
		reload_timer.stop()
		
		

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	

func _process(delta: float) -> void:
	if ability_1_cooldown_timer.time_left == 0:
		ability_1_cooldown_display.hide()
	else:
		ability_1_cooldown_display.show()
		ability_1_cooldown_display.text = str(round(ability_1_cooldown_timer.time_left))
		
	bullet_display.text = (str(bullets_in_mag) + "/" + str(max_bullets_in_mag))

func _physics_process(delta: float) -> void:
	if crosshair_raycast.is_colliding() == true:
		var hit = crosshair_raycast.get_collider()
		if hit != last_highlighted:
			emit_signal("highlight_enemy", hit)
			last_highlighted = hit
			print(hit)
	else:
		if last_highlighted:
			emit_signal("highlight_enemy", null)
			last_highlighted = null
		

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle Abilities
	
	if Input.is_action_just_pressed("r") and reload_timer.is_stopped() == true:
		reload_weapon()
		
	
	if Input.is_action_pressed("m1") and ability_1_usable == true and reload_timer.is_stopped() == true:
		if bullets_in_mag >= 1:
			print("rawr, primary")
			bullets_in_mag -= 1
			ability_1_usable = false
			ability_1_cooldown_timer.start()
			if crosshair_raycast.is_colliding():
				print("colliding")
				var hit = crosshair_raycast.get_collider()
				emit_signal("deal_damage", hit, 10)
		else:
			reload_weapon()
		
	
	if Input.is_action_just_pressed("lshift"):
		print("Rawr Ability2")
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("q"):
		print("Rawr Ability3")
		
	if Input.is_action_just_pressed("e"):
		print("Rawr Ability4")
		
	
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
		$CameraPivot.rotation.x -= event.relative.y / SENSITIVITY
		$CameraPivot.rotation.x = clamp($CameraPivot.rotation.x,deg_to_rad(-80),deg_to_rad(80))


func _on_ability_1_cooldown_timeout() -> void:
	ability_1_usable = true


	

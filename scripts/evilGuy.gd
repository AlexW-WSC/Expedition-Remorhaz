extends CharacterBody3D
var max_health := 40.0
var health := max_health
var melee_attack_damage := 5.0
const SPEED = 2.0
const TURN_SPEED = 4.0
const GRAVITY = 9.8

signal damage_player

var attacking : bool = false
var sees_player : bool = false
var ai_mode = 1

var player_in_hurtbox = false
var can_attack : bool = true
var hurtbox_enabled : bool = false
var attack_windup : float = 0.3
var attack_duration : float = 0.3
var attack_winddown : float = 0.3
var attack_cooldown : float = 10
@onready var hurtbox = $Hurtbox
@onready var hurtbox_mesh = $Hurtbox/MeshInstance3D
@onready var cooldown_timer = $AttackCooldown

@onready var mesh = $MeshInstance3D
var rng = RandomNumberGenerator.new()

var outline_shader_code := """
shader_type spatial;
render_mode cull_front, unshaded;

uniform float outline_width = 5.0;
uniform float outline_onoff = 0.0;
uniform float outline_brightness = 1.0;


const vec3 dark_red = vec3(0.0, 0.0, 0.0);
const vec3 bright_red = vec3(1.0, 0.0, 0.0);

void vertex() {
	vec4 clip_position = PROJECTION_MATRIX * (MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
	vec3 clip_normal = mat3(PROJECTION_MATRIX) * (mat3(MODELVIEW_MATRIX) * NORMAL);

	vec2 offset = normalize(clip_normal.xy) / VIEWPORT_SIZE * clip_position.w * outline_width * 2.0;

	clip_position.xy += offset;

	POSITION = clip_position;
}

void fragment() {
	if (outline_onoff > 0.5) {
		vec3 color = mix(dark_red, bright_red, outline_brightness);
		ALBEDO = color;

		ALPHA = 1.0;
	}
	else {
		discard;
	}
}

"""

@onready var shader_material : ShaderMaterial

@onready var navigation_agent : NavigationAgent3D = $NavigationAgent3D
@onready var area_3d : Area3D = $Area3D
var player : Node3D

func _ready() -> void:
	print(self)
	# Create new Shader resource and assign code
	var shader = Shader.new()
	shader.code = outline_shader_code
	shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	mesh.material_overlay = shader_material


func _physics_process(delta: float) -> void:
	var locked_rotation_y = rotation.y
	var current_location = global_transform.origin
	var next_location = navigation_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	velocity = new_velocity
	
	var pos2d : Vector2 = Vector2(global_position.x, global_position.z)
	var path_pos2d : Vector2 = Vector2(navigation_agent.get_next_path_position().x, navigation_agent.get_next_path_position().z)
	var direction = (pos2d - path_pos2d)
	rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.y), delta / 0.3)
	if attacking == false:
		move_and_slide()
	elif attacking == true:
		rotation.y = locked_rotation_y
	
	if hurtbox_enabled == true:
		if hurtbox.overlaps_body(player):
			emit_signal("damage_player", melee_attack_damage)
			hurtbox_enabled = false
	

	
	
func update_target_location(target_location):
	if sees_player == true and can_attack == true:
		navigation_agent.set_target_position(target_location)
	
	elif can_attack == false or sees_player == false:
		move_randomly()
	
		
func move_randomly():
	#if can_attack == true:
		if navigation_agent.is_navigation_finished() == true:
			if ai_mode == 1:
				navigation_agent.set_target_position(NavigationServer3D.map_get_random_point(navigation_agent.get_navigation_map(), 1, true))
			else:
				navigation_agent.set_target_position(self.global_position)
				await get_tree().create_timer(rng.randf_range(1,4)).timeout
			ai_mode = rng.randi_range(1,3)
	#elif can_attack == false:
		# write some shit for dist at some point!!
		

func melee_attack() -> void: 
	attacking = true
	navigation_agent.set_target_position(self.global_position)
	await get_tree().create_timer(attack_windup).timeout
	print("wound up")
	hurtbox_enabled = true
	var red_color = hurtbox_mesh.get_active_material(0)
	red_color.albedo_color = Color(0,0,255)
	
	await get_tree().create_timer(attack_duration).timeout
	red_color.albedo_color = Color(255,0,0)
	hurtbox_enabled = false
	print("done attack ^-^")
	await get_tree().create_timer(attack_winddown).timeout
	attacking = false
	can_attack = false
	cooldown_timer.start()

func _process(delta: float) -> void:
	if player_in_hurtbox == true and can_attack == true:
		melee_attack()
		
	if health <= 0:
		self.queue_free()
	
		
func _on_player_deal_damage(hit, damage) -> void:
	print("hit:", hit, "self:", self)
	if hit == self:
		print("meow meow meow i have been hit!!!")
		health -= damage
		var brightness = clamp(health / max_health, 0.0, 1.0)
		shader_material.set_shader_parameter("outline_brightness", brightness)
			


func _on_player_highlight_enemy(hit) -> void:
	if hit == self:
		print("I am being highlighted:", self)
		shader_material.set_shader_parameter("outline_onoff", 1.0)
	else:
		shader_material.set_shader_parameter("outline_onoff", 0.0)
		

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		sees_player = true
		print('WOAH there buddy')


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		sees_player = false
		print("i have to tell yopu somethingggg")
		


func _on_hurtbox_body_entered(body: Node3D) -> void:
	if player == body:
		print("meow meow meow meow meow meow ")
		player_in_hurtbox = true
		
		
func _on_hurtbox_body_exited(body: Node3D) -> void:
	player_in_hurtbox = false



func _on_attack_cooldown_timeout() -> void:
	can_attack = true

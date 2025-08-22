extends CharacterBody3D
var max_health := 40.0
var health := max_health
const SPEED = 2.0
const TURN_SPEED = 4.0
const GRAVITY = 9.8

@onready var mesh = $MeshInstance3D

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
@onready var target : CharacterBody3D = null
@onready var navigation_agent : NavigationAgent3D = $NavigationAgent3D
@onready var player : CharacterBody3D = $player
@onready var area_3d : Area3D = $Area3D

func _ready() -> void:
	print(self)
	# Create new Shader resource and assign code
	var shader = Shader.new()
	shader.code = outline_shader_code
	shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	mesh.material_overlay = shader_material


func _physics_process(delta: float) -> void:
	
	var current_location = global_transform.origin
	var next_location = navigation_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	velocity = new_velocity
	move_and_slide()
	
	
	
func update_target_location(target_location):
	if target != null:
		navigation_agent.set_target_position(target_location)
		print("kjkjhiu")
	else:
		navigation_agent.set_target_position(self.global_position)

func _process(delta: float) -> void:
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
		target = body
		print('WOAH there buddy')


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		target = null
		print("i have to tell yopu somethingggg")

@tool
extends MeshInstance3D

@export var wave_amplitude := 0.5
@export var wave_frequency := 2.0
@export var wave_speed := 1.0
@onready var water_view: SubViewport = $"../SubViewport"
@onready var ocean_surface: MeshInstance3D = $"../OceanSurface"
var noise_texture:Texture2D
var wave_scale
var wave_strength
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mat :ShaderMaterial= ocean_surface.get_surface_override_material(0)
	noise_texture = mat.get_shader_parameter("noise_texture")
	wave_scale = mat.get_shader_parameter("wave_scale")
	wave_strength = mat.get_shader_parameter("wave_strength")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func get_wave_height_at(uv: Vector2,_delta) -> float:
	var pos = uv
	var noise_value = noise_texture.get_image().get_pixel(pos.x,pos.y).r;
	var wave = sin(pos.x * 0.2 + pos.y * 0.2 + _delta + noise_value * 10.0) * wave_strength;
	return wave

func _process(delta):
	var pos_2d = Vector2(self.global_position.x,self.global_position.z)
	var height = get_wave_height_at(pos_2d,delta)
	self.position.y=height*100

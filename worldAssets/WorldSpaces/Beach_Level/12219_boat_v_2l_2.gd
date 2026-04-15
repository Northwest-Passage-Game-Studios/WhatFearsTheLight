extends MeshInstance3D
@onready var spot_light_3d: SpotLight3D = $CSGSphere3D/SpotLight3D
@onready var csg_sphere_3d: CSGSphere3D = $CSGSphere3D
var flickering:=false
@onready var timer: Timer = $Timer
@onready var flicker_timer: Timer = $flickerTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if flickering:
		csg_sphere_3d.visible=randi_range(0,9)==1
	else:
		csg_sphere_3d.visible=true


func _on_timer_timeout() -> void:
	timer.start(randf_range(1.0,7.0))
	flickering=true
	flicker_timer.start(randf_range(0.1,0.9))


func _on_flicker_timer_timeout() -> void:
	flickering=false

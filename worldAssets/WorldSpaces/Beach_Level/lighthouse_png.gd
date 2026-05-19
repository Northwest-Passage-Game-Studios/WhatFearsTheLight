extends Sprite3D
@onready var csg_cylinder_3d_2: CSGCylinder3D = $CSGCylinder3D2

@onready var spot_light_3d: SpotLight3D = $SpotLight3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	csg_cylinder_3d_2.rotation_degrees.y+=1
	

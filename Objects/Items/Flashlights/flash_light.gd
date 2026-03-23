extends Item

var is_broken:=false

@onready var shape_cast_3d: ShapeCast3D = $ShapeCast3D
@onready var spot_light_3d: SpotLight3D = $SpotLight3D




func _process(delta: float) -> void:
	if spot_light_3d.visible==true:
		if shape_cast_3d.is_colliding():
			var obj :Node3D= shape_cast_3d.get_collider(0)

			if obj is wendigo:
				obj.spook()
	

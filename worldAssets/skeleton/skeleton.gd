extends Node3D
@onready var physical_bone_simulator_3d: PhysicalBoneSimulator3D = $rig/Skeleton3D/PhysicalBoneSimulator3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	physical_bone_simulator_3d.physical_bones_start_simulation()
	await get_tree().create_timer(1.5).timeout
	physical_bone_simulator_3d.physical_bones_stop_simulation()

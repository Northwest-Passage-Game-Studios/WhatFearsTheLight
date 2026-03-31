extends Node3D
@onready var skeleton_3d: Skeleton3D = $Skeleton3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if animation_player.current_animation=="freakoBeako":
		var upper=skeleton_3d.find_bone("ValveBiped.Bip01_Spine4")
		skeleton_3d.set_bone_pose_rotation(upper,Quaternion(randi_range(-15,15),randi_range(-15,15),randi_range(-15,15),randi_range(-15,15)))

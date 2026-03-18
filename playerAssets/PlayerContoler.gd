extends CharacterBody3D

@onready var neck: Node3D = $Neck

var mous_sen =0.2


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		neck.rotate_y(-event.relative.x*0.01)
		var pitch_rotate = neck.rotation_degrees.x - event.relative.y* mous_sen
		var new_pitch = clampf(pitch_rotate,-90,90)

		neck.rotation_degrees.x=new_pitch

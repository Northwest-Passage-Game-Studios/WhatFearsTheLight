extends CharacterBody3D

@onready var neck: Node3D = $Neck

var mous_sen =0.2


var speed = 5.0
const JUMP_VELOCITY = 4.5

func _physics_process(delta: float) -> void:
	var inputDirX = Input.get_axis("A", "D")
	var inputDirY = Input.get_axis("W", "S")
	var walkDir = Vector3(inputDirX, 0, inputDirY).rotated(Vector3.UP, neck.rotation.y)
	
	if Input.is_action_pressed("shift"):
		speed=8.5
	else:
		if Input.is_action_pressed("ctrl"):
			speed=3.0
		else:
			speed=5.0
	
	velocity.x = walkDir.x * speed
	velocity.z = walkDir.z * speed
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		neck.rotate_y(-event.relative.x*0.01)
		var pitch_rotate = neck.rotation_degrees.x - event.relative.y* mous_sen
		var new_pitch = clampf(pitch_rotate,-90,90)

		neck.rotation_degrees.x=new_pitch

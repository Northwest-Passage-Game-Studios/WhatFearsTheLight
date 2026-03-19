extends CharacterBody3D
@onready var standing_collision_box: CollisionShape3D = $standingCollisionBox
@onready var crouching_collision_box: CollisionShape3D = $crouchingCollisionBox

@onready var neck: Node3D = $Neck

var baseSpeed:=2.5
var crouchSpeed:=0.75
var sprintSpeed:=5.5
var sprinting:=false
var jumpStrength:=7.0

var mous_sen =0.2
@export var gravity:=0.4
@onready var crouch_ray_cast: RayCast3D = $crouchRayCast

var crouching:=false
var crouchTweening:=0

var speed = 5.0
const JUMP_VELOCITY = 4.5

func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	
	#Jump code, not sure if I want to keep it or not. :/
	if Input.is_action_just_pressed("jump") && is_on_floor() && crouchTweening==0:
		velocity.y+=jumpStrength
		if jumpStrength>1:
			jumpStrength-=2
		else:
			jumpStrength=1
	if jumpStrength<7:
		jumpStrength+=0.03
	
	
	if crouchTweening==2 && speed>crouchSpeed:
		speed=crouchSpeed
	standing_collision_box.disabled=crouching
	crouching_collision_box.disabled=!crouching
	
	
	var inputDirX = Input.get_axis("A", "D")
	var inputDirY = Input.get_axis("W", "S")
	var walkDir = Vector3(inputDirX, 0, inputDirY).rotated(Vector3.UP, neck.rotation.y)
	if Input.is_action_just_pressed("ctrl"):
		if !crouching && crouchTweening==0:
			var runtween = get_tree().create_tween()
			runtween.tween_property(self, "speed", crouchSpeed, 0.25).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
			crouching=true
			crouchTweening=1
			var crtween = get_tree().create_tween()
			crtween.tween_property(neck, "position", Vector3(neck.position.x,neck.position.y-0.65,neck.position.z), 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
			await crtween.finished
			crouchTweening=2			
		elif  crouching && crouchTweening==2:
			if !crouch_ray_cast.is_colliding():
				var runtween = get_tree().create_tween()
				runtween.tween_property(self, "speed", baseSpeed, 0.45).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
				crouching=false
				crouchTweening=3
				var crtween2 = get_tree().create_tween()
				crtween2.tween_property(neck, "position", Vector3(neck.position.x,neck.position.y+0.65,neck.position.z), 0.35).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
				await crtween2.finished
				crouchTweening=0
				if Input.is_action_pressed("shift"):
					sprinting=true
					var runtween2 = get_tree().create_tween()
					runtween2.tween_property(self, "speed", sprintSpeed, 0.5).set_ease(Tween.EASE_IN)
	else:
		if Input.is_action_pressed("shift"):
			if !sprinting:
				sprinting=true
				if crouchTweening==0:
					var runtween = get_tree().create_tween()
					runtween.tween_property(self, "speed", sprintSpeed, 1.0).set_ease(Tween.EASE_IN)
				
		else:
			sprinting=false
			if crouchTweening==0:
				var runtween = get_tree().create_tween()
				runtween.tween_property(self, "speed", baseSpeed, 0.25).set_ease(Tween.EASE_IN)
			else:
				var runtween = get_tree().create_tween()
				runtween.tween_property(self, "speed", crouchSpeed, 0.25).set_ease(Tween.EASE_IN)
	
	velocity.x = walkDir.x * speed
	velocity.z = walkDir.z * speed
	if !is_on_floor():
		if velocity.y>-20:
			velocity.y-=gravity
	else:
		if velocity.y<0:
			velocity.y=0
	
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		neck.rotate_y(-event.relative.x*0.01)
		var pitch_rotate = neck.rotation_degrees.x - event.relative.y* mous_sen
		var new_pitch = clampf(pitch_rotate,-90,90)

		neck.rotation_degrees.x=new_pitch

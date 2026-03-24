class_name player_body extends CharacterBody3D


@onready var standing_collision_box: CollisionShape3D = $standingCollisionBox
@onready var crouching_collision_box: CollisionShape3D = $crouchingCollisionBox
@onready var camera_3d: Camera3D = $Neck/Camera3D
@onready var crouch_ray_cast: RayCast3D = $crouchRayCast
@onready var crouch_ray_cast_2: RayCast3D = $crouchRayCast2
@onready var crouch_ray_cast_3: RayCast3D = $crouchRayCast3
@onready var crouch_ray_cast_4: RayCast3D = $crouchRayCast4
@onready var neck: Node3D = $Neck
@onready var crouch_delay: Timer = $crouchDelay
@onready var armature: Node3D = $Armature
@onready var hands_clone_transform: RemoteTransform3D = $Neck/RemoteTransform3D
@onready var left_ik_marker: Marker3D = $LeftIKMarker
@onready var right_ik_maker: Marker3D = $RightIKMaker
@onready var right_arm_ik: JacobianIK3D = $Armature/Skeleton3D/RightArmIK
@onready var left_arm_ik: JacobianIK3D = $Armature/Skeleton3D/LeftArmIK
@onready var backpack: BackPack = $Backpack
@onready var flashlight_overheat_timer: Timer = $flashlightOverheatTimer
@onready var spot_light_3d: SpotLight3D = $Armature/Skeleton3D/BoneAttachment3D/FlashLight/SpotLight3D


@export_category("Walk Settings")
@export var baseSpeed:=2.5
@export var crouchSpeed:=0.75
@export var sprintSpeed:=5.5
@export var staminaMax:=6.0
@export_category("Jumping & Gravity")
@export var jumpStrength:=7.0
@export var gravity:=0.4
@export_category("Camera Settings")
@export var mous_sen =0.2
@export var head_bob_freq=4
@export var head_bob_amp=0.05
@export var lag_speed:=75
@export_category("Flashlight Settings")
@export var flashlightMaxDurability:=40.0
var flashlightDurability:=0.0

#Hidden Settings
var canStand:=true
var exhausted:=false
var stamina:=6.0
var head_bobtime=0
var crouching:=false
var crouchTweening:=0
var sprinting:=false
var speed = 5.0
const JUMP_VELOCITY = 4.5

func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	flashlightDurability=flashlightMaxDurability


func _head_bob(head_bobtime):
	var head_bob_pos = Vector3.ZERO
	head_bob_pos.y=sin(head_bobtime*head_bob_freq)*head_bob_amp
	head_bob_pos.x=cos(head_bobtime*head_bob_freq/2)*head_bob_amp
	return head_bob_pos

func rotate_head(delta):
	var neck_rotate = neck.global_rotation
	var hands_to_rotate_x = lerp_angle(armature.global_rotation.x,neck_rotate.x,lag_speed*delta)
	var hands_to_rotate_y = lerp_angle(armature.global_rotation.y,neck_rotate.y,lag_speed*delta)
	var hands_to_rotate_z = lerp_angle(armature.global_rotation.z,neck_rotate.z,lag_speed*delta)
	var final_vector=Vector3(hands_to_rotate_x,hands_to_rotate_y,hands_to_rotate_z)
	armature.global_rotation.x=final_vector.x
	armature.global_rotation.y=final_vector.y
func _process(delta: float) -> void:
	rotate_head(delta)
func _physics_process(delta: float) -> void:
	print(flashlightDurability)
	if spot_light_3d.visible:
		flashlightDurability-=1*delta
		if int(flashlightDurability)==25||int(flashlightDurability)==28||int(flashlightDurability)==34:
				spot_light_3d.light_energy=randi_range(8,13)
		if flashlightDurability<20:
			if int(flashlightDurability)%3==0:
				spot_light_3d.light_energy=randi_range(2,5)
				flashlightDurability+=randi_range(-2,2)
			if int(flashlightDurability)%3==1:
				spot_light_3d.light_energy=16
	else:
		if flashlightDurability<flashlightMaxDurability:
			flashlightDurability+=15*delta
		else:
			flashlightDurability=flashlightMaxDurability
	#exhaustion System
	if exhausted:
		baseSpeed=1.0
		crouchSpeed=0.4
	
	#stamina drain
	if stamina<=0:
		exhausted=true
	if !Input.is_action_pressed("shift") || exhausted || crouchTweening!=0:
		if stamina<staminaMax:
			stamina+=1*delta
			if exhausted:
				stamina+=0.25*delta
		else:
			exhausted=false
			baseSpeed=1.75
			crouchSpeed=0.75
	if sprinting && crouchTweening==0:
		if stamina>0:
			stamina-=1*delta
	
	
	#View Bobbing
	if crouchTweening==0:
		head_bob_freq=4
		head_bob_amp=0.05
		head_bobtime += delta*velocity.length()*float(is_on_floor())
		neck.transform.origin=_head_bob(head_bobtime)
	if crouchTweening==2:
		#dont change these it jitter :/
		head_bob_freq=4
		head_bob_amp=0.05
		head_bobtime += delta*velocity.length()*float(is_on_floor())
		neck.transform.origin=_head_bob(head_bobtime)-Vector3(0,0.65,0)
	#Jump code, not sure if I want to keep it or not. :/
	if Input.is_action_just_pressed("jump") && is_on_floor() && crouchTweening==0 && jumpStrength>3 && stamina>1.5 && !exhausted:
		velocity.y+=int(jumpStrength)+1
		stamina-=1
		if sprinting:
			await get_tree().create_timer(0.02).timeout
			velocity.x*=1.5+stamina/10
			velocity.z*=1.5+stamina/10
			stamina-=0.5
		if jumpStrength>1:
			jumpStrength-=2
		else:
			jumpStrength=1
	if jumpStrength<7:
		jumpStrength+=1.5*delta
	
	
	if crouchTweening==2 && speed>crouchSpeed:
		speed=crouchSpeed
	standing_collision_box.disabled=crouching
	crouching_collision_box.disabled=!crouching
	
	
	var inputDirX = Input.get_axis("A", "D")
	var inputDirY = Input.get_axis("W", "S")
	var walkDir = Vector3(inputDirX, 0, inputDirY).rotated(Vector3.UP, neck.rotation.y)
	canStand=!crouch_ray_cast.is_colliding() && !crouch_ray_cast_2.is_colliding() && !crouch_ray_cast_3.is_colliding() && !crouch_ray_cast_4.is_colliding()
	if Input.is_action_just_pressed("ctrl"):
		if !crouching && crouchTweening==0:
			var runtween = get_tree().create_tween()
			runtween.tween_property(self, "speed", crouchSpeed, 0.25).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
			crouching=true
			crouchTweening=1
			var crtween = get_tree().create_tween()
			crtween.tween_property(neck, "position", Vector3(neck.position.x,neck.position.y-0.65,neck.position.z), 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
			await crtween.finished
			await get_tree().create_timer(0.1).timeout
			crouchTweening=2			
		elif  crouching && crouchTweening==2:
			if canStand:
				var runtween = get_tree().create_tween()
				runtween.tween_property(self, "speed", baseSpeed, 0.45).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
				crouching=false
				crouchTweening=3
				var crtween2 = get_tree().create_tween()
				crtween2.tween_property(neck, "position", Vector3(neck.position.x,neck.position.y+0.65,neck.position.z), 0.35).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
				await crtween2.finished
				await get_tree().create_timer(0.1).timeout
				crouchTweening=0
				if Input.is_action_pressed("shift") && stamina>0 && !exhausted:
					sprinting=true
					var runtween2 = get_tree().create_tween()
					runtween2.tween_property(self, "speed", sprintSpeed, 0.5).set_ease(Tween.EASE_IN)
			else:
				crouch_delay.start()
	else:
		if Input.is_action_pressed("shift") && stamina>0 && !exhausted:
			if !sprinting:
				sprinting=true
				if crouchTweening==0:
					var runtween = get_tree().create_tween()
					runtween.tween_property(self, "speed", sprintSpeed, 0.75).set_ease(Tween.EASE_IN)
				
		else:
			
			sprinting=false
			if crouchTweening==0:
				var runtween = get_tree().create_tween()
				runtween.tween_property(self, "speed", baseSpeed, 0.25).set_ease(Tween.EASE_IN)
			else:
				var runtween = get_tree().create_tween()
				runtween.tween_property(self, "speed", crouchSpeed, 0.25).set_ease(Tween.EASE_IN)
	if !crouch_delay.is_stopped():
		if canStand:
			Input.action_press("ctrl")
	if is_on_floor():
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
		neck.rotate_y(-event.relative.x*0.2*get_process_delta_time())
		var pitch_rotate = neck.rotation_degrees.x - event.relative.y* mous_sen*get_process_delta_time()
		var new_pitch = clampf(pitch_rotate,-80,80)

		neck.rotation_degrees.x=new_pitch

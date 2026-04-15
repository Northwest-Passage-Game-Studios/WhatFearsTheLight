class_name blindman extends CharacterBody3D
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

@export var debug_target:Node3D
var target:Node3D
@onready var chase_timer: Timer = $chaseTimer

@export var red_eye_mat:Material
@export var white_eye_mat:Material
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var animation_player: AnimationPlayer = $blindManModel/AnimationPlayer

@onready var shape_cast_3d: ShapeCast3D = $blindManModel/thc4_arma/Skeleton3D/BoneAttachment3D2/CSGSphere3D/SpotLight3D/ShapeCast3D
@onready var spot_light_3d: SpotLight3D = $blindManModel/thc4_arma/Skeleton3D/BoneAttachment3D2/CSGSphere3D/SpotLight3D
@onready var csg_sphere_3d: CSGSphere3D = $blindManModel/thc4_arma/Skeleton3D/BoneAttachment3D2/CSGSphere3D
@onready var csg_sphere_3d_2: CSGSphere3D = $blindManModel/thc4_arma/Skeleton3D/BoneAttachment3D2/CSGSphere3D2
@onready var spot_light_3d_2: SpotLight3D = $blindManModel/thc4_arma/Skeleton3D/BoneAttachment3D2/CSGSphere3D2/SpotLight3D_2


@export_category("Speeds")
@export var chase_speed:=5
@export var wander_speed:=3
@export_category("Looks")
var fall_back_dist:=25
var physics_delta: float
var is_chasing := false
var wanderArea:=Vector3.ZERO
var wanderTarget:=Vector3.ZERO
var wanderMoving:=true
@export var wanderDistance:=10


func Totally_Better_Look_At(target_pos:Vector3):
	var oldRotation:=rotation
	look_at(target_pos)
	self.rotation.x=0
	self.rotation.z=0
	var newRotation:=rotation
	rotation=oldRotation
	var looktween = create_tween()
	looktween.set_trans(Tween.TRANS_SINE)
	looktween.tween_property(self,"rotation",newRotation,0.2)    

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if debug_target!=null:
		target=debug_target
	wanderTarget=Vector3(wanderArea.x+randi_range(-10,10),wanderArea.y,wanderArea.z+randi_range(-10,10))		
func way_point_reached():
	var new_velocity: Vector3
	var next_pos=navigation_agent_3d.get_next_path_position()
	if csg_sphere_3d.material==red_eye_mat:
		Totally_Better_Look_At(next_pos)
	if is_chasing:
		new_velocity = global_position.direction_to(next_pos) * chase_speed
	else:
		Totally_Better_Look_At(next_pos)
		new_velocity = global_position.direction_to(next_pos) * wander_speed
	if navigation_agent_3d.avoidance_enabled:
		navigation_agent_3d.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	velocity=safe_velocity
	move_and_slide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if wanderMoving==true:
		if animation_player.current_animation!="thc4_arma|st_walk":
			animation_player.play("thc4_arma|st_walk")
	else:
		await get_tree().create_timer(0.2).timeout
		if animation_player.current_animation!="thc4_arma|st_idle_howl":
			animation_player.play("thc4_arma|st_idle_howl")
	print(chase_timer.time_left)
	if shape_cast_3d.is_colliding():
		print("GUMMY")
		audio_stream_player_3d.play()
		csg_sphere_3d.material=red_eye_mat
		spot_light_3d.light_color=Color.RED
		csg_sphere_3d_2.material=red_eye_mat
		spot_light_3d_2.light_color=Color.RED
		if animation_player.current_animation!="thc4_arma|str_roar" && !is_chasing:
			animation_player.play("thc4_arma|st_roar")
	if target!=null:
		if is_chasing:
			navigation_agent_3d.target_position=target.position
		else:
			navigation_agent_3d.target_position=wanderTarget
	
func _physics_process(delta: float) -> void:
	physics_delta = delta
	if target!=null:
		way_point_reached()


func navigation_finished() -> void:
	if !is_chasing && wanderMoving:
		#await get_tree().create_timer(0.5).timeout
		wanderMoving=false
		

		


	
	



func _on_chase_timer_timeout() -> void:
	is_chasing=false
	csg_sphere_3d.material=white_eye_mat
	spot_light_3d.light_color=Color.WHITE
	animation_player.play("thc4_arma|st_walk")



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="thc4_arma|st_idle_howl":
			wanderMoving=true
			wanderTarget=Vector3(wanderArea.x+randi_range(-1*wanderDistance,wanderDistance),wanderArea.y,wanderArea.z+randi_range(-1*wanderDistance,wanderDistance))
	if anim_name=="thc4_arma|str_roar":
		animation_player.play("thc4_arma|st_run")
		is_chasing=true
		chase_timer.start()

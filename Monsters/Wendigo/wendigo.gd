class_name wendigo extends CharacterBody3D
@onready var kill_timer: Timer = $Kill_Timer
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

@onready var csg_sphere_3d: CSGSphere3D = $the_angel_reference_skeleton/Skeleton3D/BoneAttachment3D/CSGSphere3D
@onready var left_eye_light: SpotLight3D = $the_angel_reference_skeleton/Skeleton3D/BoneAttachment3D/CSGSphere3D/SpotLight3D
@onready var csg_sphere_3d_2: CSGSphere3D = $the_angel_reference_skeleton/Skeleton3D/BoneAttachment3D/CSGSphere3D2
@onready var right_eye_light: SpotLight3D = $the_angel_reference_skeleton/Skeleton3D/BoneAttachment3D/CSGSphere3D2/SpotLight3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var skeleton_3d: Skeleton3D = $the_angel_reference_skeleton/Skeleton3D
var ready4SpookyTimes:=false
@onready var stickBreakSound:=preload("res://Sounds/SoundEffects/661841__rslebs__stick-breaking-softly.wav")
@onready var bushRustleSound:=preload("res://Sounds/SoundEffects/735081__debsound__bush-hedge-thicket-short.wav")
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var footstep_player: AudioStreamPlayer3D = $footstepPlayer
@onready var footstep_interval: Timer = $footstepInterval

@export var debug_target:Node3D
var target:Node3D

@export_category("Speeds")
@export var chase_speed:=10
@export var revsere_speed:=20
@export_category("Looks")
@export var red_eye_mat:Material
@export var white_eye_mat:Material
var fall_back_dist:=25
var physics_delta: float
var is_chasing := false
var is_red_eye := (randi_range(0,2)==2)
var is_spooked :=false
var maxAnxiety:=randf_range(1.0,2.6)
var anxiety:=0.0
var uprotation:=0.0
func Totally_Better_Look_At(target_pos:Vector3):
	look_at(target_pos)
	self.rotation.x=0
	self.rotation.z=0
	pass

func clac_spook_point():
	look_at(target.global_position)
	self.rotation.x=0
	self.rotation.z=0
	var back_angle:=self.rotation.y+180
	var pos_x := 50*cos(back_angle)
	var pos_z := 50*sin(back_angle)
	var return_point:=Vector3(pos_x,0,pos_z)
	return return_point

# Called when the node enters the scene tree for the first time.
func set_target(target_node:Node3D):
	target=target_node
	kill_timer.start()



func _ready() -> void:
	if stickBreakSound!=null:
		if randi_range(0,1)==0:
			audio_stream_player_3d.stream=stickBreakSound
		else:
			audio_stream_player_3d.stream=bushRustleSound
		audio_stream_player_3d.pitch_scale=randf_range(0.8,1.9)
		audio_stream_player_3d.play()
	anxiety=maxAnxiety
	if debug_target!=null:
		target=debug_target
	if not is_red_eye:
		kill_timer.start(5.0)
		csg_sphere_3d.material=white_eye_mat
		csg_sphere_3d_2.material=white_eye_mat
		left_eye_light.light_color=Color.WHITE
		right_eye_light.light_color=Color.WHITE
	else:
		csg_sphere_3d.material=red_eye_mat
		csg_sphere_3d_2.material=red_eye_mat
		left_eye_light.light_color=Color.RED
		right_eye_light.light_color=Color.RED
		kill_timer.start(7.0)
	await get_tree().create_timer(1.0).timeout
	ready4SpookyTimes=true
func way_point_reached():
	var new_velocity: Vector3
	var next_pos=navigation_agent_3d.get_next_path_position()
	if is_chasing:
		Totally_Better_Look_At(next_pos)
		new_velocity = global_position.direction_to(next_pos) * chase_speed
	elif is_spooked:
		Totally_Better_Look_At(target.position)
		new_velocity = (global_position.direction_to(next_pos) * revsere_speed)
		new_velocity*=-1
		new_velocity.y=0
	if navigation_agent_3d.avoidance_enabled:
		navigation_agent_3d.set_velocity(new_velocity)
	_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	velocity=safe_velocity
	move_and_slide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target!=null:
		if is_chasing:
			navigation_agent_3d.target_position=target.position
			animation_player.play("the_angel_reference_skeleton|0200")
		if is_spooked:
			csg_sphere_3d.visible=false
			csg_sphere_3d_2.visible=false
			navigation_agent_3d.target_position=target.position

			
	
func _physics_process(delta: float) -> void:
	if is_chasing:
		pass
	physics_delta = delta
	if target!=null:
		if is_chasing or is_spooked:
			way_point_reached()
		else:
			Totally_Better_Look_At(target.global_position)
			

func _on_kill_timer_timeout() -> void:
	if !is_red_eye:
		is_chasing=true
		footstep_interval.start()
		await get_tree().create_timer(4.0).timeout
		is_chasing=false
		is_spooked=true
		footstep_interval.start()
		animation_player.play_backwards("the_angel_reference_skeleton|0200")
		await get_tree().create_timer(4.0).timeout
		queue_free()
	else:
		is_spooked=true
		footstep_interval.start()
		animation_player.play_backwards("the_angel_reference_skeleton|0200")
		await get_tree().create_timer(4.0).timeout
		queue_free()

func spook():
	if !is_spooked:
		anxiety-=0.01
		if is_red_eye:
			anxiety-=0.03
			uprotation=randf_range(-2.0*(1-anxiety/maxAnxiety),2.0*(1-anxiety/maxAnxiety))
		else:
			uprotation=randf_range(-1*(1-anxiety/maxAnxiety),(1-anxiety/maxAnxiety))
		var upper=skeleton_3d.find_bone("ValveBiped.Bip01_Spine4")
		skeleton_3d.set_bone_pose_rotation(upper,Quaternion(uprotation,uprotation+rotation.x,uprotation+rotation.y,uprotation+rotation.z+(4*PI)))
	if !kill_timer.is_stopped():
		if ready4SpookyTimes:
			kill_timer.start(0.7)
	if is_chasing==false and kill_timer.is_stopped()==false and is_spooked==false && anxiety<0:
		if !is_red_eye:
			footstep_interval.start()
			kill_timer.stop()
			is_chasing=false
			is_spooked=true
			animation_player.play_backwards("the_angel_reference_skeleton|0200")
			await get_tree().create_timer(4.0).timeout
			queue_free()
		else:
			footstep_interval.start()
			is_chasing=true
			kill_timer.stop()
			await get_tree().create_timer(4.0).timeout
			is_chasing=false
			is_spooked=true
			footstep_interval.start()
			animation_player.play_backwards("the_angel_reference_skeleton|0200")
			await get_tree().create_timer(4.0).timeout
			queue_free()


func navigation_finished() -> void:
	if is_spooked:
		queue_free()


func _on_footstep_interval_timeout() -> void:
	footstep_player.play()
	footstep_player.pitch_scale=randf_range(0.8,1.2)
	footstep_interval.start()


func _on_player_kill_trigger_body_entered(body: Node3D) -> void:
	if body is player_body:
		body.murdered("Wendigo")

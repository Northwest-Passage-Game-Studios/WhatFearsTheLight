class_name blindman extends CharacterBody3D
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var keeper_model: Node3D = $KeeperModel
@onready var animater: AnimationPlayer = $Animater

@export var debug_target:Node3D
var target:Node3D
@onready var anger_timer: Timer = $angerTimer
@onready var chase_timer: Timer = $chaseTimer
@onready var csg_sphere_3d: CSGSphere3D = $KeeperModel/CSGSphere3D
@onready var spot_light_3d: SpotLight3D = $KeeperModel/CSGSphere3D/SpotLight3D
@export var red_eye_mat:Material
@export var white_eye_mat:Material
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D


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
@onready var shape_cast_3d: ShapeCast3D = $KeeperModel/CSGSphere3D/ShapeCast3D

func Totally_Better_Look_At(target_pos:Vector3):
	look_at(target_pos)
	self.rotation.x=0
	self.rotation.z=0


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
	print(chase_timer.time_left)
	if shape_cast_3d.is_colliding():
		audio_stream_player_3d.play()
		csg_sphere_3d.material=red_eye_mat
		spot_light_3d.light_color=Color.RED
		animater.play("RESET")
		if anger_timer.is_stopped():
			wanderArea=target.global_position
			anger_timer.start()
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
		if keeper_model!=null:
			keeper_model.freeze()
		wanderMoving=false
		await get_tree().create_timer(1.0).timeout
		animater.play("search")
		


	
	


func _on_animater_animation_finished(anim_name: StringName) -> void:
	if anim_name=="search":
		if keeper_model!=null:
			keeper_model.freeze()
			wanderMoving=true
			wanderTarget=Vector3(wanderArea.x+randi_range(-1*wanderDistance,wanderDistance),wanderArea.y,wanderArea.z+randi_range(-1*wanderDistance,wanderDistance))


func _on_chase_timer_timeout() -> void:
	is_chasing=false
	csg_sphere_3d.material=white_eye_mat
	spot_light_3d.light_color=Color.WHITE

func _on_anger_timer_timeout() -> void:
	is_chasing=true
	
	chase_timer.start()
	

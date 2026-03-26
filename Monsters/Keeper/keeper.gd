class_name keeper extends CharacterBody3D
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var keeper_model: Node3D = $KeeperModel

@export var debug_target:Node3D
var target:Node3D

@export_category("Speeds")
@export var chase_speed:=10
@export var revsere_speed:=2
@export_category("Looks")
var fall_back_dist:=25
var physics_delta: float
var is_chasing := true
var is_red_eye =false
var is_spooked :=false

func Totally_Better_Look_At(target_pos:Vector3):
	if is_chasing:
		look_at(target_pos)
		self.rotation.x=0
		self.rotation.z=0
		pass

func clac_spook_point():
	var back_angle:=self.rotation.y*-1
	var pos_x := 25*sin(back_angle)
	var pos_z := 25*cos(back_angle)
	var return_point:=Vector3(pos_x,0,pos_z)
	return return_point

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if debug_target!=null:
		target=debug_target
		
func way_point_reached():
	var new_velocity: Vector3
	var next_pos=navigation_agent_3d.get_next_path_position()
	if is_chasing:
		Totally_Better_Look_At(next_pos)
		new_velocity = global_position.direction_to(next_pos) * chase_speed
	if navigation_agent_3d.avoidance_enabled:
		navigation_agent_3d.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	velocity=safe_velocity
	move_and_slide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target!=null:
		if is_chasing:
			navigation_agent_3d.target_position=target.position
	
func _physics_process(delta: float) -> void:
	physics_delta = delta
	if target!=null:
		if is_chasing or is_spooked:
			way_point_reached()
		else:
			Totally_Better_Look_At(target.global_position)
			

func _on_kill_timer_timeout() -> void:
	is_chasing=true


func navigation_finished() -> void:
	if is_spooked:
		queue_free()


func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	is_chasing=false
	if keeper_model!=null:
		keeper_model.freeze()

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	is_chasing=true
	if keeper_model!=null:
		keeper_model.unfreeze()
	
	

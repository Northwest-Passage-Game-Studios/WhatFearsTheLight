class_name wendigo extends CharacterBody3D
@onready var kill_timer: Timer = $Kill_Timer
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D


@export var target:Node3D
@export var move_speed:=5

var physics_delta: float
var is_chasing := false
var is_red_eye =false
var is_spooked :=false

func Totally_Better_Look_At(target_pos:Vector3):
	look_at(target_pos)
	self.rotation.x=0
	self.rotation.z=0
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	navigation_agent_3d.target_position=target.position
	if not is_red_eye:
		kill_timer.wait_time=3
	else:
		kill_timer.wait_time=1
	kill_timer.start()
func way_point_reached():

	var next_pos=navigation_agent_3d.get_next_path_position()
	Totally_Better_Look_At(next_pos)
	var new_velocity: Vector3 = global_position.direction_to(next_pos) * 6
	if navigation_agent_3d.avoidance_enabled:
		navigation_agent_3d.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	velocity=safe_velocity
	move_and_slide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if navigation_agent_3d.target_position!=Vector3.ZERO:
		navigation_agent_3d.target_position=target.position
	
func _physics_process(delta: float) -> void:
	physics_delta = delta
	if is_chasing:
		way_point_reached()

	else:
		Totally_Better_Look_At(target.global_position)
func _on_kill_timer_timeout() -> void:
	is_chasing=true
	
func spook():
	if is_chasing==false and kill_timer.is_stopped()==false and is_spooked==false:
		kill_timer.stop()
		is_chasing=false
		is_spooked=true

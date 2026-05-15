extends Node3D

@onready var quest: SubViewport = $Quest

@onready var control: SubViewport = $PuaseMenu
const FAKE_CURSOR = preload("res://UI/fake_cursor.tres")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var canClose:=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Input.mouse_mode=Input.MOUSE_MODE_CONFINED_HIDDEN
	Input.set_custom_mouse_cursor(FAKE_CURSOR)
	Manager.allow_looking=false
	Manager.allow_moving=false

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _input(event: InputEvent) -> void:
	pass
	if event is InputEventMouse:
		control.push_input(event)
		quest.push_input(event)
func _process(delta: float) -> void:
	if canClose:
		if Input.is_action_just_pressed("escape"):
			animation_player.play("closeBook")
			control.get_mouse_position()
func _on_resume_pressed() -> void:
	animation_player.play("closeBook")
	control.get_mouse_position()
	


func _on_save_pressed() -> void:
	Save_Handler._on_timer_timeout()
	


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="closeBook":
		Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
		Manager.allow_looking=true
		Manager.allow_moving=true
		queue_free()
	if anim_name=="openBook":
		canClose=true


func _on_static_body_3d_mouse_entered() -> void:
	print("entered")

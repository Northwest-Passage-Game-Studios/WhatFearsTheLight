extends Node3D

@onready var control: SubViewport = $Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	Manager.allow_looking=false
	Manager.allow_moving=false

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		control.push_input(event,true)

func _process(delta: float) -> void:
	pass
func _on_resume_pressed() -> void:
	print("Resume  ")
	control.get_mouse_position()
	


func _on_save_pressed() -> void:
	Save_Handler._on_timer_timeout()
	


func _on_quit_pressed() -> void:
	get_tree().quit()

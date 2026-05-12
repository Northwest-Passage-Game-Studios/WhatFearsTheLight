extends Node3D
var currentSel:=""
@onready var resume_label: Label3D = $topHalf/resumeLabel
@onready var save_label: Label3D = $topHalf/saveLabel
@onready var quit_label: Label3D = $topHalf/quitLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	Manager.allow_looking=false
	Manager.allow_moving=false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(currentSel)
	if currentSel=="res":
		resume_label.outline_modulate=Color.YELLOW
		if Input.is_action_just_pressed("pick_up"):
			game_resumed()
			print("game resumed!")
	if currentSel=="save":
		save_label.outline_modulate=Color.YELLOW
		if Input.is_action_just_pressed("pick_up"):
			pass
	if currentSel=="quit":
		quit_label.outline_modulate=Color.YELLOW
		if Input.is_action_just_pressed("pick_up"):
			get_tree().quit()	


func _on_resume_col_mouse_entered() -> void:
	currentSel="res"



func _on_save_col_mouse_entered() -> void:
	currentSel="save"



func _on_quit_col_mouse_entered() -> void:
	currentSel="quit"


func _on_resume_col_mouse_exited() -> void:
	currentSel=""
	quit_label.outline_modulate=Color(0.0, 0.0, 0.0, 0.0)
	save_label.outline_modulate=Color(0.0, 0.0, 0.0, 0.0)
	resume_label.outline_modulate=Color(0.0, 0.0, 0.0, 0.0)

func game_resumed() -> void:
	animation_player.play_backwards("openBook")

extends SubViewport
@onready var static_Body: CharacterBody2D = $Control/StaticBody2D
@onready var v_separator: VBoxContainer = $Control/VSeparator
@onready var texture_button: AnimatedSprite2D = $Control/StaticBody2D/TextureButton


func _input(event:InputEvent):
	if event is InputEventMouseMotion :
		pass
	

func _ready():
	for child in v_separator.get_children():
		if child is Button:
			child.mouse_entered.connect(_on_focus_entered)
			child.mouse_exited.connect(_on_focus_extied)
#
func _process(delta: float) -> void:
	static_Body.position=get_viewport().get_mouse_position()
	static_Body.move_and_slide()

#
			#
#
func _on_focus_entered():

	texture_button.play("Select")
func _on_focus_extied():

	texture_button.play("move")

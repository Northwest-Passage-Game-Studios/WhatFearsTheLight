extends SubViewport
@onready var texture_button: AnimatedSprite2D = $Control/TextureButton
@onready var v_separator: VBoxContainer = $Control/VSeparator



func _process(delta: float) -> void:
	texture_button.position=get_viewport().get_mouse_position()
	for child in v_separator.get_children():
		if child is Button:
			child.mouse_entered.connect(_on_focus_entered)
			child.mouse_exited.connect(_on_focus_extied)
			

func _on_focus_entered():
	print("entered")
	texture_button.play("Select")
func _on_focus_extied():
	print("exited")
	texture_button.play("move")

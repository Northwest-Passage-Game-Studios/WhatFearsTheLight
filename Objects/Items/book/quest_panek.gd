extends Viewport
@onready var texture_button: AnimatedSprite2D = $Control/TextureButton

@onready var v_separator: VBoxContainer = $Control/ScrollContainer/VSeparator
const QUEST_LABEL = preload("res://Objects/Items/book/Quest_Labek.tscn")

func opened_book():
	var quest = Quest_Manger.get_all_quests()
	for dict in quest:
		var new_label:Label = QUEST_LABEL.instantiate()
		new_label.text=dict["Title"]
		v_separator.add_child(new_label)
		if dict["Is_Completed"]:
			print("Hello")
func _process(delta: float) -> void:
	texture_button.position=get_viewport().get_mouse_position()

func _ready() -> void:
	opened_book()
	
func _on_focus_entered():
	print("entered")
	texture_button.play("Select")
func _on_focus_extied():
	print("exited")
	texture_button.play("move")

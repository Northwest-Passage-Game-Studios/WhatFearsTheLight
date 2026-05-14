extends Viewport
@onready var texture_button: AnimatedSprite2D = $Control/TextureButton

@onready var v_separator: VBoxContainer = $Control/ScrollContainer/VSeparator
const QUEST_LABEK = preload("uid://4yyoocmc61av")

func opened_book():
	var quest = Quest_Manger.get_all_quests()
	for dict in quest:
		var new_label:Label = QUEST_LABEK.instantiate()
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

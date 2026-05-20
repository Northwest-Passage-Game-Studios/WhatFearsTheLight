extends Viewport
@onready var texture_button: AnimatedSprite2D = $CanvasLayer2/Control/TextureButton/TextureButton

@onready var v_separator: VBoxContainer = $CanvasLayer2/Control/ScrollContainer/VSeparator
const QUEST_LABEL = preload("res://Objects/Items/book/Quest_Labek.tscn")
@onready var control: Control = $Control
const PROTEST_REVOLUTION_REGULAR = preload("uid://swrd57gvrc8t")

func opened_book():
	var quest = Quest_Manger.get_all_quests()
	for dict in quest:
		var new_label:RichTextLabel = QUEST_LABEL.instantiate()
		v_separator.add_child(new_label)
		new_label.push_color(Color.BLACK)
		new_label.push_font_size(32)
		new_label.push_font(PROTEST_REVOLUTION_REGULAR)
		if dict["Is_Completed"]:
			new_label.push_strikethrough(Color.BLACK)
		new_label.add_text(dict["Title"])
		new_label.pop_all()
		v_separator.add_child(new_label)
			

func _process(delta: float) -> void:
	#texture_button.position=get_viewport().get_mouse_position()
	pass
func _ready() -> void:
	opened_book()
	
func _on_focus_entered():

	texture_button.play("Select")
func _on_focus_extied():

	texture_button.play("move")


func _on_panel_mouse_exited() -> void:
	print("mouse left quest_pannel")

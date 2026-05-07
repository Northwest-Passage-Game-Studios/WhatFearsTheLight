extends Node3D
const SAVE_FILE_UI = preload("uid://c8ukrkmbiuhqu")
@onready var save_box: VBoxContainer = $CanvasLayer/Control/Load_Panel/ScrollContainer/VBoxContainer
@onready var load_panel: Panel = $CanvasLayer/Control/Load_Panel
@onready var enter_name: Panel = $CanvasLayer/Control/EnterName
@onready var text_edit: TextEdit = $CanvasLayer/Control/EnterName/TextEdit
@onready var play: Button = $CanvasLayer/Control/Play
@onready var load: Button = $CanvasLayer/Control/Load

@onready var black: TextureRect = $CanvasLayer/Control/Black
@export var end_color:Color
func _on_play_pressed() -> void:
	Save_Handler.current_save_file=save_file.new()
	play.visible=false
	load.visible=false
	load_panel.visible=false
	enter_name.visible=true

func _ready() -> void:
	_populate_load_screen()
	var fade_out_tween = create_tween()
	fade_out_tween.tween_property(black,"modulate",end_color,2)

func _populate_load_screen():
	for save:save_file in Save_Handler.save_files:
		var save_ui :save_slot_ui= SAVE_FILE_UI.instantiate()
		save_box.add_child(save_ui)
		save_ui.current_save_file=save


func _on_load_pressed() -> void:
	load_panel.visible=!load_panel.visible


func _on_button_pressed() -> void:
	Save_Handler.current_save_file.save_name=text_edit.text
	get_tree().change_scene_to_file("res://worldAssets/WorldSpaces/Open_Scene/Main_Sence.tscn")

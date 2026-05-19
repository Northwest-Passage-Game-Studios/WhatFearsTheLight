extends Node3D
const SAVE_FILE_UI = preload("uid://c8ukrkmbiuhqu")
@onready var save_box: VBoxContainer = $CanvasLayer/Control/Load_Panel/ScrollContainer/VBoxContainer
@onready var load_panel: Panel = $CanvasLayer/Control/Load_Panel
@onready var enter_name: Panel = $CanvasLayer/Control/EnterName
@onready var text_edit: TextEdit = $CanvasLayer/Control/EnterName/TextEdit
@onready var play: Button = $CanvasLayer/Control/VBoxContainer/Play
@onready var load: Button = $CanvasLayer/Control/VBoxContainer/Load
@onready var accept_dialog: AcceptDialog = $CanvasLayer/Control/AcceptDialog
@onready var button_contanor: VBoxContainer = $CanvasLayer/Control/VBoxContainer
@onready var cursor: AnimatedSprite2D = $CanvasLayer/Cursor
@onready var settings: Panel = $CanvasLayer/Control/Settings

@onready var black: TextureRect = $CanvasLayer/Control/Black
@export var end_color:Color

var empty_cursor_texture = preload("res://UI/fake_cursor.tres")

func _on_play_pressed() -> void:
	Save_Handler.current_save_file=save_file.new()
	Save_Handler.current_save_file.save_ver=Save_Handler.current_save_verison
	play.visible=false
	load.visible=false
	load_panel.visible=false
	enter_name.visible=true

func _ready() -> void:
	_populate_load_screen()
	var fade_out_tween = create_tween()
	fade_out_tween.tween_property(black,"modulate",end_color,2)
	Input.set_custom_mouse_cursor(empty_cursor_texture)
	for child in get_tree().get_nodes_in_group("is_focus_botton"):
		if child is Button:
			child.mouse_entered.connect(_on_focus_entered)
			child.mouse_exited.connect(_on_focus_extied)
		if child is TextEdit:
			child.mouse_entered.connect(_on_input_enter)
			child.mouse_exited.connect(_on_focus_extied)
		if child is save_slot_ui:
			child.button.mouse_entered.connect(_on_focus_entered)
			child.button.mouse_exited.connect(_on_focus_extied)
func _populate_load_screen():
	for save:save_file in Save_Handler.save_files:
		var save_ui :save_slot_ui= SAVE_FILE_UI.instantiate()
		save_box.add_child(save_ui)
		save_ui.current_save_file=save
		save_ui.error_on_load.connect(_error_on_load)
		save_ui.add_to_group("is_focus_botton")

func _process(delta: float) -> void:
	cursor.position=get_viewport().get_mouse_position()
	
func _on_focus_entered():

	cursor.play("select")
func _on_focus_extied():
	cursor.play("move")
func _on_input_enter():
	Input.set_custom_mouse_cursor(empty_cursor_texture,Input.CURSOR_IBEAM)
	cursor.play("input_text")
func _on_load_pressed() -> void:
	settings.visible=false
	load_panel.visible=!load_panel.visible


func _on_button_pressed() -> void:
	Save_Handler.current_save_file.save_name=text_edit.text
	get_tree().change_scene_to_file("res://worldAssets/WorldSpaces/Open_Scene/Main_Sence.tscn")

func _error_on_load(error:Error):
	
	if error==30:
		accept_dialog.popup_centered()
		


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	load_panel.visible=false
	settings.visible=!load_panel.visible


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://worldAssets/WorldSpaces/Credits/credits.tscn")

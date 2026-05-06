extends Node3D

@onready var black: TextureRect = $CanvasLayer/Control/Black
@export var end_color:Color
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://worldAssets/WorldSpaces/Open_Scene/Main_Sence.tscn")
	Save_Handler.current_save_file=save_file.new()

func _ready() -> void:
	var fade_out_tween = create_tween()
	fade_out_tween.tween_property(black,"modulate",end_color,2)

extends Node2D

@export var starting_mod :Color
@export var ending_mod :Color

@onready var control: Control = $CanvasLayer/Control


func _ready() -> void:
	for child in control.get_children():
		if child is Control:
			child.modulate=starting_mod
			child.visible=true
			var color_tween_in = create_tween()
			color_tween_in.tween_property(child,"modulate",ending_mod,1)
			await color_tween_in.finished
			await get_tree().create_timer(1).timeout
			var color_tween_out = create_tween()
			color_tween_out.tween_property(child,"modulate",starting_mod,1)
			await color_tween_out.finished
	get_tree().change_scene_to_file("res://worldAssets/WorldSpaces/MainMenu/main_menu.tscn")

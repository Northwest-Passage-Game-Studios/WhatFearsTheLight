extends Node3D


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://worldAssets/WorldSpaces/Open_Scene/Main_Sence.tscn")

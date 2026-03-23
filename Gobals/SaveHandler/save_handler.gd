class_name SaveHandler extends Node


var save_dict ={}

func _save():
	save_dict["Current_Scene"]=get_tree().current_scene

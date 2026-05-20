class_name World_Spaces extends Node3D

@export var player:player_body

func _ready() -> void:
	Save_Handler._write_file()

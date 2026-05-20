class_name World_Spaces extends Node3D

@export var player:player_body

func _ready() -> void:
	Save_Handler._write_file()
	player.played_died.connect(_player_died)

func _player_died(thing:String):
	if thing=="Wendigo":
		await get_tree().create_timer(0.2).timeout
		get_tree().change_scene_to_file("res://Monsters/Wendigo/wendigo_jumpscare.tscn")
	if thing=="WendigoR":
		await get_tree().create_timer(0.2).timeout
		get_tree().change_scene_to_file("res://Monsters/Wendigo/wendigo_jumpscare_red.tscn")
	if thing=="Blindman":
		await get_tree().create_timer(0.2).timeout
		get_tree().change_scene_to_file("res://Monsters/BlindMan/blindman_jumpscare.tscn")

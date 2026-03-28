extends Node3D


@onready var player: player_body = $Player
@onready var key: Object_PickUp_Point = $key



@export var starting_tool :PackedScene

var find_key_quest_ref_id:int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#Adds the Starting Tool
	player.tool_handler.pick_up_item(starting_tool)
	
	#Starts_Debug_key_finding_Quest
	find_key_quest_ref_id=Quest_Manger.add_new_quest(key.global_position,"Find the Key","Find the key")


func _on_key_picked_up() -> void:
	Quest_Manger.mark_quest_completed(find_key_quest_ref_id)

extends Node3D

var grasse=preload("res://worldAssets/grass/WAVEYgrass.tscn")
var treee=preload("res://worldAssets/treees/tree.tscn")
@onready var player: player_body = $Player
@onready var key: Object_PickUp_Point = $key
@onready var grass_contair: Node3D = $grassContair
@onready var tree_container: Node3D = $treeContainer
@onready var reference_point: Node3D = $referencePoint



@export var starting_tool :PackedScene

var find_key_quest_ref_id:int


func _make_world() -> void:
	for x in range(50):
		for z in range(50):
			var grasInst=grasse.instantiate()
			grass_contair.add_child(grasInst)
			grasInst.global_position.y=reference_point.global_position.y
			grasInst.global_position.x=reference_point.global_position.x+20*x
			grasInst.global_position.z=reference_point.global_position.z+20*z
			
			
	for x in range(100):
		for z in range(100):
			var tree=treee.instantiate()
			tree_container.add_child(tree)
			tree.global_position.y=reference_point.global_position.y
			tree.global_position.x=reference_point.global_position.x+10*x+randi_range(-30,30)
			tree.global_position.z=reference_point.global_position.z+10*z+randi_range(-30,30)
			tree.scale*=randf_range(0.9,2.1)
			tree.rotation.y=randf_range(0,360)




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_make_world()
	#Adds the Starting Tool
	player.tool_handler.pick_up_item(starting_tool)
	
	#Starts_Debug_key_finding_Quest
	find_key_quest_ref_id=Quest_Manger.add_new_quest(key.global_position,"Find the Key","Find the key")

func _on_key_picked_up() -> void:
	Quest_Manger.mark_quest_completed(find_key_quest_ref_id)

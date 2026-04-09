extends Node3D

var grasse=preload("res://worldAssets/grass/WAVEYgrass.tscn")

@onready var player: player_body = $Player
@onready var key: Object_PickUp_Point = $Key_1/gate_key
@onready var grass_contair: Node3D = $grassContair
@onready var tree_container: Node3D = $treeContainer
@onready var reference_point: Node3D = $referencePoint
@onready var ground: MeshInstance3D = $Ground
@onready var gate_static_body_3d: Door_Interact = $brick_wall_gate/StaticBody3D


@onready var navigation_region_3d: NavigationRegion3D = $NavigationRegion3D



@export var starting_tool :PackedScene

#quest stage points
var quest_stage_one_ref_id:int=-1# find the gate
var quest_stage_two_ref_id:int=-1 # find the key for the gate
var quest_stage_three_ref_id:int=-1 #Open the gate

func _make_world() -> void:
	for x in range(-25,25,1):
		for z in range(-25,25,1):
			var grasInst=grasse.instantiate()
			grass_contair.add_child(grasInst)
			grasInst.global_position.y=reference_point.global_position.y
			grasInst.global_position.x=reference_point.global_position.x+20*x
			grasInst.global_position.z=reference_point.global_position.z+20*z
			
			
	#for x in range(0,100,2):
		#for z in range(0,100,2):
			#var tree=treee.instantiate()
			#tree_container.add_child(tree)
			#tree.global_position.y=reference_point.global_position.y
			#tree.global_position.x=reference_point.global_position.x+10*x+randi_range(-30,30)
			#tree.global_position.z=reference_point.global_position.z+10*z+randi_range(-30,30)
			#tree.scale*=randf_range(0.9,2.1)
			#tree.rotation.y=randf_range(0,360)

func _handle_quest(quest:Dictionary):
	if quest["Ref_ID"]==quest_stage_two_ref_id:
		await get_tree().create_timer(4).timeout
		quest_stage_three_ref_id=Quest_Manger.add_new_quest("Find the gate key","None",Quest_Manger.Quest_Type.Smiple_Marker)
		Quest_Manger.set_quest_marker(quest_stage_three_ref_id,gate_static_body_3d.global_position)
		

	
func bake_nav_mesh():
	var nav_mesh :=NavigationMesh.new()
	var baker := NavigationMeshSourceGeometryData3D.new()
	NavigationServer3D.bake_from_source_geometry_data(nav_mesh,baker)
	return nav_mesh
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_make_world()
	#Adds the Starting Tool
	player.tool_handler.pick_up_item(starting_tool,false)
	Quest_Manger.Quest_Completed.connect(_handle_quest)
	#Starts_Forset_key_finding_Quest
	quest_stage_one_ref_id=Quest_Manger.add_new_quest("Find the way out of the forset","None",Quest_Manger.Quest_Type.Just_Text)

	
	


func _on_static_body_3d_opened() -> void:
	pass # Replace with function body.


func _on_static_body_3d_tried_to_open() -> void:
	if Quest_Manger.get_quest(quest_stage_one_ref_id)["Is_Completed"]==false:
		Quest_Manger.mark_quest_completed(quest_stage_one_ref_id)
		await get_tree().create_timer(4).timeout
		quest_stage_two_ref_id=Quest_Manger.add_new_quest("Find the gate key","None",Quest_Manger.Quest_Type.Smiple_Item_Fetch)
		Quest_Manger.add_mutiple_item(quest_stage_two_ref_id,[key])


func _on_gate_key_picked_up() -> void:
	if Quest_Manger.get_quest(quest_stage_one_ref_id)["Is_Completed"]==false:
		Quest_Manger.mark_quest_completed(quest_stage_one_ref_id)
		await get_tree().create_timer(4).timeout
		quest_stage_three_ref_id=Quest_Manger.add_new_quest("Find the gate key","None",Quest_Manger.Quest_Type.Smiple_Marker)
		Quest_Manger.set_quest_marker(quest_stage_three_ref_id,gate_static_body_3d.global_position)

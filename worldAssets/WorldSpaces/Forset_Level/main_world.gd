extends Node3D

var grasse=preload("res://worldAssets/grass/WAVEYgrass.tscn")

@onready var player: player_body = $Player
@onready var key: Object_PickUp_Point = $Key_1/gate_key
@onready var grass_contair: Node3D = $grassContair
@onready var tree_container: Node3D = $treeContainer
@onready var reference_point: Node3D = $referencePoint
@onready var ground: MeshInstance3D = $Ground

@onready var key_2: Object_PickUp_Point = $key2
@onready var key_3: Object_PickUp_Point = $key3
@onready var navigation_region_3d: NavigationRegion3D = $NavigationRegion3D
@onready var gate: Node3D = $Wall/brick_wall_gate


@export var starting_tool :PackedScene

var find_key_quest_ref_id:int


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

func _handle_quest_items(ref_id:int):
	print(ref_id)
	if ref_id==2:
		var Fnd_the_Gate_ref_id=Quest_Manger.add_new_quest("Find the Gate","Find the Gate",Quest_Manger.Quest_Type.Smiple_Marker)
		Quest_Manger.set_quest_marker(Fnd_the_Gate_ref_id,gate.global_position)
	if ref_id==1:
		print("unlocking the gate")

	
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
	player.tool_handler.quest_item_add.connect(_handle_quest_items)
	#Starts_Forset_key_finding_Quest
	find_key_quest_ref_id=Quest_Manger.add_new_quest("Find the Key","Find the key",Quest_Manger.Quest_Type.Smiple_Item_Fetch)
	Quest_Manger.add_item_to_quest(find_key_quest_ref_id,key.global_position,key.Picked_Up)
	
	
	

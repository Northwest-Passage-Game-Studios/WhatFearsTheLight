class_name Object_PickUp_Point extends Node3D

enum Types_Of_Pick {
	Tools,
	Items,
	
}


@export var type_of_item :Types_Of_Pick = Types_Of_Pick.Items
@export var real_item:PackedScene
@export var Quest_item_info:Quest_Object_Info
@export var mesh:MeshInstance3D
const ITEM_GLOW = preload("uid://b6k4dyrs2b0y5")








signal Picked_Up



func call_pick_up(player_ref:player_body):
	if type_of_item == Types_Of_Pick.Tools:
		player_ref.tool_handler.pick_up_item(real_item,true)
		#await player_ref.tool_handler.pick_up_item(real_item)
		await get_tree().create_timer(0.75).timeout
		queue_free()
	elif type_of_item == Types_Of_Pick.Items:
		print(player_ref)
		player_ref.tool_handler.pick_up_object(real_item,Quest_item_info)
		#await player_ref.tool_handler.pick_up_item(real_item)
		await get_tree().create_timer(0.75).timeout
		queue_free()
	Picked_Up.emit()

func show_outline():
	if mesh is MeshInstance3D:
		mesh.material_overlay=ITEM_GLOW

func hide_outline():
	if mesh is MeshInstance3D:
		mesh.material_overlay=null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

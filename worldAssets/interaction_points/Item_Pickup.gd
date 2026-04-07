class_name Object_PickUp_Point extends Node3D

enum Types_Of_Pick {
	Tools,
	Items,
	
}


@export var type_of_item :Types_Of_Pick = Types_Of_Pick.Items
@export var real_item:PackedScene
@export var Quest_item_info:Quest_Object_Info
@export var mesh:MeshInstance3D








signal Picked_Up

func create_outline_mesh(original: MeshInstance3D) -> MeshInstance3D:
	# Duplicate the mesh instance
	var outline_instance := MeshInstance3D.new()
	outline_instance.mesh = original.mesh
	outline_instance.transform = original.transform
	# Create an unshaded material for the outline
	var mat := load("res://Objects/item_Glow.tres")

	# Ensure the outline renders behind the original mesh
	var outline_thickness: float = 0.05       # Scale offset
	outline_instance.material_override=mat
	mat.cull_mode = BaseMaterial3D.CULL_FRONT 
	outline_instance.scale = original.scale * (1.0 + outline_thickness)
	return outline_instance


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
	var outline = mesh.get_child(0)
	if outline is MeshInstance3D:
		outline.show()

func hide_outline():
	var outline = mesh.get_child(0)
	if outline is MeshInstance3D:
		outline.hide()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var outline_mesh:=create_outline_mesh(mesh)
	outline_mesh.hide()
	mesh.add_child(outline_mesh)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

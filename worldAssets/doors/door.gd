class_name Door_Interact extends Node3D

@export var door_mesh:MeshInstance3D
@export var key_id:=1

const ITEM_GLOW = preload("uid://b6k4dyrs2b0y5")

signal tried_to_open
signal opened


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _check_if_open(key_rings:Array[int])->bool:
	for key in key_rings:
		if key==key_id:
			return true
	return false

func try_to_open(key_rings:Array[int]):
	if _check_if_open(key_rings):
		opened.emit()
	else:
		tried_to_open.emit()
	
	
func show_outline():
	if door_mesh is MeshInstance3D:
		door_mesh.material_overlay=ITEM_GLOW
		
func hide_outline():
	if door_mesh is MeshInstance3D:
		door_mesh.material_overlay=null
		

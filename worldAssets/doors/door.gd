class_name Door_Interact extends Node3D

@export var door_mesh:MeshInstance3D

@export_category("Key")
@export var use_key:=false
@export var key_id:=1

@export_category("Animation")
@export var use_ani:bool=false
@export var ani_player:AnimationPlayer
@export var animation_name:String

const ITEM_GLOW = preload("uid://b6k4dyrs2b0y5")

signal tried_to_open
signal opened
signal closed

var is_open:=false

func _open():
	print("hello")
	if not is_open:
		opened.emit()
		if use_ani:
			ani_player.play(animation_name)
		is_open=true
	else:
		closed.emit()
		if use_ani:
			ani_player.play_backwards(animation_name)
		is_open=false

func _tried_to_open():
	tried_to_open.emit()

func _check_if_open(key_rings:Array[int])->bool:
	for key in key_rings:
		if key==key_id:
			return true
	return false

func try_to_open(key_rings:Array[int]):
	if use_key:
		if _check_if_open(key_rings):
			_open()
		else:
			tried_to_open.emit()
	else:
		_open()
	
	
func show_outline():
	if door_mesh is MeshInstance3D:
		door_mesh.material_overlay=ITEM_GLOW
		
func hide_outline():
	if door_mesh is MeshInstance3D:
		door_mesh.material_overlay=null
		

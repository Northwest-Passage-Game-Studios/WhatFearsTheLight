class_name Door_Interact extends StaticBody3D

enum Teleport_Type {
	Point,
	Scene,
	Emit_signal,
	Disabled
}

enum Teleport_Time {
	on_interact,
	on_end
}


@export var door_mesh:MeshInstance3D

@export_category("Key")
@export var use_key:=false
@export var key_id:=1

@export_category("Animation")
@export var use_ani:bool=false
@export var ani_player:AnimationPlayer
@export var animation_name:String
@export_category("Teleport")
@export var teleport_type:Teleport_Type=Teleport_Type.Disabled
@export var teleport_when:Teleport_Time=Teleport_Time.on_interact
@export_category("Teleport_Objects")
@export var teleport_point:Vector3
@export var teleport_scene:PackedScene
@export var thing_to_move:Node3D

const ITEM_GLOW = preload("uid://b6k4dyrs2b0y5")

signal tried_to_open
signal opened
signal closed
signal teleport_signal

var is_open:=false

func _teleport_helper():
	print("Hello")
	if teleport_type!=Teleport_Type.Disabled:
		if teleport_type==Teleport_Type.Emit_signal:
			teleport_signal.emit()
		elif teleport_type==Teleport_Type.Scene:
			get_tree().change_scene_to_packed(teleport_scene)
		elif teleport_type==Teleport_Type.Point:
			thing_to_move.global_position=teleport_point

func _open():
	print("hello")
	if teleport_when==Teleport_Time.on_interact:
		if not is_open:
			_teleport_helper()
			opened.emit()
			if use_ani:
				ani_player.play(animation_name)
			is_open=true
		else:
			_teleport_helper()
			closed.emit()
			if use_ani:
				ani_player.play_backwards(animation_name)
			is_open=false
	elif teleport_when==Teleport_Time.on_end:
		if not is_open:

			opened.emit()
			if use_ani:
				ani_player.play(animation_name)
				ani_player.animation_finished.connect(func(_thing):
					_teleport_helper()
				)
			is_open=true

		else:
			closed.emit()
			if use_ani:
				ani_player.play_backwards(animation_name)
				ani_player.animation_finished.connect(func(_thing):
					_teleport_helper()
				)
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
		

class_name Item extends Node3D


@export_category("Animation")
@export var equip_ani_name:String
@export var dequip_ani_name:String

var _is_on:=false:
	set(value):
		_switched_on()
		_is_on=value

func equip():
	pass

func use_item():
	pass

func _switched_on():
	pass

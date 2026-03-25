class_name Item_Handler extends BoneAttachment3D

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

var items:Array[Item]

var current_item:Item:
	set(new_item):
		if current_item !=null and is_current_item_in_use==true:
			equip()
		else:
			current_item=new_item
		
		
func switch_item_state(value:bool):
	is_current_item_in_use=value

var is_current_item_in_use:=false:
	set(old_value):
		if current_item!=null:
			current_item._is_on=old_value
		is_current_item_in_use=old_value
func _ready() -> void:
	pass
func equip():
	if current_item!=null:
		if is_current_item_in_use==false:
			animation_player.play(current_item.equip_ani_name)
			current_item.equip()
			current_item.show()
		else:
			animation_player.play(current_item.dequip_ani_name)
			current_item.equip()
			await animation_player.animation_finished
			current_item.hide()

func pick_up_item(tool_model:PackedScene):
	var new_tool := tool_model.instantiate()
	add_child(new_tool)
	items.append(new_tool)
	current_item=items.get(items.find(new_tool))
	animation_player.play("pick_up")


func _input(event: InputEvent) -> void:
	if event.is_action("R-Equp") and animation_player.is_playing()==false:
		equip()

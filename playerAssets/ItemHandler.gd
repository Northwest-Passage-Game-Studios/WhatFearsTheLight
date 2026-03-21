class_name Item_Handler extends BoneAttachment3D

@onready var animation_player: AnimationPlayer = $"../../../../AnimationPlayer"

var items:Array[Item]

var current_item:Item

var is_current_item_in_use:=false
func _ready() -> void:
	items.append($FlashLight)
	current_item=items.get(0)
func equip():
	if is_current_item_in_use==false:
		animation_player.play(current_item.equip_ani_name)
		current_item.equip()
		is_current_item_in_use=true
		current_item.show()
	else:
		animation_player.play(current_item.dequip_ani_name)
		current_item.equip()
		is_current_item_in_use=false
		await animation_player.animation_finished
		current_item.hide()

func _input(event: InputEvent) -> void:
	if event.is_action("R-Equp") and animation_player.is_playing()==false:
		equip()

class_name Item_Handler extends BoneAttachment3D

@onready var animation_player: AnimationPlayer = $"../../../../AnimationPlayer"

var items:Array[Item]

var current_item:Item

func _ready() -> void:
	items.append($FlashLight)
	current_item=items.get(0)
func equip():
	animation_player.play(current_item.equip_ani_name)

func _input(event: InputEvent) -> void:
	if event.is_action("R-Equp"):
		equip()

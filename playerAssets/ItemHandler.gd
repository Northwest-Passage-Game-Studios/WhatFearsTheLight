class_name Item_Handler extends BoneAttachment3D

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var object_bone_anchor: BoneAttachment3D = $"../Object_Bone_Anchor"
@onready var tape_recorder_audio_player: AudioStreamPlayer3D = $"../../../TapeRecorderAudioPlayer"


var items:Array[Item]

var quest_objects:Array[Item]
var key_rings:Array[int]=[]

signal quest_item_add(ref_id:int)
signal note_added(note_texture:Texture2D)

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

func pick_up_item(tool_model:PackedScene,Us_Ani:bool=true):
	var new_tool := tool_model.instantiate()
	$Animation_Node.add_child(new_tool)
	items.append(new_tool)
	current_item=items.get(items.find(new_tool))
	if Us_Ani:
		animation_player.play("pick_up")
		await  animation_player.animation_finished
		animation_player.play("RESET")

	return
	
	
func pick_up_object(tool_model:PackedScene,object_info:Quest_Object_Info=Quest_Object_Info.new()):
	var new_tool :Quest_Object= tool_model.instantiate()
	object_bone_anchor.get_node("Animation_Node").add_child(new_tool)
	quest_objects.append(new_tool)
	animation_player.play("pick_up")
	await  animation_player.animation_finished
	animation_player.play(new_tool.pick_up_ani)
	await animation_player.animation_finished
	animation_player.play("RESET")
	if object_info.play_sound:
		tape_recorder_audio_player.stream=object_info.audio_file
		tape_recorder_audio_player.play()
	if object_info.does_emit_signal:
		quest_item_add.emit(object_info.ref_id_emit)
	if object_info.is_key:
		key_rings.append(object_info.key_id)
		
	new_tool.queue_free()
	
	return

func load_note(note_texture:Texture2D):
	note_added.emit(note_texture)

func _input(event: InputEvent) -> void:
	if event.is_action("R-Equp") and animation_player.is_playing()==false:
		equip()

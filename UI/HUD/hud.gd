extends Control
@onready var quest_show_label: Label = $Quest_Show_Label
@onready var debug_pannel: Panel = $DebugPannel
@onready var fade_in: ColorRect = $fadeIn
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var quest_label_display_pos:Vector2
@onready var cross_hair: TextureRect = $TextureRect

@export_category("Crosshair_Textures")
@export var normal_state_texture:Texture2D
@export var intercat_texture:Texture2D



func _on_quest_load(quest:Dictionary):
	quest_show_label.show()
	var text_to_set="Quest Added: "+quest["Title"]
	var move_tween = create_tween()
	move_tween.tween_property(quest_show_label,"text",text_to_set,1)
	await move_tween.finished
	await get_tree().create_timer(1).timeout
	var hide_tween=create_tween()
	hide_tween.tween_property(quest_show_label,"text","",1)
	await hide_tween.finished
	quest_show_label.hide()
	
func _on_quest_completed(quest:Dictionary):
	quest_show_label.show()
	var text_to_set="Quest Completed: "+quest["Title"]
	var move_tween = create_tween()
	move_tween.tween_property(quest_show_label,"text",text_to_set,1)
	await move_tween.finished
	await get_tree().create_timer(1).timeout
	var hide_tween=create_tween()
	hide_tween.tween_property(quest_show_label,"text","",1)
	await hide_tween.finished
	quest_show_label.hide()

func can_intercat(state:bool):
	if state:
		cross_hair.texture=intercat_texture
	else:
		cross_hair.texture=normal_state_texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("fadeIn")
	quest_show_label.hide()
	quest_label_display_pos=quest_show_label.position
	Quest_Manger.Quest_Added.connect(_on_quest_load)
	Quest_Manger.Quest_Completed.connect(_on_quest_completed)
	can_intercat(false)
	if OS.has_feature("debug"):
		debug_pannel.show()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

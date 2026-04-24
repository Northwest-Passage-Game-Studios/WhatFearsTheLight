extends Control
@onready var quest_show_label: Label = $Quest_Show_Label
@onready var debug_pannel: Panel = $DebugPannel
@onready var fade_in: ColorRect = $fadeIn
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var quest_label_display_pos:Vector2
@onready var cross_hair: TextureRect = $TextureRect
@onready var paper_back: TextureRect = $paperBack

@export_category("Crosshair_Textures")
@export var normal_state_texture:Texture2D
@export var intercat_texture:Texture2D
@onready var paper: TextureRect = $Paper

func load_note(note_texture):
	print(note_texture)
	paper.texture=note_texture
	paper_back.visible=true
	Manager.allow_looking=false
	audio_stream_player.pitch_scale=randf_range(0.8,1.5)
	audio_stream_player.play()

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


func _on_item_bone_anchor_note_added(note_texture: Texture2D) -> void:
	load_note(note_texture)
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if paper.texture!=null:
			paper.texture=null
			paper_back.visible=false
			Manager.allow_looking=true
			audio_stream_player.pitch_scale=randf_range(0.5,0.8)
			audio_stream_player.play()

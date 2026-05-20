class_name HUD extends Control



@onready var debug_pannel: Panel = $DebugPannel
@onready var fade_in: ColorRect = $fadeIn
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var start_save_spin: Label = $Start_Save_Spin
@onready var notfication_window: VBoxContainer = $Notfication_Window
@onready var cross_hair: TextureRect = $TextureRect
@onready var paper_back: TextureRect = $paperBack
@onready var text_spin: AnimationPlayer = $Text_Spin



@export_category("Crosshair_Textures")
@export var normal_state_texture:Texture2D
@export var intercat_texture:Texture2D
@onready var paper: TextureRect = $Paper
@export var genderman : Texture2D



const QUEST_SHOW_LABEL = preload("uid://dtejieuxnt83o")


var quest_label_display_pos:Vector2

func load_note(note_texture):
	print(note_texture)
	if paper.texture==null:
		paper.texture=note_texture
		paper_back.visible=true
		Manager.allow_looking=false
		audio_stream_player.pitch_scale=randf_range(0.8,1.5)
		audio_stream_player.play()

func _on_quest_load(quest:Dictionary):
	
	var quest_show_label := QUEST_SHOW_LABEL.instantiate()
	notfication_window.add_child(quest_show_label)
	var text_to_set="Quest Added: "+quest["Title"]	
	var move_tween = create_tween()
	move_tween.tween_property(quest_show_label,"text",text_to_set,2)
	await move_tween.finished
	await get_tree().create_timer(3).timeout
	var hide_tween=create_tween()
	hide_tween.tween_property(quest_show_label,"text","",2)
	await hide_tween.finished
	quest_show_label.queue_free()
	
func _on_quest_completed(quest:Dictionary):
	var quest_show_label := QUEST_SHOW_LABEL.instantiate()
	notfication_window.add_child(quest_show_label)
	var text_to_set="Quest Completed: "+quest["Title"]
	var move_tween = create_tween()
	move_tween.tween_property(quest_show_label,"text",text_to_set,1)
	await move_tween.finished
	await get_tree().create_timer(1.0).timeout
	var hide_tween=create_tween()
	hide_tween.tween_property(quest_show_label,"text","",1)
	await hide_tween.finished
	quest_show_label.queue_free()

func can_intercat(state:bool):
	if state:
		cross_hair.texture=intercat_texture
	else:
		cross_hair.texture=normal_state_texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("fadeIn")
	Quest_Manger.Quest_Added.connect(_on_quest_load)
	Quest_Manger.Quest_Completed.connect(_on_quest_completed)
	can_intercat(false)
	if OS.has_feature("debug"):
		debug_pannel.show()
	
	Save_Handler.Save_Writing.connect(_start_save_spin)
	Save_Handler.Save_Written.connect(_stop_save_spin)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _start_save_spin():
	start_save_spin.modulate=Color.WHITE
	text_spin.play("save_show")
func _stop_save_spin(error:Error):
	var word_tween = create_tween()
	if error:
		text_spin.stop(true)
		start_save_spin.modulate=Color.RED
		word_tween.tween_property(start_save_spin,"text","Save Failed!",0.2)
		await get_tree().create_timer(0.5).timeout
	else:
		text_spin.stop(true)
		start_save_spin.modulate=Color.GOLD
		word_tween.tween_property(start_save_spin,"text","Save Success!",0.2)
		await get_tree().create_timer(0.5).timeout
	var reset_tween = create_tween()
	reset_tween.tween_property(start_save_spin,"text","",0.2)
	await reset_tween.finished
	text_spin.play("RESET")

#THATS NOT HOW THIS WORKS
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

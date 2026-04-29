extends Node2D

@export_file("*.json", "*.txt") var data_file: String
@onready var text_label: Label = $CanvasLayer/Control/Text_Label

var texts:Array[String]=[]

func _ready() -> void:
	var loaded = FileAccess.get_file_as_string(data_file)
	var packed_texts := loaded.split("\n")
	for line in packed_texts:
		texts.append(line)
	
	for text in texts:
		var text_change_tween = create_tween()
		text_change_tween.tween_property(text_label,"text",text,2)
		await text_change_tween.finished
		await get_tree().create_timer(2).timeout
		
	get_tree().change_scene_to_file("res://worldAssets/WorldSpaces/Beach_Level/beach_scene.tscn")	
	
func _input(event: InputEvent) -> void:
	if event.is_action("jump"):
		get_tree().change_scene_to_file("res://worldAssets/WorldSpaces/Beach_Level/beach_scene.tscn")	

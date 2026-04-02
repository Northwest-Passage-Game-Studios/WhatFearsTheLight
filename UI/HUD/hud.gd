extends Control
@onready var quest_show_label: Label = $Quest_Show_Label

var quest_label_display_pos:Vector2

func _on_quest_load(quest:Dictionary):
	quest_show_label.text="Quest Added: "+quest["Title"]
	var move_tween = create_tween()
	move_tween.tween_property(quest_show_label,"position",quest_label_display_pos,1)
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quest_label_display_pos=quest_show_label.position
	quest_show_label.position.x+=100
	Quest_Manger.Quest_Added.connect(_on_quest_load)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

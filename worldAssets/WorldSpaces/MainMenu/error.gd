class_name Erorr_Box extends Panel

@onready var code: Label = $Error_Message/Code
@onready var body: Label = $Error_Message/body


func _on_button_pressed() -> void:
	self.visible=false

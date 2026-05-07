class_name save_slot_ui extends Panel
@onready var save_title: Label = $Save_Title
@onready var last_played: Label = $Last_Played

var current_save_file:save_file:
	set(new_file):
		current_save_file=new_file
		save_title.text=current_save_file.save_name
		last_played.text+=Time.get_datetime_string_from_unix_time(current_save_file.last_played)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	Save_Handler._load_save_file(self.current_save_file)

extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_area_entered(area: Area3D) -> void:
	queue_free()


func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	visible=true


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	visible=false

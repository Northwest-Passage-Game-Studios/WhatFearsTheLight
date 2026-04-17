extends Node3D
@onready var footstep: AudioStreamPlayer3D = $footstep


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_footstep_finished() -> void:
	footstep.pitch_scale=randf_range(0.70,0.90)

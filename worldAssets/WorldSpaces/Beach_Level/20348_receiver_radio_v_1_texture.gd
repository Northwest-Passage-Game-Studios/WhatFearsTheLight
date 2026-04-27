extends MeshInstance3D
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var timer: Timer = $Timer
var flickering:=false
@onready var csg_box_3d: CSGBox3D = $CSGBox3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if flickering:
		csg_box_3d.visible=randi_range(0,5)>1
		
	else:
		csg_box_3d.visible=true
		audio_stream_player_3d.volume_db=0
		audio_stream_player_3d.pitch_scale=1.0


func _on_timer_timeout() -> void:
	flickering=true
	audio_stream_player_3d.pitch_scale=randf_range(0.7,1.1)
	await get_tree().create_timer(1.0).timeout
	flickering=false
	timer.start(randf_range(1.0,3.0))

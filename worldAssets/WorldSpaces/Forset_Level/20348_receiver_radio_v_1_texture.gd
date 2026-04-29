extends MeshInstance3D
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var timer: Timer = $Timer
var flickering:=false
@onready var csg_box_3d: CSGBox3D = $CSGBox3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var glitchtween = get_tree().create_tween()
	glitchtween.tween_property(audio_stream_player_3d, "volume_db", 0, 2.5)
	await get_tree().create_timer(2.5).timeout
	timer.start(5.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if flickering:
		csg_box_3d.visible=randi_range(0,5)>4
		if !csg_box_3d.visible:
			audio_stream_player_3d.volume_db=-40
		else:
			audio_stream_player_3d.volume_db=0
		
	else:
		csg_box_3d.visible=true
		audio_stream_player_3d.pitch_scale=0.9

func _on_timer_timeout() -> void:
	flickering=true
	var glitchtween = get_tree().create_tween()
	glitchtween.tween_property(audio_stream_player_3d, "pitch_scale", randf_range(0.7,1.2), 0.25).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.5).timeout
	flickering=false
	audio_stream_player_3d.volume_db=0
	var unglitchtween = get_tree().create_tween()
	unglitchtween.tween_property(audio_stream_player_3d, "pitch_scale", 1.0, 1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	timer.start(randf_range(0.6,1.0))

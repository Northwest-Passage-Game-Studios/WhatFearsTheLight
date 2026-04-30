extends Node3D
var flickering=false
var exploded:=false
@onready var light: Node3D = $StreetLamp/light
@onready var spot_light_3d: SpotLight3D = $StreetLamp/light/SpotLight3D
@onready var whitesphere: CSGSphere3D = $StreetLamp/light/whitesphere
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !exploded:
		light.visible=true
	else:
		light.visible=false





func _on_area_3d_body_entered(body: Node3D) -> void:
	if !exploded:
		animation_player.play("lightBreak")
		


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	exploded=true
	audio_stream_player_3d.playing=true
	audio_stream_player_3d.pitch_scale=randf_range(0.8,1.2)

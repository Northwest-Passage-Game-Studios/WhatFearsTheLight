extends Node3D
var flickering=false
var exploded:=false
@onready var light: Node3D = $StreetLamp/light
@onready var spot_light_3d: SpotLight3D = $StreetLamp/light/SpotLight3D
@onready var whitesphere: CSGSphere3D = $StreetLamp/light/whitesphere
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var blow_up: Timer = $blowUP
@onready var buzz: AudioStreamPlayer3D = $buzz
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	blow_up.start(randf_range(155.0,170.0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !exploded:
		light.visible=true
	else:
		light.visible=false








func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if !exploded:
		exploded=true
		buzz.stop()
		audio_stream_player_3d.play()
		audio_stream_player_3d.volume_db=10


func _on_blow_up_timeout() -> void:
	if animation_player.current_animation!="lightBreak":
		buzz.play()
		animation_player.play("lightBreak")

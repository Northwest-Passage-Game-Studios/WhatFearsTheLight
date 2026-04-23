extends Node3D
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var footstep_player: AudioStreamPlayer = $footstepPlayer
@onready var cronch: AudioStreamPlayer = $cronch
@onready var rustle: AudioStreamPlayer = $rustle
@onready var animation_player: AnimationPlayer = $blindManModel/AnimationPlayer
@onready var blind_man_model: Node3D = $blindManModel
@onready var spot_light_3d: SpotLight3D = $SpotLight3D
@onready var spot_light_3d_2: SpotLight3D = $SpotLight3D2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if animation_player!=null:
		animation_player.pause()
	rustle.playing=false
	await get_tree().create_timer(0.5).timeout
	blind_man_model.visible=true

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_player_2_animation_finished(anim_name: StringName) -> void:
	if anim_name=="blackIn":
		animation_player_2.play("cameraAnimation")
		await get_tree().create_timer(1.0).timeout
		
		animation_player.play("thc4_arma|st_bite")
		
	elif anim_name!="bloodView":
		await get_tree().create_timer(0.35).timeout
		cronch.play()
		animation_player_2.play("bloodView")
	else:
		get_tree().change_scene_to_file("res://Debug/monster_debug_BlindMan.tscn")
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass


func _on_footstep_player_finished() -> void:
	footstep_player.pitch_scale=randf_range(0.8,1.2)

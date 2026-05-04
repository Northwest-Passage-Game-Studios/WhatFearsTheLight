extends Node3D
@onready var static_body_3d: StaticBody3D = $StaticBody3D
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $"Root Scene/AudioStreamPlayer3D"
@onready var root_scene: Node3D = $"Root Scene"
@onready var timer: Timer = $Timer
@onready var light_effects: CSGBox3D = $Node3D/lightEffects
@onready var light_effects_red: CSGBox3D = $Node3D/lightEffectsRed
@onready var light_effects_yellow: CSGBox3D = $Node3D/lightEffectsYellow
@onready var light_effects_pink: CSGBox3D = $Node3D/lightEffectsPink
@onready var light_effects_cyan: CSGBox3D = $Node3D/lightEffectsCyan
@onready var light_effects_lime: CSGBox3D = $Node3D/lightEffectsLime

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var ouiao:=false
var stops:=6
var upDistance:=2.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ouiao:
		if upDistance>0:
			global_position.y+=0.25*delta
			upDistance-=0.25*delta
		else:
			light_effects.visible=true

func _on_area_3d_body_entered(body: Node3D) -> void:
	
	static_body_3d.position.y=0
	audio_stream_player_3d.play()
	await get_tree().create_timer(1.4).timeout
	animation_player.play("ouuuiiiaauiuiooo")
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="ouuuiiiaauiuiooo":
		if stops>0:
			animation_player.play("wait")
			stops-=1
		else:
			animation_player.play("ouuuiiiaauiuiooo_2")
			timer.start()
			ouiao=true
	if anim_name=="wait":
		animation_player.play("ouuuiiiaauiuiooo")


func _on_timer_timeout() -> void:
	pass

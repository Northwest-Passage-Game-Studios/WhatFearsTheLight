extends Node3D
@onready var static_body_3d: StaticBody3D = $StaticBody3D
@onready var audio_stream_player_3d: AudioStreamPlayer = $"Root Scene/AudioStreamPlayer3D"
@onready var root_scene: Node3D = $"Root Scene"
@onready var timer: Timer = $Timer
@onready var light_effects: CSGBox3D = $Node3D/lightEffects
@onready var light_effects_red: CSGBox3D = $Node3D/lightEffectsRed
@onready var light_effects_yellow: CSGBox3D = $Node3D/lightEffectsYellow
@onready var light_effects_pink: CSGBox3D = $Node3D/lightEffectsPink
@onready var light_effects_cyan: CSGBox3D = $Node3D/lightEffectsCyan
@onready var light_effects_lime: CSGBox3D = $Node3D/lightEffectsLime
@onready var lights_effects_animator: AnimationPlayer = $lightsEffectsAnimator
var flashing:=false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var ouiao:=false
signal donezo
var stops:=6
@onready var gpu_particles_3d: GPUParticles3D = $"Root Scene/GPUParticles3D"
@onready var gpu_particles_3d_2: GPUParticles3D = $"Root Scene/GPUParticles3D2"
var lastColor:=0
@onready var node_3d: Node3D = $Node3D
var upDistance:=2.0
@onready var flash_timer: Timer = $flashTimer
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
			if node_3d.visible==false:
				node_3d.visible=true
				lights_effects_animator.play("flash")

func _on_area_3d_body_entered(body: Node3D) -> void:
	static_body_3d.position.y=0
	audio_stream_player_3d.play()
	await get_tree().create_timer(1.4).timeout
	animation_player.play("ouuuiiiaauiuiooo")
	await get_tree().create_timer(86.0).timeout
	gpu_particles_3d.emitting=true
	await get_tree().create_timer(20.0).timeout
	gpu_particles_3d_2.emitting=true	
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


func _on_lights_effects_animator_animation_finished(anim_name: StringName) -> void:
	if anim_name=="flash":
		flash_timer.start()


func _on_flash_timer_timeout() -> void:
	light_effects_red.visible=false
	light_effects_yellow.visible=false
	light_effects_cyan.visible=false
	light_effects_lime.visible=false
	var screen=randi_range(0,4)
	while lastColor==screen:
		screen=randi_range(0,4)
	lastColor=screen
	if screen>0:
		light_effects_red.visible=true
	if screen>1:
		light_effects_yellow.visible=true
	if screen>2:
		light_effects_cyan.visible=true
	if screen>3:
		light_effects_lime.visible=true


func _on_audio_stream_player_3d_finished() -> void:
	donezo.emit()
	queue_free()

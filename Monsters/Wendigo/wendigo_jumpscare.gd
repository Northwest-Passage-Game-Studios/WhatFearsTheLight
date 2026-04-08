extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var the_angel_reference_skeleton: Node3D = $the_angel_reference_skeleton
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.pause()
	await get_tree().create_timer(0.16).timeout
	the_angel_reference_skeleton.visible=true
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_player_2_animation_finished(anim_name: StringName) -> void:
	if anim_name!="bloodView":
		animation_player.play("the_angel_reference_skeleton|3000")
	else:
		get_tree().change_scene_to_file("res://worldAssets/WorldSpaces/Forset_Level/main_world.tscn")
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_player_2.play("bloodView")

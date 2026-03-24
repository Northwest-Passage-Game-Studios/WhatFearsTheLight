extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var freezeTime:=0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func freeze()->void:
	await get_tree().create_timer(freezeTime).timeout
	animation_player.pause()

func unfreeze()->void:
	animation_player.play("Armature_Monster|Monster_Chase_Anim")

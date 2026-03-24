extends Node3D

var is_player_in:=false
var player_ref :player_body
@onready var key: MeshInstance3D = $Key


func _input(event: InputEvent) -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_player_in==true:
		pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is player_body:
		player_ref=body
		is_player_in=true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is player_body:
		player_ref=null
		is_player_in=false

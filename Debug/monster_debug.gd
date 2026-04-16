extends Node3D
@export var starting_tool :PackedScene
@onready var blind_man: blindman = $BlindMan
@onready var player: player_body = $Player
@onready var spot_light_3d: SpotLight3D = $SpotLight3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Adds the Starting Tool
	player.tool_handler.pick_up_item(starting_tool,false)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	blind_man.investigate(spot_light_3d.global_position)

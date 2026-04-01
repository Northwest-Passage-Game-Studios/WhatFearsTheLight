extends Node3D
@onready var player: player_body = $Player
@export var starting_tool :PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Adds the Starting Tool
	player.tool_handler.pick_up_item(starting_tool,false)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

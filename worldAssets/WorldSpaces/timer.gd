extends Timer
var wendigoScene=preload("res://Monsters/Wendigo/Wendigo.tscn")
@onready var wendigo_container: Node3D = $"../wendigoContainer"
@onready var player: player_body = $"../Player"
@onready var reference_point: Node3D = $"../referencePoint"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timeout() -> void:
	var wendInst:wendigo=wendigoScene.instantiate()
	wendigo_container.add_child(wendInst)
	wendInst.global_position.y=reference_point.global_position.y
	var displaceX=randi_range(-10,10)
	var displaceZ=randi_range(-10,10)
	
	if abs(displaceX)+abs(displaceZ)<10:
		if randi_range(0,1)==1:
			displaceX=randi_range(10,15)
			if randi_range(0,1)==1:
				displaceX*=-1
		else:
			displaceZ=randi_range(10,15)
			if randi_range(0,1)==1:
				displaceZ*=-1
	print(str(displaceX)+"X and  "+str(displaceZ)+"Z")
	wendInst.global_position.x=player.global_position.x+displaceX
	wendInst.global_position.z=player.global_position.z+displaceZ
	wendInst.set_target(player)
	self.start(randf_range(15,27))
	

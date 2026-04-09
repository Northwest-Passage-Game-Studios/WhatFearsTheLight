extends Timer
var wendigoScene=preload("res://Monsters/Wendigo/Wendigo.tscn")
@onready var wendigo_container: Node3D = $"../wendigoContainer"
@onready var player: player_body = $"../Player"
@onready var reference_point: Node3D = $"../referencePoint"
@onready var enemyspawnchecker: VisibleOnScreenNotifier3D = $"../enemyspawnchecker"
var displaceX:=0.0
var displaceZ:=0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timeout() -> void:
	if wendigo_container.get_child_count()==0:
		displaceX=randi_range(-10,10)
		displaceZ=randi_range(-10,10)
		
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
		enemyspawnchecker.global_position.x=player.global_position.x+displaceX
		enemyspawnchecker.global_position.z=player.global_position.z+displaceZ
		enemyspawnchecker.visible=true
		await get_tree().create_timer(0.25).timeout
		print("SPawned")
		enemyspawnchecker.visible=false
		var wendInst:wendigo=wendigoScene.instantiate()
		wendigo_container.add_child(wendInst)
		wendInst.global_position.y=reference_point.global_position.y
		wendInst.global_position.x=player.global_position.x+displaceX
		wendInst.global_position.z=player.global_position.z+displaceZ
		wendInst.set_target(player)
		self.start(randf_range(15,27))
		


func _on_enemyspawnchecker_screen_entered() -> void:
	enemyspawnchecker.visible=false
	print("FLipped")
	displaceX*=-1
	displaceZ*=-1

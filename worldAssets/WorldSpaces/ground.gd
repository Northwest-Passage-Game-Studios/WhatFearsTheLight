extends MeshInstance3D
var grasse=preload("res://worldAssets/grass/WAVEYgrass.tscn")
var treee=preload("res://worldAssets/treees/tree.tscn")
@onready var reference_point: Node3D = $"../referencePoint"
@onready var tree_container: Node3D = $"../treeContainer"
@onready var grass_container: Node3D = $"../grassContainer"


func _ready() -> void:
	for x in range(50):
		for z in range(50):
			var grasInst=grasse.instantiate()
			grass_container.add_child(grasInst)
			grasInst.global_position.y=reference_point.global_position.y
			grasInst.global_position.x=reference_point.global_position.x+20*x
			grasInst.global_position.z=reference_point.global_position.z+20*z
			
			
	for x in range(200):
		for z in range(200):
			var tree=treee.instantiate()
			tree_container.add_child(tree)
			tree.global_position.y=reference_point.global_position.y
			tree.global_position.x=reference_point.global_position.x+5*x+randi_range(-30,30)
			tree.global_position.z=reference_point.global_position.z+5*z+randi_range(-30,30)
			tree.scale*=randf_range(0.9,2.1)
			tree.rotation.y=randf_range(0,360)

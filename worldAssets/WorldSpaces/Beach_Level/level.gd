extends Node3D

@onready var pickable: Object_PickUp_Point = $Pickable
@onready var door_interact: Door_Interact = $Door_Interact
@onready var you_cant_go_that_way: StaticBody3D = $YouCantGoThatWay
@onready var player: player_body = $Player

var find_the_light_quest :int
var find_the_way_out_the_beach:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.black_animator.stop()
	await get_tree().create_timer(2).timeout
=======
>>>>>>> Stashed changes
	find_the_light_quest = Quest_Manger.add_new_quest("Search The Wreckage For supplies","N/A",QuestManger.Quest_Type.Smiple_Item_Fetch)
	Quest_Manger.add_lone_item(find_the_light_quest,pickable)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pickable_picked_up() -> void:
	await get_tree().create_timer(4).timeout
	find_the_way_out_the_beach = Quest_Manger.add_new_quest("Search For a way out of the cove","N/A",QuestManger.Quest_Type.Smiple_Marker)
	Quest_Manger.set_quest_marker(find_the_way_out_the_beach,door_interact.position)
	you_cant_go_that_way.queue_free()


func _on_door_interact_teleport_signal() -> void:
	player.black_animator.play("Fad_to_Black")
	await player.black_animator.animation_finished
	get_tree().change_scene_to_file("res://worldAssets/WorldSpaces/Forset_Level/main_world.tscn")

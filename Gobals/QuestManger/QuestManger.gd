class_name QuestManger extends Node

@export var MAX_QUEST_REF_ID:int = 100
@export var Quest_Maker:PackedScene


#ONLY CREATED QUEST WHEN NEED
#SECOND DONT SPEFICLY REF QUEST ITS MENT TO BE AS GRENIC AS POSSABLE FOR A REASON
#SECOND DONT CREATE 10000s Of Quest because all quest will because just it will have to loop through it each time





#IF YOU ARE LOOKING AT THIS DUCCUN THIS HANDLES ALL OF THE MARKERS
var all_quests :Array[Dictionary]




func _check_if_dup(ref_id:int)->bool:
	for dict:Dictionary in all_quests:
		if dict["Ref_ID"]==ref_id:
			return true
	return false

#Creates New Ref_Id and checks if in use
func _create_new_ref_id()->int:
	var new_ref_id:int = randi_range(0,MAX_QUEST_REF_ID)
	var loop_count:=0
	while _check_if_dup(new_ref_id)==true and loop_count<MAX_QUEST_REF_ID+1:
		loop_count+=1
		new_ref_id = randi_range(0,MAX_QUEST_REF_ID)
	if loop_count>=MAX_QUEST_REF_ID+1:
		push_error("Loop in the ref ID create")
	return new_ref_id
	

func add_new_quest(quest_point:Vector3,Title:String,disc:String)->int:
	var new_quest:Dictionary = {}
	new_quest["Ref_ID"]=_create_new_ref_id()
	new_quest["Quest_Point"]=quest_point
	new_quest["Title"]=Title
	new_quest["Disc"]=disc
	new_quest["Is_Completed"]=false
	var new_marker :Node3D= Quest_Maker.instantiate()
	get_tree().current_scene.add_child(new_marker)
	new_marker.global_position=quest_point
	
	
	new_quest["Marker_Node"]=new_marker
	
	all_quests.append(new_quest)
	return new_quest["Ref_ID"]
	
func get_quest(Ref_ID:int)->Dictionary:
	for dict in all_quests:
		if dict["Ref_ID"]==Ref_ID:
			return dict
	return {}

func get_all_quests()->Array[Dictionary]:
	return all_quests
	
func mark_quest_completed(Ref_ID:int):
	var quest_to_mark = get_quest(Ref_ID)
	if quest_to_mark=={}:
		push_error("Quest No Exist")
	else:
		quest_to_mark["Is_Completed"]=true
		var quest_marker = quest_to_mark["Marker_Node"]
		if quest_marker is Node3D:
			quest_marker.queue_free() 
		

class_name QuestManger extends Node

@export var MAX_QUEST_REF_ID:int = 100
@export var Quest_Maker:PackedScene


#ONLY CREATED QUEST WHEN NEED
#SECOND DONT SPEFICLY REF QUEST ITS MENT TO BE AS GRENIC AS POSSABLE FOR A REASON
#SECOND DONT CREATE 10000s Of Quest because all quest will because just it will have to loop through it each time


enum Quest_Type{
	Smiple_Marker,
	Mutiple_Item_Fetch,
	Smiple_Item_Fetch,
	Just_Text
}


@warning_ignore("unused_signal")
signal DONT_NOT_USE #This Signal is not to be used for anything no tocuhy Duccun

signal Quest_Completed(Quest:Dictionary)
signal Quest_Stage_Completed(Quest:Dictionary)
signal Quest_Added(Quest:Dictionary)

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
	

func add_new_quest(Title:String,disc:String,type:Quest_Type)->int:
	var new_quest:Dictionary = {}
	new_quest["Ref_ID"]=_create_new_ref_id()

	new_quest["Title"]=Title
	new_quest["Disc"]=disc
	new_quest["Is_Completed"]=false
	new_quest["Type"]=type
	
	if type == Quest_Type.Smiple_Marker:
		new_quest["Quest_Point"]=null

	elif type==Quest_Type.Mutiple_Item_Fetch:
		new_quest["Items"]=[]
		new_quest["Stages"]=0
		new_quest["Stages_Completed"]=0
	elif type==Quest_Type.Smiple_Item_Fetch:
		new_quest["Item"]=null
	
	
	all_quests.append(new_quest)
	Quest_Added.emit(new_quest)
	return new_quest["Ref_ID"]


func _load_quest_marker(marker_pos:Vector3)->Node3D:
	var new_marker :Node3D= Quest_Maker.instantiate()
	get_tree().current_scene.add_child(new_marker)
	new_marker.global_position=marker_pos
	return new_marker

func set_quest_marker(Ref_ID:int,marker_pos:Vector3):
	var quest=get_quest(Ref_ID)
	if quest=={}:
		push_warning("Quest Ref Id Doesnt Exist")
		return
	if quest["Type"]==Quest_Type.Smiple_Marker:
		var qeust_marker_node :=  _load_quest_marker(marker_pos)
		quest["Marker_Node"]=qeust_marker_node
	
func _add_item_to_quest(Ref_ID:int,item_pos:Vector3,item_picked:Signal=DONT_NOT_USE):
	var quest=get_quest(Ref_ID)
	if quest=={}:
		push_warning("Quest Ref Id Doesnt Exist")
		return
	if quest["Type"]==Quest_Type.Smiple_Item_Fetch:
		var new_item = {
			"POS":item_pos
		}
		quest["Item"]=new_item
		var qeust_marker_node :=  _load_quest_marker(item_pos)
		quest["Marker_Node"]=qeust_marker_node
	
		
		item_picked.connect(func():
			mark_quest_completed(Ref_ID)
			)
	if quest["Type"]==Quest_Type.Mutiple_Item_Fetch:
		var new_item = {
			"POS":item_pos,
			"Found":false,
		}
		quest["Items"].append(new_item)
		quest["Stages"]+=1
		var qeust_marker_node :=  _load_quest_marker(item_pos)
		new_item["Marker_Node"]=qeust_marker_node
	
		
		item_picked.connect(func():
			new_item["Found"]=true
			var quest_marker = new_item["Marker_Node"]
			if quest_marker is Node3D:
				quest_marker.queue_free()
				new_item["Marker_Node"]=null
			quest["Stages_Completed"]+=1
			Quest_Stage_Completed.emit(quest)
			if _quest_complete_check(Ref_ID):
				mark_quest_completed(Ref_ID)
			)

func add_mutiple_item(Ref_ID:int,item_list:Array[Object_PickUp_Point]):
	for item:Object_PickUp_Point in item_list:
		_add_item_to_quest(Ref_ID,item.global_position,item.Picked_Up)
		
		
func add_lone_item(Ref_ID:int,item:Object_PickUp_Point):
	_add_item_to_quest(Ref_ID,item.global_position,item.Picked_Up)


func _quest_complete_check(Ref_ID:int):
	var quest=get_quest(Ref_ID)
	if quest=={}:
		push_warning("Quest Ref Id Doesnt Exist")
		return
	if quest["Type"]!=Quest_Type.Mutiple_Item_Fetch:
		return
	for item in quest["Items"]:
		if item["Found"]==false:
			return false
	return true


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
		return
	if quest_to_mark["Type"]==Quest_Type.Mutiple_Item_Fetch:
		quest_to_mark["Is_Completed"]=true
	if quest_to_mark["Type"]==Quest_Type.Smiple_Item_Fetch:
		quest_to_mark["Is_Completed"]=true
		var quest_marker = quest_to_mark["Marker_Node"]
		if quest_marker is Node3D:
			quest_marker.queue_free() 
	Quest_Completed.emit(quest_to_mark)
	print(quest_to_mark)
		

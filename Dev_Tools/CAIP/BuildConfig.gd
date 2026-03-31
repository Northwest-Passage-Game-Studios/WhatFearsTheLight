class_name Object_Config extends Resource


@export var name:String
@export var object:PackedScene
@export_range(0,100,0.01)
var chance_to_spawn:float 
@export var scale_random := 1
@export var offset_random := 1
@export var allow_other_gen := true

func _to_string() -> String:
	var output_str:=""
	output_str+="Name: "+name+" "
	output_str+="object: "+object.resource_path+" "
	output_str+="Chace To Spawn: "+str(chance_to_spawn)+" "
	return output_str

@tool
class_name CAIP extends Node3D



@export_category("Object Configs")

@export var Objects:Array[Object_Config]




@export_category("World Size")
@export var size_x :=100
@export var size_z :=100

@export_category("No Build Areas")
@export_flags_3d_physics var no_place_layers


@export_category("Build Settings")
@export var gen_steps := 1
@export_category("     ")
@export_tool_button("Gen World","Tools")
var gen_world_button = gen_world

func _sort_world_objects(a:Object_Config,b:Object_Config):
	return a.chance_to_spawn<b.chance_to_spawn
	
func _is_point_allowed(pos:Vector3)->bool:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsPointQueryParameters3D.new()
	query.position = pos
	query.collide_with_areas = true # Set to true to detect Area3D
	query.collision_mask=no_place_layers
	var results = space_state.intersect_point(query)
	if not results.is_empty():
		return false
	return true


func create_object_at_point(pos:Vector3):
	#Objects.sort_custom(_sort_world_objects)
	#Objects.reverse()
	for build_object:Object_Config in Objects:
		var chance_clac := randi_range(0,101)
		if _is_point_allowed(pos):		
			if build_object.chance_to_spawn <= chance_clac:
				var build_object_ref :Node3D= build_object.object.instantiate()
				add_child(build_object_ref)
				build_object_ref.owner = get_tree().edited_scene_root
				build_object_ref.position=pos
				var offset_pos :=Vector3(0,0,0)
				offset_pos.x = randi_range(1,build_object.offset_random)
				offset_pos.z = randi_range(1,build_object.offset_random)
				build_object_ref.position+=offset_pos
				if not _is_point_allowed(build_object_ref.global_position):
					build_object_ref.queue_free()
					break
				build_object_ref.scale*=randi_range(1,build_object.scale_random)
				build_object_ref.rotation_degrees.y=randi_range(0,180)
				if build_object.allow_other_gen==false:
					return
		
		
func _clear_all_children():
	for child in get_children():
		child.queue_free()

func gen_world():
	_clear_all_children()
	var y = 0
	for x in range(-size_x/2.0,size_x/2.0,gen_steps):
		for z in range(-size_z/2.0,size_z/2.0,gen_steps):
			var pos = Vector3(x,y,z)
			create_object_at_point(pos)
			

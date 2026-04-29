@tool
class_name CAIP extends Node3D



@export_category("Object Configs")

@export var Objects:Array[Object_Config]




@export_category("World Size")
@export var size_x :=100
@export var size_z :=100



@export_category("Build Settings")
@export var gen_steps := 1
@export_category("     ")
@export_tool_button("Gen World","Tools")
var gen_world_button = gen_world

@export_flags_3d_physics var NoSpawnLayer

func _check_if_allowed_to_spawn(pos:Vector3):
	var world_space = get_world_3d().direct_space_state
	var phyiscs_space = PhysicsPointQueryParameters3D.new()
	phyiscs_space.collision_mask=NoSpawnLayer
	phyiscs_space.position=pos
	phyiscs_space.collide_with_areas=true

	var raycast := world_space.intersect_point(phyiscs_space)
	print_debug(raycast)
	if raycast==[]:
		return true
	return false
	

func _sort_world_objects(a:Object_Config,b:Object_Config):
	return a.chance_to_spawn<b.chance_to_spawn

func create_object_at_point(pos:Vector3):
	#Objects.sort_custom(_sort_world_objects)
	#Objects.reverse()

	for build_object:Object_Config in Objects:
		var chance_clac := randi_range(0,101)
		if build_object.chance_to_spawn <= chance_clac:
			var build_object_ref :Node3D= build_object.object.instantiate()
			add_child(build_object_ref)
			build_object_ref.owner = get_tree().edited_scene_root
			build_object_ref.position=pos
			var offset_pos :=Vector3(0,0,0)
			offset_pos.x = randi_range(1,build_object.offset_random)
			offset_pos.z = randi_range(1,build_object.offset_random)

				
			build_object_ref.position+=offset_pos
			build_object_ref.scale*=randi_range(1,build_object.scale_random)
			build_object_ref.rotation_degrees.y=randi_range(0,180)
			if _check_if_allowed_to_spawn(build_object_ref.position)==false:
				build_object_ref.queue_free()
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
			

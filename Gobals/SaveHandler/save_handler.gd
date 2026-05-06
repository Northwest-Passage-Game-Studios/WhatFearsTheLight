class_name SaveHandler extends Node

@onready var user_dir = DirAccess.open("user://") 
#file_paths
var save_file_path := "saves"
var current_save_file:save_file
var save_files = []

signal AutoSave



func find_all_save_files():
	var dir =  DirAccess.open("user://"+save_file_path)
	if dir==null:
		user_dir.make_dir("user://"+save_file_path)
		dir =  DirAccess.open("user://"+save_file_path)
	dir.list_dir_begin()
	var next_file_path = dir.get_next()
	while next_file_path!="":
		var ext = next_file_path.get_extension()
		if ext =="res" || ext=="tres":
			var save_file_path = ResourceLoader.load(next_file_path)
			save_files.append(save_file_path)
		next_file_path=dir.get_next()
	print(save_files)
func _ready() -> void:
	find_all_save_files()


func _load_save_file(path:String):
	
	pass

func _write_file():
	var save_locate = "user://"+save_file_path+"/"+current_save_file.save_name+".tres"
	print(save_locate)
	ResourceSaver.save(current_save_file,save_locate)
	print("writing")


func _on_timer_timeout() -> void:
	AutoSave.emit()
	await get_tree().create_timer(2).timeout
	
	_write_file()

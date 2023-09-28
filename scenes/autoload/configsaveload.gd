extends Node2D

#temporary hack bc missing engine feature
#var data : ConfigData

const path_last_edited = "res://config/last_edited.tres" 
const path_demo = "res://config/demo.tres"
const path_fast = "res://config/fast.tres"
const path_n_up = "res://config/n_up.tres"

var demo : Parameters
var fast : Parameters
var n_up : Parameters
var last_edited : Parameters


func _ready():
	ensure_default()

func _load():
	demo = load(path_demo)
	fast = load(path_fast)
	n_up = load(path_n_up)
	last_edited = load(path_last_edited)

	
func ensure_default():
	var f := File.new()
	if not f.file_exists(path_demo):
		demo = Parameters.new()
		fast = Parameters.new()
		n_up = Parameters.new()
		last_edited = Parameters.new()
	else:
		_load()
	save()
	
	
func save():
	ResourceSaver.save(path_demo,demo)
	ResourceSaver.save(path_fast,fast)
	ResourceSaver.save(path_n_up,n_up)
	ResourceSaver.save(path_last_edited,last_edited)

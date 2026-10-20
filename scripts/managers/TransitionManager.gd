extends Node

signal progress_changed(progress)
signal load_finished

enum LOADING_SCREEN_TYPE {
	DEFAULT,
	BATTLE,
	TRAVERSAL,
	ACT_END
}

var loading_screen_options: Dictionary = {
	LOADING_SCREEN_TYPE.DEFAULT: preload("uid://ck72488dlnhf0"),
	LOADING_SCREEN_TYPE.BATTLE: preload("uid://bwr7n8yxx3lta")
}

var loading_screen: PackedScene = null
var loaded_resource: PackedScene
var scene_path: String
var progress: Array = []
var use_sub_threads: bool = true

func _ready() -> void:
	set_process(false)

##Loads the scene specified in the scene path with the loading screen animation specified in the load type
func load_scene(_scene_path: String, load_type: LOADING_SCREEN_TYPE = LOADING_SCREEN_TYPE.DEFAULT) -> void:
	scene_path = _scene_path
	loading_screen = loading_screen_options[load_type]
	
	var new_load_screen = loading_screen.instantiate()
	add_child(new_load_screen)
	progress_changed.connect(new_load_screen._on_progress_changed)
	load_finished.connect(new_load_screen._on_load_finished)
	
	await new_load_screen.loading_screen_ready
	
	start_load()

func start_load() -> void:
	var state: Error = ResourceLoader.load_threaded_request(scene_path, "", use_sub_threads)
	if state == OK:
		set_process(true)
		

func _process(delta: float) -> void:
	var load_status: ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(scene_path, progress)
	progress_changed.emit(progress[0])
	
	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			set_process(false)
		ResourceLoader.THREAD_LOAD_LOADED:
			loaded_resource = ResourceLoader.load_threaded_get(scene_path)
			get_tree().change_scene_to_packed(loaded_resource)
			load_finished.emit()

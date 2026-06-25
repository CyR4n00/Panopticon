extends Node

var next_scene_path: String = ""
var loading: bool = false
var progress: Array = []

var loading_screen_scene = preload("res://scenes/ui/loading_screen.tscn")
var current_loading_screen: Node = null

func _ready():
    print("Scene Transition Manager ready.")

func transition_to_scene(scene_path: String):
    if loading:
        return

    next_scene_path = scene_path
    loading = true

    current_loading_screen = loading_screen_scene.instantiate()
    get_tree().root.add_child(current_loading_screen)

    if current_loading_screen.has_method("play_movie"):
        current_loading_screen.play_movie()

    ResourceLoader.load_threaded_request(next_scene_path)
    set_process(true)

func _process(_delta):
    if not loading:
        set_process(false)
        return

    var status = ResourceLoader.load_threaded_get_status(next_scene_path, progress)

    if status == ResourceLoader.THREAD_LOAD_LOADED:
        loading = false
        var new_scene = ResourceLoader.load_threaded_get(next_scene_path)

        get_tree().change_scene_to_packed(new_scene)

        if current_loading_screen and current_loading_screen.has_method("finish_loading"):
            current_loading_screen.finish_loading()
        else:
            if current_loading_screen:
                current_loading_screen.queue_free()

    elif status == ResourceLoader.THREAD_LOAD_FAILED or status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
        print("Error loading scene: ", next_scene_path)
        loading = false
        if current_loading_screen:
            current_loading_screen.queue_free()

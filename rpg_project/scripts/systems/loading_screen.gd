extends CanvasLayer

@onready var video_player = $VideoStreamPlayer
@onready var color_rect = $ColorRect

var ready_to_close: bool = false

func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS

    if video_player:
        video_player.finished.connect(_on_video_finished)

func play_movie():
    if color_rect:
        color_rect.color = Color(0, 0, 0, 1)

    if video_player:
        video_player.play()

func finish_loading():
    ready_to_close = true
    if not video_player or not video_player.is_playing():
        queue_free()

func _on_video_finished():
    if ready_to_close:
        queue_free()
    else:
        video_player.play()

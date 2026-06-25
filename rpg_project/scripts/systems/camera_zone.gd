extends Area3D

@export var linked_camera: Camera3D

func _ready():
    collision_mask = 2
    collision_layer = 0
    body_entered.connect(_on_body_entered)

func _on_body_entered(body):
    if body.is_in_group("player"):
        if linked_camera:
            linked_camera.make_current()
            print("Camera switched to: ", linked_camera.name)

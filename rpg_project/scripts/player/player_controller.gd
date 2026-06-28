extends CharacterBody3D

var movement_locked: bool = false

func lock_movement():
    movement_locked = true
    velocity = Vector3.ZERO

func unlock_movement():
    movement_locked = false


const SPEED = 5.0

func _physics_process(delta):
    if movement_locked:
        move_and_slide()
        return

    var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()

    var camera = get_viewport().get_camera_3d()
    if camera:
        var cam_forward = -camera.global_transform.basis.z
        cam_forward.y = 0
        cam_forward = cam_forward.normalized()

        var cam_right = camera.global_transform.basis.x
        cam_right.y = 0
        cam_right = cam_right.normalized()

        direction = (cam_right * input_dir.x + cam_forward * -input_dir.y).normalized()

    if direction:
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED

        var look_target = position + direction
        if position.distance_to(look_target) > 0.01:
            var target_transform = transform.looking_at(look_target, Vector3.UP)
            transform.basis = transform.basis.slerp(target_transform.basis, 10.0 * delta)
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)

    if not is_on_floor():
        velocity.y -= 9.8 * delta

    move_and_slide()

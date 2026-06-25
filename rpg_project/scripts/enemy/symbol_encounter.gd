extends Area3D

@export var enemy_group_id: String = "slime_group"
@export var battle_scene_path: String = "res://scenes/battle/battle_main.tscn"

var triggered: bool = false

func _ready():
    collision_mask = 2
    collision_layer = 4
    body_entered.connect(_on_body_entered)

func _on_body_entered(body):
    if not triggered and body.is_in_group("player"):
        triggered = true
        _start_encounter(body)

func _start_encounter(player):
    print("Encounter triggered with: ", enemy_group_id)

    if player.has_method("lock_movement"):
        player.lock_movement()

    GameManager.set("pending_enemy_group", enemy_group_id)

    if SceneTransitionManager:
        SceneTransitionManager.transition_to_scene(battle_scene_path)

    queue_free()

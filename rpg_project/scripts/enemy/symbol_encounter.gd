extends Area3D

@export var enemy_group_id: String = "slime_group"
@export var battle_scene_path: String = "res://scenes/battle/battle_main.tscn"
@export var unique_encounter_id: String = "" # Unique ID for this specific enemy spawn

var triggered: bool = false

func _ready():
    # If no unique ID is set, generate one based on path so it's consistent between reloads
    if unique_encounter_id == "":
        unique_encounter_id = str(get_path())

    # Check if this specific enemy was already defeated
    var gm = get_node_or_null("/root/GameManager")
    if gm and gm.is_enemy_defeated(unique_encounter_id):
        queue_free()
        return

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

    var gm = get_node_or_null("/root/GameManager")
    if gm:
        gm.set("pending_enemy_group", enemy_group_id)
        # Register as defeated (usually you would do this after winning the battle, but for simplicity we do it here)
        gm.register_enemy_defeated(unique_encounter_id)

    var stm = get_node_or_null("/root/SceneTransitionManager")
    if stm:
        stm.transition_to_scene(battle_scene_path)

    queue_free()

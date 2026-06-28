extends Node

var current_floor: int = 1
var pending_enemy_group: String = ""

# Keep track of defeated enemy node names or unique IDs to prevent respawn
var defeated_enemies: Array[String] = []

func _ready():
    print("GameManager initialized. Panopticon Tower ready.")

func change_floor(new_floor: int):
    current_floor = new_floor
    print("Ascended/Descended to floor: ", current_floor)

func register_enemy_defeated(enemy_id: String):
    if not enemy_id in defeated_enemies:
        defeated_enemies.append(enemy_id)

func is_enemy_defeated(enemy_id: String) -> bool:
    return enemy_id in defeated_enemies

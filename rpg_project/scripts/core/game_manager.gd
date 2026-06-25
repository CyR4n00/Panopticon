extends Node

var current_floor: int = 1
var pending_enemy_group: String = ""

func _ready():
    print("GameManager initialized. Panopticon Tower ready.")

func change_floor(new_floor: int):
    current_floor = new_floor
    print("Ascended/Descended to floor: ", current_floor)

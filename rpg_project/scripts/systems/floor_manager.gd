extends Node3D

@export var floor_number: int = 1
@export var floor_name: String = "Panopticon - First Stratum"
@export var has_puzzle: bool = true

# Signals to notify other systems when a puzzle is solved
signal puzzle_solved
signal door_unlocked

func _ready():
    print("Entered Floor: ", floor_number, " - ", floor_name)

    # Example logic: Connect to all puzzles on this floor
    # Assuming puzzles are grouped under a node named "Puzzles"
    var puzzles_node = get_node_or_null("Puzzles")
    if puzzles_node:
        for puzzle in puzzles_node.get_children():
            if puzzle.has_signal("solved"):
                puzzle.solved.connect(_on_puzzle_solved)

func _on_puzzle_solved():
    print("A puzzle was solved on floor ", floor_number)
    emit_signal("puzzle_solved")

    # Check if all puzzles are solved, unlock the door to the next floor, etc.
    _check_floor_completion()

func _check_floor_completion():
    # Placeholder logic for unlocking the next area
    print("Floor completion check...")
    # emit_signal("door_unlocked")

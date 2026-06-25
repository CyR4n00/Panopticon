extends Node3D
class_name BasePuzzle

signal solved

var is_solved: bool = false

func complete_puzzle():
    if not is_solved:
        is_solved = true
        print("Puzzle Completed: ", name)
        emit_signal("solved")

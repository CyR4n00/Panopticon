@tool
extends Node3D
class_name PanopticonGenerator

@export var generate_now: bool = false : set = _set_generate
@export var outer_radius: float = 20.0
@export var inner_radius: float = 12.0
@export var tower_radius: float = 4.0
@export var floor_height: float = 4.0
@export var cell_count: int = 12
@export var cell_depth: float = 5.0
@export var cell_width: float = 4.0

func _set_generate(val: bool):
    if val:
        if Engine.is_editor_hint():
            generate_panopticon()
        generate_now = false

func generate_panopticon():
    # Only remove children that we previously generated to avoid destroying user placed objects (like Player)
    for child in get_children():
        if child.name == "PanopticonBase":
            child.queue_free()

    var root_csg = CSGCombiner3D.new()
    root_csg.name = "PanopticonBase"
    root_csg.use_collision = true
    add_child(root_csg)
    _set_owner_recursive(root_csg, get_tree().edited_scene_root)

    var main_building = CSGCylinder3D.new()
    main_building.name = "OuterWall"
    main_building.radius = outer_radius
    main_building.height = floor_height
    root_csg.add_child(main_building)
    _set_owner_recursive(main_building, get_tree().edited_scene_root)

    var courtyard_hollow = CSGCylinder3D.new()
    courtyard_hollow.name = "CourtyardHollow"
    courtyard_hollow.operation = CSGShape3D.OPERATION_SUBTRACTION
    courtyard_hollow.radius = inner_radius
    courtyard_hollow.height = floor_height + 0.1
    main_building.add_child(courtyard_hollow)
    _set_owner_recursive(courtyard_hollow, get_tree().edited_scene_root)

    var center_tower = CSGCylinder3D.new()
    center_tower.name = "CenterTower"
    center_tower.radius = tower_radius
    center_tower.height = floor_height
    root_csg.add_child(center_tower)
    _set_owner_recursive(center_tower, get_tree().edited_scene_root)

    var cells_combiner = CSGCombiner3D.new()
    cells_combiner.name = "Cells"
    cells_combiner.operation = CSGShape3D.OPERATION_SUBTRACTION
    main_building.add_child(cells_combiner)
    _set_owner_recursive(cells_combiner, get_tree().edited_scene_root)

    var angle_step = TAU / cell_count
    var cell_center_radius = inner_radius + (cell_depth / 2.0)

    for i in range(cell_count):
        var angle = i * angle_step

        var cell = CSGBox3D.new()
        cell.name = "Cell_" + str(i)
        cell.size = Vector3(cell_width, floor_height - 0.5, cell_depth)

        var x = cos(angle) * cell_center_radius
        var z = sin(angle) * cell_center_radius

        cell.position = Vector3(x, 0.25, z)
        cell.rotation.y = -angle + (PI / 2)

        cells_combiner.add_child(cell)
        _set_owner_recursive(cell, get_tree().edited_scene_root)

    print("Panopticon floor generated!")

func _set_owner_recursive(node: Node, scene_root: Node):
    if scene_root != null:
        node.owner = scene_root
        for child in node.get_children():
            _set_owner_recursive(child, scene_root)

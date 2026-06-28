extends SceneTree

func _init():
    print("Generating scenes...")

    # 1. Player Scene
    var player = CharacterBody3D.new()
    player.name = "Player"
    player.add_to_group("player")
    player.collision_layer = 2 # Match what symbol_encounter expects
    var player_script = load("res://scripts/player/player_controller.gd")
    player.set_script(player_script)

    var player_col = CollisionShape3D.new()
    player_col.name = "CollisionShape3D"
    var capsule_shape = CapsuleShape3D.new()
    player_col.shape = capsule_shape
    player.add_child(player_col)
    player_col.owner = player
    player_col.position.y = 1.0

    var player_mesh = MeshInstance3D.new()
    player_mesh.name = "MeshInstance3D"
    var capsule_mesh = CapsuleMesh.new()
    player_mesh.mesh = capsule_mesh
    player.add_child(player_mesh)
    player_mesh.owner = player
    player_mesh.position.y = 1.0

    var player_scene = PackedScene.new()
    player_scene.pack(player)
    ResourceSaver.save(player_scene, "res://scenes/main/player.tscn")

    # 2. Enemy Symbol Scene
    var enemy = Area3D.new()
    enemy.name = "EnemySymbol"
    var enemy_script = load("res://scripts/enemy/symbol_encounter.gd")
    if enemy_script != null:
        enemy.set_script(enemy_script)

    var enemy_col = CollisionShape3D.new()
    enemy_col.name = "CollisionShape3D"
    var enemy_shape = SphereShape3D.new()
    enemy_col.shape = enemy_shape
    enemy.add_child(enemy_col)
    enemy_col.owner = enemy
    enemy_col.position.y = 0.5

    var enemy_mesh = MeshInstance3D.new()
    enemy_mesh.name = "MeshInstance3D"
    var sphere_mesh = SphereMesh.new()
    var material = StandardMaterial3D.new()
    material.albedo_color = Color(1, 0, 0) # Red
    sphere_mesh.material = material
    enemy_mesh.mesh = sphere_mesh
    enemy.add_child(enemy_mesh)
    enemy_mesh.owner = enemy
    enemy_mesh.position.y = 0.5

    var enemy_scene = PackedScene.new()
    enemy_scene.pack(enemy)
    ResourceSaver.save(enemy_scene, "res://scenes/main/enemy_symbol.tscn")

    # 3. Sample Level Scene
    var level = Node3D.new()
    level.name = "SampleLevel"

    var floor_mesh = MeshInstance3D.new()
    floor_mesh.name = "Floor"
    var plane_mesh = PlaneMesh.new()
    plane_mesh.size = Vector2(20, 20)

    var floor_mat = StandardMaterial3D.new()
    floor_mat.albedo_color = Color(0.2, 0.4, 0.2)
    plane_mesh.material = floor_mat

    floor_mesh.mesh = plane_mesh
    level.add_child(floor_mesh)
    floor_mesh.owner = level

    var floor_body = StaticBody3D.new()
    floor_body.name = "StaticBody3D"
    floor_mesh.add_child(floor_body)
    floor_body.owner = level

    var floor_col = CollisionShape3D.new()
    floor_col.name = "CollisionShape3D"
    var box_shape = BoxShape3D.new()
    box_shape.size = Vector3(20, 0.1, 20)
    floor_col.shape = box_shape
    floor_body.add_child(floor_col)
    floor_col.owner = level

    var camera = Camera3D.new()
    camera.name = "MainCamera"
    camera.position = Vector3(0, 10, 10)
    camera.rotation_degrees = Vector3(-45, 0, 0)
    level.add_child(camera)
    camera.owner = level

    var light = DirectionalLight3D.new()
    light.name = "DirectionalLight3D"
    light.rotation_degrees = Vector3(-60, 45, 0)
    level.add_child(light)
    light.owner = level

    # Instance player
    var p_inst = player_scene.instantiate()
    p_inst.name = "Player"
    p_inst.position = Vector3(0, 0, 0)
    level.add_child(p_inst)
    p_inst.owner = level

    # Instance enemy
    var e_inst = enemy_scene.instantiate()
    e_inst.name = "EnemySymbol"
    e_inst.position = Vector3(5, 0, -5)
    level.add_child(e_inst)
    e_inst.owner = level

    var level_scene = PackedScene.new()
    level_scene.pack(level)
    ResourceSaver.save(level_scene, "res://scenes/main/sample_level.tscn")

    print("Done generating scenes.")
    quit()

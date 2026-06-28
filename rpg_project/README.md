# 3D RPG Project (Panopticon) - 開発マニュアル

Godot 4を用いた、円柱状の塔「パノプティコン」を舞台とする3D RPGのベースプロジェクトです。
Godotの使い方がわからない方でも、以下の手順に沿って設定していくことでゲームを作成できます。

---

## 1. プロジェクトの開き方

1. Godot Engine (バージョン4.2以降推奨) を起動します。
2. プロジェクトマネージャー画面の右上にある「Import (インポート)」ボタンをクリックします。
3. この `rpg_project` フォルダ内にある `project.godot` ファイルを選択し、「Import & Edit」をクリックします。

---

## 2. 各システムの使い方と設定方法

### A. プレイヤーの配置と移動

プレイヤーを動かすための設定です。
すでに `scripts/player/player_controller.gd` というスクリプトが用意されています。

1. 画面左上の「Scene (シーン)」ドックの「+」ボタンを押し、`CharacterBody3D` ノードを作成します。名前を `Player` などに変更します。
2. `Player` ノードを選択した状態で、右側の「Inspector (インスペクター)」の一番下にある「Script」プロパティの「<empty>」をクリックし、「Quick Load」から `player_controller.gd` をアタッチします。
3. プレイヤーの見た目として、`Player` の子ノードに `MeshInstance3D` (例: カプセル型) を追加します。
4. 当たり判定として、`Player` の子ノードに `CollisionShape3D` を追加し、右側のShapeでCapsuleShapeなどを選びます。

### B. マップの作成と固定カメラの切り替え

見下ろし型の固定カメラ（バイオハザードや初期FFのような方式）を設定します。

1. マップを作るために `Node3D` を作成し、床や壁（`CSGBox3D` など）を配置します。
2. エリアごとに `Camera3D` を複数配置します。
3. カメラを切り替えるための「透明なスイッチ」を作ります。
   - `Area3D` ノードを作成し、子ノードに `CollisionShape3D` (当たり判定の範囲) を追加します。
   - `Area3D` に `scripts/systems/camera_zone.gd` をアタッチします。
   - 右側のInspectorに「Linked Camera」という項目が出るので、そこに切り替えたい `Camera3D` ノードをドラッグ＆ドロップします。
4. プレイヤーがこのArea3Dに入ると、自動的に指定したカメラに切り替わります。

### C. 敵との遭遇（シンボルエンカウント）

マップ上の敵の「モヤ」に触れると戦闘が始まる仕組みです。

1. 敵のシンボルとして `Area3D` ノードを作成し、見た目(`MeshInstance3D`)と当たり判定(`CollisionShape3D`)を子ノードに追加します。
2. `Area3D` に `scripts/enemy/symbol_encounter.gd` をアタッチします。
3. 右側のInspectorに以下の項目が表示されます。
   - `Enemy Group Id`: "slime_group" など、遭遇する敵のグループ名を入力します。
   - `Battle Scene Path`: ここに後で作る「戦闘画面のシーンファイル(.tscn)」のパスを設定します。
4. プレイヤーが触れると、画面のロードが開始されます。

### D. マップ移動や戦闘へのシームレスなロードとムービー再生

マップを移動したり戦闘に入る際、ロード中に動画を流す仕組みです。
このシステムは裏側で自動的に動く (`SceneTransitionManager` という名前のAutoLoad) ようになっています。

**使い方（スクリプトから呼び出す場合）**:
別のマップや戦闘画面に切り替えたい時は、任意のスクリプトで以下のように書きます。
```gdscript
SceneTransitionManager.transition_to_scene("res://scenes/next_map.tscn")
```
※ロード中に再生する動画は、`scenes/ui/loading_screen.tscn` 内の `VideoStreamPlayer` ノードに `.ogv` 形式の動画ファイルを設定することで変更できます。

### E. 階層（パノプティコン）と謎解きギミックの作成

円柱の塔の階層ごとの管理と、謎解きのベースです。

1. 階層のマップを作ったら、一番親のノードに `scripts/systems/floor_manager.gd` をアタッチします。
2. Inspectorで「Floor Number（現在の階層）」や「Floor Name（階層名）」を設定します。
3. 謎解きギミック（スイッチなど）を作る場合は、新しいノードを作り `scripts/systems/base_puzzle.gd` をアタッチします。
4. そのギミックが解かれた時に、スクリプト内で `complete_puzzle()` 関数を呼び出すと、階層の管理システムに「クリアした」という通知が自動で飛びます。

### F. RPGデータの作成（アイテムや敵のステータス）

Godotの機能を使って、エディター上で簡単にデータを作れます。

1. 左下の「FileSystem (ファイルシステム)」内で右クリックし、「Create New -> Resource」を選びます。
2. 検索窓に `BaseStats`, `EnemyData`, `ItemData` のいずれかを入力して作成します。
3. 作成されたファイル（例: `slime_data.tres`）をダブルクリックすると、右側のInspectorで「HP」「攻撃力」「名前」などのステータスを直接入力して保存できます。

---

## 開発の進め方

まずは、**「A. プレイヤーの配置」** と **「B. マップの作成と固定カメラ」** を組み合わせて、プロトタイプのマップを作ってプレイヤーを歩かせてみることから始めるのがおすすめです。

### G. パノプティコン（円形刑務所）のマップ自動生成

塔の各階層のベースとなるマップ（中央塔、円形通路、独房）を一瞬で作成できる専用ツールを用意しました。

1. 新しいシーン(`Node3D`)を作成し、名前に `Floor_1` などを付けます。
2. そのノードに `scripts/tools/panopticon_generator.gd` をアタッチします。
3. 右側のInspectorに以下の項目が表示されます。
   - `Outer Radius`: 外壁の半径（全体の広さ）
   - `Inner Radius`: 内周の広場の半径（通路の広さ）
   - `Tower Radius`: 中央の監視塔の太さ
   - `Cell Count`: 外周にくり抜く独房（部屋）の数
4. 数値を調整し、一番上の **`Generate Now`** にチェックを入れます。
5. 3Dビューポートにパノプティコンの基本形状（CSGノード）が自動生成されます！
   - ※自動生成された後に各部屋の `CSGBox3D` のサイズを変えたり、階段(`CSGPolygon3D`など)を手動で追加して、自由に階層をカスタマイズしてください。

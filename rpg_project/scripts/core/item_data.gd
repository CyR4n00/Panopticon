class_name ItemData
extends Resource

enum ItemType { CONSUMABLE, WEAPON, ARMOR, KEY_ITEM }

@export var item_name: String = "Item"
@export_multiline var description: String = ""
@export var item_type: ItemType = ItemType.CONSUMABLE
@export var icon: Texture2D
@export var heal_amount: int = 0
@export var stat_bonus: BaseStats

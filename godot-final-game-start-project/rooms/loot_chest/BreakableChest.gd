extends LootChest

export var health := 10

var no_more_health := false

func _ready() -> void:
	assert(last_gems.size() > 0, "Chest has no last Loot inside his last Inventory")

func take_damage(amount: int) -> void:
	if no_more_health:
		return
	var damage = amount
	while damage > 0:
		health -= 1
		if health <= 0:
			chest_full.hide()
			drop_last_item()
			damage = 0
			no_more_health = true
		else:
			drop_item()
			damage -= 1

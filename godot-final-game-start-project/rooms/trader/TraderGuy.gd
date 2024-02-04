class_name TraderGuy
extends StaticBody2D

export var game_events : Resource = null

const product_prices := {
	preload("res://pickups/health/pickup_health/PickupHealth.tscn") : 600, # Health
	preload("res://pickups/fire_spells/PickupFire.tscn") : 800, # Fire
	preload("res://pickups/ice_spells/PickupIce.tscn") : 800, # Ice
	preload("res://pickups/lightnings_spells/PickupLightning.tscn") : 800, # Lightning
	preload("res://pickups/health/pickup_extra_health/PickupExtraHealth.tscn") : 900, # Extra Health
	preload("res://pickups/health/pickup_regeneration/PickupRegeneration.tscn") : 400, # Regeneration
	preload("res://pickups/health/pickup_kit_slot/PickupKitSlot.tscn") : 1000,
	preload("res://pickups/health/pickup_heal_power/PickupHealPower.tscn") : 750
}

onready var price_label := $PriceHint/Label
onready var animation_player := $AnimationPlayer

export var is_active : bool = false


func _ready() -> void:
	for child in get_children():
		if child is TradeProduct:
			child.connect("buy_product", self, "_buy_product")
			child.connect("show_price", self, "_show_price")
			child.connect("hide_price", self, "_hide_price")
	Events.connect("no_mobs_in_view", self, "_no_mobs_in_view")
	animation_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	

func _buy_product(robot: Robot, product_path: PackedScene, self_path: Node2D) -> void:
	if not product_path in product_prices:
		return
	var price : int = product_prices[product_path] + game_events.extra_payment
	if robot.gold_gems < price or not is_active:
		return
	robot.buy_product(price)
	self_path.drop_product()
	game_events.increase_extra_payment()

func _show_price(product_path: PackedScene) -> void:
	if not product_path:
		return
	var price : String = str(product_prices[product_path] + game_events.extra_payment)
	
	price_label.text = price
	if animation_player.is_playing():
		animation_player.queue("show_price")
	else:
		animation_player.play("show_price")

func _hide_price() -> void:
	if animation_player.is_playing():
		animation_player.queue("hide_price")
	else:
		animation_player.play("hide_price")

func _on_AnimationPlayer_animation_finished(animation: String) -> void:
	if animation == "hide_price":
		price_label.text = "0000"
	

func _no_mobs_in_view() -> void:
	is_active = true

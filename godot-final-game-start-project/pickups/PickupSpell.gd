# Gives the player a new spell.
extends Pickup

enum Type {FIRE, ICE, LIGHT}

var spell_type := {
	Type.FIRE : "fire",
	Type.ICE : "ice",
	Type.LIGHT : "light"
}

# This is the spell that will be set on the player's SpellHolder
export(Type) var spell_type_index: int


#func _on_spell_holder_pickup(holder: SpellHolder) -> void:
	
	

func loot_spell_pickup(holder: SpellHolder) -> void:
	if not holder.has_method("set_spell_scene"):
		return
	# We use the "set_spell_scene" method to pass our spell_scene to the
	# player's spell holder.
	holder.increase_spell_fragment(spell_type[spell_type_index])
	#holder.set_spell_scene(spell_type[spell_type_index])
	
	_disable()
	_animation_player.play("destroy")

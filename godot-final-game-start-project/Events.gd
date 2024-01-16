extends Node

# OnScreenUI
signal mob_died(score_value)
signal set_max_health(max_health)
signal set_gold_gems(gem_value)
signal flash_screen()

signal player_health_changed(new_health)
signal player_heal_kit_changed(new_heal_kit)

signal set_emblem_cooldown(sec)
signal set_emblem_icon(emblem_index)

# Player
signal set_current_camera(toggle_current)

# Baseroom
signal set_mobs_physics(toggle)
signal died_in_baseroom()
signal no_mobs_in_view() # on Teleporter

# Inventory
signal selected_spell_changed(scene)
signal update_max_spell_bar(type_index, updated_value)
signal update_spell_bar(type_index, updated_value)

# Main
signal end_game()
signal next_game()

# Bullets
# LoadedLight
signal set_transform(transform)
signal play_shoot_sound()

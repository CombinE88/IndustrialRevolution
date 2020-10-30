extends Button

func _pressed():
	GameData.game_world.get_node("VillageManager").set_village(text)

extends Spatial

##Function // Local only:
#locally sets camera to the active Village
#hide nonactive villages

func set_village(villageName:String) -> Village:
	
	GameData.cameraAnchor.cursor_handler.set_cursor(null)
	
	var village
	
	for vill in GameData.Villages.keys():
		if villageName == GameData.Villages[vill].Village_Name:
			village =  GameData.Villages[vill]
			break
	
	if village == null:
		return null
	
	if !GameData.game_world.get_children().has(village):
		GameData.game_world.add_child(village)
		
	if !GameData.Villages.has(village):
		GameData.Villages[village.Village_Name] = village
		
	if GameData.cameraAnchor.activeVillage == null:
		GameData.cameraAnchor.activeVillage = village
		village.reInitilize()
		disableVillageButton(village.Village_Name)
	else:
		enableVillageButton(GameData.cameraAnchor.activeVillage.Village_Name)
		GameData.cameraAnchor.activeVillage.deInitilize()
		GameData.cameraAnchor.activeVillage = village
		village.reInitilize()
		disableVillageButton(village.Village_Name)
		
	GameData.cameraAnchor.transform.origin = village.transform.origin + Vector3(0,30,0)
	
	return village

func unload_village():
	if GameData.cameraAnchor.activeVillage != null:
		GameData.cameraAnchor.activeVillage.deInitilize()
	GameData.cameraAnchor.activeVillage = null
	
remote func SetActiveVillage(villageName:String):
	set_village(villageName)

func disableVillageButton(village_name):
	for button in UiLibData.IngamePanelManuTree.find_node("VillageVBoxContainer").get_children():
		if button.text == village_name:
			button.disabled = true
			return

func enableVillageButton(village_name):
	for button in UiLibData.IngamePanelManuTree.find_node("VillageVBoxContainer").get_children():
		if button.text == village_name:
			button.disabled = false
			return

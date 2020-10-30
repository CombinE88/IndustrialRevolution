extends CurserType

class_name PlaceBuildingCursor

func getType() -> String:
	return "PlaceBuildingCursor"

var ghost_item = null
var infoString:String

func _init(parts:Array,actorInfo:String):
	var placementParts:Array = []
	for part in parts:
		placementParts.append(part)
	infoString = actorInfo
		
	ghost_item = Placement_Ghost.new(placementParts)
	GameData.cameraAnchor.activeVillage.add_child(ghost_item)

func handle_cursor(current_cell:Vector2,event:InputEvent,current_click:Vector3 = Vector3(0,0,0)):
	if current_cell == null:
		return
		
	var village_terrain = GameData.cameraAnchor.activeVillage.Village_Terrain
	
	var placing:Footprint = ghost_item.getFirstPartOrDefault("Footprint")
	if(placing == null):
		return
	
	var cell_center = village_terrain.get_centerOfCell(current_cell)
	cell_center += Vector3(
		(placing.origin_x * village_terrain.cellSize.x) + (placing.width / 2.0 * village_terrain.cellSize.x- village_terrain.cellSize.x/2),
		0,
		(placing.origin_y * village_terrain.cellSize.y) + (placing.height / 2.0 * village_terrain.cellSize.y - village_terrain.cellSize.y/2))
	cell_center.y = village_terrain.getAverageHeightOfCell(village_terrain.get_highest_cell(current_cell, placing))
	
	ghost_item.transform.origin = cell_center
	
	var handler = GameData.cameraAnchor.activeVillage.footPrintHandler
			
	if event.is_action_pressed("Rotate"):
		placing.rotate_Footprint()
		ghost_item.rotate_y(deg2rad(90))
	
	if event.is_action_pressed("Mouse_Left_click") && handler.Check_Footprint_can_Occupy(placing,current_cell):
		
		var valued = ghost_item.getFirstPartOrDefault("Valued")
		if valued != null:
			if !ResourceManager.CanWithDrawRecourcesBulk(
			GameData.cameraAnchor.activeVillage.Village_Name,
			GameData.LocalPlayer.PlayerID,
			valued.Cost):
				return
		
		for res in valued.Cost.keys():
			ResourceManager.WithDraw(
				GameData.cameraAnchor.activeVillage.Village_Name,
				GameData.LocalPlayer.PlayerID,
				res,
				valued.Cost[res])
		
		var init = {}
		
		init["Rotation"] = int(round(rad2deg(ghost_item.rotation.y)/90)) % 4
		init["Owner"] = GameData.LocalPlayer.PlayerID
		init["CellPos"] = current_cell
		
		GameData.game_world.get_node("WorldLoader/ActorLoader").AddActorToVillage(
			GameData.cameraAnchor.activeVillage.Village_Name,
			infoString,
			init)
			
		GameData.cursorHandler.queue_cursore_for_free(self)
		#delete self
	return
	
func free_custom(game_world):
	game_world.remove_child(ghost_item)
	if ghost_item != null:
		ghost_item.queue_free()

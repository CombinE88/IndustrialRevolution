extends CurserType

class_name IndoorCellSelectionCursor

func getType() -> String:
	return "IndoorCellSelectionCursor"

var cells:Array
var myself
var cellSize:Vector2
var size:Vector2
var ghost_item

func _init(_size:Vector2,_cellSize:Vector2,_cells:Array,_myself):
	size = _size
	cellSize = _cellSize
	cells=_cells
	myself=_myself
	pass

func _initPlaceObject(parts:Array):
	
	var placementParts:Array = []
	for part in parts:
		placementParts.append(part)
		
	ghost_item = Placement_Ghost.new(placementParts)
	GameData.game_world.CurrentVillage.add_child(ghost_item)

func handle_cursor(current_cell:Vector2,event:InputEvent,current_click:Vector3 = Vector3(0,0,0)):
	
	GameData.game_world.CurrentVillage.add_child(GameData.game_world)
	var subCell = findCellByCoordinates((current_click - myself.transform.origin + Vector3(
			(size.x*cellSize.x/2),
			0,
			(size.y*cellSize.y/2)))) 
	+ Vector2(
		cellSize.x/2,
		cellSize.y/2)
		
	var cellCenterLocation = Vector3(0,0,0)
	
	if(ghost_item == null || !cells.has(subCell)):
		return
		
	cellCenterLocation = myself.transform.origin - Vector3(
		(size.x * cellSize.x)/2,
		0,
		(size.y * cellSize.y)/2) + Vector3(
		(subCell.x * cellSize.x) + cellSize.x/2,
		0,
		(subCell.y * cellSize.y) + cellSize.y/2)
		
	ghost_item.transform.origin = cellCenterLocation
	var footprintHandler = GameData.game_world.selectedItem.getFirstPartOrDefault("FootprintHandler")
	var footprint = ghost_item.getFirstPartOrDefault("Footprint")
		
	if footprintHandler == null || footprint == null:
		return
		
	if event.is_action_pressed("Mouse_Left_click") && footprintHandler.Check_Footprint_can_Occupy(footprint,subCell):
		
		for meshes in ghost_item.getPartsOfType("CSGMesh"):
			meshes.material.albedo_color = Color(1,1,1,1)
			
		var parts = []
		for part in ghost_item.get_children():
			parts.append(part)
			ghost_item.remove_child(part)
		
		var new_item = Actor.new()
		GameData.game_world.add_child(new_item)
		
		new_item.transform.origin = ghost_item.transform.origin
		new_item.rotation = ghost_item.rotation
		footprintHandler.Register_Footprint(new_item,subCell,new_item.getFirstPartOrDefault("Footprint"))
		
		#delete self
		#queue_for_deletion(game_world)
		GameData.game_world.remove_child(ghost_item)
		if ghost_item != null:
			ghost_item.free()
	return
	
func findCellByCoordinates(worldPos:Vector3):
	
	var cellx = round((worldPos.x - 2) / cellSize.x)
	var celly = round((worldPos.z - 2) / cellSize.y)
	
	return Vector2(cellx,celly)


func free_custom(game_world):
	if(ghost_item != null):
		game_world.CurrentVillage.remove_child(ghost_item)
		ghost_item.queue_free()
	return

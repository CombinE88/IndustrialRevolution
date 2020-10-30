extends CurserType

class_name DrawScreenCursor

func getType() -> String:
	return "DrawScreenCursor"

var dragCenter:bool = false
var dragCell:Vector2
var dragMesh: CSGMesh
var dragFootPrint : Footprint
var ghost_item = null

func handle_cursor(current_cell:Vector2,event:InputEvent,current_click:Vector3 = Vector3(0,0,0)):
	var village_terrain = GameData.game_world.CurrentVillage.Village_Terrain
	
	if village_terrain.cells.has(current_cell):
		if !dragCenter && event.is_action_pressed("Mouse_Left_click"):
			dragCell = current_cell
			
			dragMesh = CSGMesh.new()
			dragMesh.mesh = CubeMesh.new()
			dragFootPrint = Footprint.new()
			dragFootPrint.initialize(1,1,"x",0,0)
			
			var newParts = []
			
			newParts.append(dragMesh)
			newParts.append(dragFootPrint)
			
			ghost_item = Placement_Ghost.new(newParts)
			GameData.game_world.CurrentVillage.add_child(ghost_item)
			
			dragCenter = true
			
		elif dragCenter && event.is_action_released("Mouse_Left_click"):
			
			var newX : = abs(dragCell.x - current_cell.x) + 1
			var newY : = abs(dragCell.y - current_cell.y) + 1
			
			var text = ""
			for i in range(newX*newY):
				text += "x"
				
			var smallesCell = Vector2(min(current_cell.x,dragCell.x),min(current_cell.y,dragCell.y))
						
			dragFootPrint.occupationType = text
			var handler = GameData.game_world.CurrentVillage.footPrintHandler
			
			if(!handler.Check_Footprint_can_Occupy(dragFootPrint,smallesCell)):
				ghost_item.queue_free()
				queue_for_deletion()
				return
						
			var buildingInstance = preload("res://Scripts/Scenen/Buildings/Factories/Factory_A.tscn")
			var building = buildingInstance.instance()
			
			building.InitializeFootPrint(
				dragFootPrint.width,
				dragFootPrint.height,
				dragFootPrint.occupationType,
				dragFootPrint.origin_x,
				dragFootPrint.origin_y)
			
			building.InitializeSelectable(dragMesh.mesh.size/2*Vector3(1,0.01,1))
			building.InitializeIndootCellSystem(
				ghost_item.transform.origin,
				Vector2(
					(dragFootPrint.width-1)*2,
					(dragFootPrint.height-1)*2),
				Vector2(2,2),
				GameData.game_world.CurrentVillage.Astar_Navigation,
				[GameData.game_world.CurrentVillage.Astar_Navigation.get_closest_point(
					village_terrain.get_centerOfCell(
						smallesCell + Vector2(dragFootPrint.width,dragFootPrint.height)
						))])
						
			GameData.game_world.CurrentVillage.add_child(building)
			
			building.Cell_Location = smallesCell
			building.transform.origin = ghost_item.transform.origin
			building.rotation = ghost_item.rotation
			building.ConstrucFactory(GameData.standardCellSize)
				
			handler.Register_Footprint(building,building.Cell_Location,building.getFirstPartOrDefault("Footprint"))
			
			ghost_item.remove_child(dragFootPrint)
			dragFootPrint.queue_free()
			
			ghost_item.queue_free()
			queue_for_deletion()
			
			
			return
			
		if(!dragCenter):
			return
			
		var newX : = abs(dragCell.x - current_cell.x) + 1
		var newY : = abs(dragCell.y - current_cell.y) + 1
			
		dragFootPrint.width = newX
		dragFootPrint.height = newY
		
		dragMesh.mesh.size = Vector3(
			newX*4,
			0.5,
			newY*4)
		
		var cell_center = Vector3(
			min(village_terrain.get_centerOfCell(current_cell).x,village_terrain.get_centerOfCell(dragCell).x),
			0,
			min(village_terrain.get_centerOfCell(current_cell).z,village_terrain.get_centerOfCell(dragCell).z))
			
		cell_center += Vector3(
			- village_terrain.cellSize.x / 2.0 -(dragFootPrint.origin_x * village_terrain.cellSize.x) + (dragFootPrint.width / 2.0 * village_terrain.cellSize.x),
			0,
			- village_terrain.cellSize.y / 2.0 -(dragFootPrint.origin_y * village_terrain.cellSize.y) + (dragFootPrint.height / 2.0 * village_terrain.cellSize.y))
		cell_center.y = village_terrain.getAverageHeightOfCell(
			village_terrain.get_highest_cell(
				Vector2(
					min(dragCell.x,current_cell.x),
					min(dragCell.y,current_cell.y)),
				dragFootPrint))
		
		ghost_item.transform.origin = cell_center

func free_custom(game_world):
	game_world.CurrentVillage.remove_child(ghost_item)
	if ghost_item != null:
		ghost_item.free()

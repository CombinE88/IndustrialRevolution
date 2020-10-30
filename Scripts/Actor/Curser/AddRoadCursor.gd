extends CurserType

class_name AddRoadCursor

func getType() -> String:
	return "AddRoadCursor"

var data_tool:MeshDataTool
var roadNetwork

func _init(_roadNetwork:RoadNetwork):
	roadNetwork = _roadNetwork

func handle_cursor(current_cell:Vector2,event:InputEvent,current_click:Vector3 = Vector3(0,0,0)):
	if current_cell == null:
		return
	
	if event.is_action_pressed("Mouse_Left_click") && !GameData.game_world.CurrentVillage.footPrintHandler.Is_Cell_Occupied(current_cell):
		
		GameData.game_world.CurrentVillage.footPrintHandler.BlockCellForBuilding(current_cell)
		GameData.game_world.CurrentVillage.roadNetwork.RegisterNewRoadSegment(GameData.game_world.CurrentVillage.Village_Terrain,current_cell)
		
		if !Input.is_action_pressed("Schift"):
			queue_for_deletion()
			return

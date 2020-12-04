extends Part

class_name FootprintHandler

var Footprints : Dictionary = {}
var cellSystem:Dictionary
var astar:AStar

#TODO Save all Occupied Cells instead, make sit a lot faster ~DONE

func get_class():
	return "FootprintHandler"

func initialize(_cellSystem:Dictionary,_astar:AStar):
	cellSystem = _cellSystem
	astar = _astar

#TODO: change to actor
func Register_Footprint(actor:Actor,cellLocation:Vector2,footprint:Footprint):
	var cells:Array = []
	var actor_centerCell:Vector2 = cellLocation
	for x in range(footprint.width):
		for y in range(footprint.height):
			if(footprint.occupationType[x + footprint.width * y] != "x"):
				continue
			var cellx = actor_centerCell.x - footprint.origin_x + x
			var celly = actor_centerCell.y - footprint.origin_y + y
			cells.append(Vector2(cellx,celly))
			get_node("../FoilageLayer").RemoveTree(Vector2(cellx,celly))
	Footprints[actor] = cells
	
	for cell in cells:
		astar.set_point_disabled(cellSystem[cell], true)

func Remove_Footprint(actor:Actor):
	for cell in Footprints[actor]:
		astar.set_point_disabled(cellSystem[cell], false)
	Footprints.erase(actor)

func Is_Cell_Occupied(cell:Vector2):
	for key in Footprints.keys():
		var entry_value:Array = Footprints.get(key)
		if entry_value.has(cell):
			return true
	return false

func BlockCellForBuilding(cell:Vector2):
	if(!Footprints.keys().has(cell)):
		Footprints[cell] = [cell]
		get_node("../FoilageLayer").RemoveTree(cell)
	pass

func Check_Footprint_can_Occupy(footprint:Footprint,cell:Vector2):
	if !cellSystem.has(cell):
		return false
	for x in range(footprint.width):
		for y in range(footprint.height):
			if(footprint.occupationType[x + y * footprint.width] != "x"):
				continue
			var freshCell:Vector2 = Vector2(x + cell.x - footprint.origin_x, y + cell.y - footprint.origin_y)
			if !cellSystem.has(freshCell) || Is_Cell_Occupied(freshCell):
				return false
	return true

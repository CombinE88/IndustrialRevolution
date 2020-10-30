extends Node

class_name RoadBuilder

var patches:Array = []
var roadCells:Array = []
var beginDistacne:int

remote func addCell(cell):
	roadCells.append(cell)
	
func GeneratePrerenderedRoadNetwork(
	xSize:Vector2,
	ySize:Vector2,
	gridSize:Vector2,
	distance:int,
	randomSeed:int):
		
	patches = GlobalFunctions.Patchgenerator(gridSize,xSize,ySize,randomSeed)
	
	for rect in patches:
		for x in rect.size.x:
			var checkCell = Vector2(rect.position.x + x,rect.position.y + rect.size.y)
			if !roadCells.has(checkCell):
				roadCells.append(checkCell)
			checkCell = Vector2(rect.position.x + x,rect.position.y + rect.size.y + 1)
			if !roadCells.has(checkCell):
				roadCells.append(checkCell)
		for y in rect.size.y:
			var checkCell = Vector2(rect.position.x ,rect.position.y + y)
			if !roadCells.has(checkCell):
				roadCells.append(checkCell)
			checkCell = Vector2(rect.position.x + 1 ,rect.position.y + y)
			if !roadCells.has(checkCell):
				roadCells.append(checkCell)
	
	roadCells.sort_custom(self,"SortyByDistance")
	
	findNewExits(gridSize.x,gridSize.y,distance,randomSeed)
	
func findNewExits(maxXSize:int,maxYSize:int,distance:int,randomSeed:int):
	
	var xZeroRoadPoints = []
	var xMaxRoadPoints = []
	for cell in roadCells:
		if cell.x == 0 && cell.y < maxXSize:
			xZeroRoadPoints.append(cell)
	for cell in roadCells:
		if cell.x == maxXSize-1 && cell.y < maxXSize:
			xMaxRoadPoints.append(cell)
			
	moveFromLeft(xZeroRoadPoints,randomSeed,max(distance-10,1),maxXSize,maxYSize)
	moveFromLeft(xMaxRoadPoints,randomSeed,max(distance-10,1),maxXSize,maxYSize)
	
	AddRoad(distance)
	
func moveFromLeft(cells,mrandomSeed:int,distance:int,maxXSize:int,maxYSize:int):
	var rng = RandomNumberGenerator.new()
	rng.set_seed(mrandomSeed+5)
	
	var currentCell = cells[rng.randi_range(0,cells.size()-1)]
	get_parent().get_parent().AddRoad(currentCell)
	get_parent().get_parent().exits.append(currentCell)
	roadCells.erase(currentCell)
	
	while currentCell.distance_to(Vector2(int(maxXSize/2),int(maxYSize/2))) > distance:
		var nextCell = Vector2(int(maxXSize/2),int(maxYSize/2))
		for cell in roadCells:
			if cell.distance_to(currentCell) < currentCell.distance_to(nextCell):
				nextCell = cell
		if nextCell != Vector2(int(maxXSize/2),int(maxYSize/2)):
			currentCell = nextCell
			get_parent().get_parent().AddRoad(currentCell)
			roadCells.erase(currentCell)
		

func AddRoad(beginDistacne):
	var workWith = roadCells.duplicate()
	for i in range(workWith.size()):
		if (workWith[i]-Vector2(49,49)).length() < beginDistacne:
			get_parent().get_parent().AddRoad(workWith[i])
			roadCells.erase(workWith[i])

func SortyByDistance(a:Vector2, b:Vector2):
	if a != b:
		return (a-Vector2(49,49)).length() < (b-Vector2(49,49)).length()
	else:
		return a < b

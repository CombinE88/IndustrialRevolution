extends Spatial

class_name Village

var Village_Name:String
var Village_Terrain:TerrainWorld
var World_Pos:Vector2

var footPrintHandler
var Astar_Navigation:AStar
var PachtZellen:Dictionary
var villageSeed:int

var exits:Array = []

var ActorList = []

#Recource Storage: Player:Storage Dictionary
var resourceStorage = {}

##debug migration
var time = 0
func _process(delta):
	
	time += delta
	
	if time>2:
		if HasLivingSpaceAvailable():
			var new_mobile = load("res://Scripts/Scenen/MobileActor/Actor.tscn")
			var instanceActor = new_mobile.instance()
			instanceActor.transform.origin = Village_Terrain.get_centerOfCell(exits[0])
			AddActorToVillage(instanceActor)
		time = 0
		
func HasLivingSpaceAvailable()->bool:
	for actor in ActorList:
		var living = actor.getFirstPartOrDefault("ProvidesLivingSpace")
		if living == null:
			continue
		if !living.isFull():
			return true
			
	return false

func _initialize(_name:String,_worldPos:Vector2,_villageSeed:int):
	Village_Name =_name
	World_Pos = _worldPos
	Village_Terrain = $TerrainWorld
	villageSeed = _villageSeed
	
	Astar_Navigation = AStar.new()
	
	global_transform.origin = Vector3(
		GameData.VillageChunkWorldSize.x * World_Pos.x,
		0,
		GameData.VillageChunkWorldSize.y * World_Pos.y)
	
	$RoadNetwork._initialize()

func AddActorToVillage(newactor:Actor):
	add_child(newactor)
	ActorList.append(newactor)
	var footprint = newactor.getFirstPartOrDefault("Footprint")
	if footprint != null:
		footPrintHandler.Register_Footprint(newactor,newactor.Cell_Location,footprint)
	newactor.UpdateParts()
	
func InitializeFootprintHandler():
	footPrintHandler = $FootprintHandler
	footPrintHandler.initialize(Village_Terrain.cells,Astar_Navigation)

func PreloadRoadNetwork(distanceBegin:int):
	$RoadNetwork.get_node("RoadBuilder").GeneratePrerenderedRoadNetwork(Vector2(5,10),Vector2(5,10),Village_Terrain.grid,distanceBegin,villageSeed)

func GenerateTerrain(_grid:Vector2,_cellSize:Vector2,_noise:OpenSimplexNoise,_terrainheight:int,_renderDebug:bool = false):
	Village_Terrain.GenerateTerrain(_grid,_cellSize,_noise,_terrainheight,_renderDebug)
	PopulateAstar()

func CreatePatches(minWidth:int = 6, maxWidth:int = 12,minHeight:int = 6, maxHeight:int = 12):
	var rects = GlobalFunctions.Patchgenerator(Vector2(100,100),Vector2(minWidth,maxWidth),Vector2(minHeight,maxHeight),villageSeed)
	for rect in rects:
		PachtZellen[rect] = null

func reInitilize():
	set_visible(true)
	pass
	
func deInitilize():	
	set_visible(false)
	pass

func IsCellFree(cell:Vector2) -> bool:
	for pacht in PachtZellen:
		var cellArray = PachtZellen.get(pacht)
		for arrayCell in cellArray:
			if arrayCell.x == cell.x && arrayCell.y == cell.y:
				return false
	return true

func AddRoad(cell:Vector2):
	if footPrintHandler.Is_Cell_Occupied(cell):
		return
	footPrintHandler.BlockCellForBuilding(cell)
	$RoadNetwork.RegisterNewRoadSegment(Village_Terrain,cell)

func PopulateAstar(debug:bool = false):
	#Populate CellArray
	
	for x in int(Village_Terrain.grid.x):
		for y in int(Village_Terrain.grid.y):
			
			var astar_Point_Id = Astar_Navigation.get_available_point_id()
			
			var newCell = Vector2(x,y)
			
			if(debug):
				var mesy = CSGBox.new()
				get_parent().add_child(mesy)
				mesy.global_transform.origin = to_global(Village_Terrain.get_centerOfCell(newCell))
			
			Village_Terrain.cells[newCell] = astar_Point_Id
			
			Astar_Navigation.add_point(Village_Terrain.cells[newCell], to_global(Village_Terrain.get_centerOfCell(newCell)),3.0)
			
	for cell in Village_Terrain.cells:
		var checkLeft = Vector2(cell.x-1,cell.y)
		var checkRight = Vector2(cell.x+1,cell.y)
		var checkTop = Vector2(cell.x,cell.y-1)
		var checkBotton = Vector2(cell.x,cell.y+1)
		if Village_Terrain.cells.has(checkLeft):
			Astar_Navigation.connect_points(Village_Terrain.cells[cell],Village_Terrain.cells[checkLeft])
		if Village_Terrain.cells.has(checkRight):
			Astar_Navigation.connect_points(Village_Terrain.cells[cell],Village_Terrain.cells[checkRight])
		if Village_Terrain.cells.has(checkTop):
			Astar_Navigation.connect_points(Village_Terrain.cells[cell],Village_Terrain.cells[checkTop])
		if Village_Terrain.cells.has(checkBotton):
			Astar_Navigation.connect_points(Village_Terrain.cells[cell],Village_Terrain.cells[checkBotton])

extends Spatial

class_name BuildingLoader

func GeneratePreloadedBuildingSet(village:Village,number:int):
	
	var rng = RandomNumberGenerator.new()
	rng.set_seed(village.villageSeed)
	
	var cityCenterFootprint
	for part in ActorDatabase.Rathaus:
		if part[0] == "FootprintPart":
			cityCenterFootprint = Footprint.new()
			cityCenterFootprint.initialize(part[1],part[2],part[3])
			
	FindNextFreePossiblePlacableCell(village,ActorDatabase.Rathaus[0],cityCenterFootprint,0)
	cityCenterFootprint.queue_free()
		
	number = 20
	
	for i in number:
		
		var next = rng.randi_range(0,ActorDatabase.RandomBuildingActor.size()-1)
		
		var buildingFootPrint
		for part in ActorDatabase.RandomBuildingActor[next]:
			if part[0] == "FootprintPart":
				buildingFootPrint = Footprint.new()
				buildingFootPrint.initialize(part[1],part[2],part[3])
		var building = ActorLoader.GenerateNewActor(ActorDatabase.RandomBuildingActor[next])
		
		FindNextFreePossiblePlacableCell(village,ActorDatabase.RandomBuildingActor[next][0],buildingFootPrint,0)
		buildingFootPrint.queue_free()
		
	var lagerhausFootPrint
	for part in ActorDatabase.Lagerhaus:
		if part[0] == "FootprintPart":
			lagerhausFootPrint = Footprint.new()
			lagerhausFootPrint.initialize(part[1],part[2],part[3])
	FindNextFreePossiblePlacableCell(village,ActorDatabase.Lagerhaus[0],lagerhausFootPrint,1)
	lagerhausFootPrint.queue_free()
	
	for part in ActorDatabase.Lagerhaus:
		if part[0] == "FootprintPart":
			lagerhausFootPrint = Footprint.new()
			lagerhausFootPrint.initialize(part[1],part[2],part[3])
	FindNextFreePossiblePlacableCell(village,ActorDatabase.Lagerhaus[0],lagerhausFootPrint,1)
	
	lagerhausFootPrint.queue_free()
	ResourceManager.Deposit(village.Village_Name, 1, "Roh Holz", 400,0)
	ResourceManager.Deposit(village.Village_Name, 1, "Bruchstein", 350,0)
	ResourceManager.Deposit(village.Village_Name, 1, "Zement", 80,0)
	ResourceManager.Deposit(village.Village_Name, 1, "Ziegel", 240,0)
	
func FindNextFreePossiblePlacableCell(village:Village,actorInfo,footprint,ownerId):
	var roadsCells = village.get_node("RoadNetwork").roadCells.duplicate()
	roadsCells.sort_custom(self,"SortyByDistance")
	
	var initDict = {}
	initDict["Owner"] = ownerId
		
	for cell in roadsCells:
		var ceckCellTop = Vector2(cell.x,cell.y+1)
		var checkCellBelow = Vector2(cell.x,cell.y-1)
		if village.footPrintHandler.Check_Footprint_can_Occupy(footprint,ceckCellTop):
			
			initDict["CellPos"] = ceckCellTop
			initDict["Rotation"] = 2
			get_node("../../ActorLoader").AddActorToVillage(village.Village_Name,actorInfo,initDict)
			
			break
		elif village.footPrintHandler.Check_Footprint_can_Occupy(footprint,checkCellBelow):
			
			initDict["CellPos"] = checkCellBelow
			
			get_node("../../ActorLoader").AddActorToVillage(village.Village_Name,actorInfo,initDict)
			break
		
		var ceckCellLeft = Vector2(cell.x+1,cell.y)
		var checkCellRight = Vector2(cell.x-1,cell.y)
		
		footprint.rotate_Footprint()
		
		if village.footPrintHandler.Check_Footprint_can_Occupy(footprint,ceckCellLeft):
			
			initDict["CellPos"] = ceckCellLeft
			initDict["Rotation"] = 3
			
			get_node("../../ActorLoader").AddActorToVillage(village.Village_Name,actorInfo,initDict)
			
			break
		elif village.footPrintHandler.Check_Footprint_can_Occupy(footprint,checkCellRight):
			
			initDict["CellPos"] = checkCellRight
			initDict["Rotation"] = 1
			
			get_node("../../ActorLoader").AddActorToVillage(village.Village_Name,actorInfo,initDict)
			
			break
		
		footprint.rotate_Footprint()
		footprint.rotate_Footprint()
		footprint.rotate_Footprint()
		
			
###DUplication Function: Auslagern in static script
func SortyByDistance(a:Vector2, b:Vector2):
	if a != b:
		return (a-Vector2(49,49)).length() < (b-Vector2(49,49)).length()
	else:
		return a < b


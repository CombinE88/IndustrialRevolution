extends Spatial

class_name ActorLoader

##Function:
#Load Actors into villages

remote func AddActorToVillage(_villageName:String,actorInfo:String,initInformations:Dictionary):
	if !GlobalFunctions.IsServer():
		rpc_id(1,"AddActorToVillage",_villageName,actorInfo,initInformations)
		return
	else:
		rpc("SyncAddActorToVillage",_villageName,actorInfo,initInformations)
		SyncAddActorToVillage(_villageName,actorInfo,initInformations)

# initInformations Dictionary can contain:
# WorldPos:Vector3(x,y,z)
# CellPos:Vector2(x,y)
# Rotation:int
# Owner:playerID

remote func SyncAddActorToVillage(_villageName:String,actorInfo:String,initInformations:Dictionary):
	var actorInfos = FindActorInformations(actorInfo)
	
	if actorInfos.empty():
		return
		
	if initInformations.keys().has("WorldPos") && initInformations.keys().has("CellPos"):
		return
		
	var new_actor = GenerateNewActor(actorInfos)
	
	if initInformations.keys().has("Rotation"):
		new_actor.rotate_y(deg2rad((initInformations["Rotation"] % 4)*90))
		var footprint = new_actor.getFirstPartOrDefault("Footprint")
		if footprint != null:
			for i in initInformations["Rotation"] % 4:
				footprint.rotate_Footprint()
	
	var ownerPlayer = null
	if initInformations.keys().has("Owner"):
		for player in GameData.player.values():
			if player.PlayerID == initInformations["Owner"]:
				ownerPlayer = player
				break
				
	var _village = GameData.Villages[_villageName]
	
	
	if initInformations.keys().has("WorldPos"):
		new_actor.transform.origin = initInformations["WorldPos"]
		
	if initInformations.keys().has("CellPos"):
		new_actor.Cell_Location = initInformations["CellPos"]
		if !initInformations.keys().has("WorldPos"):
			var footprint = new_actor.getFirstPartOrDefault("Footprint")
			if footprint != null:
				new_actor.transform.origin = footprint.CenterOfFootprintLocation(new_actor.Cell_Location,Vector2(4,4),_village.Village_Terrain)
			else:
				new_actor.transform.origin = _village.Village_Terrain.get_centerOfCell(new_actor.Cell_Location)
	if _village != null:
		new_actor._initialize(ownerPlayer)
		_village.AddActorToVillage(new_actor)
		
static func GenerateActorParts(BuildingPartsLoader:Array) -> Array:
	
	var actorParts = []
	
	var loaderParts = BuildingPartsLoader
	
	var mesh = ArrayMesh.new()
	
	for part in loaderParts:
		if part[0] == "ArrayMeshPart":
			mesh = load(part[1])
			var meshInstance = MeshInstance.new()
			meshInstance.mesh = mesh
			actorParts.append(meshInstance)
			break
			
	for part in loaderParts:
		if part[0] == "FootprintPart":
			var footprint = Footprint.new()
			footprint.initialize(part[1],part[2],part[3])
			actorParts.append(footprint)
			
		if part[0] == "ToolTipInfoPart":
			var tooltip = ToolTipInfo.new()
			tooltip.setName(part[1])
			actorParts.append(tooltip)
			
		if part[0] == "Selectable":
			var selectable = Selectable.new()
			selectable.initialize(mesh)
			actorParts.append(selectable)
			
		if part[0] == "ProvidesLivingSpacePart":
			var livingSpace = ProvidesLivingSpace.new()
			livingSpace.LivingSpace = part[1]
			actorParts.append(livingSpace)
		
		if part[0] == "EingangPart":
			var eingang = Eingang.new()
			eingang.initialize(part[2],(part[2]+part[1])/2,part[1])
			actorParts.append(eingang)
			
		if part[0] == "StoresRecources":
			var stores = StoresRecources.new()
			actorParts.append(stores)
			
		if part[0] == "GeneratesRecources":
			var generates = GeneratesRecources.new()
			generates.SetUpProduction(part[1],part[2],part[3])
			actorParts.append(generates)
			
		if part[0] == "Valued":
			var generates = Valued.new()
			generates.initialize(part[1])
			actorParts.append(generates)
			
		if part[0] == "ProvidesWorkingSpace":
			var povidesWork = ProvidesWorkingSpace.new()
			povidesWork.JobName = part[1]
			povidesWork.maxJobs = part[2]
			povidesWork.RequiredTraits = part[3]
			if part.size()>=5:
				povidesWork.Weight = part[4]
			actorParts.append(povidesWork)

	return actorParts

	
static func FindActorInformations(actorInfo:String)->Array:
	for info in ActorDatabase.BuildingInfos:
		if info[0] == actorInfo:
			return info
	return []


static func GenerateNewActor(BuildingPartsLoader:Array) -> Actor:
			
	var new_Actor = Actor.new()
	
	var actorParts = GenerateActorParts(BuildingPartsLoader)
	
	for part in actorParts:
		new_Actor.add_child(part)

	return new_Actor

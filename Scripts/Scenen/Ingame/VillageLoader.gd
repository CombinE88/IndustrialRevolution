extends Spatial

##Function // Network:
#Load new Village into the World
#generate all Village related Data
#sync and share village related data across network

#create patches
#create roadnetwork

#Workflow:
#generate random Data
#share random data across network
#each client and host loads in data and generates villages of it
#villages should be synced

remote func GenerateVillageDataAndAddVillage(villageName:String,randomNumber):
	var noise = OpenSimplexNoise.new()
	noise.set_seed(randomNumber)
	noise.period = 100
	noise.octaves = 2
	AddVillageToWorld(noise,villageName,Vector2(5%randomNumber,5%int(randomNumber/2)),randomNumber)
	
func generateCityName(seedNumber:int) -> String:
	return GameData.stadtVorSilben[seedNumber % GameData.stadtVorSilben.size()] + "" + GameData.stadtNachSilben[seedNumber % GameData.stadtNachSilben.size()]

func AddVillageToWorld(
	noise:OpenSimplexNoise,
	villageName:String,
	location:Vector2,
	villageSeed:int) -> Village:
		
	###Debug Debug Debug
	print(str(location))
	###
	var v1 = preload("res://Scripts/Scenen/Village/Village.tscn")
	var new_village = v1.instance()
	new_village._initialize(villageName,location,villageSeed)
	
	GameData.Villages[villageName] = new_village
	expand_VillageButtons(new_village.Village_Name)
	
	GameData.game_world.add_child(new_village)
		
	#### TODO: Sync Random Roadbuilder
	#### TODO: Sync Random Patchbuilder
	new_village.GenerateTerrain(
		GameData.standardVillageSize,
		GameData.standardCellSize,
		noise,
		10)
	new_village.InitializeFootprintHandler()
	new_village.CreatePatches()
	new_village.PreloadRoadNetwork(GameData.standardRoadPreBuild)
	#### TODO: Sync Random Roadbuilder
	#### TODO: Sync Random Patchbuilder
	
	$BuldingLoader.GeneratePreloadedBuildingSet(new_village,30)
	
	new_village.visible = false
	
	#debug create Units
	for res in ResourceManager.rawRecources:
		ResourceManager.Deposit(new_village.Village_Name,0,res[0],round(res[1]/3),0)

	for res in ResourceManager.craftMaterials:
		ResourceManager.Deposit(new_village.Village_Name,0,res[0],round(res[1]/3),0)

	for res in ResourceManager.luxeryGoods:
		ResourceManager.Deposit(new_village.Village_Name,0,res[0],round(res[1]/3),0)

	return new_village

func expand_VillageButtons(village_Name:String):
	var newButton = UiLibData.IngamePanelManuTree.find_node("VillageVillageSelection").duplicate()
	newButton.text = village_Name
	newButton.visible = true
	UiLibData.IngamePanelManuTree.find_node("VillageVBoxContainer").add_child(newButton)

extends Spatial
	
##Function // Network:
#loads new Worldscene into the game
#handles all Loading releated data
#only used once on loading the entire world

func GenerateWorld(_startVillages = GameData.player.size()):
	
	var startVillages = _startVillages
	startVillages = 1
	
	#generate villages
	if GameData.LocalPlayer.PlayerID != 1:
		return
	
	for player in GameData.player.keys():
		setupNetworkStartVillages(player)
	
	for i in startVillages - GameData.player.size():
		setupNetworkVillages()

func setupNetworkVillages():
	var rngNumber = GlobalFunctions.GetSharedRandomNumber()
	rpc("CreateVillage",rngNumber)
	CreateVillage(rngNumber)
	

remote func CreateVillage(rngNumber):
	var vilname = $VillageLoader.generateCityName(rngNumber)
	$VillageLoader.GenerateVillageDataAndAddVillage(vilname,rngNumber)
	
func setupNetworkStartVillages(playerId):
	var rngNumber = GlobalFunctions.GetSharedRandomNumber()
	rpc("CreateStartVillage",rngNumber,playerId)
	CreateStartVillage(rngNumber,playerId)

remote func CreateStartVillage(rngNumber,playerId):
	var vilname = $VillageLoader.generateCityName(rngNumber)
	$VillageLoader.GenerateVillageDataAndAddVillage(vilname,rngNumber)
	if GameData.LocalPlayer.PlayerID == playerId:
		get_node("../VillageManager").SetActiveVillage(vilname)

extends Node

# name, standart Stack, Preis pro Enheit bei vollem Stack

var rawRecources = [
	["Roh Holz",50,150],
	["Bruchstein",45,100],
	["Lehm",75,80],
	["Kalk",96,70],
	["Eisenerz",24,250],
	["Bauxiterz",32,200],
]

var craftMaterials = [
	["Zement",46,220],
	["Werkzeuge",100,350],
	["Ziegel",75,180]
]

var luxeryGoods = [
	["Schmuck",5,1000],
	["Möbel",8,640],
	["Seide",10,450]
]

remote func WithDraw(village:String,playerID:int,resource:String,amount:int):
	
	if !CanWithDrawRecources(village,playerID,resource,amount):
		return
	
	if !GlobalFunctions.IsServer():
		rpc_id(1,"WithDraw",village,playerID,resource,amount)
		return
	
	rpc("WithDrawRecources",village,playerID,resource,amount)
	WithDrawRecources(village,playerID,resource,amount)
	
remote func Deposit(village:String,playerID:int,resource:String,amount:int,price:int):
	
	if !CanDepositRecources(village,playerID) && resource != "SpielerGold":
		return
	
	if !GlobalFunctions.IsServer():
		rpc_id(1,"Deposit",village,playerID,resource,amount,price)
		return
	
	rpc("StoreRecources",village,playerID,resource,amount,price)
	StoreRecources(village,playerID,resource,amount,price)

func CanWithDrawRecources(villageName:String,playerID:int,resource:String,amount:int)->bool:
	
	if resource == "SpielerGold":
		if GlobalFunctions.GetPlayer(playerID).Gold < amount:
			return false
		return true
	
	var player = GlobalFunctions.GetPlayer(playerID)
	var village = GameData.Villages[villageName]
	
	if player == null:
		return false
		
	var storage = GlobalFunctions.GetPlayerStorage(village,player)
	
	
	if !storage.Resources.keys().has(resource):
		return false
	
	return storage.Resources[resource][0] >= amount
	
func CanWithDrawRecourcesBulk(villageName:String,playerID:int,resources:Dictionary)->bool:
	
	var player = GlobalFunctions.GetPlayer(playerID)
	var village = GameData.Villages[villageName]
	
	if player == null:
		return false
		
	var storage = GlobalFunctions.GetPlayerStorage(village,player)
	
	for res in resources.keys():		
		if !storage.Resources.keys().has(res):
			return false
		if !storage.Resources[res] < resources[res]:
			return false
	
	return true
	
func CanDepositRecources(villageName:String,playerID:int)->bool:
		
	var player = GlobalFunctions.GetPlayer(playerID)
	var village = GameData.Villages[villageName]
	
	if player == null:
		return false
		
	var storage = GlobalFunctions.GetPlayerStorage(village,player)
	
	if storage == null:
		return false
	
	return true
	
remote func WithDrawRecources(villageName:String,playerID:int,resource:String,amount:int):
	var player = GlobalFunctions.GetPlayer(playerID)
			
	if resource == "SpielerGold":
		player.Gold -= amount
		return
	
	var village = GameData.Villages[villageName]
	
	if player == null:
		return
		
	var storage = GlobalFunctions.GetPlayerStorage(village,player)
		
	if !storage.Resources.keys().has(resource):
		return
		
	storage.RemoveResources(resource,amount)

remote func StoreRecources(villageName:String,playerID:int,resource:String,amount:int,price):
	
	var player = GlobalFunctions.GetPlayer(playerID)
		
	if resource == "SpielerGold":
		player.Gold += amount
		return
	
	var village = GameData.Villages[villageName]
	
	if player == null:
		return
		
	var storage = GlobalFunctions.GetPlayerStorage(village,player)
		
	if storage.Resources == null:
		return
		
	storage.AddResources(resource,amount,price)
	
func getCurrentRecources(villageName:String,playerID:int)->Dictionary:
	
	var player = GlobalFunctions.GetPlayer(playerID)
	var village = GameData.Villages[villageName]
	
	if player == null:
		return {}
		
	var storage = GlobalFunctions.GetPlayerStorage(village,player)
	
	if storage == null:
		return {}
		
	return village.resourceStorage[player]
	
func CalculateBuyPriceSpan(
	currentStock:int,
	averageStock:int,
	averagePrice:int,
	percentige:int = 100,
	underPercentSpan:int = 1000,
	abovePercentSpan = 500,
	stauch = 70)->int:
	
	var stauchVar = averageStock*stauch/100
		
	var curveDevider = stauchVar*stauchVar*stauchVar
	var parableStretcher:float = 1/float(curveDevider)
	var stock = averageStock-currentStock
	
	var deteredRange:float = stock*stock*stock*parableStretcher+1
	var currentPrice = averagePrice*deteredRange
	
	var price = min(max(currentPrice,averagePrice*100/underPercentSpan),averagePrice*abovePercentSpan/100)
	
	return int(round(price*percentige/100))

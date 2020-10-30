extends Part

class_name StoresRecources

var Resources:Dictionary = {} setget setRecources, getRecources

func get_class():
	return "StoresRecources"
	
func _ready():
	_self().GetVillage().resourceStorage[_self().Owner] = {}
	
func setRecources(recources:Dictionary)->Dictionary:
	return {}

func getRecources()->Dictionary:
	return _self().GetVillage().resourceStorage[_self().Owner]

func AddResources(type:String,ammount:int,price:int):
	
	var village = _self().GetVillage()
	
	if !village.resourceStorage[_self().Owner].keys().has(type):
		village.resourceStorage[_self().Owner][type] = [ammount,price]
	else:
		var oldValue = village.resourceStorage[_self().Owner][type][0] * village.resourceStorage[_self().Owner][type][1]
		var newValue = ammount*price
		var sumValue = newValue+oldValue
		var sumNewStack = ammount+village.resourceStorage[_self().Owner][type][0]
		var calculatedCalue = int(round(sumValue/sumNewStack))
		
		village.resourceStorage[_self().Owner][type][0] += ammount
		village.resourceStorage[_self().Owner][type][1] = calculatedCalue

func RemoveResources(type:String,ammount:int):
	if !_self().GetVillage().resourceStorage[_self().Owner].has(type):
		return
	
	if _self().GetVillage().resourceStorage[_self().Owner][type][0] < ammount:
		return
	
	_self().GetVillage().resourceStorage[_self().Owner][type][0] -= ammount
	return

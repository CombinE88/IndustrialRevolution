extends Node

class_name ConsumptionHandler

var basicUsageRate = 6000
var MaterialUsages = {}

var verbrauch = {
	"Mittelschicht":{
		# basic resources
		"Fisch":0.03,
		"Weizen":0.03,
		"Roggen":0.03,
		"Tee":0.03,
		"Wein":0.03,
		"Bier":0.03,
		"Kleidung":0.02,
		
		#Luxury
		"Schmuck":0.02,
		"Möbel":0.03,
		"Seide":0.03,
		
		#Craft Materials
		"Werkzeuge":0.02,
		"Stoff":0.03,
		"Seile":0.02,
		},
	"Adlige":{
		# basic resources
		"Fisch":0.01,
		"Weizen":0.01,
		"Roggen":0.01,
		"Tee":0.04,
		"Wein":0.05,
		"Bier":0.02,
		"Kleidung":0.03,
		
		#Luxury
		"Schmuck":0.04,
		"Möbel":0.05,
		"Seide":0.06
		
		},
	"Unterschicht":{
		# basic resources
		"Fisch":0.02,
		"Weizen":0.02,
		"Roggen":0.02,
		"Tee":0.02,
		"Wein":0.01,
		"Bier":0.03,
		"Kleidung":0.01,
		
		#Craft Materials
		"Werkzeuge":0.01,
		"Stoff":0.01,
		"Seile":0.01
		}
	}

func _ready():
	for res in ResourceManager.rawRecources:
		MaterialUsages[res[0]] = 0
	for res in ResourceManager.craftMaterials:
		MaterialUsages[res[0]] = 0
	for res in ResourceManager.luxeryGoods:
		MaterialUsages[res[0]] = 0
	for res in ResourceManager.basicNeeds:
		MaterialUsages[res[0]] = 0
	pass

func TickRecource():
	for res in MaterialUsages.keys():
		MaterialUsages[res] -= 1
		if MaterialUsages[res] <= 0:
			useResource(res)
			RecalculateResource(res)
			
func useResource(resource:String):
	ResourceManager.WithDraw(get_parent().Village_Name,0,resource,1)
	
func RecalculateResource(resource:String):
	
	var demographie = get_node("../PopulationHandler").GetDemographie()
	
	var multiplier:float = 1
	for group in demographie.keys():
		for n in demographie[group].size():
			for group2 in verbrauch.keys():
				if group == group2:
					if verbrauch[group].keys().has(resource):
						var verb = verbrauch[group][resource]
						multiplier += verb
	
	var rate = int(round(basicUsageRate/multiplier))
	
	MaterialUsages[resource] = rate


func Tick():
	TickRecource()
	pass

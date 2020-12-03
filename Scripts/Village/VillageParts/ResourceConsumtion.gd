extends Part

class_name ResourceConsumtion

var Recource:String = ""

func get_class():
	return "ProvidesLivingSpace"

func SetUp(resource:String):
	Recource = resource

func getPopulation()->int:
	var Inhabitants = 0
	
	for actor in get_parent().ActorList:
		var livingSpace =  actor.getFirstPartOrDefault("ProvidesLivingSpace")
		if livingSpace == null:
			continue
		Inhabitants += livingSpace.HousingActos.size()
		
	return Inhabitants


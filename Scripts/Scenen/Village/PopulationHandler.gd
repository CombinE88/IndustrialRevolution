extends Node

class_name PopulationHandler

var time = 0

func _village()->Village:
	return get_parent() as Village
	
func Tick():
	
	if time > 0:
		time -=1
		return
		
	SpawnNewCitizen()
	
func SpawnNewCitizen(prepopulate:bool = false):
	# calulate Demand
	# wenn 30% freie Wohnunge 100% einwanderung
	# wenn 50% freie wohnunge steigert einwanderung bis 4 leute gleichzeitig
	# unter 30% freie wohnungen sinkt wahrscheinlichkeit der einwadnerung bis auf 50%
	
	var gesamtWohnungen = _village().getMaxPossiblePopulation()
	var freieWohnungen = _village().GetFreeLivingSpace()
	
	var prozentFreieWohungen = int(round(freieWohnungen*100/gesamtWohnungen))
	
	if 30 < prozentFreieWohungen && prozentFreieWohungen < 50:
		time = 2500
		
	elif prozentFreieWohungen > 50:
		time = int(2500 / max(1,int(ceil((prozentFreieWohungen - 50) /12.5))))
	
	var demograph = GetDemographie()
	var complettbev = _village().getPopulation()
	
	var demoChoosen:String = ""
	
	for demon in GameData.Demographie.keys():
		if !demograph.keys().has(demon):
			demoChoosen = demon
			break
			
		if demograph[demon].size()*100/max(1,complettbev) < GameData.Demographie[demon]:
			demoChoosen = demon
			break
	
	if demoChoosen == "":
		demoChoosen = GameData.Demographie.keys()[GameData.Demographie.size()-1]
	
	var new_mobile = preload("res://Scripts/Scenen/MobileActor/Actor.tscn")
	var instanceActor = new_mobile.instance()
	
	var info = instanceActor.getFirstPartOrDefault("CitizenInformations")
	if info != null:
		info.CitizenStatus = demoChoosen
		
	instanceActor.transform.origin = _village().Village_Terrain.get_centerOfCell(_village().exits[0])
	_village().AddActorToVillage(instanceActor)

	#move in
	var housing = instanceActor.getFirstPartOrDefault("NeedsLivingSpace")
	var house = null
	if housing == null:
		return
	for actor in _village().ActorList:
		var livingSpace = actor.getFirstPartOrDefault("ProvidesLivingSpace") 
		if livingSpace != null && !livingSpace.isFull():
			housing.MoveInto(actor)
			house = actor
			if prepopulate:
				instanceActor.global_transform.origin = house.global_transform.origin
			break
	if house != null:
		instanceActor.QueueAction("EnterBuildingAction",[house.ActorID])

# Get PopulationDemograpgy

func GetDemographie()->Dictionary:
	var demo = {}
	for actor in _village().ActorList:
		var info = actor.getFirstPartOrDefault("CitizenInformations")
		if info == null:
			continue
		var status = info.CitizenStatus
		if !demo.keys().has(status):
			demo[status] = [actor]
		else:
			demo[status].append(actor)
	return demo

extends Node

class_name WorkplaceHandler

func GetHouseOhneWerkstaette()->Array:
	
	var PossibleHouses = []
	
	for house in get_parent().ActorList:
		if house.Owner != GlobalFunctions.GetPlayer(0):
			continue
		if house.getFirstPartOrDefault("ProvidesLivingSpace") == null:
			continue
		if house.getFirstPartOrDefault("ProvidesWorkingSpace") != null:
			continue
			
		PossibleHouses.append(house)
	
	return PossibleHouses

func GetHouseMitWerkstaette()->Array:
	
	var PossibleHouses = []
	
	for house in get_parent().ActorList:
		if house.Owner != GlobalFunctions.GetPlayer(0):
			continue
		if house.getFirstPartOrDefault("ProvidesLivingSpace") == null:
			continue
		if house.getFirstPartOrDefault("ProvidesWorkingSpace") == null:
			continue
			
		PossibleHouses.append(house)
	
	return PossibleHouses
	
func GetNextFreePeasent()->Actor:
	
	for actor in get_parent().ActorList:
		var work = actor.getFirstPartOrDefault("CanWork")
		if work == null || work.WorkSpace != null:
			continue
			
		return actor
	
	return null
	
func PopulateWorkshops():
	var houses = GetHouseMitWerkstaette()
	for house in houses:
		var getWorkForces = house.getPartsOfType("ProvidesWorkingSpace")
		for workSpace in getWorkForces:
			for i in workSpace.maxJobs:
				var newWorker = GetNextFreePeasent()
				if newWorker == null:
					return
				GlobalFunctions.RegisterWorkerAtWork(newWorker.ActorID,house.ActorID,workSpace.JobName)

func RegisterNewWorkSpace(workspace:Array):
	
	var freeHouses = GetHouseOhneWerkstaette()
	if freeHouses.empty():
		return
		
	var freeHouse = freeHouses[0]
	
	var parts = ActorLoader.GenerateActorParts(workspace)
	
	for part in parts:
		freeHouse.add_child(part)
		part.Update()

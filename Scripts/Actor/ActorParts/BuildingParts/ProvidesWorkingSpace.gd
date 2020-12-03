extends Part

class_name ProvidesWorkingSpace

var maxJobs:int
var WorkingCitizens:Array = []
var JobName:String

#traits die jene Arbeiter benötigen um erfolgreich zu arbeiten
var RequiredTraits = []

# dieser wert beeinflusst die gesamteffektivität der Fabrik. desdo wichtiger der
# je höher sollte der Weight wert sein.
# 100 ist standart 
var Weight = 100

func get_class():
	return "ProvidesWorkingSpace"

func isFull() -> bool:
	return WorkingCitizens.size() >= maxJobs

func RegisterWokring(actor:Actor) -> bool:
	if !isFull():
		WorkingCitizens.append(actor)
		return true
	return false

func RemoveFromJob(actor:Actor):
	if WorkingCitizens.has(actor):
		WorkingCitizens.erase(actor)

func giveExperience():
	if WorkingCitizens.empty():
		return
	for actor in WorkingCitizens:
		var canwork = actor.getFirstPartOrDefault("CanWork")
		if canwork == null:
			continue
		canwork.Work(RequiredTraits)

func getEfficency() -> int:
	var filled =  float(WorkingCitizens.size()) / float(maxJobs) * 100
	var overallQuality = []
	for worker in WorkingCitizens:
		var workQuality:float = 0
		var workforce = worker.getFirstPartOrDefault("CanWork")
		if workforce != null:
			for trait in RequiredTraits:
				if workforce.Traits.keys().has(trait):
					workQuality += workforce.Traits[trait]
			workQuality = (workQuality / max(1,RequiredTraits.size())) / 100
			overallQuality.append(workQuality)
	
	var finalQuality:float = 0
	for quality in overallQuality:
		finalQuality += quality
		
	if !overallQuality.empty():
		finalQuality = finalQuality / overallQuality.size()
	
	return filled * finalQuality
	
func Tick():
	return

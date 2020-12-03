extends Part

class_name GeneratesRecources

var ammount:int = 1
var time:int = 200
var currentTime:float = 0
var resource:String
var started = false

func get_class():
	return "GeneratesRecources"
	
func SetUpProduction(_resource:String,_ammount:int,_time:int):
	resource = _resource
	ammount = _ammount
	time = _time
	
func Update():	
	started = true
	
func produce():
	pass

func calculateGlobalEfficency():
	var jobs = _self().getPartsOfType("ProvidesWorkingSpace")

func Tick():
	if resource == null || resource.empty() || !started:
		return
		
	var jobList = _self().getPartsOfType("ProvidesWorkingSpace")
	var efficencySum:float = 0
	var devider:float = 0
	for job in jobList:
		devider += job.Weight
		efficencySum += job.getEfficency() * job.Weight
	var eff:float = min(100 , max(0 , efficencySum / devider))
		
	currentTime += 1*eff/100
	for job in jobList:
		job.giveExperience()
		
	var price = 0
	
	#TODO: Calculate Price here!!!
	
	if currentTime >= float(time):
		ResourceManager.StoreRecources(
			get_parent().GetVillage().Village_Name,
			get_parent().Owner.PlayerID,
			resource,
			ammount,
			price)
		currentTime = 0

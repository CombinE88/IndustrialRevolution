extends Part

class_name CanWork

# actor in dem gearbeitet wird
var WorkSpace:Actor

# {"TraitName":0-100%} ability
var Traits:Dictionary = {}

#wieviel er minimum möchte
var Lohn:int

func Work(traits:Array):
	for t in traits:
		if !Traits.keys().has(t):
			Traits[t] = float(0)
		elif Traits[t] < 100:
			var fraction = (Traits[t] + 1) * 10
			Traits[t] += float(0.1 / fraction)
		
func get_class():
	return "CanWork"
	
func Update():
	ServerCreateTraits()
	
func HireAtWorkplace(workSpace:Actor):
	WorkSpace = workSpace
	
func Fired():
	WorkSpace = null

func startWoorking(force:bool):
	if WorkSpace != null:
		_self().QueueAction("EnterBuildingAction",[WorkSpace.ActorID],false,force)

remote func generateProcedualTraits(trait:Dictionary):
	for t in trait.keys():
		Traits[t] = trait[t]		
	pass
	
remote func ServerCreateTraits():
	if !GlobalFunctions.IsServer():
		rpc_id(1,"ServerCreateTraits")
		return
	
	var traits:Dictionary
	
	var number = GameData.rng.randi_range(1,5)
	var n = 0
	while n < number:
		var randomSkill = GameData.faehigkeiten[GameData.rng.randi_range(0,GameData.faehigkeiten.size()-1)]
		if traits.keys().has(randomSkill):
			continue
		traits[randomSkill] = GameData.rng.randi_range(1,75)
		n += 1
	
	rpc("generateProcedualTraits",traits)
	generateProcedualTraits(traits)
	

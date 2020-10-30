extends Part

class_name NeedsLivingSpace

var House:Actor

func get_class():
	return "NeedsLivingSpace"
	
func Update():
	var provider:Actor = null
	for actor in _self().GetVillage().ActorList:
		var livingSpace = actor.getFirstPartOrDefault("ProvidesLivingSpace") 
		if livingSpace != null && !livingSpace.isFull():
			MoveInto(actor)
			break
	if House != null:
		_self().QueueAction("EnterBuildingAction",[House.ActorID])
	
func MoveInto(house:Actor):
	var houseSpace = house.getFirstPartOrDefault("ProvidesLivingSpace")
	if houseSpace == null || houseSpace.isFull():
		return
	
	if House != null:
		var oldHouseSpace = House.getFirstPartOrDefault("ProvidesLivingSpace")
		oldHouseSpace.MoveOut(_self())
	
	if houseSpace.RegisterInHouse(_self()):
		House = house

func goHome(force:bool):
	if House != null:
		_self().QueueAction("EnterBuildingAction",[House.ActorID],false,force)
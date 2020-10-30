extends Panel

var _workerCard
var _job

func _unhandled_input(event):
	if event.is_action("Close"):
		close()
		
func close():
	visible = false
	for child in get_node("ArbeiterListePanelInner/ScrollContainer/GridContainer").get_children():
		child.queue_free()
		
func Update():
	rpc("NetworkUpdate")
	NetworkUpdate()

remote func NetworkUpdate():
	if !self.visible:
		return
	HireWorker(_workerCard,_job)
		
func HireWorker(workerCard,job:ProvidesWorkingSpace):
	_workerCard = workerCard
	_job = job
	close()
	self.visible = true
	# create Worker List
	for actor in job._self().GetVillage().ActorList:
		var workForce = actor.getFirstPartOrDefault("CanWork")
		if workForce == null:
			continue
		if workForce.WorkSpace != null:
			continue
		
		var new_Karta = load("res://User_Interface/UIScenes/ExampleWorkerCard.tscn")
		var karte_instanced = new_Karta.instance()
		karte_instanced.setUpKarta(self,workerCard,workForce,job)
		get_node("ArbeiterListePanelInner/ScrollContainer/GridContainer").add_child(karte_instanced)

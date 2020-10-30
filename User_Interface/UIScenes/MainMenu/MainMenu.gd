extends Button

func _pressed():
	if GameData.LocalPlayer == null:
		var network = load("res://Networking/Host/Server.gd").new()
		GameData.network = network
		get_node("../../..").add_child(GameData.network)
		GameData.network.StartServer(1)
	
	rpc("setScene")
	setSceneServer()
	
remote func setScene():
	get_tree().change_scene("res://Scripts/Scenen/Ingame/World.tscn")
	
func setSceneServer():
	get_tree().change_scene("res://Scripts/Scenen/Ingame/World.tscn")


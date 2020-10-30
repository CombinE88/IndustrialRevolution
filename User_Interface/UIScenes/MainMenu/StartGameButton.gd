extends Button

func _pressed():
	if GameData.LocalPlayer == null:
		GameData.hostNetwork.CreateServerPlayer("localhost")
		GameData.hostNetwork.StartServer(1)
	
	rpc("setScene")
	setScene()
	
remote func setScene():	
	UiLibData.LoadingScreen.visible = true
	UiLibData.MainMenuTree.visible = false
	UiLibData.LobbyPanel.visible = false
	
	var new_world = preload("res://Scripts/Scenen/Ingame/World.tscn")
	var instancedWorld = new_world.instance()
	get_node("../../..").add_child(instancedWorld)

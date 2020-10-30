extends Button

func _ready():
	var network = load("res://Networking/Host/Server.gd").new()
	GameData.hostNetwork = network
	add_child(network)

func _pressed():
	GameData.hostNetwork.StartServer()
	get_node("../GridContainer/connectToHost").disabled = true
	disabled = true
	get_node("../../..").set_position(Vector2(0,0))
	get_node("../../../../LobbyPanel").visible = true
	GameData.hostNetwork.CreateServerPlayer(getPlayerName())
		
func SetupPlayerGrid(player):
	var playerSceneScript = preload("res://Networking/LobbyPlayer.tscn")
	var playerSceneInstance = playerSceneScript.instance()
	
	get_node("../../../../LobbyPanel/PlayerGrid").add_child(playerSceneInstance)
	
	playerSceneInstance.get_node("NameLabel").text = player.PlayerName
	playerSceneInstance.get_node("IDLabel").text = str(player.PlayerID)
	
	if player.PlayerID == 1:
		playerSceneInstance.get_node("IPLabel").text = "localhost"
	else:
		playerSceneInstance.get_node("IPLabel").text = "Ip stands here"

func getPlayerName() -> String:
	return get_node("../playerName").text

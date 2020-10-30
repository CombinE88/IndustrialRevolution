extends Button

func _ready():
	var network = load("res://Networking/Client/Server.gd").new()
	network.ipChild = get_node("../ipTarget")
	network.portChild = get_node("../ipPort")
	GameData.clientNetwork = network
	add_child(network)

func _pressed():
	GameData.clientNetwork.ConnectToServer()

func disableButtons():
	get_node("../../hostGame").disabled = true
	get_node("../../startGame").disabled = true
	get_node("../ipTarget").readonly = true
	get_node("../../../..").visible = false
	get_node("../../../../../LobbyPanel").visible = true
	disabled = true

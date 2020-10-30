extends Node

var network = NetworkedMultiplayerENet.new()
var port = 1337
var max_players = 100
	
func StartServer(playerCount:int = max_players):
	network.create_server(port,playerCount)
	get_tree().set_network_peer(network)
	print("Server started")

	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	
func CreateServerPlayer(playerName):
	var localPlayer = Player.new()
	localPlayer.PlayerID = 1
	localPlayer.PlayerName = playerName
	GameData.player[1] = localPlayer
	
	GameData.LocalPlayer = localPlayer
	
	get_parent().SetupPlayerGrid(localPlayer)

func _Peer_Connected(player_id):
	print("User: "+str(player_id) + " Connected")
	rpc_id(player_id,"RequestPlayerInformation",player_id)

func _Peer_Disconnected(player_id):
	print("User: "+str(player_id) + " Disconnected")
	for pl in GameData.player.duplicate():
		if pl.key() == player_id:
			 GameData.player.erase(pl)

remote func RequestPlayerInformation(player_id):
	var playerName = get_parent().getPlayerName()
	rpc_id(1,"SendPlayerInformation",player_id,playerName)
	pass
	
remote func SendPlayerInformation(player_id,playerName):
	var newClient = Player.new()
	newClient.PlayerID = player_id
	newClient.PlayerName = playerName
	GameData.player[player_id] = newClient
	get_parent().SetupPlayerGrid(newClient)
	for player in GameData.player.values():
		rpc_id(player_id,"SyncPlayerPool",player.PlayerID,player.PlayerName,player.PlayerID==player_id)
	
remote func SyncPlayerPool(player_id,playerName,isLocal):
	if !GameData.player.has(playerName):
		var newClient = Player.new()
		newClient.PlayerID = player_id
		newClient.PlayerName = playerName
		GameData.player[player_id] = newClient
		get_parent().SetupPlayerGrid(newClient)
		if isLocal:
			GameData.LocalPlayer = newClient

extends Node

var network = NetworkedMultiplayerENet.new()
var port = 1337
var ip = "192.168.178.46"
var ipChild
var portChild

func ConnectToServer():
	ip = ipChild.text
	port = portChild.text
	if(network.create_client(ip,int(float(port))) != OK):
		_OnConnectionFailed()
		return
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")

func _OnConnectionFailed():
	print("Failed to connect")

func _OnConnectionSucceeded():
	print("Succesfully connected")
	get_parent().disableButtons()

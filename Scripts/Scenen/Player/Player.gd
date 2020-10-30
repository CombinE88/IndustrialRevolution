extends Node

class_name Player

var PlayerID:int
var PlayerName:String
var Gold:int = 0

func IsLocalPlayer() -> bool:
	return GameData.LocalPlayer == self

static func GetCameraAnchor():
	return GameData.cameraAnchor

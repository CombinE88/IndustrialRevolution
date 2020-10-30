extends Spatial

class_name Game_World

##Function // Network:
#basenode of the game
#does nothing but holding nodes and set references

func _ready():
	GameData.game_world = self
	GameData.cameraAnchor = $CameraAnchor
	
	$WorldLoader.GenerateWorld()
	
	UiLibData.LoadingScreen.visible = false
	UiLibData.IngamePanelManuTree.visible = true

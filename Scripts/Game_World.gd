extends Spatial

class_name Game_World

##Function // Network:
#basenode of the game
#does nothing but holding nodes and set references
var tickRate:float = 0.02
var deltaRate:float = 0

func _ready():
	GameData.game_world = self
	GameData.cameraAnchor = $CameraAnchor
	
	$WorldLoader.GenerateWorld()
	
	UiLibData.LoadingScreen.visible = false
	UiLibData.IngamePanelManuTree.visible = true

func _process(delta):
	deltaRate += delta
	while deltaRate >= tickRate:
		Tick()
		deltaRate -= tickRate

func Tick():
	for vill in GameData.Villages.values():
		vill.Tick()

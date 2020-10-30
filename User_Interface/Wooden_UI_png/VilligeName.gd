extends Label

func _process(delta):
	if Player.GetCameraAnchor() != null:
		if Player.GetCameraAnchor().activeVillage != null:
			text = Player.GetCameraAnchor().activeVillage.Village_Name

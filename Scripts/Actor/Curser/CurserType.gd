extends Object

class_name CurserType

func getType() -> String:
	return "CurserType"

func handle_cursor(current_cell:Vector2,event:InputEvent,current_click:Vector3 = Vector3(0,0,0)):
	return

func queue_for_deletion():
	GameData.game_world.cameraAnchor.cursor_handler.queue_cursore_for_free(self)

func free_custom(game_world):
	return

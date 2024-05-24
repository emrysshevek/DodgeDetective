class_name LevelUI extends CanvasLayer


@onready var start_text = get_node("Control/MarginContainer/StartingText")
@onready var end_text = get_node("Control/MarginContainer/EndingText")
@onready var pause_menu: PauseMenu = get_node("Control/PauseMenu")

func set_level_name(name):
	(start_text.get_child(0) as Label).text = name
	
func show_start():
	start_text.show()
	end_text.hide()
	pause_menu.hide()
	
func show_end():
	start_text.hide()
	end_text.show()
	pause_menu.hide()

func show_pause():
	start_text.hide()
	end_text.hide()
	pause_menu.show()
	
func hide_all():
	start_text.hide()
	end_text.hide()
	pause_menu.hide()

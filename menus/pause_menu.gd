class_name PauseMenu extends Control

signal resume
signal restart
signal options
signal home

func _on_resume_button_clicked():
	resume.emit()
	
func _on_restart_button_clicked():
	restart.emit()
	
func _on_options_button_clicked():
	options.emit()
	
func _on_home_button_clicked():
	home.emit()

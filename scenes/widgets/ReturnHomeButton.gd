extends Button

var return_home_on_pressed := true
signal ReturningHome


func _on_pressed():
	emit_signal("ReturningHome")
	if return_home_on_pressed:
		return_home()

func return_home():
	get_tree().change_scene("res://scenes/menu/menu.tscn")

extends PanelContainer

const help_text = "HELPTEXT"

func _on_HelpButton_pressed():
	var x = AcceptDialog.new()
	x.window_title = ""
	x.dialog_text = get_help_text()
	add_child(x)
	x.popup_centered()


func _on_Demo_pressed():
	if get_tree().change_scene("res://scenes/runners/demo.tscn") !=0: print("err")
	


func _on_ParametersButton_pressed():
	get_tree().change_scene("res://scenes/custom_menu.tscn")

func _on_FastMode_pressed():
	if get_tree().change_scene("res://scenes/runners/fast.tscn") !=0: print("err")


func _on_NUpMode_pressed():
		if get_tree().change_scene("res://scenes/runners/n.tscn") !=0: print("err")


func get_help_text() -> String:
	return TranslationServer.translate(help_text)

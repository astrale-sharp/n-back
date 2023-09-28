extends Control

var x := preload("res://scenes/main/main.tscn").instance()

func _ready():
	x.parameters = $"/root/Configsaveload".n_up
	x.parameters.delay = 0.1
	x.connect("EndGame",self,"reload")
	add_child(x)

func reload():
	print("reload")
	x._on_n_plus_1_button()

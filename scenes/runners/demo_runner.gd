extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	var x := preload("res://scenes/main/main.tscn").instance()
	x.parameters = $"/root/Configsaveload".demo
	add_child(x)
	x.connect("EndGame",self,"on_end_game")
	# connect to stat printer on end
	
func on_end_game():
	modulate = Color.beige
	yield(get_tree().create_timer(2.5),"timeout")
	get_tree().change_scene("res://scenes/menu/menu.tscn")
	pass

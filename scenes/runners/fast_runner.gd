extends Control


func _ready():
	var x := preload("res://scenes/main/main.tscn").instance()
	x.parameters = $"/root/Configsaveload".fast
	x.connect("EndGame",x,"_on_accelerate_button")
	# record score, show score at end
	add_child(x)

extends VBoxContainer

#
#func _ready():
#	visible = owner.Debug
#	if owner.Debug:
#		owner.connect("MissedPositionTrigger",self,"signal_received")
#		owner.connect("GotPositionTrigger",self,"signal_received")
#		owner.connect("NextTurn",self,"on_next_turn")
#
#func signal_received():
#	trigger()
#
#func on_next_turn():
#	untrigger()
#
#func trigger():
#	$ColorRect.color = Color.green
#
#func untrigger():
#	$ColorRect.color = Color.red
#

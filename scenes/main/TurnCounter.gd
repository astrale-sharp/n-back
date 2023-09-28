extends Node

signal LastTurn

var turn_count := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	owner.connect("NextTurn",self,"count")

func reset():
	turn_count = 0

func count():
	turn_count += 1
	owner.turn_label.text = owner.label_printer.print_turn(max(owner.parameters.max_turns,owner.parameters.n + 1),owner.parameters.n,turn_count)
	if turn_count == max(owner.parameters.max_turns,owner.parameters.n + 1):
		emit_signal("LastTurn")


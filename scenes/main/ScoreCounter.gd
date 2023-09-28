extends Node

# tuple (hit_points, missed_points, wrong_hits)
#var score = [0,0,0] setget set_score
var POSITION = 0
var SOUND = 1
var COLOR = 2

var score 

func reset():
	score = {
	POSITION : [0,0,0],
	SOUND : [0,0,0],
	COLOR : [0,0,0],
}


func set_score(value):
	score = value
	owner.score_label.bbcode_text =  owner.label_printer.print_score(score)

#idx is for indexing the "tuple"
func _update_score_by_value(type_idx,idx):
	var new_score = score.duplicate(true)
	new_score[type_idx][idx] += 1
	set_score(new_score)

func _ready():
	reset()
	owner.connect("PressedSuccessfully",self,"_update_score_by_value",[0])
	owner.connect("ForgotToPress",self,"_update_score_by_value",[1])
	owner.connect("PressedByMistake",self,"_update_score_by_value",[2])


extends GutTest

var instance := preload("res://scenes/main/main.tscn").instance()


func before_all():
	gut.p("ran run setup", 2)

func before_each():
	instance = preload("res://scenes/main/main.tscn").instance()
	var p = Parameters.new()
	p.n = 1
	p.max_turns = 9999
	p.delay = 9999.0
	instance.parameters = p
	add_child(instance)
		
func after_each():
	instance.queue_free()


func test_it_instanciates():
	assert_true(true)

func test_it_updates_score_missed_points():
	assert_eq(instance.get_node("ScoreCounter").score[0],[0,0,0],"score starts at 0 0 0 ")
	instance.turn(instance.position_button,instance.POSITION,instance.grid.get_child(0))
	instance.turn(instance.position_button,instance.POSITION,instance.grid.get_child(0))
	instance.turn(instance.position_button,instance.POSITION,instance.grid.get_child(0))	
	assert_eq(instance.get_node("ScoreCounter").score[0],[0,1,0],"missed a point")
	
func test_it_updates_score_hit_points():
	assert_eq(instance.get_node("ScoreCounter").score[0],[0,0,0],"score starts at 0 0 0 ")
	instance.turn(instance.position_button,instance.POSITION,instance.grid.get_child(0))
	instance.turn(instance.position_button,instance.POSITION,instance.grid.get_child(0))
	instance.position_button.pressed = true
	instance.position_button.emit_signal("pressed")
	instance.turn(instance.position_button,instance.POSITION,instance.grid.get_child(0))
	assert_eq(instance.get_node("ScoreCounter").score[0],[1,0,0],"got a point")

func test_it_updates_score_wrong_points():
	assert_eq(instance.get_node("ScoreCounter").score[0],[0,0,0],"score starts at 0 0 0 ")
	instance.turn(instance.position_button,instance.POSITION,instance.grid.get_child(0))
	instance.turn(instance.position_button,instance.POSITION,instance.grid.get_child(1))
	instance.position_button.emit_signal("pressed")
	instance.position_button.pressed = true
	instance.turn(instance.position_button,instance.POSITION,instance.grid.get_child(0))
	assert_eq(instance.get_node("ScoreCounter").score[0],[0,0,1],"wrongful hit!")


extends GutTest



func test_saves_and_loads():
	var data := ConfigData.new()
	data.n_up = Parameters.new()
	data.n_up.n = 7
	ResourceSaver.save("res://config/config1.res",data)
	var loaded = load("res://config/config1.res")
	assert_eq(data.n_up.n,7)
	assert_not_null(loaded.n_up)
	pending()
#	assert_eq(loaded.n_up.n,7)

func test_save_and_loads_parameters():
	var p = Parameters.new()
	p.n = 60
	ResourceSaver.save("res://config/test_param.res",p)
	var loaded = load("res://config/test_param.res")
	assert_not_null(loaded)
	assert_eq(p.n,loaded.n)


func test_prints():
	var c = get_node("/root/Configsaveload")
	var d = c._load()
	assert_not_null(d.last_edited,"nothing stored in last edited")

	
func test_it_saves():
	var c = get_node("/root/Configsaveload")
	var p = c._load()
	
	var temp := Parameters.new()
	temp.n = 66
	temp.delay = 20.0
	temp.max_turns = 30
	
	c.data.last_edited = temp
	c.save()
#	assert_eq(c._load(),temp)
	assert_eq(c._load().last_edited.n,temp.n)
	assert_eq(c._load().last_edited.delay,temp.delay)
	assert_eq(c._load().last_edited.max_turns,temp.max_turns)

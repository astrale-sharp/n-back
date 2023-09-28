extends Panel

signal NextTurn
# emitted with type
signal ForgotToPress
signal PressedSuccessfully
signal PressedByMistake
signal EndGame


export var Debug := false

const POSITION = 0
const SOUND = 1
const COLOR = 2
#const NUMBER = 3

var parameters : Parameters = Parameters.new()
func color_delay() -> float:
	return 1.5/ 5.0 * parameters.delay


onready var audio = $"%Audio"
onready var buttons = {
	POSITION :  $"%PositionButton",
	SOUND :  $"%SoundButton",
	COLOR : $"%ColorButton",
}

onready var grid := $"%GridContainer"
onready var backup_rect := $"%SpecialColorRect" as ColorRect

onready var start_timer := $"%Timer" as Timer

onready var turn_counter = $"%TurnCounter" 

onready var label_printer = $"%LabelPrinter"
onready var n_label := $"%NLabel" as Label
onready var delay_label := $"%DelayLabel" as Label
onready var turn_label := $"%RemainingTurnLabel" as Label
onready var score_label := $"%ScoreLabel" as RichTextLabel

onready var n_plus_button = $"%N+" as Button
onready var accelerate_button = $"%Accelerate" as Button


var is_last_turn : bool 
var end_next_turn : bool
var cached_color : Color

var should_press_next_turn 

var queue



func _ready():
	assert(parameters != null)
	assert(audio != null)
	assert(buttons[POSITION] != null)
	assert(buttons[SOUND] != null)
	assert(buttons[COLOR] != null)
	assert(grid != null)
	assert(backup_rect != null)
	assert(start_timer != null)
	assert(turn_counter != null)
	assert(label_printer != null)
	assert(n_label != null)
	assert(delay_label != null)
	assert(turn_label != null)
	assert(score_label != null)
	assert(n_plus_button != null)
	assert(accelerate_button != null)

	randomize()
	turn_counter.connect("LastTurn",self,"_on_last_turn_signal_received")
	start_timer.connect("timeout",self,"_on_timer")
	n_plus_button.connect("pressed",self,"_on_n_plus_1_button")
	accelerate_button.connect("pressed",self,"_on_accelerate_button")

	initialize()


func _on_timer():
	if parameters.select_mode[POSITION]: turn(POSITION,_select_random_position())
	if parameters.select_mode[SOUND]: turn(SOUND,_select_random_sound())
	if parameters.select_mode[COLOR]: turn(COLOR, cached_color)
	emit_signal("NextTurn")
	

func _on_game_end():
	emit_signal("EndGame")
#	$Timer.stop()

func _on_last_turn_signal_received():
	is_last_turn = true
	
func _on_n_plus_1_button():
	parameters.n += 1
	initialize()

# TODO make customazible
func _on_accelerate_button():
	parameters.delay *= 9.0/10.0
	initialize()
	
################################################


func turn(signal_type: int, extern_node):
	if end_next_turn:
		_on_game_end()
		return
	var button = buttons[signal_type]
	var should_press = should_press_next_turn[signal_type]
	should_press_next_turn[signal_type] = false
	var shouldnt_select_next_item = false
	
	var pressed = button.pressed
	button.pressed = false
	if should_press:
		if pressed:
			emit_signal("PressedSuccessfully",signal_type)
		else:
			emit_signal("ForgotToPress",signal_type)
	elif pressed:
		emit_signal("PressedByMistake",signal_type)
	
	if is_last_turn:
		button.disabled = true
		shouldnt_select_next_item = true
		end_next_turn = true
		return
	
	match signal_type:
		POSITION:
			if parameters.select_mode[COLOR]:
				cached_color = _select_random_color()
				_change_color_temp(extern_node,cached_color)
			else: _change_color_temp(extern_node,Color.aqua)
		SOUND:
			_play_sound(extern_node)
		COLOR:
			# light backup colorrect
			if not parameters.select_mode[POSITION]:
				cached_color = _select_random_color()
				extern_node = cached_color
				_change_color_temp(backup_rect,cached_color)
			
	add_to_queue(signal_type,extern_node)
	# queue is long enough?
	if queue[signal_type].size() == parameters.n + 1:
		button.disabled = false
		if should_be_pressed(signal_type):
			should_press_next_turn[signal_type] = true
	else:
		button.disabled = true

func initialize():
	for k in [POSITION,SOUND,COLOR]:
		if not parameters.select_mode[k]: buttons[k].visible = false
	
	queue = {
		POSITION : [],
		SOUND : [],
		COLOR : [],
	}
	
	should_press_next_turn = {
		POSITION : false,
		SOUND : false,
		COLOR : false
	}
	
	
	is_last_turn = false
	end_next_turn = false
	$ScoreCounter.reset()
	$TurnCounter.reset()
	n_label.text = label_printer.print_n(parameters.n)
	delay_label.text = label_printer.print_delay(parameters.delay)
	turn_label.text = label_printer.print_turn(parameters.max_turns,parameters.n,0) 
	$ScoreCounter.set_score($ScoreCounter.score)
	start_timer.wait_time = parameters.delay
	start_timer.one_shot = false
#	start_timer.stop()
	start_timer.start()
	print("initialize!")

###################################################

func add_to_queue(_type,x):
	queue[_type].push_front(x)
	if queue[_type].size() > parameters.n + 1:
		queue[_type].pop_back()


func should_be_pressed(sig_type):
	return queue[sig_type].back() == queue[sig_type].front()


################################################### 
func _select_random_position() -> ColorRect:
	if Debug: return grid.get_child(randi() % 3) as ColorRect

	# idx cannot be 4 because the middle color rect is special and shouldnt be colored so the game is more interesting
	var idx = randi() % grid.get_child_count()
	while idx == 4:
		idx = randi() % grid.get_child_count()
	return grid.get_child(idx) as ColorRect

func _select_random_sound():
	if Debug: return audio.get_child(randi() % 3)
	return audio.get_child(randi() % audio.get_child_count())

func _select_random_color():
	var colors = [Color.aqua,Color.red,Color.gold,Color.green,Color.violet,Color.black,Color.orange,Color.brown] if not Debug else [Color.aqua,Color.red,Color.gold]
	colors.shuffle()
	return colors.pop_back()


# TODO, accelerate the sound if delay is too short
func _play_sound(sound : AudioStreamPlayer):
	sound.play()

func _change_color_temp(x, temp_color : Color):
	if not is_last_turn:
		x.color = temp_color
		get_tree().create_timer(color_delay()).connect("timeout",self,"_turn_white_back",[x])


func _turn_white_back(x):
	x.color = Color.white

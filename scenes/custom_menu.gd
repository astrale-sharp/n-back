extends Panel
onready var return_home_button = $"%ReturnHomeButton"

var should_ask_to_save_before_exit := true

func _ready():
	$"%SaveButton".connect("pressed",self,"_save_button_pressed")
	$"%InputN".connect("value_changed",self,"_on_edit")
	$"%InputDelay".connect("value_changed",self,"_on_edit")
	$"%InputTurns".connect("value_changed",self,"_on_edit")
	$"%IsPositionEnabled".connect("toggled",self,"_on_edit")
	$"%IsSoundEnabled".connect("toggled",self,"_on_edit")
	$"%IsColorEnabled".connect("toggled",self,"_on_edit")
	return_home_button.return_home_on_pressed = false
	return_home_button.connect("ReturningHome",self,"confirm_and_exit")
	
	var le = $"/root/Configsaveload".last_edited
	if le != null:
		set_ide(le)
	
func set_ide(p : Parameters):
	$"%InputN".value = p.n
	$"%InputDelay".value = p.delay
	$"%InputTurns".value = p.max_turns
	$"%IsPositionEnabled".pressed = p.select_mode[0]
	$"%IsSoundEnabled".pressed = p.select_mode[1]
	$"%IsColorEnabled".pressed = p.select_mode[2]
	
	
	
func get_ide()-> Parameters:
	var p := Parameters.new()
	p.n = $"%InputN".value
	p.delay = $"%InputDelay".value
	p.max_turns = $"%InputTurns".value
	p.select_mode = {
		0:  $"%IsPositionEnabled".pressed,
		1: 	$"%IsSoundEnabled".pressed,
		2: 	$"%IsColorEnabled".pressed,
	}
	return p

func _save_button_pressed():
	var p = get_ide()
	match $"%OptionButton".selected:
		0: #demo
			$"/root/Configsaveload".demo = p
		1: #fast
			$"/root/Configsaveload".fast = p
		2: # nup
			$"/root/Configsaveload".n_up = p
		3: # all
			$"/root/Configsaveload".demo = p
			$"/root/Configsaveload".fast = p
			$"/root/Configsaveload".n_up = p
	$"/root/Configsaveload".last_edited = p
	$"/root/Configsaveload".save()
	set_ide(p)

func _on_edit(x):
	print("edit")
	$"/root/Configsaveload".last_edited = get_ide()
	$"/root/Configsaveload".save()
#	_should_save_before_exit()
		
		
func _should_save_before_exit():
	var to_compare
	match $"%OptionButton".selected:
		0: #demo
			to_compare = $"/root/Configsaveload".demo
			$"/root/Configsaveload".last_edited = to_compare
		1: #fast
			to_compare = $"/root/Configsaveload".fast
			$"/root/Configsaveload".last_edited = to_compare
		2: # nup
			to_compare = $"/root/Configsaveload".n_up
			$"/root/Configsaveload".last_edited = to_compare
		3:
			should_ask_to_save_before_exit = true
			return

	should_ask_to_save_before_exit = not get_ide().is_equal(to_compare)



func confirm_and_exit():
	_should_save_before_exit()
	if not should_ask_to_save_before_exit:
		return_home_button.return_home()
#	else:
	var cd = ConfirmationDialog.new()
	cd.dialog_text = "SAVE_BEF_EXIT"
	cd.window_title = ""
	cd.get_ok().connect("pressed",self,"save_and_exit")
	cd.get_cancel().connect("pressed",self,"restore_and_return_home")
	add_child(cd)
	cd.popup_centered()

func restore_and_return_home():
#	set_ide(get_ide())
	return_home_button.return_home()

func save_and_exit():
	_save_button_pressed()
	return_home_button.return_home()


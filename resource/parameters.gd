extends Resource
class_name Parameters

export var select_mode : Dictionary = {
			0: true,
			1: false,
			2: false
		} setget set_select_mode

export var delay : float = 2.0
export var max_turns : int = 20
export var n : int = 1

func debug():
	print("n ",n)
	print("delay ",delay)
	print("turns ",max_turns)
	print("select_mode ",select_mode)

func set_select_mode(val):
	select_mode = val
	if not select_mode.has_all([0,1,2]):
		printerr("INVALID SELECT MODE SET, OVERWRITTEN")
		breakpoint
		select_mode = {
			0:true,
			1:false,
			2:false
		}
	elif not (select_mode.get(0) or select_mode.get(1) or select_mode.get(2)):
		select_mode = {
			0:true,
			1:false,
			2:false
		}


func is_equal(other):
	if not other: return false
#	var dic1 = select_mode.duplicate(true)
#	var dic2 = other.select_mode.duplicate(true)

	return  delay == other.delay and \
			max_turns == other.max_turns  and \
			n == other.n  and \
			select_mode.hash() == other.select_mode.hash() 

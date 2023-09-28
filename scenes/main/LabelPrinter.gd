extends Node

func print_n(n):
	return "N = " + str(n)
	
func print_delay(delay : float):
	return "D = " + str(stepify(delay,0.01))
	
func print_score(score):
	var translated = [
		TranslationServer.translate("POS"),
		TranslationServer.translate("SOUND"),
		TranslationServer.translate("COLOR")]
	
	var s = "[center]"
	if owner.parameters.select_mode[owner.POSITION]: s += translated[0] + "\t" + _print_score_queue(score[owner.POSITION]) + "\n"
	if owner.parameters.select_mode[owner.SOUND]: s += translated[1] + "\t" + _print_score_queue(score[owner.SOUND])  + "\n"
	if owner.parameters.select_mode[owner.COLOR]: s += translated[2] + "\t" + _print_score_queue(score[owner.COLOR])  #+ "\n"
	return s

func print_turn(max_turn,n,turn_count):
	return TranslationServer.translate("TURN_REMAIN") + str(max(max(max_turn,n + 1) - turn_count,0))

func _print_score_queue(queue):
	return str(queue[0])    + " [img=10]res://assets/icons/check.png[/img]\t"   \
			+ str(queue[1]) + " [img=10]res://assets/icons/cancel.png[/img]\t" \
			+ str(queue[2]) + " [img=15]res://assets/icons/warning.png[/img]\t"

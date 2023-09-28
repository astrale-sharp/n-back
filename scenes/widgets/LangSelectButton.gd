extends OptionButton

const path = "res://config/lang_select"
var cache_selected : int setget set_cache_selected
var file := File.new()

func set_cache_selected(val):
	cache_selected = val
	file.open(path,File.WRITE)
	file.store_8(cache_selected)
	file.close()

	
func _ready():
	file.open(path,File.READ)
	var buffer = file.get_8()
	file.close()
	set_cache_selected(buffer)
	match cache_selected:
		0:
			TranslationServer.set_locale("en")
		1:
			TranslationServer.set_locale("fr")
	
	match TranslationServer.get_locale():
		"en":
			selected = 0
		"fr":
			selected = 1


func _on_Control_item_selected(index):
	match index:
		0:
			TranslationServer.set_locale("en")
		1:
			TranslationServer.set_locale("fr")
	set_cache_selected(index)

extends Button


export var reference_path = ""
export(bool) var start_focused = false


func _ready():
	if start_focused:
		grab_focus()
	
# warning-ignore:return_value_discarded
	connect("mouse_entered", self, "_on_Button_mouse_entered")
# warning-ignore:return_value_discarded
	connect("pressed", self, "_on_Button_pressed")


func _on_Button_mouse_entered():
	grab_focus()


func _on_Button_pressed():
	if reference_path != "":
# warning-ignore:return_value_discarded
		get_tree().change_scene(reference_path)
	else:
		get_tree().quit()


#func _process(delta):
#	pass

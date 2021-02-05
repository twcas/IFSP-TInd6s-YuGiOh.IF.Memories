extends Sprite


onready var nodeCardBase = get_node("../../CardBase")
onready var nodeDialogActionSelect = get_node("../DialogActionSelect")
var cardId = null


func _ready():
	cardId = int(self.editor_description)


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if get_rect().has_point(to_local(event.position)):
			if nodeCardBase.playerIsChoosingAction == true && nodeCardBase.playerTable[cardId].get_used() == 0:
				nodeDialogActionSelect.updateTableCardAction(cardId)
	elif event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_RIGHT:
		if get_rect().has_point(to_local(event.position)):
			get_node("../LabelCardInfo").visible = true
			get_node("../LabelCardInfo").text = str(
				"Card Info:" +
				"\nAttack: " + str(nodeCardBase.playerTable[cardId].get_attack()) +
				"\nDefense: " + str(nodeCardBase.playerTable[cardId].get_defense()) +
				"\nMode: " + str(nodeCardBase.playerTable[cardId].get_mode()) +
				"\nUsed: " + str(nodeCardBase.playerTable[cardId].get_used())
			)
			
			get_node("../TimerCardInfo").stop()
			get_node("../TimerCardInfo").start()


#func _process(delta):
#	pass

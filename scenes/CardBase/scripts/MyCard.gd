extends Sprite


onready var nodeCardBase = get_node("../../CardBase")
onready var nodeDialogCardModeSelect = get_node("../DialogCardModeSelect")
var cardId = null


func _ready():
	cardId = int(self.editor_description)


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if get_rect().has_point(to_local(event.position)):
			for x in range(5):
				if nodeCardBase.playerTable[x] == null:
					nodeCardBase.playerTable[x] = nodeCardBase.playerHands[cardId]
					get_node("../TableMyCard" + str(x)).texture = load(nodeCardBase.playerHands[cardId].get_imgUrl())
					get_node("../TableMyCard" + str(x)).rotation_degrees = 0
					get_node("../TableMyCard" + str(x)).visible = true
					
					nodeDialogCardModeSelect.updateTableCardMode(cardId, x)
					break
				else:
					if x == 4:
						nodeCardBase.playerTable[x] = nodeCardBase.playerHands[cardId]
						get_node("../TableMyCard" + str(x)).texture = load(nodeCardBase.playerHands[cardId].get_imgUrl())
						get_node("../TableMyCard" + str(x)).rotation_degrees = 0
						get_node("../TableMyCard" + str(x)).visible = true
						
						nodeDialogCardModeSelect.updateTableCardMode(cardId, x)
						break
					else:
						continue
	elif event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_RIGHT:
		if get_rect().has_point(to_local(event.position)):
			get_node("../LabelCardInfo").visible = true
			get_node("../LabelCardInfo").text = str(
				"Card Info:" +
				"\nAttack: " + str(nodeCardBase.playerHands[cardId].get_attack()) +
				"\nDefense: " + str(nodeCardBase.playerHands[cardId].get_defense())
			)
			
			get_node("../TimerCardInfo").stop()
			get_node("../TimerCardInfo").start()


#func _process(delta):
#	pass

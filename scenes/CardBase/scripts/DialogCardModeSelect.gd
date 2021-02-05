extends ConfirmationDialog


onready var nodeCardBase = get_node("../../CardBase")
var tableCard
var handCard


func _ready():
	get_ok().text = "Attack"
	get_cancel().text = "Defense"
	
	get_cancel().connect("pressed", self, "_cancel_pressed")
	get_ok().connect("pressed", self, "_ok_pressed")


func _ok_pressed():
	nodeCardBase.playerTable[tableCard].set_mode(1)
	get_node("../TableMyCard" + str(tableCard)).rotation_degrees = 0
	
	get_node("../MyCard" + str(handCard)).texture = load(nodeCardBase.playerDeck[nodeCardBase.playerCardsRemaining].get_imgUrl())
	nodeCardBase.playerHands[handCard] = nodeCardBase.playerDeck[nodeCardBase.playerCardsRemaining]
	
	nodeCardBase.playerRound()


func _cancel_pressed():
	nodeCardBase.playerTable[tableCard].set_mode(0)
	get_node("../TableMyCard" + str(tableCard)).rotation_degrees = 90
	
	get_node("../MyCard" + str(handCard)).texture = load(nodeCardBase.playerDeck[nodeCardBase.playerCardsRemaining].get_imgUrl())
	nodeCardBase.playerHands[handCard] = nodeCardBase.playerDeck[nodeCardBase.playerCardsRemaining]
	
	nodeCardBase.playerRound()


func updateTableCardMode(handId, tableId):
	print("Player chose a card and now is selecting its mode...")
	
	handCard = handId
	tableCard = tableId
	nodeCardBase.playerCardsRemaining -= 1
	
	for x in range(5):
		get_node("../MyCard" + str(x)).visible = false
	
	popup()


#func _process(delta):
#	pass

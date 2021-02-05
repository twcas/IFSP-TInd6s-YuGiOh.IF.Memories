extends ConfirmationDialog


onready var nodeCardBase = get_node("../../CardBase")
var tableCard


func _ready():
	get_ok().text = "Attack"
	get_cancel().text = "Change mode"
	
	get_cancel().connect("pressed", self, "_cancel_pressed")
	get_ok().connect("pressed", self, "_ok_pressed")


func _ok_pressed():
	nodeCardBase.playerAttackingCardId = tableCard
	get_node("../TableMyCard" + str(tableCard)).rotation_degrees = 0
	nodeCardBase.playerTable[tableCard].set_mode(1)
	
	var enemyHasCardsInTable = true
	for x in range(5):
		if nodeCardBase.enemyTable[x] == null:
			if x == 4:
				enemyHasCardsInTable = false
			else:
				continue
		else:
			break
	
	if enemyHasCardsInTable == true:
		print("CHOOSE AN ENEMY CARD TO ATTACK!")
		nodeCardBase.playerIsChoosingCardToAttack = true
	else:
		print("You attacked the enemy directly!")
		nodeCardBase.enemyHp -= nodeCardBase.playerTable[tableCard].get_attack()
		get_node("../LabelEnemyHp").text = "Enemy HP: " + str(nodeCardBase.enemyHp)
		nodeCardBase.playerTable[tableCard].set_used(1)
		get_node("../TableMyCard" + str(tableCard)).modulate.a = 0.7


func _cancel_pressed():
	if nodeCardBase.playerTable[tableCard].get_mode() == 1:
		nodeCardBase.playerTable[tableCard].set_mode(0)
		get_node("../TableMyCard" + str(tableCard)).rotation_degrees = 90
	else:
		nodeCardBase.playerTable[tableCard].set_mode(1)
		get_node("../TableMyCard" + str(tableCard)).rotation_degrees = 0


func updateTableCardAction(tableId):
	tableCard = tableId
	
	popup()


#func _process(delta):
#	pass

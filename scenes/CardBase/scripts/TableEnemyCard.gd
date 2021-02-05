extends Sprite


onready var nodeCardBase = get_node("../../CardBase")
var cardId = null


func _ready():
	cardId = int(self.editor_description)


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if get_rect().has_point(to_local(event.position)):
			if nodeCardBase.playerIsChoosingCardToAttack == true:
				if nodeCardBase.enemyTable[cardId].get_mode() == 1:
					if nodeCardBase.playerTable[nodeCardBase.playerAttackingCardId].get_attack() > nodeCardBase.enemyTable[cardId].get_attack():
						print("You destroyed the enemy's card and he suffered with the difference of points!")
						nodeCardBase.enemyHp -= (nodeCardBase.playerTable[nodeCardBase.playerAttackingCardId].get_attack() - nodeCardBase.enemyTable[cardId].get_attack())
						get_node("../LabelEnemyHp").text = "Enemy HP: " + str(nodeCardBase.enemyHp)
						nodeCardBase.enemyTable[cardId] = null
						get_node("../TableEnemyCard" + str(cardId)).texture = load("res://assets/cards/verso.png")
						get_node("../TableEnemyCard" + str(cardId)).visible = false
						nodeCardBase.playerTable[nodeCardBase.playerAttackingCardId].set_used(1)
						get_node("../TableMyCard" + str(nodeCardBase.playerAttackingCardId)).modulate.a = 0.7
					elif nodeCardBase.playerTable[nodeCardBase.playerAttackingCardId].get_attack() == nodeCardBase.enemyTable[cardId].get_attack():
						print("You destroyed the enemy's card and your own!")
						nodeCardBase.playerTable[nodeCardBase.playerAttackingCardId] = null
						get_node("../TableMyCard" + str(nodeCardBase.playerAttackingCardId)).texture = load("res://assets/cards/verso.png")
						get_node("../TableMyCard" + str(nodeCardBase.playerAttackingCardId)).visible = false
						nodeCardBase.enemyTable[cardId] = null
						get_node("../TableEnemyCard" + str(cardId)).texture = load("res://assets/cards/verso.png")
						get_node("../TableEnemyCard" + str(cardId)).visible = false
					elif nodeCardBase.playerTable[nodeCardBase.playerAttackingCardId].get_attack() < nodeCardBase.enemyTable[cardId].get_attack():
						print("You failed to attack enemy's card so you lost your card and you suffered with the difference of points!")
						nodeCardBase.playerHp -= (nodeCardBase.enemyTable[cardId].get_attack() - nodeCardBase.playerTable[nodeCardBase.playerAttackingCardId].get_attack())
						get_node("../LabelPlayerHp").text = "Player HP: " + str(nodeCardBase.playerHp)
						nodeCardBase.playerTable[nodeCardBase.playerAttackingCardId] = null
						get_node("../TableMyCard" + str(nodeCardBase.playerAttackingCardId)).texture = load("res://assets/cards/verso.png")
						get_node("../TableMyCard" + str(nodeCardBase.playerAttackingCardId)).visible = false
				else:
					if nodeCardBase.playerTable[nodeCardBase.playerAttackingCardId].get_attack() > nodeCardBase.enemyTable[cardId].get_defense():
						print("You destroyed the enemy's card!")
						nodeCardBase.enemyTable[cardId] = null
						get_node("../TableEnemyCard" + str(cardId)).texture = load("res://assets/cards/verso.png")
						get_node("../TableEnemyCard" + str(cardId)).visible = false
						nodeCardBase.playerTable[nodeCardBase.playerAttackingCardId].set_used(1)
						get_node("../TableMyCard" + str(nodeCardBase.playerAttackingCardId)).modulate.a = 0.7
					elif nodeCardBase.playerTable[nodeCardBase.playerAttackingCardId].get_attack() <= nodeCardBase.enemyTable[cardId].get_defense():
						print("The enemy's card blocked your attack!")
						nodeCardBase.playerTable[nodeCardBase.playerAttackingCardId].set_used(1)
						get_node("../TableMyCard" + str(nodeCardBase.playerAttackingCardId)).modulate.a = 0.7
	elif event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_RIGHT:
		if get_rect().has_point(to_local(event.position)):
			get_node("../LabelCardInfo").visible = true
			get_node("../LabelCardInfo").text = str(
				"Card Info:" +
				"\nAttack: " + str(nodeCardBase.enemyTable[cardId].get_attack()) +
				"\nDefense: " + str(nodeCardBase.enemyTable[cardId].get_defense()) +
				"\nMode: " + str(nodeCardBase.enemyTable[cardId].get_mode())
			)
			
			get_node("../TimerCardInfo").stop()
			get_node("../TimerCardInfo").start()


#func _process(delta):
#	pass

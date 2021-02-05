extends Control


var cardDatabase = preload("res://assets/cards/cardsDatabase.gd")
var Card = load("res://classes/classCard.gd")
const totalCards = 40

var gameFirstRound = true

var playerHp = 8000
var playerDeck = Array()
var playerTable = Array()
var playerHands = Array()
var playerCardsRemaining = totalCards
var playerIsChoosingAction = false
var playerIsChoosingCardToAttack = false
var playerAttackingCardId = null

var enemyHp = 8000
var enemyDeck = Array()
var enemyTable = Array()
var enemyHands = Array()
var enemyCardsRemaining = totalCards


func _ready():
	playerDeck.resize(totalCards)
	playerHands.resize(5)
	playerTable.resize(5)
	
	enemyDeck.resize(totalCards)
	enemyHands.resize(5)
	enemyTable.resize(5)
	
	print("Player HP: ", playerHp)
	print("Enemy HP: ", enemyHp)
	$LabelPlayerHp.text = "Player HP: " + str(playerHp)
	$LabelEnemyHp.text = "Enemy HP: " + str(enemyHp)
	
	for x in range(5):
		get_node("TableMyCard" + str(x)).visible = false
		get_node("TableEnemyCard" + str(x)).visible = false
	
	$ButtonFinishAction.visible = false
	$LabelCardInfo.visible = false
	
	$TimerCardInfo.set_wait_time(3)
	$TimerCardInfo.connect("timeout",self,"_on_timer_timeout") 
	
	for x in range(totalCards):
		var playerCardInfo = cardDatabase.DATA[x]
		playerDeck[x] = Card.new(x)
		playerDeck[x].set_type(playerCardInfo[0])
		playerDeck[x].set_description(playerCardInfo[1])
		playerDeck[x].set_attack(playerCardInfo[2])
		playerDeck[x].set_defense(playerCardInfo[3])
		playerDeck[x].set_mode(1)
		playerDeck[x].set_used(0)
		playerDeck[x].set_imgUrl(str("res://assets/cards/", x+1, ".jpg"))
		
		var enemyCardInfo = cardDatabase.DATA[x]
		enemyDeck[x] = Card.new(x)
		enemyDeck[x].set_type(enemyCardInfo[0])
		enemyDeck[x].set_description(enemyCardInfo[1])
		enemyDeck[x].set_attack(enemyCardInfo[2])
		enemyDeck[x].set_defense(enemyCardInfo[3])
		enemyDeck[x].set_mode(1)
		enemyDeck[x].set_used(0)
		enemyDeck[x].set_imgUrl(str("res://assets/cards/", x+1, ".jpg"))
	
	randomize()
	playerDeck.shuffle()
	randomize()
	enemyDeck.shuffle()
	
	for x in range(5):
		playerCardsRemaining -= 1
		get_node("MyCard" + str(x)).texture = load(playerDeck[playerCardsRemaining].get_imgUrl())
		playerHands[x] = playerDeck[playerCardsRemaining]
	
	for x in range(5):
		enemyCardsRemaining -= 1
		#get_node("EnemyCard" + str(x)).texture = load(enemyDeck[enemyCardsRemaining].get_imgUrl())
		enemyHands[x] = enemyDeck[enemyCardsRemaining]


func playerRound():
	if gameFirstRound == false:
		print("Player is now choosing to attack or not...")
		
		$ButtonFinishAction.visible = true
		playerIsChoosingAction = true
	else:
		# set used state for the first player's card on the first round
		playerTable[0].set_used(0)
		get_node("TableMyCard0").modulate.a = 0.7
		
		print("You finished your round! (you can't attack on the first round)")
		enemyRound()


func enemyRound():
	$ButtonFinishAction.visible = false
	playerIsChoosingAction = false
	
	var highestEnemyHandAttack = 0
	var highestEnemyHandDefense = 0
	var highestEnemyAttackSelectedCardId = null
	var highestEnemyDefenseSelectedCardId = null
	var enemySelectedCard = null
	
	# reset used state of all enemy cards in table
	for x in range(5):
		get_node("TableEnemyCard" + str(x)).modulate.a = 1
		if enemyTable[x] == null:
			continue
		else:
			enemyTable[x].set_used(0)
	
	# select the best card in hands
	print("Enemy is now choosing a new card...")
	yield(get_tree().create_timer(0.5), "timeout")
	
	for x in range(5):
		if enemyHands[x].get_attack() > highestEnemyHandAttack:
			highestEnemyAttackSelectedCardId = x
			highestEnemyHandAttack = enemyHands[x].get_attack()
		
		if enemyHands[x].get_defense() > highestEnemyHandDefense:
			highestEnemyDefenseSelectedCardId = x
			highestEnemyHandDefense = enemyHands[x].get_defense()
	
	enemyCardsRemaining -= 1
	if highestEnemyHandAttack >= highestEnemyHandDefense:
		enemySelectedCard = enemyHands[highestEnemyAttackSelectedCardId]
		enemyHands[highestEnemyAttackSelectedCardId] = enemyDeck[enemyCardsRemaining]
	else:
		enemySelectedCard = enemyHands[highestEnemyDefenseSelectedCardId]
		enemyHands[highestEnemyDefenseSelectedCardId] = enemyDeck[enemyCardsRemaining]
	
	# put the selected card in the available spot in table
	for x in range(5):
		if enemyTable[x] == null:
			enemyTable[x] = enemySelectedCard
			enemyTable[x].set_used(0)
			get_node("TableEnemyCard" + str(x)).texture = load(enemySelectedCard.get_imgUrl())
			get_node("TableEnemyCard" + str(x)).rotation_degrees = 0
			get_node("TableEnemyCard" + str(x)).visible = true
			break
		else:
			if x == 4:
				enemyTable[x] = enemySelectedCard
				enemyTable[x].set_used(0)
				get_node("TableEnemyCard" + str(x)).texture = load(enemySelectedCard.get_imgUrl())
				get_node("TableEnemyCard" + str(x)).rotation_degrees = 0
				get_node("TableEnemyCard" + str(x)).visible = true
				break
			else:
				continue
	
	# perform attacks to player cards
	print("Enemy is now choosing to attack or not...")
	yield(get_tree().create_timer(0.5), "timeout")
	for x in range(5):
		for y in range(5):
			if playerTable[y] == null:
				continue
			else:
				if enemyTable[x] == null:
					continue
				else:
					if playerTable[y].get_mode() == 1:
						if enemyTable[x].get_attack() > playerTable[y].get_attack() && enemyTable[x].get_used() == 0:
							print("Enemy destroyed your card and you suffered with the difference of points!")
							playerHp -= (enemyTable[x].get_attack() - playerTable[y].get_attack())
							get_node("LabelPlayerHp").text = "Player HP: " + str(playerHp)
							playerTable[y] = null
							get_node("TableMyCard" + str(y)).texture = load("res://assets/cards/verso.png")
							get_node("TableMyCard" + str(y)).visible = false
							enemyTable[x].set_used(1)
							get_node("TableEnemyCard" + str(x)).modulate.a = 0.7
							enemyTable[x].set_mode(1)
							get_node("TableEnemyCard" + str(x)).rotation_degrees = 0
						elif enemyTable[x].get_attack() == playerTable[y].get_attack() && enemyTable[x].get_used() == 0:
							print("Enemy destroyed your card and his own!")
							playerTable[y] = null
							get_node("TableMyCard" + str(y)).texture = load("res://assets/cards/verso.png")
							get_node("TableMyCard" + str(y)).visible = false
							enemyTable[x] = null
							get_node("TableEnemyCard" + str(x)).texture = load("res://assets/cards/verso.png")
							get_node("TableEnemyCard" + str(x)).visible = false
					else:
						if enemyTable[x].get_attack() > playerTable[y].get_defense() && enemyTable[x].get_used() == 0:
							print("Enemy destroyed your card!")
							playerTable[y] = null
							get_node("TableMyCard" + str(y)).texture = load("res://assets/cards/verso.png")
							get_node("TableMyCard" + str(y)).visible = false
							enemyTable[x].set_used(1)
							get_node("TableEnemyCard" + str(x)).modulate.a = 0.7
							enemyTable[x].set_mode(1)
							get_node("TableEnemyCard" + str(x)).rotation_degrees = 0
					
					yield(get_tree().create_timer(0.5), "timeout")
	
	# check if player has cards left on table
	var playerHasCardsOnTable = false
	for x in range(5):
		if playerTable[x] != null:
			playerHasCardsOnTable = true
	
	# perform attacks to player directly if has no card left or finish his round
	for x in range(5):
		if enemyTable[x] == null:
			continue
		else:
			if enemyTable[x].get_used() == 0:
				if playerHasCardsOnTable == false:
					print("Enemy attacked you directly!")
					playerHp -= enemyTable[x].get_attack()
					get_node("LabelPlayerHp").text = "Player HP: " + str(playerHp)
					enemyTable[x].set_mode(1)
					get_node("TableEnemyCard" + str(x)).rotation_degrees = 0
					enemyTable[x].set_used(1)
					get_node("TableEnemyCard" + str(x)).modulate.a = 0.7
				else:
					enemyTable[x].set_mode(0)
					get_node("TableEnemyCard" + str(x)).rotation_degrees = 90
					enemyTable[x].set_used(1)
					get_node("TableEnemyCard" + str(x)).modulate.a = 0.7
				
				yield(get_tree().create_timer(0.5), "timeout")
	
	print("Enemy finished his round!")
	print("Player HP: ", playerHp)
	print("Enemy HP: ", enemyHp)
	
	if playerHp <= 0:
		print("ENEMY WON THE GAME!")
		get_tree().change_scene("res://scenes/MainTitleMenu/MainTitleMenu.tscn")
	elif enemyHp <= 0:
		print("PLAYER WON THE GAME!")
		get_tree().change_scene("res://scenes/MainTitleMenu/MainTitleMenu.tscn")
	elif playerCardsRemaining <= 0:
		print("ENEMY WON THE GAME! (Player ran out of cards)")
		get_tree().change_scene("res://scenes/MainTitleMenu/MainTitleMenu.tscn")
	
	if gameFirstRound == true:
		gameFirstRound = false
	
	# show hand cards and reset used state of all player cards in table
	for x in range(5):
		get_node("MyCard" + str(x)).visible = true
		get_node("TableMyCard" + str(x)).modulate.a = 1
		
		if playerTable[x] == null:
			continue
		else:
			playerTable[x].set_used(0)


func _on_timer_timeout():
	$LabelCardInfo.visible = false


#func _process(delta):
#	pass

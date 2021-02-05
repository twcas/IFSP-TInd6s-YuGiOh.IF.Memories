extends Button


onready var nodeCardBase = get_node("../../CardBase")


func _ready():
	connect("pressed", self, "_button_pressed")


func _button_pressed():
	print("You finished your round!")
	print("Player HP: ", nodeCardBase.playerHp)
	print("Enemy HP: ", nodeCardBase.enemyHp)
	
	# set used state for all player cards in table
	for x in range(5):
		get_node("../TableMyCard" + str(x)).modulate.a = 0.7
		if nodeCardBase.playerTable[x] != null:
			nodeCardBase.playerTable[x].set_used(0)
	
	if nodeCardBase.playerHp <= 0:
		print("ENEMY WON THE GAME!")
		get_tree().change_scene("res://scenes/MainTitleMenu/MainTitleMenu.tscn")
	elif nodeCardBase.enemyHp <= 0:
		print("PLAYER WON THE GAME!")
		get_tree().change_scene("res://scenes/MainTitleMenu/MainTitleMenu.tscn")
	elif nodeCardBase.playerCardsRemaining <= 0:
		print("ENEMY WON THE GAME! (Player ran out of cards)")
		get_tree().change_scene("res://scenes/MainTitleMenu/MainTitleMenu.tscn")
	
	nodeCardBase.enemyRound()


#func _process(delta):
#	pass

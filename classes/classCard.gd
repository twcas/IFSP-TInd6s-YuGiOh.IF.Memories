# Class classCard.gd


var _id
var _type
var _description
var _attack
var _defense
var _mode
var _used
var _imgUrl

func _init(id):
	self._id = id

func set_id(id):
	self._id = id

func set_type(type):
	self._type = type

func set_description(description):
	self._description = description

func set_attack(attack):
	self._attack = attack

func set_defense(defense):
	self._defense = defense

func set_mode(mode):
	self._mode = mode

func set_used(used):
	self._used = used

func set_imgUrl(url):
	self._imgUrl = url

func get_id():
	return self._id

func get_type():
	return self._type

func get_description():
	return self._description

func get_attack():
	return self._attack

func get_defense():
	return self._defense

func get_mode():
	return self._mode

func get_used():
	return self._used

func get_imgUrl():
	return self._imgUrl

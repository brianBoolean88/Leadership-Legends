extends CanvasLayer

@export var money_label : Label
@export var battles_label : Label
@export var currBattlesWon = 0;

func _process(_delta):
	money_label.text = "Coins: " + "%d" % GameManager.money
	battles_label.text = "Battles Won: %s" %[currBattlesWon]

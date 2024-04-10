extends Node2D

@onready var transition = $Transition
@onready var moneyLabel = $Money
@onready var click = $ButtonClick
@onready var success = $Success
@onready var label = $CanvasLayer/Notification

var startup = true
var notiAnimPlaying = false

func _ready():
	transition.play("fade_in")
	updateMoney()

func updateMoney():
	moneyLabel.text = "Coins: %s" % (GameManager.money)

func onButtonClick(cash, item_name):
	click.play()
	if GameManager.money >= cash and GameManager.inventory.size() < 15:
		GameManager.money -= cash
		updateMoney()
		GameManager.inventory.append(item_name)
		print(GameManager.inventory)
		success.play()
		if notiAnimPlaying == false:
			label.text = "bought %s!" % (item_name)
			transition.play("notification")
			notiAnimPlaying = true
			
			if item_name == "FBLAShirt":
				GameManager.boughtShirt = true
			elif item_name == "FBLAPants":
				GameManager.boughtPants = true
	else:
		
		if GameManager.money < cash:
			label.text = "not enough coins!"
		else:
			label.text = "too much inventory space!"
		
		if notiAnimPlaying == false:
			transition.play("notification")
			notiAnimPlaying = true

func _on_apple_buy_pressed():
	if GameManager.boughtShirt == false:
		onButtonClick(20, "FBLAShirt")
	else:
		label.text = "already bought shirt!"
		if notiAnimPlaying == false:
			transition.play("notification")
			notiAnimPlaying = true

func _on_banana_buy_pressed():
	if GameManager.boughtPants == false:
		onButtonClick(5, "FBLAPants")
	else:
		label.text = "already bought pants!"
		if notiAnimPlaying == false:
			transition.play("notification")
			notiAnimPlaying = true
	

func _on_grape_buy_pressed():
	onButtonClick(10, "FBLASnack")

func _on_orange_buy_pressed():
	onButtonClick(35, "FBLASoda")

func _on_transition_animation_finished(anim_name):
	if anim_name == "notification":
		notiAnimPlaying = false
	elif anim_name == "fade_out":
		get_tree().change_scene_to_file("res://Scenes/Levels/%s" %(GameManager.level))


func _on_leave_pressed():
	transition.play("fade_out")

extends Node2D

func _ready():
	GameManager.level = "Level3.tscn"
	GameManager.easyMode = false
	event_handler.inBattle = false
	GameManager.CanMove = true

func _process(delta):
	$Player/Network.text = "Networked w/ %s NPCS" % [GameManager.interactedNPCS]

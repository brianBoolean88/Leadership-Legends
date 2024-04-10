extends Node2D

func _ready():
	GameManager.level = "Level3.tscn"

func _process(delta):
	$Player/Network.text = "Networked w/ %s NPCS" % [GameManager.interactedNPCS]

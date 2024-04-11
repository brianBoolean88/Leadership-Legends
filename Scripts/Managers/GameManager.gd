extends Node

var money = 0
var battles_won = 0
var level : String = "MainFloor.tscn"

var easyMode = true
var badEnding = false

var interactedNPCS = 0
var ione = false
var itwo = false
var ithree = false
var ifour = false
var ifive = false

var CanMove = true
var KingDouglass = false

var inventory = []

var boughtShirt = false
var boughtPants = false

func reset_money():
	money = 0

func add_money(addmoney : int):
	money += addmoney

func load_next_level(next_scene : PackedScene):
	get_tree().change_scene_to_packed(next_scene)

func load_same_level():
	get_tree().reload_current_scene()
	
func douglassEnd():
	get_tree().change_scene_to_file("res://Scenes/Levels/ending.tscn")
	

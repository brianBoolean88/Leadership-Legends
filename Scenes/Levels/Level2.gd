extends Node2D

var airLeft : float = 2.5
var timeElapsed = 0
var inWater = false
var allyNear = false

@onready var root = get_tree().get_root()
@onready var minionCloneFolder = root.get_node("Scene_Root/AllPlayerMinions");

func _ready():
	GameManager.level = "Level2.tscn"
	GameManager.easyMode = false
	event_handler.inBattle = false
	GameManager.CanMove = true

func _process(delta):
	if inWater == true and allyNear == false and event_handler.inBattle == false:
		timeElapsed += delta  # Accumulate time elapsed
		if timeElapsed >= 0.1:  # If 1 second has passed
			airLeft -= 0.1
			$Player/Air.text = "Air Left: %s" % [airLeft]
			timeElapsed = 0  # Reset timeElapsed
			
		
	if airLeft <= 0:
		get_tree().reload_current_scene()
		var minion_names = []
		for child in minionCloneFolder.get_children():
			child.queue_free()
			minion_names.append(child.enemyName)
		AttackData.minionData += minion_names


func _on_water_body_entered(body):
	if body.is_in_group("Player"):
		inWater = true

func _on_water_body_exited(body):
	inWater = false


func _on_area_2d_body_entered(body):
	if body.is_in_group("Ally"):
		airLeft = 2.5
		allyNear = true
		$Player/Air.text = "Air Left: %s" % [airLeft]


func _on_area_2d_body_exited(body):
	if body.is_in_group("Ally"):
		allyNear = false

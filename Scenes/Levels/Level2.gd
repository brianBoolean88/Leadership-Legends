extends Node2D

var airLeft : float = 5
var timeElapsed = 0
var inWater = false
var allyNear = false

func _ready():
	GameManager.level = "Level2.tscn"
	GameManager.easyMode = false

func _process(delta):
	if inWater == true and allyNear == false:
		timeElapsed += delta  # Accumulate time elapsed
		if timeElapsed >= 0.1:  # If 1 second has passed
			airLeft -= 0.1
			$Player/Air.text = "Air Left: %s" % [airLeft]
			timeElapsed = 0  # Reset timeElapsed
		
	if airLeft <= 0:
		get_tree().reload_current_scene()


func _on_water_body_entered(body):
	if body.is_in_group("Player"):
		inWater = true

func _on_water_body_exited(body):
	inWater = false


func _on_area_2d_body_entered(body):
	if body.is_in_group("Ally"):
		airLeft = 5
		allyNear = true
		$Player/Air.text = "Air Left: %s" % [airLeft]


func _on_area_2d_body_exited(body):
	allyNear = false

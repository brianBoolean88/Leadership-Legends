extends Area2D


@onready var transition = $Transition

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if GameManager.interactedNPCS >= 5:
			transition.play("fade_out")
		else:
			$Label.text = "Talk to at least %s more NPCs\nStep here to go to the\nnext level!" % [5-GameManager.interactedNPCS]
		
func _on_transition_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://Scenes/Levels/Level4.tscn")

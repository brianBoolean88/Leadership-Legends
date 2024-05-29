extends Area2D


@onready var transition = $Transition
@onready var notifier = $Notifier

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if GameManager.interactedNPCS >= 5:
			transition.play("fade_out")
		else:
			notifier.descriptions[0] = "Talk to at least %s more NPCs" % [5-GameManager.interactedNPCS]
		
func _on_transition_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://Scenes/Levels/Level4.tscn")

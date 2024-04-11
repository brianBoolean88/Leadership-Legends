extends Area2D


@onready var transition = $Transition

func _on_body_entered(body):
	if body.is_in_group("Player"):
		transition.play("fade_out")
		
func _on_transition_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://Scenes/level_3.tscn")

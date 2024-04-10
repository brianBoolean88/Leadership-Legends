extends Area2D


@onready var transition = $Transition
var startup = true
# Opens up shop GUI!

func _ready():
	transition.play("fade_in")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		transition.play("fade_out")
		
func _on_transition_animation_finished(anim_name):
	if startup:
		startup = false
		return
	get_tree().change_scene_to_file("res://Scenes/Levels/shop.tscn")

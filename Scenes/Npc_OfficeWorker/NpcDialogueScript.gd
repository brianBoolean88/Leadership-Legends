extends Area2D

var inVacinity = false

func _on_body_entered(body):
	if body.is_in_group("Player"):
		inVacinity = true
		



func _on_body_exited(body):
	if body.is_in_group("Player"):
		inVacinity = false
	pass # Replace with function body.

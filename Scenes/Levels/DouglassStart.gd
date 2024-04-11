extends Area2D

@onready var animationPlayer = get_parent().get_node("Transition")

func _ready():
	pass


func _on_body_entered(body):
	if body.is_in_group("Player"):
		GameManager.CanMove = false
		GameManager.KingDouglass = true
		animationPlayer.play("king_douglass")

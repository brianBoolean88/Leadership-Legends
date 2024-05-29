extends Area2D

@export var GUI : Panel
@export var descriptions : Array[String] = []
@onready var menuOpen : AudioStreamPlayer2D = $SFX

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("Player"):
		GameManager.CanMove = false
		var label = GUI.get_node("Label") as Label
		# Concatenate the array of strings with newline characters
		var text = ""
		for description in descriptions:
			text += description + "\n"
		label.text = text.strip_edges()
		GUI.visible = true
		menuOpen.play()

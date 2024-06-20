extends TextureButton

func endPrompt():
	var parent = get_parent()
	var sfx = get_parent().get_node("SFX")
	sfx.play()
	parent.visible = false
	GameManager.CanMove = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("DialogueInteract") and get_parent().visible:
		endPrompt()


func _on_pressed():
	endPrompt()

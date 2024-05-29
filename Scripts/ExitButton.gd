extends TextureButton



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	var parent = get_parent()
	var sfx = get_parent().get_node("SFX")
	sfx.play()
	parent.visible = false
	GameManager.CanMove = true

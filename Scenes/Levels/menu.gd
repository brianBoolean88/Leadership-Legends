extends Control

@onready var fader = $Fader
@onready var startButton = $CanvasLayer/VBoxContainer/StartButton
@onready var credits = $CanvasLayer/Credits
@onready var controls = $CanvasLayer/Controls

func _ready():
	fader.play("fade_in")
	startButton.grab_focus()
	
	

func _on_fader_animation_finished(anim_name):
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://Scenes/Levels/MainFloor.tscn")


func _on_start_button_pressed():
	fader.play("fade_out")


func _on_credits_button_pressed():
	credits.visible = !credits.visible
	controls.visible = false


func _on_controls_pressed():
	controls.visible = !controls.visible
	credits.visible = false


func _on_quit_button_pressed():
	get_tree().quit()

extends Control

@onready var fader = $Fader
@onready var label2 = $CanvasLayer/Label2

func _ready():
	fader.play("fade_in")
	if GameManager.badEnding == true:
		label2.text = "ENDING: DEMOTED LEADER"
	else:
		if AttackData.minionData.size() > 15:
			label2.text = "ENDING: OPEN LEADER"
		else:
			label2.text = "ENDING: CLOSED LEADER"

func _on_fader_animation_finished(anim_name):
	if anim_name == "fade_in":
		fader.play("ending")

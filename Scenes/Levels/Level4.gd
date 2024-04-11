extends Node2D

@onready var animationPlayer = $Transition
@onready var Douglass = $Douglass
@onready var bell = $Music/Bell

func _ready():
	animationPlayer.play("fade_in")
	bell.play()


#character_name, lvl, tolerance, health, sprite
var health = 600
func _on_transition_animation_finished(anim_name):
	if anim_name == "king_douglass":
		event_handler.emit_signal("battle_started", "Douglass", 100, 25, health, Douglass)

extends CharacterBase
class_name PlayerMain

@onready var fsm = $FSM as FiniteStateMachine
@onready var actionable_finder: Area2D = $Direction/ActionableFinder


const DEATH_SCREEN = preload("res://Scenes/DeathScreen.tscn")

#logic is either in the CharacterBase class
#or spread out over our states in the finite-state-manager, this class is almost empty 

func _unhandled_input(event) -> void:
	if Input.is_action_just_pressed("DialogueInteract"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			return
	elif Input.is_action_just_pressed("quitCommand"):
		get_tree().quit()

func _die():
	super() #calls _die() on base-class CharacterBase
	
	fsm.force_change_state("Die")
	var death_scene = DEATH_SCREEN.instantiate()
	add_child(death_scene)
	
	
func dialogueText(ss) -> void:
	$AnimationPlayer.play("dialogue_fade_in");
	$Dialogue/Label.text = ss
	await get_tree().create_timer(3).timeout
	$AnimationPlayer.play("dialogue_fade_out");
	
var water_timer = 10
	

func decrease_timer_action():
	pass

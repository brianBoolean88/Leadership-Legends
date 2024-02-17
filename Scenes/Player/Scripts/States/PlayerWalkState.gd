extends State
class_name PlayerWalking

@export var movespeed := int(350)
@export var dash_max := int(500)
@export var sprite : AnimatedSprite2D
var dashspeed := int(100)
var can_dash := bool(false)
var dash_direction := Vector2(0,0)

var player : CharacterBody2D
@export var animator : AnimationPlayer 

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	animator.play("Walk")

func Update(delta : float):
	var input_dir = Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown").normalized()
	if !event_handler.inBattle:
		Move(input_dir)
		LessenDash(delta)
	

	if(Input.is_action_just_pressed("Dash") && can_dash):
		start_dash(input_dir)
		AudioManager.play_sound(AudioManager.PLAYER_ATTACK_SWING, 0.3, -1)
		
	if Input.is_action_just_pressed("MinionSpawn"):
		var chosen_minion = Minion.chosenMinion
		if get_tree().get_root().has_node("Scene_Root/MinionCloneSamples"):
			if get_tree().get_root().get_node("Scene_Root/MinionCloneSamples").has_node(chosen_minion):
				var enemy = get_tree().get_root().get_node("Scene_Root/MinionCloneSamples").get_node(chosen_minion).duplicate()
				enemy.position = player.position
				
				var all_player_minions = get_tree().get_root().get_node("Scene_Root/AllPlayerMinions")
				all_player_minions.add_child(enemy)
				
				
				enemy.startup(sprite.scale.x)
				
				AttackData.minionData.remove_at(Minion.currentSelectedMinionIndex)
				Minion.minionSwapManual = true
			else:
				print("Selected minion sample does not exist!")
		else:
			print("MinionCloneSamples node not found!")
			
	elif Input.is_action_just_pressed("MinionRecall"):
		var minion_names = []

		# Find the "AllPlayerMinions" node
		var all_player_minions = get_tree().get_root().get_node("Scene_Root/AllPlayerMinions")

		# Loop through all children of "AllPlayerMinions"
		for child in all_player_minions.get_children():
			# Destroy each child node
			child.queue_free()

			# Store the name of the destroyed minion as a string
			minion_names.append(child.enemyName)

		# Store minion names in AttackData.minionData array
		AttackData.minionData += minion_names
		pass


	
func Move(input_dir):
	#Suddenly turning mid dash
	if(dash_direction != Vector2.ZERO and dash_direction != input_dir):
		dash_direction = Vector2.ZERO
		dashspeed = 0

	player.velocity = input_dir * movespeed + dash_direction * dashspeed 
	player.move_and_slide()

	if(input_dir.length() <= 0):
		Transition("Idle")

func start_dash(input_dir):
	dash_direction = input_dir.normalized()
	dashspeed = dash_max
	animator.play("Dash")
	can_dash = false

func LessenDash(delta):
	#Higher multiplier values makes the dash shorter
	var multiplier = 4.0
	var timemultiplier = 4.1
	
	#slow down the dash over time, both as a fraction of dashspeed and also time
	#While clamping it between 0 and dash_max
	dashspeed -= (dashspeed * multiplier * delta) + (delta * timemultiplier)
	dashspeed = clamp(dashspeed, 0, dash_max)
	
	if(dashspeed <= 0):
		can_dash = true
		dash_direction = Vector2.ZERO
		
	if(animator.current_animation == "Dash"):
		await animator.animation_finished
		animator.play("Walk")

#We cannot allow a transition before the dash is complete and the animation has stopped playing
func Transition(newstate):
	if(dashspeed <= 0):
		state_transition.emit(self, newstate)

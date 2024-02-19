extends State
class_name PlayerIdle

@export var player : CharacterBody2D
@export var animator : AnimationPlayer
@export var sprite : AnimatedSprite2D

func Enter():
	animator.play("Idle")
	pass
	
func Update(_delta : float):
	if(Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown").normalized()):
		state_transition.emit(self, "Moving")
	
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

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

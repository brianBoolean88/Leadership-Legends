extends CharacterBase
class_name EnemyMain

@onready var fsm = $FSM as FiniteStateMachine
var player_in_range = false
@export var enemyName : String = "Shadow";
@export var enemyLvl : int = 1;
	


func _on_collider_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("Player"):
		event_handler.emit_signal("battle_started", enemyName, enemyLvl)
	pass # Replace with function body.

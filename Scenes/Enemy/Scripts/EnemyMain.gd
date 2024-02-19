extends CharacterBase
class_name EnemyMain

@onready var fsm = $FSM as FiniteStateMachine
var player_in_range = false
@export var enemyName : String = "Shadow";
@export var enemyLvl : int = 1;
@export var tolerance : int = 3;
@export var healthMain : int = 100;
@export var levelLabel : Label;

func _ready():
	levelLabel.text = "Level %s" %[enemyLvl]

func _on_collider_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("Player"):
		event_handler.emit_signal("battle_started", enemyName, enemyLvl, tolerance, healthMain, self)
	pass # Replace with function body.

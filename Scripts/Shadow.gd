extends StaticBody2D

var startupMove = false;
var dir : bool;
@export var level = 1;
@export var enemyName = "Shadow";

@onready var root = get_tree().get_root()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Name2.text = "Lvl %s"%[level];
	pass # Replace with function body.

func startup(dir):
	startupMove = true;
	if dir > 0:
		#right
		self.position.x += 50
	else:
		#left
		self.position.x -= 50
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("Enemy"):
		if level >= body.enemyLvl:
			print("Wow, captured!");
			AttackData.minionData.append(body.enemyName);
			if body != null && body.is_queued_for_deletion() == false:
				body.queue_free()
			$Music/Victory.play()
			if StateDialogue.main_status == "Q1":
				StateDialogue.main_status = "Q2"
			print("obtained new enemy!")
			
			GameManager.battles_won += 1
			
		else:
			print("Nope, failed.");
			if self != null && self.is_queued_for_deletion() == false:
				self.queue_free()
			
			AttackData.minionData.append(enemyName)
			$Music/BattleStart.play()
			event_handler.emit_signal("battle_started", body.enemyName, body.enemyLvl, body.tolerance, body.healthMain, body)

	pass # Replace with function body.

extends StaticBody2D

var startupMove = false;
var dir : bool;
@export var level = 1;
@export var enemyName = "Shadow";

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
			body.queue_free();
			print("obtained new enemy!")
		else:
			print("Nope, failed.");
			self.queue_free()
			AttackData.minionData.append(enemyName)
			
			event_handler.emit_signal("battle_started", body.enemyName, body.enemyLvl, body.tolerance, body.healthMain, body)

	pass # Replace with function body.

extends Control
var thread: Thread

var tolerance : int = 0;
var health : int = 0;
var animatedSprite : CharacterBody2D;
var char_name : String;
# Called when the node enters the scene tree for the first time.
func _ready():
	#visible = false;
	event_handler.battle_started.connect(init);
	pass # Replace with function body.

func init(character_name, lvl, tolerance, health, sprite):
	animatedSprite = sprite;
	visible = true
	
	event_handler.inBattle = true;
	$Enemy.visible = true;
	$AnimationPlayer.play("fade_out")
	$LevelIndicator.text = "Level %s"%[lvl];
	$Panel/Label.text = "A level %s %s appears!" %[lvl, character_name]
	char_name = character_name;
	$Panel/Move1_button.text = AttackData.move1Name;
	$Panel/Move2_button.text = AttackData.move2Name;
	$Health.value = health;
	self.health = health;
	self.tolerance = tolerance;
	$Tolerance.text = "Tolerance: %s turns." %[tolerance];
	$Panel/Move1_button.disabled = true;
	$Panel/Move2_button.disabled = true;
		
	var time_in_seconds = 2
	await get_tree().create_timer(time_in_seconds).timeout
	
	$Panel/Label.text = "What will you do?";
	$Panel/Move1_button.disabled = false;
	$Panel/Move2_button.disabled = false;
	$Panel/Fight_button.grab_focus();
	
	pass


func _on_run_button_pressed():
	visible = false;
	event_handler.inBattle = false;
	pass # Replace with function body.

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func _on_fight_button_pressed():
	$Panel/Run_button.visible = false;
	$Panel/Fight_button.visible = false;
	
	$Panel/Move1_button.visible = true;
	$Panel/Move2_button.visible = true;
	
	if $Panel/Move2_button.text == "n/a":
		$Panel/Move2_button.disabled = true;
	$Panel/Return.visible = true;
	
	$Panel/Label.text = "You attempt to use your business leadership skills...";
	$Panel/Move1_button.grab_focus();
	pass # Replace with function body.


func _on_return_pressed():
	$Panel/Run_button.visible = true;
	$Panel/Fight_button.visible = true;
	
	$Panel/Move1_button.visible = false;
	$Panel/Move2_button.visible = false;
	$Panel/Return.visible = false;
	$Panel/Label.text = "What will you do?";
	$Panel/Fight_button.grab_focus();
	pass # Replace with function body.

func fullInvis():
	$Panel/Run_button.visible = false;
	$Panel/Fight_button.visible = false;
	$Panel/Move1_button.visible = false;
	$Panel/Move2_button.visible = false;
	$Panel/Return.visible = false;

func detectEnd() -> int:
	if health <= 0:
		return 1;
	elif tolerance <= 0:
		return 2;
	return 3;

func dialogueText(ss) -> void:
	$AnimationPlayer.play("dialogue_fade_in");
	get_parent().get_parent().get_parent().get_parent().get_node("Dialogue").get_node("Label").text = ss
	await get_tree().create_timer(3).timeout
	$AnimationPlayer.play("dialogue_fade_out");

func _on_move_1_button_pressed():
	fullInvis();
	$Panel/Label.text = "You use %s"%[AttackData.move1Name];
	get_parent().get_parent().get_parent().startup();
	
	$Player.play("Attack");
	$Player.play_backwards("Attack");
	
	health -= AttackData.dmgData[AttackData.move1Name]
	$Health.value = health;
	tolerance -= 1;
	$Tolerance.text = "Tolerance: %s turns." %[tolerance];
	
	var cont = detectEnd();
	var time_in_seconds = 1
	
	if cont == 1:
		$Panel/Label.text = "You gathered an ally!"
		$Tolerance.text = "";
		$Health.value = 0;
		$LevelIndicator.text = "";
		$Enemy.visible = false;
		time_in_seconds = 2;
	elif cont == 2:
		$Panel/Label.text = "You lost!"
		$Tolerance.text = "";
		$Health.value = 0;
		$LevelIndicator.text = "";
		$Enemy.visible = false;
		time_in_seconds = 2;
	
	
	await get_tree().create_timer(time_in_seconds).timeout
	if cont == 3:
		fullInvis();
		$Panel/Run_button.visible = true;
		$Panel/Fight_button.visible = true;
		$Panel/Label.text = "What will you do?";
		$Panel/Fight_button.grab_focus();
	elif cont == 1:
		fullInvis();
		$Panel/Run_button.visible = true;
		$Panel/Fight_button.visible = true;
		visible = false;
		event_handler.inBattle = false;
		animatedSprite.queue_free();
		AttackData.minionData.append(char_name);
		dialogueText("Thanks for your consideration!");
		print("captured!");
	elif cont == 2:
		fullInvis();
		$Panel/Run_button.visible = true;
		$Panel/Fight_button.visible = true;
		visible = false;
		event_handler.inBattle = false;
		print("died!");
		get_tree().reload_current_scene()
	
	
	pass # Replace with function body.


func _on_move_2_button_pressed():
	fullInvis();
	$Panel/Label.text = "You use %s"%[AttackData.move2Name];
	get_parent().get_parent().get_parent().startup();
	
	$Player.play("Attack");
	$Player.play_backwards("Attack");
	
	health -= AttackData.dmgData[AttackData.move2Name]
	$Health.value = health;
	tolerance -= 1;
	$Tolerance.text = "Tolerance: %s turns." %[tolerance];
	
	var cont = detectEnd();
	var time_in_seconds = 1
	
	if cont == 1:
		$Panel/Label.text = "You captured it!"
		time_in_seconds = 2;
	elif cont == 2:
		$Panel/Label.text = "You lost!"
		time_in_seconds = 2;
	
	
	await get_tree().create_timer(time_in_seconds).timeout

	
	if cont == 3:
		fullInvis();
		$Panel/Run_button.visible = true;
		$Panel/Fight_button.visible = true;
		$Panel/Label.text = "What will you do?";
		$Panel/Fight_button.grab_focus();
	elif cont == 1:
		fullInvis();
		$Panel/Run_button.visible = true;
		$Panel/Fight_button.visible = true;
		visible = false;
		event_handler.inBattle = false;
		animatedSprite.queue_free();
		AttackData.minionData.append(char_name);
		
		#$AnimationPlayer.play("dialogue_fade_out");
		#print("faded out");
		print("captured!");
	elif cont == 2:
		fullInvis();
		$Panel/Run_button.visible = true;
		$Panel/Fight_button.visible = true;
		visible = false;
		event_handler.inBattle = false;
		print("died!");
		get_tree().reload_current_scene()
	
	
	pass # Replace with function body.

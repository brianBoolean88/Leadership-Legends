extends Control
var thread: Thread

var tolerance : int = 0;
var health : int = 0;
var animatedSprite : CharacterBody2D;
var char_name : String;

@export var battleMusic : AudioStreamWAV;
@export var normalMusic : AudioStreamMP3;
@onready var root = get_tree().get_root()
@onready var normal_player_audio = root.get_node("Scene_Root/Music/Normal")
@onready var battle_player_audio = root.get_node("Scene_Root/Music/Battle")

func _ready():
	battle_player_audio.stream_paused = true #pause the battle music
	event_handler.battle_started.connect(init); #connect to battle_started signal
	
func menu(checkpoint):
	if checkpoint == "actionMenu":
		$Panel/Move1_button.visible = false;
		$Panel/Move2_button.visible = false;
		$Panel/Return.visible = false;
		$Panel/Fight_button.visible = true;
		$Panel/Run_button.visible = true;
		$Panel/Fight_button.grab_focus();
	elif checkpoint == "moveMenu":
		$Panel/Move1_button.visible = true;
		$Panel/Move2_button.visible = true;
		$Panel/Return.visible = true;
		$Panel/Fight_button.visible = false;
		$Panel/Run_button.visible = false;
		$Panel/Move1_button.grab_focus();
		

func init(character_name, lvl, tolerance, health, sprite):
	#Add constructor values
	animatedSprite = sprite;
	char_name = character_name;
	self.health = health;
	self.tolerance = tolerance;
	
	 #move names must be updated each new battle
	$Panel/Move1_button.text = AttackData.move1Name;
	$Panel/Move2_button.text = AttackData.move2Name;
	
	#Begin battle music
	normal_player_audio.stream_paused = true #stop normal music
	battle_player_audio.seek(0.0) #start battle music
	battle_player_audio.stream_paused = false
	
	#Make battle UI visible
	event_handler.inBattle = true;
	$Enemy.visible = true;
	visible = true
	$AnimationPlayer.play("fade_out")
	
	#display text
	$LevelIndicator.text = "Level %s"%[lvl];
	$Tolerance.text = "Tolerance: %s turns." %[tolerance];
	$Health.value = health;
	$Panel/Label.text = "A level %s %s appears!" %[lvl, character_name]
	
	#disable all actions for 2 seconds
	$Panel/Move1_button.disabled = true;
	$Panel/Move2_button.disabled = true;
	await get_tree().create_timer(2).timeout
	
	#ask for an action
	$Panel/Label.text = "What will you do?";
	menu("actionMenu")

func _on_run_button_pressed():
	#TODO: make a chance to make the run successful
	visible = false;
	event_handler.inBattle = false;

func _on_fight_button_pressed():
	$Music/ButtonClick.play()
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
	$Music/ButtonClick.play()
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
	$Music/ButtonClick.play()
	$Panel/Label.text = "You use %s"%[AttackData.move1Name];
	get_parent().get_parent().get_parent().startup();
	
	$Player.play("Attack");
	$Player.play_backwards("Attack");
	$Music/Attack.play()
	
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
		$Music/Victory.play()
		time_in_seconds = 2;
	elif cont == 2:
		$Panel/Label.text = "You lost!"
		$Tolerance.text = "";
		$Health.value = 0;
		$LevelIndicator.text = "";
		$Enemy.visible = false;
		$Music/Defeat.play()
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
		if animatedSprite != null && animatedSprite.is_queued_for_deletion() == false:
			animatedSprite.queue_free()
		AttackData.minionData.append(char_name);
		$Music/Dialogue.play()
		dialogueText("Thanks for your consideration!");
		
		normal_player_audio.stream_paused = false
		battle_player_audio.stream_paused = true
		
		GameManager.battles_won += 1
		
		if StateDialogue.main_status == "Start":
			StateDialogue.main_status = "Q1"
		
		print("captured!");
	elif cont == 2:
		fullInvis();
		$Panel/Run_button.visible = true;
		$Panel/Fight_button.visible = true;
		visible = false;
		event_handler.inBattle = false;
		print("died!");
		
		get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")
	
	
	pass # Replace with function body.


func _on_move_2_button_pressed():
	fullInvis();
	$Music/ButtonClick.play()
	$Panel/Label.text = "You use %s"%[AttackData.move2Name];
	get_parent().get_parent().get_parent().startup();
	
	$Player.play("Attack");
	$Player.play_backwards("Attack");
	$Music/Attack.play()
	
	health -= AttackData.dmgData[AttackData.move2Name]
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
		$Music/Victory.play()
		time_in_seconds = 2;
	elif cont == 2:
		$Panel/Label.text = "You lost!"
		$Tolerance.text = "";
		$Health.value = 0;
		$LevelIndicator.text = "";
		$Enemy.visible = false;
		$Music/Defeat.play()
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
		if animatedSprite != null && animatedSprite.is_queued_for_deletion() == false:
			animatedSprite.queue_free()
		AttackData.minionData.append(char_name);
		$Music/Dialogue.play()
		
		normal_player_audio.stream_paused = false
		battle_player_audio.stream_paused = true
		
		GameManager.battles_won += 1
		
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

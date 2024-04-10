extends Control
var thread: Thread

var tolerance : int = 0;
var health : int = 0;
var animatedSprite : CharacterBody2D;
var char_name : String;

@export var battleMusic : AudioStreamWAV;
@export var normalMusic : AudioStreamMP3;

@onready var question_scene = $QuestionTab
@onready var root = get_tree().get_root()
@onready var normal_player_audio = root.get_node("Scene_Root/Music/Normal")
@onready var battle_player_audio = root.get_node("Scene_Root/Music/Battle")

func _ready():
	battle_player_audio.stream_paused = true #pause the battle music
	event_handler.battle_started.connect(init); #connect to battle_started signal

func fullInvis():
	$Panel/Run_button.visible = false;
	$Panel/Fight_button.visible = false;
	$Panel/Move1_button.visible = false;
	$Panel/Move2_button.visible = false;
	$Panel/Return.visible = false;

func detectRunButton():
	if AttackData.unlockRun == true:
		$Panel/Run_button.visible = true;
	else:
		$Panel/Run_button.visible = false;
	
func menu(checkpoint):
	if checkpoint == "actionMenu":
		$Panel/Move1_button.visible = false;
		$Panel/Move2_button.visible = false;
		$Panel/Return.visible = false;
		$Panel/Fight_button.visible = true;
		
		detectRunButton();
		
		$Panel/Label.text = "What will you do?";
		$Panel/Fight_button.grab_focus();
	elif checkpoint == "moveMenu":
		$Panel/Move1_button.visible = true;
		$Panel/Move2_button.visible = true;
		
		if $Panel/Move2_button.text == "n/a":
			$Panel/Move2_button.disabled = true;
		
		
		$Panel/Return.visible = true;
		$Panel/Fight_button.visible = false;
		$Panel/Run_button.visible = false;
		
		$Panel/Label.text = "You attempt to use your business leadership skills...";
		$Panel/Move1_button.grab_focus();
	
		
func invisAllAnimates():
	var child_count = get_child_count()
	
	for i in range(child_count):
		var child_node = get_child(i)
		if is_instance_valid(child_node) and child_node is AnimatedSprite2D:
			child_node.visible = false

func visibleEnemy(vis):
	var animate = get_node(char_name)
	animate.visible = vis

func init(character_name, lvl, tolerance, health, sprite):
	#Add constructor values
	animatedSprite = sprite;
	char_name = character_name;
	
	invisAllAnimates()
	visibleEnemy(true)
	
	$Player.visible = true
	
	self.health = health;
	$Health.max_value = health
	self.tolerance = tolerance;
	
	 #move names must be updated each new battle
	$Panel/Move1_button.text = AttackData.move1Name;
	$Panel/Move2_button.text = AttackData.move2Name;
	
	#Begin battle music
	normal_player_audio.stream_paused = true #stop normal music
	battle_player_audio.play()
	
	#Make battle UI visible
	event_handler.inBattle = true;
	visible = true
	$AnimationPlayer.play("fade_out")
	
	#display text
	$LevelIndicator.text = "Level %s"%[lvl];
	$Tolerance.text = "Tolerance: %s turns." %[tolerance];
	$Health.value = health;
	$Panel/Label.text = "A level %s %s appears!" %[lvl, character_name]
	
	#disable all actions for 2 seconds
	await get_tree().create_timer(2).timeout
	
	#ask for an action
	$Panel/Label.text = "What will you do?";
	menu("actionMenu")

func _on_run_button_pressed():
	fullInvis();
	$Panel/Fight_button.visible = true;
	visible = false;
	event_handler.inBattle = false;
	$Music/Dialogue.play()
	dialogueText("Phew...that was a close one");
	
	normal_player_audio.play()
	battle_player_audio.stream_paused = true
	

func _on_fight_button_pressed():
	$Music/ButtonClick.play()
	menu("moveMenu")

func _on_return_pressed():
	$Music/ButtonClick.play()
	menu("actionMenu")

func detectEnd() -> int:
	if health <= 0:
		return 1; #return 1 if the player has got rid of all the health of the enemy
	elif tolerance <= 0:
		return 2; #return 2 if the player has run out of "tolerance" for the monster
	return 3; #return 3 if battle continues

func dialogueText(text) -> void:
	$AnimationPlayer.play("dialogue_fade_in");
	get_parent().get_parent().get_parent().get_parent().get_node("Dialogue").get_node("Label").text = text
	await get_tree().create_timer(3).timeout
	$AnimationPlayer.play("dialogue_fade_out");
		
func onMove(button) -> void:		
	#GUI manipulations
	fullInvis()
	$Music/ButtonClick.play()
	
	#Ask the question to them first!
	AttackData.passedQuestion = false
	AttackData.correctAnswer = false
	
	#set up move name
	var moveName = AttackData.move1Name
	if button == "move2":
		moveName = AttackData.move2Name
	
	#initiate question scene
	question_scene.init(moveName)

func answered_question(moveName):
	#determine if we should use the move based on the MCQ
	if AttackData.correctAnswer:
		$Panel/Label.text = "You use %s"%[moveName]
		health -= AttackData.dmgData[moveName]
		$Health.value = health
	else:
		$Panel/Label.text = "Oh no! You almost missed %s"%[moveName]
		health -= AttackData.dmgData[moveName]/2
		$Health.value = health
		
	tolerance -= 1
	$Tolerance.text = "Tolerance: %s turns." %[tolerance]
	
	#reset question parameters after we're done
	AttackData.passedQuestion = false
	AttackData.correctAnswer = false

	#Apply shake to the camera
	get_parent().get_parent().get_parent().startup();
	
	#Player attacking animation
	$Player.play("Attack");
	$Player.play_backwards("Attack");
	$Music/Attack.play()

	var cont = detectEnd();
	
	if cont == 1: #Player got rid of all the health of the enemy
		$Panel/Label.text = "You gathered an ally!"
		$Tolerance.text = "";
		$Health.value = 0;
		$LevelIndicator.text = "";
		visibleEnemy(false)
		$Music/Victory.play()
		
		await get_tree().create_timer(2).timeout
		
		fullInvis();
		detectRunButton();
		$Panel/Fight_button.visible = true;
		visible = false;
		event_handler.inBattle = false;
		if animatedSprite != null && animatedSprite.is_queued_for_deletion() == false:
			animatedSprite.queue_free()
		AttackData.minionData.append(char_name);
		$Music/Dialogue.play()
		dialogueText("Thanks for your consideration!");
		
		normal_player_audio.play()
		battle_player_audio.stream_paused = true
		
		GameManager.battles_won += 1
		
		if StateDialogue.main_status == "Start":
			StateDialogue.main_status = "Q1"
		
		print("captured!");	
	elif cont == 2: #Player ran out of time for tolerance
		$Panel/Label.text = "You lost!"
		$Tolerance.text = "";
		$Health.value = 0;
		$LevelIndicator.text = "";
		visibleEnemy(false)
		$Music/Defeat.play()
		
		await get_tree().create_timer(2).timeout
		
		fullInvis();
		detectRunButton();
		$Panel/Fight_button.visible = true;
		visible = false;
		event_handler.inBattle = false;
		print("died!");
		
		get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")
	elif cont == 3: #Player can continue the game
		await get_tree().create_timer(1).timeout
		
		fullInvis();
		detectRunButton();
		$Panel/Fight_button.visible = true;
		$Panel/Label.text = "What will you do?";
		$Panel/Fight_button.grab_focus();

func _on_move_1_button_pressed():
	onMove("move1")
	
func _on_move_2_button_pressed():
	onMove("move2")

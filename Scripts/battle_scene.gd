extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	#visible = false;
	event_handler.battle_started.connect(init);
	pass # Replace with function body.

func init(character_name, lvl):
	visible = true
	event_handler.inBattle = true;
	$AnimationPlayer.play("fade_out")
	$Panel/Label.text = "A level %s %s appears!" %[lvl, character_name]
	$Panel/Move1_button.text = AttackData.move1Name;
	$Panel/Move2_button.text = AttackData.move2Name;
		
	wait(2.0);
	$Panel/Label.text = "What will you do?";
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

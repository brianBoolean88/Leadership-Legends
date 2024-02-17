extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


@export var currentSelectedMinionIndex = 0;
@export var chosenMinion : String;
@export var minionSwapManual : bool = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("MinionSwap") or minionSwapManual:
		minionSwapManual = false
		if AttackData.minionData.size() == 0:
			return
		
		currentSelectedMinionIndex += 1;
		if currentSelectedMinionIndex > AttackData.minionData.size()-1:
			currentSelectedMinionIndex = 0;
		chosenMinion = AttackData.minionData[currentSelectedMinionIndex];
		text = "Selected Ally (%s): %s [E]" %[currentSelectedMinionIndex+1, chosenMinion];
	
	if AttackData.minionData.size() == 0:
		text = "Selected Ally: none";
	elif AttackData.minionData.size() == 1:
		currentSelectedMinionIndex = 0
		chosenMinion = AttackData.minionData[currentSelectedMinionIndex]
		text = "Selected Ally (%s): %s [E]" %[currentSelectedMinionIndex+1, chosenMinion];
	elif text == "Selected Ally: none":
		currentSelectedMinionIndex = 0
		chosenMinion = AttackData.minionData[currentSelectedMinionIndex]
		text = "Selected Ally (%s): %s [E]" %[currentSelectedMinionIndex+1, chosenMinion];

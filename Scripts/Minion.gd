extends TextureRect

@export var index : int = 0; # We will automatically give the player a Shadow Strategist Minion.
@export var minionSwapManual : bool = false; # This will be called by another script to automatically swap minions.
@export var labelText : Label;
@export var player : PlayerMain;
@export var sprite : AnimatedSprite2D;

@onready var root = get_tree().get_root()
@onready var minionCloneSamples = root.get_node("Scene_Root/MinionCloneSamples");
@onready var minionCloneFolder = root.get_node("Scene_Root/AllPlayerMinions");

var loadedHeadshots = {
	"Shadow Strategist" : load("res://Headshots/Shadow Strategist.png"),
	"FBLAqua Spirit" : load("res://Headshots/FBLAqua Spirit.png"),
	"NotListed" : load("res://Headshots/NoHeadshot.png"),
}

func purifyName(allyName):
	for i in loadedHeadshots:
		if allyName[0] == i:
			return
	allyName[0] = "NotListed"


func updateImage():
	var selectedAlly = AttackData.minionData[index]
	var chosenAlly = [selectedAlly]
	purifyName(chosenAlly)
	var preloadedImage = loadedHeadshots[chosenAlly[0]]
	if preloadedImage:
		self.texture = preloadedImage

var ray_length = 10000
var minions_node_path = "Scene_Root/AllPlayerMinions"

func _ready():
	self.visible = true
	updateImage()

func get_input_direction():
	# Get the input direction based on WASD keys
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("MoveRight"):
		input_vector.x += 1
	if Input.is_action_pressed("MoveLeft"):
		input_vector.x -= 1
	if Input.is_action_pressed("MoveUp"):
		input_vector.y += 1
	if Input.is_action_pressed("MoveDown"):
		input_vector.y -= 1
	return input_vector.normalized()

func _process(delta):
	#Reading input for minion utilization
	if Input.is_action_just_pressed("MinionSpawn") and AttackData.minionData.size() > 0: #Spawning minions next to the player
		var chosen_minion = AttackData.minionData[index]
		if minionCloneSamples.has_node(chosen_minion):
			var enemy = minionCloneSamples.get_node(chosen_minion).duplicate()
			enemy.position = player.position
			minionCloneFolder.add_child(enemy)
			enemy.startup(sprite.scale.x)
			AttackData.minionData.remove_at(index)
			minionSwapManual = true
		else:
			print("Selected minion sample does not exist!")	
	
	if Input.is_action_just_pressed("MinionRecall"): #Recalling all minions back to player's inventory
		var minion_names = []
		for child in minionCloneFolder.get_children():
			child.queue_free()
			minion_names.append(child.enemyName)
		AttackData.minionData += minion_names
	
	if Input.is_action_just_pressed("MinionSwap") or minionSwapManual: #Swapping to another minion
		minionSwapManual = false
		
		if AttackData.minionData.size() == 0: #If the player has no more minions, then we can't swap.
			return
		
		index += 1;
		if index > AttackData.minionData.size()-1: #We will loop back around to the first ally
			index = 0;
		
		labelText.text = str(index+1);
		#Change Image
		updateImage()
	
	if Input.is_action_just_pressed("MinionJump"):
		var player_position = player.global_transform.origin
		var ray_end = player_position + get_input_direction() * ray_length
		var space_state = get_world_2d().direct_space_state
		var params = PhysicsRayQueryParameters2D.new()
		params.from = player_position
		params.to = ray_end
		var rid_array : Array[RID]
		rid_array.append(player.get_rid())
		params.exclude = rid_array
		params.collision_mask = 1
		var collision = space_state.intersect_ray(params)
		
		if collision and collision.collider is StaticBody2D:
			var parent_node = collision.collider.get_parent()
			if (parent_node.name == "AllPlayerMinions"):
				var minion_position = collision.position
				player.global_transform.origin = minion_position
	#End of reading input
	
	#Changing the UI based on information
	if AttackData.minionData.size() == 0: #If the player has no allies
		labelText.text = "";
		index = -1;
	else: #The player has some allies
		index = max(0, index) #Ensure the player has at least one ally equipped
		labelText.text = str(index+1);
		#Change Image
		updateImage()
	#End of changing UI from player's information

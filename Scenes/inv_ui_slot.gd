extends Panel

@onready var item_visual : Sprite2D = $item_display
@onready var failSound = $Fail
@onready var eatingSound = $Eating
@onready var equipSound = $Wearing
@export var index = 0
var itemRepresentative : String = ""

func update(item):
	if item == "none":
		item_visual.texture = null
		itemRepresentative = ""
		print("yeah")
	else:
		var path = "res://Art/Sprites/%s.png" % (item)
		item_visual.texture = ResourceLoader.load(path)
		itemRepresentative = item

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func eaten(fruit):
	GameManager.inventory.remove_at(index)
	
	if fruit == "FBLAShirt":
		equipSound.play()
		AttackData.move2Name = "Pathos"
	elif fruit == "FBLAPants":
		equipSound.play()
		AttackData.unlockRun = true
	else:
		eatingSound.play()
	
	itemRepresentative = ""
	item_visual.texture = null
	get_parent().get_parent().get_parent().update_slots()

func _on_button_pressed():
	if itemRepresentative == "":
		print("nothing!")
		failSound.play()
	else:
		eaten(itemRepresentative)

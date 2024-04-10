extends Control

var is_open = false

func update_slots():
	var slots: Array = $NinePatchRect/GridContainer.get_children()
	
	for loops in range(slots.size()):
		
		var item = "none"
		if (loops <= GameManager.inventory.size()-1):
			item = GameManager.inventory[loops]
		slots[loops].update(item)
		

func _ready():
	close()

func _process(delta):
	if Input.is_action_just_pressed("InventoryKey"):
		if is_open:
			close()
		else:
			open()
			update_slots()

func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false

extends Label

func _ready():
	top_level = true

func _process(delta):
	text = "Active spawners: "
	get_parent().get_children().map(func (n):
		if("AsteroidsSpawner" in n.name and n.enabled):
			text += (n.name + ", ")
	)

extends SubViewportContainer

func _ready():
	$SubViewport/Node3D.using_shield = false
	$SubViewport/Node3D.hovering()

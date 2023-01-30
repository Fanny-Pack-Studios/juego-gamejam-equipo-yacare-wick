extends Node

const RuakeControl = preload("res://addons/ruake/core/Ruake.tscn")

func _unhandled_input(event):
	if event.is_action_pressed("ruake"):
		var root := get_node("/root")
		if root.has_node("RuakeControl"):
			root.get_node("RuakeControl").queue_free()
			get_tree().paused = false
		else:
			var ruake_control = RuakeControl.instantiate()
			ruake_control.name = "RuakeControl"
			root.add_child(ruake_control)
			get_tree().paused = true

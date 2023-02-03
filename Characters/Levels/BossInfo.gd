extends Label

func _process(delta):
	if(is_instance_valid($"../../Travel/Boss")):
		text = str("Boss health: ", $"../../Travel/Boss".current_health)
	else:
		text = "RIP boss"

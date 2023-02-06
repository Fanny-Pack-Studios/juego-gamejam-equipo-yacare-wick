extends Control

func _process(delta):
	var primary_power = Party.primary_power()
	var secondary_power = Party.secondary_power()
	$PrimaryPower.texture = primary_power.icon
	$SecondaryPower.texture = secondary_power.icon
	$PrimaryPower/ProgressBar.max_value = primary_power.cooldown_wait_time()
	$PrimaryPower/ProgressBar.value = primary_power.time_left_to_cooldown()
	$SecondaryPower/ProgressBar.max_value = secondary_power.cooldown_wait_time()
	$SecondaryPower/ProgressBar.value = secondary_power.time_left_to_cooldown()

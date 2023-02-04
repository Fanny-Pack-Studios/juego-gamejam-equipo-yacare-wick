extends Control

func _process(delta):
	$PrimaryPower.texture = Party.primary_power().icon
	$SecondaryPower.texture = Party.secondary_power().icon

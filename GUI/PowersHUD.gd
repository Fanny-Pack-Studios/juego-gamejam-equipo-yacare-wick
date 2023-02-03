extends Control

func _process(delta):
	$PrimaryPower.texture = Party.primary_power().icon
	$SecondaryPower.texture = Party.primary_power().icon

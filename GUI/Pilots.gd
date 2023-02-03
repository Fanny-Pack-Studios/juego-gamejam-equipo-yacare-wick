extends Control

func _ready():
	$%PilotSlot/Photo.texture = Party.pilot.photo
	$%PilotSlot/Name.text = Party.pilot.name
	
	$%CopilotSlot/Photo.texture = Party.copilot.photo
	$%CopilotSlot/Name.text = Party.copilot.name

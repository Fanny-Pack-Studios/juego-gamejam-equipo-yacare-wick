extends Node3D

var rotation_speed = 30
var petals

func _ready():
	petals = [$general_floralis/Flora_petals001,
	$general_floralis/Flora_petals002,
	$general_floralis/Flora_petals003,
	$general_floralis/Flora_petals004,
	$general_floralis/Flora_petals005,
	$general_floralis/Flora_petals006]

func _physics_process(delta):
	petals.map(func(petal): petal.rotation_degrees.y += delta * rotation_speed)

func spin_faster():
	return create_tween().tween_property(self, "rotation_speed", 250, 0.5).set_trans(Tween.TRANS_CUBIC).finished

func stop_spinning_fast():
	return create_tween().tween_property(self, "rotation_speed", 30, 0.3).finished

extends Control

func appear(pilot):
	$Panel/TextureRect.texture = pilot.photo

	self.scale = Vector2(1.0, 0.0)
	create_tween()\
		.tween_property(self, "scale", Vector2(1.0, 1.0), 0.5)\
		.set_trans(Tween.TRANS_ELASTIC)

func disappear():
	await create_tween()\
		.tween_property(self, "scale", Vector2(1.0, 0.0), 0.5)\
		.set_trans(Tween.TRANS_ELASTIC).finished


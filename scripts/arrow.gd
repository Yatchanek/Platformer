extends Projectile

func _ready():
	$Sprite2D.modulate = Globals.affinity_colors[affinity]

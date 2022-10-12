extends RigidBody2D

enum GUN_FIRE_MODE{
	ONESHOT,
	AUTO
}

export(NodePath) var visibilityNotifier
export(float) var damage = 80.0
export(float) var speed: = 1500.0
export(PackedScene) var explosion
export(float) var firingRate: = 0.005
export(GUN_FIRE_MODE) var fireMode = GUN_FIRE_MODE.AUTO

var direction: = Vector2.RIGHT

func _ready():
	var _p = connect("body_entered", self, "deal_damage")
	var _q = (get_node(visibilityNotifier) as VisibilityNotifier2D).connect("screen_exited", self, "queue_free")
	linear_velocity = direction * speed

func deal_damage(body):
	body.receive_damage(damage)
	VfxManager.create_effect(explosion, global_position)
	queue_free()

func _process(delta):
	damage -= 0.001 * delta

extends Area2D
# This is a generic fireball that anyhting can shoot out
const SPEED = 900.0
var damage = 0
var hit = false
var direction = 1 # 1 for right, -1 for left
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	# Move the projectile forward horizontally
	position.x += SPEED * direction * delta
	$AnimatedSprite2D.play("default")


func _on_body_entered(body: Node2D) -> void:
	if hit == true:
		$AnimatedSprite2D.play("boom")
		$AnimatedSprite2D.scale = Vector2(10.0,10.0)
		await $AnimatedSprite2D.animation_finished
		return
	if body.has_method("TakeDamage"):
		hit = true
		body.TakeDamage(int(damage))
	# Deal damage to enemies here if needed

	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

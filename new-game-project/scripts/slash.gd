extends Area2D
var damage = 0
var hit = false
var direction = -1 # 1 for right, -1 for left
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale.x = direction
	$AnimatedSprite2D.play("default")
	


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("TakeDamage"):
		hit = true
		body.TakeDamage(int(damage))
	# Deal damage to enemies here if needed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
	pass # Replace with function body.

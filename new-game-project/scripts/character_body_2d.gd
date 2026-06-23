extends CharacterBody2D


const SPEED = 300.0
const SPRINT_SPEED = 600
const JUMP_VELOCITY = -600.0
var isAttacking = false
var isDead = false
const PROJECTILE_SCENE = preload("res://scenes/projectile.tscn")
var spawn_offset = 50.0
signal health_changed(health)
var health = 100 :
	set(value):
		health = value
		print("health changed to ", health)
		health_changed.emit(health)


func _physics_process(delta: float) -> void:
	
	var current_speed = SPEED
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	#if not is_on_floor() and is_on_wall():
		#if
		
	if isAttacking:
	# If we are attacking, do nothing with movement inputs, but still let gravity apply.
		move_and_slide()
		return
	if isDead:
		velocity.x = 0
		velocity.y = 0
		return

	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor() or Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_pressed("sprint"):
		current_speed = SPRINT_SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
	
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false  # Facing Right
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true   # Facing Left
		
	if not is_on_floor():
		# Only call play() if it isn't already playing "jump"
		#this cycles through animations based on the current y speed of the character, but only if we are not on the floor
			if velocity.y < -150:
				$AnimatedSprite2D.play("jump")
				$AnimatedSprite2D.frame = 2
			elif velocity.y >= -150 and velocity.y <=0:
				$AnimatedSprite2D.play("jump")
				$AnimatedSprite2D.frame = 3
			elif velocity.y >= 150 and velocity.y > 0:
				$AnimatedSprite2D.play("jump")
				$AnimatedSprite2D.frame = 4
			else:
				$AnimatedSprite2D.play("jump")
				$AnimatedSprite2D.frame = 5
	elif velocity.x != 0:
		if Input.is_action_pressed("sprint"):
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and is_on_floor():
		isAttacking = true
		$AnimatedSprite2D.play("attack1")

	
func _on_animated_sprite_2d_animation_finished() -> void:
	#checks to see if the attack animation is done, and then resets the boolean
	if isAttacking:
		isAttacking = false
		
	$AnimatedSprite2D.play("idle")
	pass# Replace with function body.
	
func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "attack1":
		# Check if it has hit or passed frame 5, and make sure we haven't fired yet
		if $AnimatedSprite2D.frame >= 5:
			spawn_projectile()
	
func spawn_projectile() -> void:
	var projectile = PROJECTILE_SCENE.instantiate()
	projectile.position = global_position
	projectile.damage = 50
	if $AnimatedSprite2D.flip_h:
		projectile.direction = -1
		projectile.position = global_position + Vector2(-spawn_offset, -10)
	else:
		projectile.direction = 1
		projectile.position = global_position + Vector2(spawn_offset, -10)
		
	get_parent().add_child(projectile)
	
func TakeDamage(damage_taken):
	health -= damage_taken
	velocity.y = JUMP_VELOCITY/1.5
	if health <= 0:
		Die()
		
	
func Die():
	isDead = true
	$AnimatedSprite2D.play("die")
	await $AnimatedSprite2D.animation_finished
	if is_instance_valid(self):
		get_tree().reload_current_scene()


func _on_animated_sprite_2d_animation_changed() -> void:
	pass # Replace with function body.

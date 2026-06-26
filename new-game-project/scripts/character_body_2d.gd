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
	#if event.is_action_pressed("attack") and is_on_floor():
	if event.is_action_pressed("attack"):
		isAttacking = true
		$AnimatedSprite2D.play("attack1")

	
func _on_animated_sprite_2d_animation_finished() -> void:
	#checks to see if the attack animation is done, and then resets the boolean
	if isDead:
		return 
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
	#I'm gonna define each amount of damage as a different jump height. 
	health -= damage_taken
	#velocity.y = JUMP_VELOCITY/1.5
	if damage_taken == 1:
		velocity.y = JUMP_VELOCITY*0.3
	elif damage_taken == 5:
		velocity.y = JUMP_VELOCITY*0.5
	elif damage_taken == 10:
		velocity.y = JUMP_VELOCITY
	elif damage_taken == 20:
		velocity.y = JUMP_VELOCITY*1.2
	elif damage_taken == 30:
		velocity.y = JUMP_VELOCITY*1.3
	elif damage_taken == 40:
		velocity.y = JUMP_VELOCITY*1.5
	elif damage_taken == 50:
		velocity.y = JUMP_VELOCITY*2
	if health <= 0:
		Die()
		
	
	#Because I want damage to be correlated directly with movement, I need to make a system that will actually encourage damaging yourself intentionally
	#versus going the platforming bits. Damage amounts done by enemies should not be high, and neither should spikes
	#Heres a general guide of what I'm thinking
	#0 damage - If I want to implement a spring or something along those lines, it may be easier to simply reuse this method, but we'll see
	#1 damage - this will be very high frequency, so we cant make this give too much jump height
	#5 damage - this will likely be the standard per hit, nothing crazy, maybe a .3x just height
	#10 damage - 1x getting into meaningful damage here, so we should have a meaningful boost
	#20 damage - 1.5x jump
	#30 damage - 2x
	#40 damage - 4x
	#50 damage - this will need to be extremely good in order to justify, and likely either at the very beginnning or the very end of a level
	# probably 5 or 6x.
	#debating on putting a speed boost on these as well while I'm at it
	
func Die():
	isDead = true
	var tree = get_tree()
	$AnimatedSprite2D.play("die")
	await $AnimatedSprite2D.animation_finished
	#if is_instance_valid(self):
	tree.reload_current_scene()


func _on_animated_sprite_2d_animation_changed() -> void:
	pass # Replace with function body.

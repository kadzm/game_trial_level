using Godot;
using System;

namespace _FlyingEnemy{

public partial class FlyingEnemy : CharacterBody2D
{
	[Export] public Marker2D[] PatrolPoints;
	private int _currentPatrol = 0;
	
	public const float Speed = 200.0f;
	public const float AttackSpeed = 275.0f;
	public float _direction = 1.0f;
	public float gravity = ProjectSettings.GetSetting("physics/2d/default_gravity").AsSingle();
	private AnimatedSprite2D _animatedSprite;
	private int Health = 50;
	private bool isDead = false;
	private CharacterBody2D player;
	private bool attack = false;
	
	public override void _Ready()
	{
		_animatedSprite = GetNodeOrNull<AnimatedSprite2D>("Hurtbox/Sprite");
		GetNode<Area2D>("Hurtbox/Area2D").BodyEntered += _OnBodyEntered;
		player = GetTree().GetFirstNodeInGroup("player") as CharacterBody2D;
		
		AddCollisionExceptionWith(player); // passes through player physically
	}
	//public override void _Process(double delta)
	//{
	
	//}
	public override void _PhysicsProcess(double delta)
	{
		bool flip = player.GlobalPosition.X < GlobalPosition.X;
		Vector2 velocity = Velocity;
		if(isDead){
			velocity.X = 0;
			velocity.Y = 0;
			return;
		} 
		float dist = GlobalPosition.DistanceTo(player.GlobalPosition);
		if(IsOnWall())
		{
			_direction *= -1.0f;
			velocity.X = _direction * Speed;
		}
		if (!attack)
		{
		var target = PatrolPoints[_currentPatrol].GlobalPosition;
		var direction = (target - GlobalPosition).Normalized();
		velocity = direction * Speed;
		_animatedSprite.FlipH = direction.X < 0;
			if (GlobalPosition.DistanceTo(target) < 10.0f)
			{
				_currentPatrol = (_currentPatrol + 1) % PatrolPoints.Length;
			}
		}

		if (dist < 400.0f)
		{
			GD.Print("Dist:", dist);
			attack = true;
		}
		else{
			attack = false;
		}
		if(attack)
		{
			Vector2 direction = (player.GlobalPosition - GlobalPosition).Normalized();
			velocity = direction * AttackSpeed;
			_animatedSprite.Play("attack");
			_animatedSprite.FlipH = flip;
			ToSignal(_animatedSprite, "animation_finished");
			
		}
		if (!attack){ 
			_animatedSprite.Play("walk");
			ToSignal(_animatedSprite, "animation_finished");
		}
		Velocity = velocity;
		MoveAndSlide();
		
		
	}
	public void TakeDamage(int Damage)
	{
		Health = Health-Damage;
		if (Health <= 0)
		{
			Die();
		}
	}
	public async void Die(){
		isDead = true;
		var collisionShape = GetNodeOrNull<CollisionShape2D>("Hurtbox");
		if (collisionShape != null)
			collisionShape.SetDeferred("disabled", true);
		_animatedSprite.Play("die");
		await ToSignal(_animatedSprite, "animation_finished");
		QueueFree();
	}
	public void _OnBodyEntered(Node2D body)
	{
		if (body.HasMethod("TakeDamage") && body.IsInGroup("player"))
	{
		body.Call("TakeDamage", 30);
		
	}
	}
}
}

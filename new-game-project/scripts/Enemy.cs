using Godot;
using System;

namespace _Enemy{

public partial class Enemy : CharacterBody2D
{
	public const float Speed = 200.0f;
	public const float JumpVelocity = -400.0f;
	public float _direction = 1.0f;
	public bool hasSpawned = false;
	private AnimatedSprite2D _animatedSprite;
	public float gravity = ProjectSettings.GetSetting("physics/2d/default_gravity").AsSingle();
	private static readonly PackedScene SlashScene = GD.Load<PackedScene>("res://scenes/slash.tscn");
	private float spawnOffset = 60.0f;
	private int Health = 100;
	private bool isDead = false;
	private CharacterBody2D player;
	private bool attack = false;
	
	public override void _Ready()
	{
		_animatedSprite = GetNodeOrNull<AnimatedSprite2D>("Hurtbox/Sprite");
		GetNode<Area2D>("Hurtbox/Area2D").BodyEntered += _OnBodyEntered;
		player = GetTree().GetFirstNodeInGroup("player") as CharacterBody2D;
	}
	//public override void _Process(double delta)
	//{
	
	//}
	public override void _PhysicsProcess(double delta)
	{
		bool flip = player.GlobalPosition.X < GlobalPosition.X;
		if(isDead) return;
		Vector2 velocity = Velocity;
		float dist = GlobalPosition.DistanceTo(player.GlobalPosition);
		//if (player == null) return;
		
		velocity.X = _direction*Speed;
		if(!IsOnFloor())
		{
			velocity.Y += gravity * (float)delta;
		}
		else
		{
			velocity.Y = 0;
		}
		if(IsOnWall())
		{
			_direction *= -1.0f;
			velocity.X = _direction * Speed;
		}
		if(!attack)
		_animatedSprite.FlipH = _direction < 0;
		
		if(isDead) //makes the enemy stand still when dying
		{
			velocity.X = 0;
			velocity.Y = 0;
		} 
		if (dist < 400.0f)
		{

			Vector2 direction = (player.GlobalPosition - GlobalPosition).Normalized();
			_animatedSprite.FlipH = flip;
			velocity = direction * Speed;
			velocity.Y = 0;
			attack = false;
			if (dist < 140.0f)
			{
				attack = true;
				velocity.X = 0;
				Velocity = velocity;
			}
		}
		else{
			attack = false;
		}
		if(attack)
		{
			Vector2 direction = (player.GlobalPosition - GlobalPosition).Normalized();
			velocity = direction * Speed;
			velocity.Y = 0; //remove this to get a flying enemy lol
			velocity.X = 0;
			if(!hasSpawned){
			_animatedSprite.Play("attack");
			_animatedSprite.FlipH = flip;
			if (_animatedSprite.Frame >= 3)
			{
			hasSpawned = true;
			SpawnSlash();
			}
			ToSignal(_animatedSprite, "animation_finished");
			
			}
		}
		if (!attack){ 
			_animatedSprite.Play("walk");
			hasSpawned = false;
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
	public void SpawnSlash()
	{
		
		var slash = SlashScene.Instantiate();
		var SlashNode = slash as Node2D;
		SlashNode.Set("damage", 1);
		
		if (_animatedSprite.FlipH)
		{
			SlashNode.Set("direction", -1.0f);
			SlashNode.GlobalPosition = GlobalPosition + new Vector2(-spawnOffset, -10);
		}
		else
		{
			SlashNode.Set("direction", 1.0f);
			SlashNode.GlobalPosition = GlobalPosition + new Vector2(spawnOffset, -10);
		}
		GetParent().AddChild(slash);
		hasSpawned = false;
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

using Godot;
using System;

public partial class Character : CharacterBody2D
{
	[Export]
	public float Speed { get; set; } = 300.0f;
	public float JumpVelocity { get; set; } = -400.0f;
	public float gravity = ProjectSettings.GetSetting("physics/2d/default_gravity").AsSingle();
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{

	}
	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _PhysicsProcess(double delta)
	{
		Vector2 velocity = Vector2.Zero;
		if (!IsOnFloor())
		{
		// 'gravity' variable needs to be declared at the top of your class!
		velocity.Y += gravity * (float)delta; 
		}
		
		if (Input.IsActionJustPressed("ui_up") && Mathf.IsEqualApprox(Velocity.Y, 0))
		{
		 	velocity.Y = JumpVelocity;
		}
		/*
		if (Input.IsActionPressed("ui_down"))
		{	
		velocity.Y += 1;
		}
		if (Input.IsActionPressed("ui_up"))
		{
		velocity.Y -= 1;
		}
		*/
		float horizontalInput = 0;
	if (Input.IsActionPressed("ui_right")) horizontalInput += 1;
	if (Input.IsActionPressed("ui_left"))  horizontalInput -= 1;
	velocity.X = horizontalInput * Speed;
	
	Velocity = velocity.Normalized() * Speed;
	MoveAndSlide();
	//Position += velocity.Normalized() * 5f;
	}
	
}

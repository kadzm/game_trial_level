using Godot;
using System;
using _Enemy;

public partial class StaticBody2d : StaticBody2D
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		PackedScene BasicEnemy = GD.Load<PackedScene>("res://scenes/enemy.tscn");
		
		//PackedScene Rectangle = GD.Load<PackedScene>("res://Rectangular_block.tscn");
		//Node2D block = Rectangle.Instantiate<Node2D>();
		//block.Position = new Vector2(650,200);
		//AddChild(block);
		
		
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}

using Godot;
using System;

public partial class killplane : Area2D
{
	public void _OnBodyEntered(Node2D body)
	{
		Console.WriteLine("Enemy entered body");
		if (body.HasMethod("Die"))
	{
		body.Call("Die");
	}
	}
}

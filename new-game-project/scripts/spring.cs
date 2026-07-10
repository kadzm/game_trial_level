using Godot;
using System;

public partial class spring : Node2D
{
	public void _OnBodyEntered(Node2D body)
	{
		if (body.HasMethod("TakeDamage"))
	{
		body.Call("TakeDamage", 0);
	}
	}
}

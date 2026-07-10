using Godot;
using System;

public partial class Spikes5 : Node2D
{
	public void _OnBodyEntered(Node2D body)
	{
		if (body.HasMethod("TakeDamage") && body.IsInGroup("player"))
	{
		body.Call("TakeDamage", 5);
	}
	}
}

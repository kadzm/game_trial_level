using Godot;
using System;

public partial class Key : Node2D
{
	public void _OnBodyEntered(Node2D body)
	{
		if (body.HasMethod("Acquire_Key") && body.IsInGroup("player"))
	{
		body.Call("Acquire_Key");
		QueueFree();
	}
	}
}

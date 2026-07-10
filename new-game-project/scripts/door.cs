using Godot;
using System;

public partial class door : Node2D
{
	public void _OnBodyEntered(Node2D body)
	{
		if (body.HasMethod("Check_Key") && body.IsInGroup("player"))
	{
		if(body.Call("Check_Key").AsBool())
		QueueFree();
	}
	}
}

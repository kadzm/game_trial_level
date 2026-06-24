using Godot;
using System;

public partial class Overlay : CanvasLayer
{
	public override void _Ready()
	{
		var player = GetNode<CharacterBody2D>("../CharacterBody2D");
		
		var healthBar = GetNode<ProgressBar>("ProgressBar");
		healthBar.MinValue = 0;
		healthBar.MaxValue = 100; // match your max health
		healthBar.Value = 100;    // starting health
		
		player.Connect("health_changed", Callable.From<int>(_OnHealthChanged));
	}

	private void _OnHealthChanged(int newHealth)
	{
		GetNode<ProgressBar>("ProgressBar").Value = newHealth;
		Console.WriteLine("Here");
	}
}

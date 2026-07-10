extends Area2D

func _OnBodyEntered(body):
	Global.spawn_point = "spawn_up"
	get_tree().change_scene_to_file('res://scenes/Rooms_castle/new_castle_level_room_2.tscn')
	

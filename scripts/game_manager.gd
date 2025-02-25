extends Node

signal level_completed  
signal player_died      

var current_level = "res://scenes/game.tscn"  

func change_level(new_level_path):
	current_level = new_level_path
	get_tree().change_scene_to_file(new_level_path)

func restart_level():
	CoinsController.reset_coins()
	get_tree().reload_current_scene()

func quit_game():
	get_tree().quit()




# HECHO POR ALEJANDRO FLORES RUIZ

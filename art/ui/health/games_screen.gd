extends CanvasLayer

@onready var coin_label =  $MarginContainer/VBoxContainer/HBoxContainer/CoinsLabel

func _ready():
	CoinsController.on_collectible_coin_received.connect(on_collectible_coin_received)


func on_collectible_coin_received(total_coins : int):
	coin_label.text = str(total_coins)




# HECHO POR ALEJANDRO FLORES RUIZ

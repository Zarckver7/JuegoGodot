extends Node


static var total_coins_amount : int = 0

signal on_collectible_coin_received

func _ready():
	total_coins_amount = 0

func give_pickup_coins(collectible_coin : int):
	total_coins_amount += collectible_coin
	
	on_collectible_coin_received.emit(total_coins_amount)

func reset_coins():
	total_coins_amount = 0
	print("🔄 Monedas reseteadas a 0")




# HECHO POR ALEJANDRO FLORES RUIZ

extends Area2D  

@onready var anim_sprite = $AnimatedSprite2D

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))  


func _on_area_entered(area: Area2D) -> void:
	print("Colisión detectada con:", area.name)
	if area.is_in_group("Player"):  
		print("¡Juego terminado!")
		GameManager.quit_game()  




# HECHO POR ALEJANDRO FLORES RUIZ

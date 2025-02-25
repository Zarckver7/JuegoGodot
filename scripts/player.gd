extends CharacterBody2D

@export var speed: float = 140.0
@export var jump_force: float = -320.0
@export var gravity: float = 1300.0
@export var max_jumps: int = 2

var jumps_done: int = 0
var attacking: bool = false
var locked_direction: int = 0  

@onready var anim = $AnimatedSprite2D
@onready var sword = $sword  
@onready var sword_collision = $sword/sword_collision  
@onready var hurtbox = $Hurtbox 

func _ready():
	HealthManager.current_health = HealthManager.max_health
	anim.connect("animation_finished", Callable(self, "_on_animation_finished"))
	sword_collision.set_deferred("disabled", true) 
	hurtbox.connect("area_entered", Callable(self, "_on_hurtbox_entered"))  
	sword.area_entered.connect(_on_sword_collision_entered)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = 0
	if Input.is_action_pressed("right"):
		direction += 1
	if Input.is_action_pressed("left"):
		direction -= 1

	if attacking:
		direction = locked_direction
	else:
		locked_direction = direction if direction != 0 else locked_direction

	if attacking and is_on_floor():
		velocity.x = 0
	elif not attacking:
		velocity.x = direction * speed

	if Input.is_action_just_pressed("saltar"):
		if is_on_floor():
			velocity.y = jump_force
			jumps_done = 1
			anim.play("jump")
		elif jumps_done < max_jumps:
			velocity.y = jump_force
			jumps_done += 1
			anim.play("double_jump")

	if is_on_floor() and velocity.y == 0:
		jumps_done = 0

	if Input.is_action_just_pressed("atacar") and not attacking and is_on_floor():
		attacking = true
		anim.speed_scale = 10.0
		locked_direction = direction if direction != 0 else locked_direction
		anim.play("sword")
		sword_collision.set_deferred("disabled", false)

	if not attacking:
		if velocity.y > 0:
			anim.play("fall")
		elif velocity.x != 0 and is_on_floor():
			anim.play("walk")
		elif is_on_floor():
			anim.play("idle")

	if not attacking and direction != 0:
		anim.flip_h = direction < 0
		_adjust_sword_position()

	move_and_slide()

func _adjust_sword_position():
	if anim.flip_h:
		sword.position.x = -1
		sword.scale.x = -1
	else:
		sword.position.x = 0
		sword.scale.x = 1

func _on_animation_finished():
	if anim.animation == "sword":
		attacking = false
		anim.speed_scale = 1.0
		anim.play("idle")
		sword_collision.set_deferred("disabled", true)


func _on_sword_collision_entered(area):
	if area.is_in_group("enemy"):
		if area.has_method("take_damage"):
			area.take_damage(1)

func player_death():
	anim.play("dead")
	queue_free()
	get_tree().reload_current_scene()

func _on_hurtbox_body_entered(body: Node2D):
	if body.is_in_group("Enemy"):
		print("Enemy entered", body.damage_amount)
		HealthManager.decrease_health(body.damage_amount)
	
	
	if HealthManager.current_health == 0:
		player_death()


func _on_health_body_entered(body: Node2D) -> void:
	print("Colisión detectada con:", body.name)
	if body.is_in_group("Pickup"): 
		print("Fruta recogida")
		HealthManager.increase_health(1)
		body.queue_free() 

func _on_finish_detector_area_entered(area):
	if area.is_in_group("Final"): 
		print("¡Juego terminado!")
		GameManager.quit_game()




# HECHO POR ALEJANDRO FLORES RUIZ

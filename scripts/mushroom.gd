extends CharacterBody2D

@export var patrol_points : Node
@export var health: int = 1 
@export var damage_amount: int = 1

@onready var sprite = $AnimatedSprite2D 
@onready var hurtbox = $Hurtbox 

const GRAVITY = 1000
const SPEED = 800

enum State {IDLE, WALK, DEAD} 
var current_state : State = State.IDLE
var direction : Vector2 = Vector2.ZERO
var number_of_points : int
var point_positions : Array[Vector2]
var current_point : Vector2
var current_point_position : int
var is_dying: bool = false  

func _ready():
	if patrol_points != null:
		number_of_points = patrol_points.get_children().size()
		for point in patrol_points.get_children():
			point_positions.append(point.global_position)
		current_point_position = 0
		current_point = point_positions[current_point_position]

		if current_point.x > position.x:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT

		sprite.scale.x = -1 if direction == Vector2.LEFT else 1
	else:
		print("No patrol points")

	sprite.play("idle")
	current_state = State.IDLE

	hurtbox.area_entered.connect(_on_hurtbox_entered)

func _physics_process(delta: float):
	if current_state == State.DEAD:
		return 

	enemy_gravity(delta)
	
	if current_state == State.IDLE:
		enemy_idle()
	elif current_state == State.WALK:
		enemy_walk(delta)
	
	move_and_slide()

func enemy_gravity(delta: float):
	velocity.y += GRAVITY * delta

func enemy_idle():
	velocity.x = 0
	if not is_dying:
		sprite.play("idle")
		await get_tree().create_timer(2.0).timeout
		if not is_dying:
			current_state = State.WALK
			sprite.play("walk")

func enemy_walk(delta: float):
	if abs(position.x - current_point.x) > 1.0:
		velocity.x = direction.x * SPEED * delta
	else:
		velocity.x = 0
		if not is_dying:
			sprite.play("idle")
			current_state = State.IDLE

			current_point_position = (current_point_position + 1) % number_of_points
			current_point = point_positions[current_point_position]

			if current_point.x > position.x:
				direction = Vector2.RIGHT
			else:
				direction = Vector2.LEFT

			sprite.scale.x = -1 if direction == Vector2.LEFT else 1

func _on_hurtbox_entered(area):
	if area.is_in_group("sword_attack") and current_state != State.DEAD:
		take_damage(1)

func take_damage(amount: int):
	if current_state == State.DEAD or is_dying:
		return 
	
	health -= amount
	print("Enemigo recibió daño. Vida restante:", health)
	
	if health <= 0:
		die()

func die():
	if current_state == State.DEAD or is_dying:
		return 
	
	print("El enemigo ha muerto")
	current_state = State.DEAD
	is_dying = true
	velocity = Vector2.ZERO  
	if hurtbox.has_node("CollisionShape2D"):
		hurtbox.get_node("CollisionShape2D").set_deferred("disabled", true)   
	if has_node("CollisionShape2D"): 
		get_node("CollisionShape2D").set_deferred("disabled", true)
	sprite.play("dead") 
	await sprite.animation_finished  
	queue_free()  




# HECHO POR ALEJANDRO FLORES RUIZ

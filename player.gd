extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

const SPEED = 400.0
const JUMP_VELOCITY = -500.0
var idle_time = 0
var sleep_idle = false
var time = 0
var stop_on_land = false
@onready
var label_win = get_node("../Label")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 16)

	move_and_slide()

func _process(_delta):
	if Input.is_action_pressed("restart"):
		set_physics_process(true) # make sure its enabled at restart
		global_position.x = 0
		global_position.y = -100 
		velocity = Vector2.ZERO
		_animated_sprite.play("idle")
		label_win.text = ""
	if stop_on_land and is_on_floor():
		velocity = Vector2.ZERO
		set_physics_process(false)
		stop_on_land = false
	elif Input.is_action_pressed("right") and is_on_floor():
		idle_time = 0
		_animated_sprite.play("right run")
	elif Input.is_action_pressed("left") and is_on_floor():
		idle_time = 0
		_animated_sprite.play("left run")
	elif Input.is_action_pressed("jump") and Input.is_action_pressed("right"):
		idle_time = 0
		_animated_sprite.play("right jump")
	elif Input.is_action_pressed("jump") and Input.is_action_pressed("left"):
		idle_time = 0
		_animated_sprite.play("left jump")
	elif not is_on_floor() and not Input.is_action_pressed("jump") and Input.is_action_pressed("right"):
		idle_time = 0
		_animated_sprite.play("right static jump")
	elif not is_on_floor() and not Input.is_action_pressed("jump") and Input.is_action_pressed("left"):
		idle_time = 0
		_animated_sprite.play("left static jump")
	elif idle_time < 5:
		_animated_sprite.play("idle")
		idle_time += _delta
	else:
		_animated_sprite.play("sleep")


#func _on_area_2d_area_entered(area: Area2D) -> void:
	#global_position.x = 0
	#global_poswinition.y = 0 
	#print("reset position")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player": 
		global_position.x = 0
		global_position.y = -200 
		#print("reset position")


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		stop_on_land = true
		#set_physics_process(false) this instantly stops, we want it to fall first
		label_win.text = "You win!\nPress R to restart!"

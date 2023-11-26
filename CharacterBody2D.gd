extends CharacterBody2D

@export var world : Node2D
var speed := 175
var cohee = preload("res://coheefire.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("idle")
	pass # Replace with function body.

enum State {
	IDLE,
	MOVE,
	PANIC
}

var state := State.IDLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2.ZERO
	
	match state:
		State.IDLE:
			process_idle(delta)
		State.MOVE:
			process_move(delta)
		State.PANIC:
			process_panic(delta)
	if Input.is_action_just_pressed("ui_accept"):
		$Coheecohee.rotation_degrees = 0
		$Coheecohee.visible = true
	if Input.is_action_pressed("ui_accept"):
		$Coheecohee.rotation_degrees += 3
	if Input.is_action_just_released("ui_accept"):
		$Coheecohee.visible = false
		var coheecohee = cohee.instantiate()
		coheecohee.rotation_degrees = $Coheecohee.rotation_degrees + 60
		coheecohee.global_position = $Coheecohee.global_position
		world.add_child(coheecohee)
	
	velocity = velocity.normalized()
	velocity *= speed
	
	move_and_slide()
	pass
	
func process_idle(delta: float):
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") \
		or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up"):
			state = State.MOVE
			$AnimatedSprite2D.play("run")
			process_move(delta)
			return
	pass

func process_move(delta: float):
	if Input.is_action_pressed("ui_left"):
		velocity += Vector2.LEFT
		$AnimatedSprite2D.scale.x = -1
	elif Input.is_action_pressed("ui_right"):
		velocity += Vector2.RIGHT
		$AnimatedSprite2D.scale.x = 1
	if Input.is_action_pressed("ui_down"):
		velocity += Vector2.DOWN
	elif Input.is_action_pressed("ui_up"):
		velocity += Vector2.UP
	if velocity == Vector2.ZERO:
		state = State.IDLE
		$AnimatedSprite2D.play("idle")
		return
	pass

func process_panic(delta: float):
	pass

extends CharacterBody2D

var speed = 100
var spawned_at : int
var demand := -1
var state := State.IDLE
var player : CharacterBody2D
var follow_point
@onready var helpnodes := [$Helpcoffee, $Helpcr, $Helphelp]

signal impacted

enum State {
	IDLE,
	HELP,
	COFFEE,
	RESTROOM,
	FOLLOW
}

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/world/CharacterBody2D")
	follow_point = player.get_node("AnimatedSprite2D/FollowPoint")
	randomize()
	demand = randi_range(0, 2)
	$demand_trigger.wait_time = randi_range(1, 2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	match state:
		State.IDLE:
			pass
		State.HELP:
			pass
		State.COFFEE:
			pass
		State.RESTROOM:
			pass
		State.FOLLOW:
			process_follow(delta)
	pass

func process_follow(delta):
	var target = follow_point.global_position
	velocity = Vector2.ZERO
	if position.distance_to(target) > 5:
		velocity = position.direction_to(target) * speed

	if velocity.x != 0:
		$AnimatedSprite2D.scale.x = sign(velocity.x)

	if velocity.length() > 0:
		$AnimatedSprite2D.play("move")
	else:
		$AnimatedSprite2D.play("idle")

	move_and_slide()
	pass

func _on_demand_trigger_timeout():
	$AnimatedSprite2D.play("panic")
	helpnodes[demand].visible = true
	match demand:
		0:
			state = State.COFFEE
		1:
			state = State.RESTROOM
		2:
			state = State.HELP
	pass # Replace with function body.


func _on_area_2d_body_entered(body):
	if state == State.HELP:
		$ProgressBar.visible = true
		$help_timer.start()
		return
	elif state == State.RESTROOM:
		state = State.FOLLOW
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	$help_timer.stop()
	pass # Replace with function body.


func _on_help_timer_timeout():
	$ProgressBar.value += 1
	pass # Replace with function body.


func _on_progress_bar_value_changed(value):
	if value != 100:
		return
	state = State.IDLE
	$AnimatedSprite2D.play("idle")
	$ProgressBar.visible = false
	$ProgressBar.value = 0
	hide_help()
	pass # Replace with function body.

func hide_help():
	emit_signal("impacted", spawned_at)
	queue_free()
	return
	for node in helpnodes:
		node.visible = false
	


func _on_area_2d_area_entered(area):
	if area.name == "toilet" and state == State.FOLLOW:
		state = State.IDLE
		$AnimatedSprite2D.play("idle")
		hide_help()
	elif area.name == "cohee" and state == State.COFFEE:
		state = State.IDLE
		$AnimatedSprite2D.play("idle")
		hide_help()
	pass # Replace with function body.

extends Node2D

var hacker = preload("res://hacker.tscn")
var spawn_taken = []
var num_markers = 22
var score := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_spawn_timeout():
	if spawn_taken.size() == num_markers:
		$CanvasLayer/HackathonOverwhelmed/AnimationPlayer.play("fadein")
		$CanvasLayer/HackathonOverwhelmed.visible = true
		get_tree().paused = true
		return
	var spawn_at := randi_range(1, num_markers)
	while spawn_at in spawn_taken:
		spawn_at = randi_range(1, num_markers)
	spawn_taken.append(spawn_at)
	var loc : Vector2 = find_child("Marker2D" + str(spawn_at)).global_position
	var the_hacker = hacker.instantiate()
	the_hacker.global_position = loc
	the_hacker.connect("impacted", _on_hacker_impact)
	the_hacker.spawned_at = spawn_at
	$sprites.add_child(the_hacker)
	$spawn.wait_time = randi_range(0.25, 1.75)
	pass # Replace with function body.

func _on_hacker_impact(spawned_at):
	score += 1
	spawn_taken.erase(spawned_at)
	$CanvasLayer/Label.text = "TOTAL IMPACT: " + str(score)

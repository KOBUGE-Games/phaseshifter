extends Node2D

var tile_offset = 64 # distance between tiles in pixels
var vertical_distance = 96
var horizontal_distance = 1600
var current_horizontal = 0

var obstacle: PackedScene
onready var obstacle0 = preload("res://obstacle/obstacle0.tscn")
onready var obstacle1 = preload("res://obstacle/obstacle1.tscn")
onready var obstacle2 = preload("res://obstacle/obstacle2.tscn")
onready var obstacle_container = $obstacle_container
onready var timer: Timer = $Timer

# obstacle switching logic
var previous_obstacle = 0
var gap_obstacle = 0
var probability = 0
export var difficulty = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	if current_horizontal < horizontal_distance:
		start_level()
	pass

func start_level():
	if timer.is_stopped():
		obstacle_switch()
		for x in range(2):
			var new_obstacle = obstacle.instance()
			new_obstacle.rotation_degrees = -x*180 # set different fade in direction for top / bottom
			x = (x-0.5) * 2 # make value -1 and 1 to spawn top / bottom
			new_obstacle.position = Vector2(current_horizontal,x*vertical_distance)
			obstacle_container.add_child(new_obstacle)
		current_horizontal += tile_offset
		timer.start()
		
func obstacle_switch():
	if gap_obstacle:
		obstacle = obstacle2
		gap_obstacle = 0
	elif previous_obstacle:
		obstacle = obstacle0
		previous_obstacle = 0
		gap_obstacle = 1
	else:
		probability = randi()%101
		if probability < difficulty:
			obstacle = obstacle1
			previous_obstacle = 1
		else:
			obstacle = obstacle0
		gap_obstacle = 1

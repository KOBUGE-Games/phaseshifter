extends Node2D

var tile_offset = 64 # distance between tiles in pixels
var vertical_distance = 96
var horizontal_distance = 1600
var current_horizontal = 0

onready var obstacle = preload("res://obstacle/obstacle.tscn")
onready var obstacle_container = $obstacle_container
onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	if current_horizontal < horizontal_distance:
		start_level()
	pass

func start_level():
	if timer.is_stopped():
		for x in range(2):
			var new_obstacle = obstacle.instance()
			new_obstacle.rotation_degrees = -x*180 # set different fade in direction for top / bottom
			x = (x-0.5) * 2 # make value -1 and 1 to spawn top / bottom
			new_obstacle.position = Vector2(current_horizontal,x*vertical_distance)
			obstacle_container.add_child(new_obstacle)
		current_horizontal += tile_offset
		timer.start()

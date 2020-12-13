extends Node2D

var game_start = true
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

# color management
export var color_amount = 2
var color_palette: Array
var current_color = [Color(1,1,1),Color(1,1,1)]
export var neutrals_color_switch = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	if game_start:
		start_level()
	else:
		for child in obstacle_container.get_child_count():
			var current_child = obstacle_container.get_child(child)
			var current_position = current_child.get_position()
			current_child.set_position(current_position - delta*Vector2(200,0))
			if current_position.x < -tile_offset:
				current_child.get_node("line_container").die()
		if global.create_new_obstacle:
			obstacle_switch()
			create_obstacle()
			global.create_new_obstacle = false
	if game_start and current_horizontal >= horizontal_distance:
		game_start = false
		current_horizontal -= tile_offset
		
	pass

func start_level():
	if timer.is_stopped():
		# make first tiles be flat
		if current_horizontal < 64*10:
			obstacle_starter()
		else:
			obstacle_switch()
			
		create_obstacle()
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
			color_switch()
		else:
			obstacle = obstacle0
		gap_obstacle = 1
	if neutrals_color_switch and (obstacle == obstacle0 or obstacle == obstacle2):
		color_switch()

func obstacle_starter():
	if gap_obstacle:
		obstacle = obstacle2
		gap_obstacle = 0
	else:
		obstacle = obstacle0
		gap_obstacle = 1
	if neutrals_color_switch:
		color_switch()

func create_obstacle():
	for x in range(2):
		var new_obstacle = obstacle.instance()
		new_obstacle.modulate = current_color[x]
		new_obstacle.rotation_degrees = -x*180 # set different fade in direction for top / bottom
		x = (x-0.5) * 2 # make value -1 and 1 to spawn top / bottom
		new_obstacle.position = Vector2(current_horizontal,x*vertical_distance)
		obstacle_container.add_child(new_obstacle)

func color_switch():
	# reset colors for every new element pair
	current_color = [Color(1,1,1),Color(1,1,1)]
	color_palette = global.full_color_palette.duplicate()
	var color_count = color_amount
	for x in range(2):
		var color_index = randi() % color_count # find a random color
		current_color[x] = color_palette[color_index]
		color_palette.remove(color_index) # remove color so it will not be selected twice
		color_count -= 1
	pass

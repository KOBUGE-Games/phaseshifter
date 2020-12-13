extends Node2D

export var animation_length = 1.0

var child_count
var animation
var animation_player: AnimationPlayer
var dead = false

onready var property_name = ["position", "rotation_degrees", "self_modulate", "visible", "scale"]
onready var property_value: Dictionary

func _ready():
	set_process(false) # only needed for death
	child_count = get_child_count()
	# add an animationplayer to the scene
	var animation_instance = AnimationPlayer.new()
	animation_instance.name = "AnimationPlayer"
	self.add_child(animation_instance)
	animation_player = get_node("AnimationPlayer")
	animation_player.add_animation("fade",Animation.new())
	animation = animation_player.get_animation("fade")
	
	for child in child_count:
		# hide childs so they won't be visible before the animation starts
		get_child(child).hide()
		# add all animation properties of every child
		for property in property_name:
			var track_index = animation.add_track(Animation.TYPE_VALUE)
			randomize_properties()
			animation.track_set_path(track_index, str("line", child, ":", property))
			animation.track_insert_key(track_index, 0.0, property_value[property][0])
			animation.track_insert_key(track_index, animation_length, property_value[property][1])
	animation_player.play("fade")

func _process(delta):
	if not animation_player.is_playing():
		get_parent().queue_free()

func randomize_properties():
	randomize()
	property_value = {"position": [Vector2((randi()%2-0.5)*512,(-randi()%4-1)*64), Vector2(0,0)], # slide in randomly
		"rotation_degrees": [randi()%360, 0], # rotate in randomly
		"self_modulate": [Color(0,0,0,1), Color(1.5,1.5,1.5,1)], # fade in effect
		"visible": [true,true], # make childs visible once animation starts
		"scale": [Vector2(0,0),Vector2(1,1)]} # scale up while appearing

func die():
	if not dead:
		animation_player.play_backwards("fade")
		global.create_new_obstacle = true
		set_process(true)
		dead = true

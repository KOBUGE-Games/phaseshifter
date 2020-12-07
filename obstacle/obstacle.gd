extends Node2D

export var animation_length = 1.0

var child_count
var animation

onready var property_name = ["position", "rotation_degrees", "self_modulate"]
onready var property_value: Dictionary

#onready var sprite = $Sprite
#onready var anim = $Node2D/AnimationPlayer
#var current_anim: Animation
#var time = 0
#var distance = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	child_count = get_child_count()
#	randomize_properties()
	
	var animation_instance = AnimationPlayer.new()
	animation_instance.name = "AnimationPlayer"
	self.add_child(animation_instance)
	var animation_player = get_node("AnimationPlayer")
	animation_player.add_animation("fade",Animation.new())
	animation = animation_player.get_animation("fade")
	
	for child in child_count:
		for property in property_name:
			var track_index = animation.add_track(Animation.TYPE_VALUE)
			randomize_properties()
			animation.track_set_path(track_index, str("line", child, ":", property))
			animation.track_insert_key(track_index, 0.0, property_value[property][0])
			animation.track_insert_key(track_index, animation_length, property_value[property][1])
	animation_player.play("fade")

func randomize_properties():
	randomize()
	property_value = {"position": [Vector2(randi()%256-128,-randi()%256-64), Vector2(0,0)],
		"rotation_degrees": [randi()%360, 0],
		"self_modulate": [Color(0,0,0,1), Color(1.5,1.5,1.5,1)]}
#	current_anim = anim.get_animation("fade_in")
#	current_anim.track_insert_key(0,0.0,randi()%360)
#	current_anim.track_insert_key(1,0.0,Vector2(-randi()%100,-randi()%200-100))
#	anim.play("fade_in")

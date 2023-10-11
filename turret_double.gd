extends CharacterBody3D

var player = null
var turret = null

const SPEED = 2.0

@export var player_path : NodePath
@export var turret_path : NodePath
@export var max_speed : float = 10.0

@onready var nav_agent = $NavigationAgent3D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)
	turret = get_node(turret_path)
	
	nav_agent.velocity_computed.connect(move)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector3.ZERO
	
	#Navigation
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	
	var direction = global_position.direction_to(next_nav_point) * max_speed;
	var new_velocity = velocity + (direction - velocity)
	#nav_agent.velocity = new_velocity
	nav_agent.set_velocity(new_velocity)
	nav_agent.set_max_speed(max_speed)
	
	#velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	
	look_at(Vector3(player.global_position.x - 10, global_position.y, player.global_position.z), Vector3.UP)
	turret.look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	#move_and_slide()

func move(new_velocity: Vector3) -> void:
	velocity = new_velocity
	move_and_slide()

extends CharacterBody3D

var player = null
@export var player_path : NodePath

func _ready():
	player = get_node(player_path)
	
func _process(delta):
	$tmpParent/turret_single2/turret.look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)

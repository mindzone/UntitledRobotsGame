extends Camera3D

@export_range(0, 10, 0.01) var sensitivity : float = 3
@export_range(0, 1000, 0.1) var default_velocity : float = 5
@export_range(0, 10, 0.01) var speed_scale : float = 1.17
@export_range(1, 100, 0.1) var boost_speed_multiplier : float = 3.0
@export var max_speed : float = 1000
@export var min_speed : float = 0.2

@onready var _velocity = default_velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction := Vector3.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_down", "move_up")
	direction.z = Input.get_axis("move_forward", "move_back")
	
	if Input.is_action_pressed("move_faster"): # boost
		translate(direction.normalized() * _velocity * delta * boost_speed_multiplier)
	else:
		translate(direction.normalized() * _velocity * delta)
		
func _unhandled_input(event: InputEvent):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotation.y -= event.relative.x / 1000 * sensitivity
			rotation.x -= event.relative.y / 1000 * sensitivity
			rotation.x = clamp(rotation.x, PI/-2, PI/2)
		if event is InputEventJoypadMotion:
			var axis_vector = Vector2.ZERO
			axis_vector.x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
			axis_vector.y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
			rotation.y -= axis_vector.x / 300 * sensitivity
			rotation.x -= axis_vector.y / 300 * sensitivity
			rotation.x = clamp(rotation.x, PI/-2, PI/2)
			
	if(event.is_action("exit_camera_capture")):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if event.pressed else Input.MOUSE_MODE_VISIBLE)
			
	else:
		if event is InputEventMouseButton:
			match event.button_index:
				MOUSE_BUTTON_WHEEL_UP: # increase fly velocity
					_velocity = clamp(_velocity * speed_scale, min_speed, max_speed)
				MOUSE_BUTTON_WHEEL_DOWN: # decrease fly velocity
					_velocity = clamp(_velocity / speed_scale, min_speed, max_speed)

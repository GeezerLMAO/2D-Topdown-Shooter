extends KinematicBody2D

export (float) var speed := 300
export (float) var dash_multiplier := 2.0
export (float) var dash_time := 0.5 # Still don't know what to name it...

var _velocity := Vector2.ZERO
var _dash_timer := 0.0
var _dashing := false

var _last_direction = Vector2.ZERO

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())

func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if direction.length_squared() > 0:
		_last_direction = direction
	
	if Input.is_action_just_pressed("dash"):
		_dashing = true
	# I will probably add this... I still don't know though
#	var mouse_position = get_viewport().get_mouse_position()
#	var distance: Vector2 = (mouse_position - global_position).normalized()
	
	if _dashing:
		_dash_timer += delta
		_velocity = _last_direction * speed * dash_multiplier
		if _dash_timer > dash_time:
			_dash_timer = 0.0
			_dashing = false
	else:
		_velocity = direction.normalized() * speed
	_velocity = move_and_slide(_velocity)

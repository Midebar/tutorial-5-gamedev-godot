extends KinematicBody2D

# If a game is made, can be changed by RPG mechanics, except const
export (int) var speed = 300
export (int) var GRAVITY = 1200
export (int) var jump_speed = -600
export (int) var dash_speed = 750
export (float) var dash_duration = 0.25
export (float) var dash_cooldown = 1.0

const UP = Vector2(0, -1)

var velocity = Vector2()
var doublejump = false

var dash_timer = 0
var dash_cooldown_timer = 0
var dash_direction = Vector2.ZERO

func get_input():
	velocity.x = 0
	if is_on_floor() and Input.is_action_just_pressed('ui_up'):
		velocity.y = jump_speed
		doublejump = false
	elif !is_on_floor() and doublejump == false and Input.is_action_just_pressed('ui_up'):
		velocity.y = jump_speed
		doublejump = true
	
	if Input.is_action_pressed('ui_right'):
		velocity.x += speed
	elif Input.is_action_pressed('ui_left'):
		velocity.x -= speed

	# Dash when Shift key is pressed
	if Input.is_action_pressed('ui_shift') and (Input.is_action_pressed('ui_right') or Input.is_action_pressed('ui_left')) and dash_cooldown_timer <= 0:
		if Input.is_action_pressed('ui_right'):
			dash_direction = Vector2.RIGHT
		elif Input.is_action_pressed('ui_left'):
			dash_direction = Vector2.LEFT
		dash_timer = dash_duration
		dash_cooldown_timer = dash_cooldown

func _physics_process(delta):
	if dash_timer > 0:
		velocity = dash_direction * dash_speed
		dash_timer -= delta
#		print("Dash timer: ", dash_timer)
#		var dash_increment = dash_direction * (dash_speed / dash_duration) * delta
#		print("Dash increment: ", dash_increment)
#		velocity += dash_increment
#		print("Velocity during dash: ", velocity)
	else:
		if dash_cooldown_timer > 0:
			dash_cooldown_timer -= delta
		velocity.y += GRAVITY * delta
		get_input()
	velocity = move_and_slide(velocity, UP)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()

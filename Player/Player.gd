extends KinematicBody2D
export (int) var SPEED = 50
var moveDir = Vector2.ZERO
enum states { IDLE, MOVE }
var state = states.IDLE


func _ready():
	pass

func _process(delta):
	get_inputs()
	if moveDir != Vector2.ZERO:
		state = states.MOVE
	else:
		state = states.IDLE
	
	match state:
		states.IDLE:
			$AnimationPlayer.play("idle")
		states.MOVE:
			set_move_anim()
			move()

func set_move_anim():
	if moveDir.y > 0:
		$AnimationPlayer.play("walk_down")
	elif moveDir.y < 0:
		$AnimationPlayer.play("walk_up")
	elif moveDir.x < 0:
		$AnimationPlayer.play("walk_left")
	elif moveDir.x > 0:
		$AnimationPlayer.play("walk_right")

func get_inputs():
	var move_up = Input.is_action_pressed("move_up");
	var move_down = Input.is_action_pressed("move_down");
	var move_right = Input.is_action_pressed("move_right");
	var move_left = Input.is_action_pressed("move_left");
	
	moveDir.x = -int(move_left) + int(move_right)
	moveDir.y = -int(move_up) + int(move_down)

func move():
	move_and_slide(moveDir.normalized()*SPEED, Vector2.ZERO)

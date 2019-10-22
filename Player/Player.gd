extends KinematicBody2D

# Declare member variables here
export (int) var speed = 50
var TYPE = "PLAYER"
var moveDir = Vector2.ZERO
var lastmoveDir = Vector2.ZERO

enum facings { up, down, left, right }
enum {
	IDLE,
	MOVE
}
var FACING = facings.right
var state
var PREV_STATE
var NEXT_STATE = IDLE
var isDead = false
var alpha = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	idle_state()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	state = NEXT_STATE
	match state:
		IDLE:
			idle_state()
		MOVE:
			move_state()

func set_last_moveDir():
	lastmoveDir = moveDir;

func get_next_state():
	var right = Input.is_action_pressed("move_right")
	var left = Input.is_action_pressed("move_left")
	var up = Input.is_action_pressed("move_up")
	var down = Input.is_action_pressed("move_down")
	
	if right || left || up || down:
		NEXT_STATE = MOVE
	else:
		NEXT_STATE = IDLE



#########################################################
###### IDLE STATE #######################################
#########################################################
func idle_state():
	match FACING:
		facings.right:
			$AnimationPlayer.play("idle_right")
		facings.left:
			$AnimationPlayer.play("idle_left")
		facings.up:
			$AnimationPlayer.play("idle_up")
		facings.down:
			$AnimationPlayer.play("idle_down")
	
	set_last_moveDir()
	get_next_state()
#########################################################


#########################################################
###### MOVE STATE #######################################
#########################################################
func move_state():
	get_movement_inputs()
	movement_loop()
	update_walk_sprite()
	set_last_moveDir()
	get_next_state()

func movement_loop():
	var motion = moveDir.normalized() * speed
	move_and_slide(motion, Vector2(0,0))

func get_movement_inputs():
	var move_up = Input.is_action_pressed("move_up");
	var move_down = Input.is_action_pressed("move_down");
	var move_right = Input.is_action_pressed("move_right");
	var move_left = Input.is_action_pressed("move_left");
	
	moveDir.x = -int(move_left) + int(move_right)
	moveDir.y = -int(move_up) + int(move_down)

func update_walk_sprite():
	var movingHorizontal = false
	var movingVertical = false
	if lastmoveDir.x != 0:movingHorizontal = true
	if lastmoveDir.y != 0:movingVertical = true
	
	if moveDir.x < 0 && !movingVertical:
		$AnimationPlayer.play("walk_left")
		FACING = facings.left
	elif moveDir.x > 0 && !movingVertical:
		$AnimationPlayer.play("walk_right")
		FACING = facings.right
	elif moveDir.y > 0 && !movingHorizontal:
		$AnimationPlayer.play("walk_down")
		FACING = facings.down
	elif moveDir.y < 0 && !movingHorizontal:
		$AnimationPlayer.play("walk_up")
		FACING = facings.up
	elif moveDir.y == 0 && moveDir.x == 0:
		NEXT_STATE = IDLE
		PREV_STATE = state
	
###########################################################
extends KinematicBody2D

# Declare member variables here
export (int) var speed = 50
var TYPE = "NPC"
var moveDir = Vector2.ZERO
var lastmoveDir = Vector2.ZERO

enum facings { up, down, left, right }
var facingStrings = ["up", "down", "left", "right"]

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

func _ready():
	idle_state()

func set_last_move_dir():
	lastmoveDir = moveDir;

func update_anim(animName):
	var anim = animName + facingStrings[FACING]
	$AnimationPlayer.play(anim)

func get_next_state():
	NEXT_STATE = global.choose([MOVE, IDLE])

#########################################################
###### IDLE STATE #######################################
#########################################################
func idle_state():
	update_anim("idle_")
	
	set_last_move_dir()
	get_next_state()
#########################################################


#########################################################
###### MOVE STATE #######################################
#########################################################
func move_state():
	get_movement_inputs()
	movement_loop()
	update_move_sprite()
	set_last_move_dir()
	get_next_state()

func movement_loop():
	var motion = moveDir.normalized() * speed
	move_and_slide(motion, Vector2.ZERO)

func get_movement_inputs():
	var move_up = global.choose([1, 0]);
	var move_down = global.choose([1, 0]);
	var move_right = global.choose([1, 0]);
	var move_left = global.choose([1, 0]);
	
	moveDir.x = -int(move_left) + int(move_right)
	moveDir.y = -int(move_up) + int(move_down)

func update_move_sprite():
	var movingHorizontal = false
	var movingVertical = false
	if lastmoveDir.x != 0:movingHorizontal = true
	if lastmoveDir.y != 0:movingVertical = true
	
	if moveDir.x < 0 && !movingVertical:
		FACING = facings.left
	elif moveDir.x > 0 && !movingVertical:
		FACING = facings.right
	elif moveDir.y > 0 && !movingHorizontal:
		FACING = facings.down
	elif moveDir.y < 0 && !movingHorizontal:
		FACING = facings.up
	elif moveDir.y == 0 && moveDir.x == 0:
		NEXT_STATE = IDLE
		PREV_STATE = state
	
	update_anim("walk_")
###########################################################
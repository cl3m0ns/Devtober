extends KinematicBody2D

# Declare member variables here
export (int) var speed = 50
var TYPE = "PLAYER"
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

export (int) var character_sprite_number = 2;
var sprite_per_character = 12;

func _ready():
	update_anim_frames()
	idle_state()

func _physics_process(delta):
	state = NEXT_STATE
	match state:
		IDLE:
			idle_state()
		MOVE:
			move_state()

func update_anim_frames():
	var anims_list = $AnimationPlayer.get_animation_list()
	for anim in anims_list:
		var animation = $AnimationPlayer.get_animation(anim)
		var idx = animation.find_track("Sprite:frame")
		var anim_frames = animation.track_get_key_count(idx)
		
		if anim_frames == 4:
			var frames = [0,1,2,3]
			for frame in frames:
				var current_val = animation.track_get_key_value ( idx, frame ) 
				animation.track_set_key_value(idx, frame, current_val + (character_sprite_number * sprite_per_character))
		else:
			var current_val = animation.track_get_key_value ( idx, 0 ) 
			animation.track_set_key_value(idx, 0, current_val + (character_sprite_number * sprite_per_character))

func set_last_move_dir():
	lastmoveDir = moveDir;

func update_anim(animName):
	var anim = animName + facingStrings[FACING]
	$AnimationPlayer.play(anim)

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
	var move_up = Input.is_action_pressed("move_up");
	var move_down = Input.is_action_pressed("move_down");
	var move_right = Input.is_action_pressed("move_right");
	var move_left = Input.is_action_pressed("move_left");
	
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
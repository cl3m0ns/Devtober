extends "res://Character/character.gd" 

func _physics_process(delta):
	state = NEXT_STATE
	match state:
		IDLE:
			idle_state()
		MOVE:
			move_state()



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

func get_movement_inputs():
	var move_up = Input.is_action_pressed("move_up");
	var move_down = Input.is_action_pressed("move_down");
	var move_right = Input.is_action_pressed("move_right");
	var move_left = Input.is_action_pressed("move_left");
	
	moveDir.x = -int(move_left) + int(move_right)
	moveDir.y = -int(move_up) + int(move_down)
###########################################################
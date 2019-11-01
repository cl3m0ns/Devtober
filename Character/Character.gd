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

enum CharacterSprite { 
	Boy_Spikey_Har,
	Girl_Blue_Hair,
	Boy_Short_Black_Hair,
	Boy_Red_Hair,
	Boy_Short_Brown_Hair,
	Boy_Glasses,
	Boy_Spikey_Green_Hair,
	Black_Bieber_Hair,
	Girl_Flower_Hat,
	Boy_Brown_Tophat,
	Girl_Red_Hair,
	Girl_Brown_Hair,
	Boy_Black_Flattop,
	Deadlock_Hair_Maybe,
	Boy_Blue_Hat_And_Glasses,
	Boy_Middle_Part_Blue_Hair,
	Boy_Red_Mohawk,
	Girl_Black_Hair_Red_Headband,
	Boy_Fonzie_Lookalike,
	Girl_Brown_Hair_Glasses,
	Brown_Waivey_Long_Hair,
	Boy_Dark_Brown_Hair,
	Girl_Brown_Hair_Blue_PJs,
	Girl_Blond_with_Link_Tunic,
	Boy_Old_Grey_Hair,
	Ninja,
	Girl_Black_Hair_in_Bun,
	Boy_Middle_Part_Brown_Hair,
	Boy_Scienctist_Black_Hair,
	Blond_Hair_Secret_Agent,
	Bald_Secret_Agent,
	Girl_Black_Hair_Kinda_Wavy,
	Emo_Person_Black_Hair,
	Girl_Dreadlocks_Maybe,
	Boy_Blonde_Bieber_In_Shades,
	Girl_Old_White_Hair,
	Turban_Man,
	Girl_Afro,
	Boy_Scienctist_Blue_Hair,
	Boy_Old_White_Hair,
	Boy_spikey_black_hair_and_shades,
	Girl_redhead_with_nerd_glasses,
	Boy_Brown_Mohawk,
	Boy_winter_hat_maybe,
	Boy_black_bowler_hat,
	Girl_Red_hair_2,
	girl_curly_black_hair,
	clown,
	Boy_flattop_blonde,
	Boy_middle_part_brown_haired_nerd,
	Boy_redhead_bierber_lookin_mfer,
	Girl_blue_cheerleader,
	girl_readhead_middle_part,
	boy_generic_brown_hair_kinda_cool,
	girl_blonde_hair_in_a_ponytail,
	girl_red_cheerleader,
	Boy_cool_bearded_guy,
	girl_brownhair_kinda_side_parted,
	Boy_nerdy_glasses_and_black_hair,
	boy_football_blue,
	Boy_brownhaired_prettyboi,
	Boy_tall_cool_black_guy,
	Girl_blackhair_and_dress,
	Boy_football_red,
	Boy_basketball_blue,
	boy_basketball_red,
	boy_bald_white_dude,
	boy_black_guy_with_tiny_silver_hat,
	police,
	security_guard_maybe,
	construction_worker,
	firefighter,
	blue_hat_and_apron,
	red_hat_and_apron,
	black_hat_maybe_baseball_helmet,
	Boy_generic_middle_part_brown_hair_black_clothes,
	Boy_short_blonde_hair,
	boy_short_brown_hair_and_beard,
	girl_generic_blonde_chicka_number_idk,
	girl_brown_hair_inna_kinda_ponytail,
	Boy_short_red_hair,
	Bearded_cool_black_guy_greyish_hair,
	Girl_darkskin_dark_hair,
	girl_dark_skin_hair_in_ponytail,
	Angry_balk_businessman_brown_hair,
	Girl_fancy_looking_rich_lady_brown_hair,
	Girl_pigtails_and_red_bow,
	Boy_blone_hair_kinda_generic_looking,
	Angry_balk_businessman_black_hair,
	Girl_fancy_looking_rich_lady_red_hair,
	Girl_pigtails_and_green_bow,
	Boy_brown_hair_kinda_generic_looking,
	army_1,
	army_2,
	army_3,
	army_4,
	army_with_helmet_1,
	army_with_helmet_2,
	army_chicka,
	look_at_me_im_the_captain_now
}
export( CharacterSprite ) var sprite_type =  CharacterSprite.Boy_Spikey_Har 

var sprite_per_character = 12;

func _ready():
	update_anim_frames()
	idle_state()

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
				animation.track_set_key_value(idx, frame, current_val + (sprite_type * sprite_per_character))
		else:
			var current_val = animation.track_get_key_value ( idx, 0 ) 
			animation.track_set_key_value(idx, 0, current_val + (sprite_type * sprite_per_character))

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
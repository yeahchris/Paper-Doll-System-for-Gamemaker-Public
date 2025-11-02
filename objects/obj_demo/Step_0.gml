
keyright = keyboard_check(vk_right) || keyboard_check(ord("D"));
keyleft = keyboard_check(vk_left) || keyboard_check(ord("A"));
keyup = keyboard_check(vk_up) || keyboard_check(ord("W"));
keydown = keyboard_check(vk_down) || keyboard_check(ord("S"));

hdir =  keyright - keyleft;
vdir = keydown - keyup;
input_magnitude = hdir != 0 || vdir != 0;

move_x = hdir * move_speed;
move_y = vdir * move_speed;


if (input_magnitude == false) {
//Go to 'standing' frame if not pressing movement buttons
	pds.SetCurrentFrame(0);	
} else {

///Update PDS animation based upon move direction

	if (hdir > 0) {
		pds.SetAnimation(ANIM.FSWALKRIGHT)	
	} else if (hdir < 0) {
		pds.SetAnimation(ANIM.FSWALKLEFT)	
	} else {
		if (vdir > 0) {
			pds.SetAnimation(ANIM.FSWALKDOWN);	
		} else if (vdir < 0) {
			pds.SetAnimation(ANIM.FSWALKUP)	
		}	
	}
}

//Update shake magnitude based on slider selection
pds.SetShakeMagnitude(obj_selector.shake_magnitude);


image_angle = obj_selector.angle;
image_xscale = obj_selector.scale;
image_yscale = obj_selector.scale;
image_alpha = obj_selector.alpha;


move_and_collide(move_x,move_y,collidables);
x = clamp(x,0,room_width);
y = clamp(y,0,room_height);
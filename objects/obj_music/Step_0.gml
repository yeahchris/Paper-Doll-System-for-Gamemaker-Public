var gain = audio_sound_get_gain(music);
if (gain <= 0){
	audio_pause_sound(music);
} else {
	audio_resume_sound(music);
}


var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx,my,bbox_left,bbox_top,bbox_right,bbox_bottom)){
	if (gain < 1) audio_sound_gain(music,1,500);
	if (gain >= 1) audio_sound_gain(music,0,500);
}
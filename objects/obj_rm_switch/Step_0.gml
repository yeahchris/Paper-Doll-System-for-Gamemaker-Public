var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mx,my,bbox_left,bbox_top,bbox_right,bbox_bottom)){

	if (room = room_demo) room_goto(room_demo_3D); 
	else room_goto(room_demo);
}
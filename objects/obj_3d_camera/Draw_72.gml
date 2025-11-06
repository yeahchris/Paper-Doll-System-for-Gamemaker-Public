var camera = camera_get_active();
var cam_width = camera_get_view_width(camera)
var xto = obj_demo_3d.x;
xto = clamp(xto,50,room_width-50);
var yto = obj_demo_3d.y;
var zto = 35;

var xfrom = obj_demo_3d.x;
var yfrom = obj_demo_3d.y+100;
var zfrom = 50;



camera_set_view_mat(camera, matrix_build_lookat(xfrom,yfrom,zfrom,xto,yto,zto,0,0,1));
camera_set_proj_mat(camera,matrix_build_projection_perspective_fov(-60,-window_get_width()/window_get_height(),1,1000));
camera_apply(camera);

draw_clear(c_black);
layer_force_draw_depth(true,0);
gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
gpu_set_alphatestenable(true);
gpu_set_alphatestref(254);




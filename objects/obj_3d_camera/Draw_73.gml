gpu_set_zwriteenable(false);
gpu_set_ztestenable(false);
var camera = camera_get_active();
camera_set_view_mat(camera, oldviewmatrix);
camera_set_proj_mat(camera, oldprojectionmatrix);

//draw_clear(c_black);
//layer_force_draw_depth(true,0);
gpu_set_alphatestref(0);
gpu_set_zwriteenable(false);
gpu_set_ztestenable(false);
gpu_set_alphatestenable(false);

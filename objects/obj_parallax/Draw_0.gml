draw_sprite_tiled_ext(spr_parallax_back,0,500,0,1.6,1.6,c_white,1);
draw_sprite_tiled_ext(spr_parallax_middle,0,0-current_time/380,0,1.6,1.6,c_white,1);
draw_sprite_tiled_ext(spr_parallax_front,0,0-current_time/200,0,1.6,1.6,c_white,1);

draw_set_font(fnt_small);
draw_set_valign(fa_middle);
draw_text(room_width*.03,room_height*.9,"Elementalis Sprites courtesy of LordFitoi on itch.io");
draw_text(room_width*.03,room_height*.95,"'CalmBGM' courtesy of syncopika on opengameart.org");


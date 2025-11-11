global.PDSTemplates = {}

///@desc Adds a new sheet template that you can use for a paper doll system. Can be applied to a paper doll system either when you create one or by calling the ApplyTemplate method afterward.
///@param _key {string} A one-word key for storing/retrieving the template. Will be used as a key to identify and retrieve the template. No spaces.
///@param _animation_array The array where animations for this template can be found.
///@param _frame_width {real} The width (in pixels) of an individual frame on the sprite sheets for this template. Integer.
///@param _frame_height {real} The height (in pixels) of an individual frame on the sprite sheets for this template. Integer.
///@param _sheet_width {real} The width (in frames) for a given row on the sprite sheet. Integer.
///@param _uses_milliseconds {boolean} Controls whether the template will use milliseconds or game frames for a frame's duration when reading an animation struct animations. True/False.
function AddPDSTemplate (_key,_animation_array,_frame_width,_frame_height,_sheet_width,_uses_milliseconds){
	var _struct = {}
	_struct.key = _key;
	_struct.animations = _animation_array;
	_struct.frame_width = _frame_width;
	_struct.frame_height = _frame_height;
	_struct.sheet_width = _sheet_width
	_struct.uses_milliseconds = _uses_milliseconds;
	global.PDSTemplates[$ _key] = _struct;
}

///@desc Returns an empty animation struct with the following variables:
///_____________________________________________________________________
///framenumber ---- an array of numbered frames for the animation.
///xscale ---- an array of xscales for the frame (1 to draw it normally, -1 to mirror it).
///duration ---- an array of numbers indicating the amount of time to show that frame for. Duration can be set either in frames or milliseconds (determined by the sheet template assigned to the paper doll system).
function PDSAnimation(_name) constructor {
	name = _name;
	framenumber = [0];
	xscale = [0];
	duration = [0];
}


///@desc Checks for data entry errors in the global animation array.
function PDSVerifyAnimations(_array){
	var _failed = 0;
	var _verified = 0;
	for (var i = 0; i < array_length(_array);i++){
		var _struct = _array[i];
		if (is_struct(_struct) == false){
			_failed++
			show_message($"Animation at index {i} is not a struct!")
			continue;
			}
		var _framecount = array_length(_struct.framenumber);
		if (_framecount == array_length(_struct.xscale) && _framecount == array_length(_struct.duration)){
			_verified++;
		} else {
			_failed++;
			show_message($"Malformed animation: {_struct.name} at index {i} -- arrays do not match!");	
		}
	}
	show_debug_message($"Paper Doll System: {_verified} animations verified. {_failed} animations failed verification.");
}



///@desc Returns a new Paper Doll System. The paper doll system has a variety of static methods for issuing commands to the paper doll system. See individual methods' descriptions for details.
///@param {string} _template_key The sheet template for the Paper Doll System to use.
function PaperDollSystem(_template_key) constructor {
	if (!variable_global_exists("retro_pal_swapper")){
		pal_swap_init_system(shd_pal_swapper,shd_pal_html_sprite,shd_pal_html_surface);
	}
    __sprite_array = [];
    __animation = {};
    __currentframe = 0;
    __frametimer = 0;
    __animationEnd = false;
	__currentanimation = undefined;
	__shakemagnitude = 1;
	__shake = false;
	__template = global.PDSTemplates[$ _template_key]
	__paletteswaps = []
	__surface = -1;
	__lastanimframe = -1;
	__lastframexscale = undefined;
	

	///@method ApplyTemplate(_template)
	///@desc Applies a previously created template to the paper doll system.
	///@param {string} _template_key The name/key of the template to apply as a single word without spaces.
	static ApplyTemplate = function(_template_key){
		if variable_instance_exists(global.PDSTemplates,_template){
			__template = global.PDSTemplates[$ _template];	
		} else {
			show_message($"Template named {_template} not found!");	
		}
	}
	
	///@method GetFrame(_framenum)
	///@desc Takes in a frame number (counted left to right, top to bottom) and returns the X and Y coordinates (in frames) for that frame.
	///@param {real} _framenum The frame number as an integer.
	static GetFrame = function(_framenum) {
		var _struct = {
			X: _framenum mod __template.sheet_width,
			Y: _framenum div __template.sheet_width
		}
		return _struct
	}
	
	///@method AddSprite(_sprite)
	///@desc Adds a new sprite for the paper doll system to draw on top of all existing sprites.
	///@param _sprite {asset} The sprite asset for the system to add.
    static AddSprite = function(_sprite) {
        if (asset_get_type(_sprite) == asset_sprite) {
            array_push(__sprite_array, _sprite);
			__lastanimframe = -1;
        } else {
			show_debug_message("You attempted to add a sprite which isn't a sprite to a Paper Doll System. This is why we can't have nice things.");	
		}
    }
	
	///@method AddSpriteAtIndex(_sprite,_index)
	///@desc Adds a sprite at a specified index for the paper doll system to draw. Sprites at higher indexes will be drawn on top of sprites at lower indexes. Will overwrite existing sprite at that index if the index is already in use. Useful if you want pre-defined equipment 'slots'.
	///@param _sprite {asset} The sprite to add.
	///@param _index {real} The index to add it at. Integer.
	static AddSpriteAtIndex = function(_sprite,_index) {
        if (asset_get_type(_sprite) == asset_sprite) {
            __sprite_array[_index] = _sprite;
			__lastanimframe = -1;
        } else {
			show_debug_message("You attempted to add a sprite which isn't a sprite to a Paper Doll System. This is why we can't have nice things.");	
		}
    }
	
	///@method SetShakeMagnitude(_magnitude)
	///@desc Sets the magnitude of the shake effect that will be used when SetShake method is used.
	///@param _magnitude {real} (Recommended: 1)
	static SetShakeMagnitude = function(_magnitude) {
		__shakemagnitude = _magnitude;	
	}
	
	///@method GetShakeMagnitude
	///@desc Returns the current magnitude of the shake effect.
	static GetShakeMagnitude = function(){
		return __shakemagnitude;	
	}
	
	///@method SetShake(_bool)
	///@desc Used to toggle the shake effect.
	///@param {bool} _bool True (turns the shake effect on) or False (turns the shake effect off)
	static SetShake = function (_bool) {
		__shake = _bool;
	}
	
	///@method GetShake
	///@desc Returns true if the shake effect is currently enabled, returns false if it is not.
	static GetShake = function() {
		return __shake;	
	}
	
	///@method ClearSpriteAtIndex(_index)
	///@desc Clears the sprite at a given index without deleting the slot. Use if you are using indexes slots for paper doll layers.
	///@param {real} _index The index to clear.
	static ClearSpriteAtIndex = function(_index) {
		__sprite_array[_index] = 0;
		__lastanimframe = -1;
	}
	
	///@method RemoveSprite(_sprite)
	///@desc Removes the first instance of a given sprite and deletes its slot. Use if you're not using static indexes for paper doll layers.
	///@param {asset} _sprite The sprite to remove.
    static RemoveSprite = function(_sprite) {
        if (asset_get_type(_sprite) == asset_sprite) {
            var _index = array_get_index(__sprite_array, _sprite);
            array_delete(__sprite_array, _index, 1);
			__lastanimframe = -1;
        }
    }
	
	///@method GetAnimationName(_animation)
	///@desc Takes in an animation number (enumerator) and returns the name of that animation (a string).
	///@param {real} _animation The animation number (use the enumerator)
	static GetAnimationName = function(_animation) {
		return __template.animations[_animation].name;			
	}
	
	///@method ContainsSprite(_sprite)
	///@desc Returns true if the specified sprite is already being drawn by the paper doll system.
	///@param {asset} _sprite The sprite to check.
	static ContainsSprite = function(_sprite){
		if (asset_get_type(_sprite) == asset_sprite) {
            return array_contains(__sprite_array,_sprite);
        }
	}
	
	///@method GetSpriteAtIndex(_index)
	///@desc Returns the sprite at a given index.
	///@param {real} _index The index to check. Integer. Returns 0 for an empty slot. Returns undefined if slot exceeds the length of the sprite array.
	static GetSpriteAtIndex = function(_index){
		if (_index <= array_length(__sprite_array)-1){
			return __sprite_array[_index];        
		} else {
			return undefined;	
		}
	}
	
	
	///@method SetAnimation(_animation)
	///@desc Takes in an animation number (enumerator), retrieves the animation struct, and sets that to be the current animation.
	///@param {real} _animation The animation number
    static SetAnimation = function(_animation) {
        if (is_struct(__template.animations[_animation]) == true && __template.animations[_animation] != __animation) {
            __animation = __template.animations[_animation];
            __currentframe = 0;
            __frametimer = MillisecondstoGameFrames(__animation.duration[__currentframe]);
        }
		__currentanimation = _animation;
    }
	///@method SetPaletteSwap(_sprite,_palette_sprite,_index)
	///@desc Specifies a palette swap for the given sprite.
	///@param {asset} _sprite The sprite you want to do the palette swap on.
	///@param {asset} _palette_sprite The palette sprite with which to do the swap.
	///@param {real} _index The number of pixels into the palette sprite you wish to step.
	static SetPaletteSwap = function (_sprite, _palette_sprite, _index) {
		var _struct = {
			sprite : _sprite,
			palette : _palette_sprite,
			index : _index
		}
		__lastanimframe = -1;
		for (var i = 0; i < array_length(__paletteswaps);i++){
			if (__paletteswaps[i].sprite == _sprite){
				__paletteswaps[i]= _struct;
				return;	
			}	
		}
		array_push(__paletteswaps,_struct);
	}
	
	///@method RemovePaletteSwap(_sprite)
	///@desc Removes a previously set up palette swap for a given sprite.
	///@param {asset} _sprite The sprite for which you want to clear the palette swap.
	static RemovePaletteSwap = function (_sprite) {
		if (array_length(__paletteswaps) > 0){
			for (var i = 0; i < array_length(__paletteswaps);i++){
				if (__paletteswaps[i].sprite == _sprite){
					array_delete(__paletteswaps,i,1);
					return;	
				}	
			}
		}
		__lastanimframe = -1;
	}
	
	///@method DrawSelf
	///@desc Draws the paper doll system at the calling instances' X and Y coordinate using the calling instance's default draw parameters (image_xscale, image_yscale, image_blend, image_alpha)
    static DrawSelf = function() {
		var _shake_x = 0
		var _shake_y = 0;
		var _surface_new = false;
		var _framenum = __animation.framenumber[__currentframe];
        var _frame = GetFrame(_framenum);
		var _coords = FrameCoordsToPixelCoords(_frame.X, _frame.Y);
		var _framexscale = __animation.xscale[__currentframe]
        var _xoffset = sprite_get_xoffset(other.sprite_index);
        var _yoffset = sprite_get_yoffset(other.sprite_index);
		var _angle = other.image_angle
		var _xscale = other.image_xscale
		var _yscale = other.image_yscale;
		if (__shake == true){
			_shake_x = random_range(-__shakemagnitude,__shakemagnitude);
			_shake_y = random_range(-__shakemagnitude,__shakemagnitude);
		}
		
		if (surface_exists(__surface) == false){
			__surface = surface_create(__template.frame_width,__template.frame_height);
			_surface_new = true;
		}

		if (_framenum != __lastanimframe || _framexscale != __lastframexscale || _surface_new == true){
			surface_set_target(__surface);
			draw_clear_alpha(c_black,0)
			var _mirrorcorrection = 0
			if (_framexscale == -1) _mirrorcorrection = __template.frame_width;
			for (var i = 0; i < array_length(__sprite_array); i++) {
				if (__sprite_array[i] == 0) continue;
				if (array_length(__paletteswaps) > 0){
					for (var ii = 0; ii < array_length(__paletteswaps);ii++){
						if (__sprite_array[i] == __paletteswaps[ii].sprite){
							pal_swap_set(__paletteswaps[ii].palette,__paletteswaps[ii].index,false);
							break;
						}
					}
				}
				draw_sprite_part_ext(__sprite_array[i],0,_coords.X,_coords.Y,__template.frame_width,__template.frame_height, _shake_x + _mirrorcorrection,_shake_y,__animation.xscale[__currentframe],1, other.image_blend,1);
				pal_swap_reset();
				}
			surface_reset_target();
			}
		var _x = other.x - _xoffset * _xscale * dcos(_angle) - _yoffset * _yscale * dsin(_angle);
	    var _y = other.y + _xoffset * _xscale * dsin(_angle) - _yoffset * _yscale * dcos(_angle);
		draw_surface_ext(__surface,_x+_shake_x,_y+_shake_y,_xscale,_yscale,_angle,other.image_blend,other.image_alpha)
		__lastanimframe = _framenum;
		__lastframexscale = _framexscale;
    }
	

	///@desc Draws the paper doll system allows you to pass custom values to be used in place of x, y, image_xscale,image_yscale, image_blend, and image_alpha.
	///@param {real} _x The X coordinate at which to draw the paper doll system.
	///@param {real} _y The Y coordinate at which to draw the paper doll system.
	///@param {real} _xscale Horizontal scaling multiplier, .5 to draw it at half width, 2 to draw it at double its normal width.
	///@param {real} _yscale Vertical scaling multiplier, .5 to draw it at half height, 2 to draw it at double its normal height.
	///@param {real} _angle Rotation to apply to the drawn paper doll system.
	///@param {Constant.Colour} _color The color with which to blend the paper doll systems top left. c_white to draw it normally.
	///@param {real} _alpha The alpha of the paper doll system, from 0 to 1, where 0 is fully transparent and 1 is fully opaque.
	static DrawSelfExt = function(_x, _y, _xscale, _yscale, _angle, _color, _alpha) {
		var _shake_x = 0
		var _shake_y = 0;
		var _surface_new = false;
		var _framenum = __animation.framenumber[__currentframe];
        var _frame = GetFrame(_framenum);
		var _coords = FrameCoordsToPixelCoords(_frame.X, _frame.Y);
		var _framexscale = __animation.xscale[__currentframe]
        var _xoffset = sprite_get_xoffset(other.sprite_index);
        var _yoffset = sprite_get_yoffset(other.sprite_index);
		if (__shake == true){
			_shake_x = random_range(-__shakemagnitude,__shakemagnitude);
			_shake_y = random_range(-__shakemagnitude,__shakemagnitude);
		}
		if (surface_exists(__surface) == false){
			__surface = surface_create(__template.frame_width,__template.frame_height);
			_surface_new = true;
		}

		if (_framenum != __lastanimframe || _framexscale != __lastframexscale || _surface_new == true){
			surface_set_target(__surface);
			draw_clear_alpha(c_black,0)
			var _mirrorcorrection = 0
			if (_framexscale == -1) _mirrorcorrection = __template.frame_width;

			for (var i = 0; i < array_length(__sprite_array); i++) {
				if (__sprite_array[i] == 0) continue;
				if (array_length(__paletteswaps) > 0){
					for (var ii = 0; ii < array_length(__paletteswaps);ii++){
						if (__sprite_array[i] == __paletteswaps[ii].sprite){
							pal_swap_set(__paletteswaps[ii].palette,__paletteswaps[ii].index,false);
							break;
						}
					}
				}
				draw_sprite_part_ext(__sprite_array[i],0,_coords.X,_coords.Y,__template.frame_width,__template.frame_height, _shake_x + _mirrorcorrection,_shake_y,__animation.xscale[__currentframe],1, c_white,1);
				pal_swap_reset();
				}
			surface_reset_target();
			}
		var _xpos = _x - _xoffset * _xscale * dcos(_angle) - _yoffset * _yscale * dsin(_angle);
	    var _ypos = _y + _xoffset * _xscale * dsin(_angle) - _yoffset * _yscale * dcos(_angle);
		draw_surface_ext(__surface,_xpos+_shake_x,_ypos+_shake_y,_xscale,_yscale,_angle,_color,_alpha)
		__lastanimframe = _framenum;
		__lastframexscale = _framexscale;
    }
	
	
	///@method DrawSelfMatrix
	///@desc Draws the paper doll system using a matrix. Experimental.
	static DrawSelfMatrix = function(_x, _y, _z, _xrot, _yrot, _zrot, _xscale, _yscale, _zscale, _angle, _color) {
		var _shake_x = 0
		var _shake_y = 0;
		var _surface_new = false;
		var _framenum = __animation.framenumber[__currentframe];
        var _frame = GetFrame(_framenum);
		var _coords = FrameCoordsToPixelCoords(_frame.X, _frame.Y);
		var _framexscale = __animation.xscale[__currentframe]
        var _xoffset = sprite_get_xoffset(other.sprite_index);
        var _yoffset = sprite_get_yoffset(other.sprite_index);
		if (__shake == true){
			_shake_x = random_range(-__shakemagnitude,__shakemagnitude);
			_shake_y = random_range(-__shakemagnitude,__shakemagnitude);
		}
		if (surface_exists(__surface) == false){
			__surface = surface_create(__template.frame_width,__template.frame_height);
			_surface_new = true;
		}

		if (_framenum != __lastanimframe || _framexscale != __lastframexscale || _surface_new == true){
			surface_set_target(__surface);
			draw_clear_alpha(c_black,0)
			var _mirrorcorrection = 0
			if (_framexscale == -1) _mirrorcorrection = __template.frame_width;

			for (var i = 0; i < array_length(__sprite_array); i++) {
				if (__sprite_array[i] == 0) continue;
				if (array_length(__paletteswaps) > 0){
					for (var ii = 0; ii < array_length(__paletteswaps);ii++){
						if (__sprite_array[i] == __paletteswaps[ii].sprite){
							pal_swap_set(__paletteswaps[ii].palette,__paletteswaps[ii].index,false);
							break;
						}
					}
				}
				draw_sprite_part_ext(__sprite_array[i],0,_coords.X,_coords.Y,__template.frame_width,__template.frame_height, _shake_x + _mirrorcorrection,_shake_y,__animation.xscale[__currentframe],1, c_white,1);
				pal_swap_reset();
				}
			surface_reset_target();
			}
		var _surf_x = 0 - _xoffset * _xscale * dcos(_angle) - _yoffset * _yscale * dsin(_angle);
	    var _surf_y = 0 + _xoffset * _xscale * dsin(_angle) - _yoffset * _yscale * dcos(_angle);
		var _matrix = matrix_build(_x,_y,_z,_xrot,_yrot,_zrot,_xscale,_yscale,_zscale);
		matrix_set(matrix_world,_matrix);
		draw_surface_ext(__surface,_surf_x+_shake_x,_surf_y+_shake_y,_xscale,_yscale,_angle,_color,1);
		matrix_set(matrix_world,matrix_build_identity());
		__lastanimframe = _framenum;
		__lastframexscale = _framexscale;
    }
	

	///@method AnimationEnd
	///@desc Returns true on the frame the animation completes if the current animation has more than one frame. Otherwise returns false.
    static AnimationEnd = function() {
        if (__animationEnd == true) {
            return true;
        } else {
			return false;
		}
    }

	///@method GetCurrentFrame
	///@desc Returns the current frame of the current animation as an integer.
    static GetCurrentFrame = function() {
        return __currentframe;
    }
	
	///@method GetAnimationLength(_animation)
	///@desc Returns the array_length of a given animation
	///@param {real} _animation The animation to check.
	static GetAnimationLength = function(_animation) {
		return array_length(__template.animations[_animation].framenumber);	
	}
	
	///@method Animate
	///@desc Animates the paper doll system.
    static Animate = function() {
        if (__frametimer <= 0) {
            __currentframe++;
            if (__currentframe > array_length(__animation.framenumber) - 1) {
                __currentframe = 0
                if (array_length(__animation.framenumber) > 1) {
                    __animationEnd = true;
                }
            }
            if (__template.uses_milliseconds == true) {
				__frametimer = MillisecondstoGameFrames(__animation.duration[__currentframe]);
			} else {
				__frametimer = __animation.duration[__currentframe];	
			}
        } else {
            if (__animationEnd == true) {
                __animationEnd = false;
            }
            __frametimer--;
        }
    }
	
	///@method SetCurrentFrame(_frame)
	///@desc Sets the current frame of the current animation to the frame you specify.
	///@param {real} _frame The frame you wish to set the current animation to
	static SetCurrentFrame = function(_frame) {
		__currentframe = _frame;
		if (__template.uses_milliseconds = true){
			__frametimer = MillisecondstoGameFrames(__animation.duration[__currentframe]);
		} else {
			__frametimer = __animation.duration[__currentframe]; 
		}
		return;
	}
	
	///@method MillisecondstoGameFrames(_milliseconds)
	///@desc - Converts milliseconds to game frames.
	///Used by the paper doll system for animation when using a template where animations are timed in milliseconds. Typically does not need to be called manually.
	///(Unless you want to).
	///@param {real} _milliseconds The number (in milliseconds) to return in game frames.
	static MillisecondstoGameFrames = function(_milliseconds) {
    var _frames = round(_milliseconds * game_get_speed(gamespeed_fps) / 1000);
    return _frames;
	}
	
	///@method GetCurrentAnimation
	///@desc - Returns the current animation number.
	static GetCurrentAnimation = function(){
		return __currentanimation;	
	}
	
	///@method GetAnimationStruct(_animation)
	///@desc Returns the current animation's struct.
	static GetAnimationStruct = function(_animation) {
		return __template.animations[_animation];	
	}
	
	///@method FrameCoordsToPixelCoords(_x,_y)
	///@desc Takes in the FRAME X/Y coordinate for a given sheet frame and returns the PIXEL coordinates for that frame. This is used by the PDS drawing methods. Typically does not need to be called manually. 
	///@param {real} _x Integer. The X coordinate of the frame, usually returned by GetFrame.
	///@param {real} _y Integer. The Y coordinate of the frame, usually returned by GetFrame.
	static FrameCoordsToPixelCoords = function(_x,_y) {
		_x *= __template.frame_width;
	    _y *= __template.frame_height;
	    var _frame = {
	        X: _x,
	        Y: _y
	    }
	    return _frame;
	}
	///@method Cleanup
	///@desc Cleans up the paper doll system. Use prior to deleting the object.
	static Cleanup = function() {
        surface_free(__surface);
    }
	
}
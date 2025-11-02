///@desc Returns a blank animation struct.

enum ANIM {
	FSWALKRIGHT,
	FSWALKUP,
	FSWALKLEFT,
	FSWALKDOWN,
	
	
	
	COUNT

	
}


//Prepare animation list
global.PDSAnimations = array_create(ANIM.COUNT,undefined)

//Prepare animations

global.PDSAnimations[ANIM.FSWALKRIGHT] = new PDSAnimation("FS-Walkright");
global.PDSAnimations[ANIM.FSWALKRIGHT].framenumber =		[8,9,10,11];
global.PDSAnimations[ANIM.FSWALKRIGHT].xscale =				[1,1,1,1];
global.PDSAnimations[ANIM.FSWALKRIGHT].duration =			[8,8,8,8];

global.PDSAnimations[ANIM.FSWALKUP] = new PDSAnimation("FS-WalkUp");
global.PDSAnimations[ANIM.FSWALKUP].framenumber =			[12,13,14,15];
global.PDSAnimations[ANIM.FSWALKUP].xscale =				[1,1,1,1];
global.PDSAnimations[ANIM.FSWALKUP].duration =				[8,8,8,8];

global.PDSAnimations[ANIM.FSWALKLEFT] = new PDSAnimation("FS-WalkLeft");
global.PDSAnimations[ANIM.FSWALKLEFT].framenumber =			[4,5,6,7];
global.PDSAnimations[ANIM.FSWALKLEFT].xscale =				[1,1,1,1];
global.PDSAnimations[ANIM.FSWALKLEFT].duration =			[8,8,8,8];

global.PDSAnimations[ANIM.FSWALKDOWN] = new PDSAnimation("FS-Walkdown");
global.PDSAnimations[ANIM.FSWALKDOWN].framenumber =			[0,1,2,3];
global.PDSAnimations[ANIM.FSWALKDOWN].xscale =				[1,1,1,1];
global.PDSAnimations[ANIM.FSWALKDOWN].duration =			[8,8,8,8];


//Verify Animations
PDSVerifyAnimations(global.PDSAnimations);



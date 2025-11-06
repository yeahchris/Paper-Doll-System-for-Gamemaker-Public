
///-------CREATE NEW SHEET TEMPLATE FOR THE PDS SYSTEM TO USE-----------//
AddPDSTemplate("FreeSprites",global.PDSAnimations,126,126,4,false);


///--------INITIALIZE PAPER DOLL SYSTEM, AND ASSIGN TEMPLATE------------//
pds = new PaperDollSystem("FreeSprites");


//Set initial sprite
pds.AddSpriteAtIndex(spr_Elm_Male_Base,SLOT.BODY);

//Set initial animation:
pds.SetAnimation(ANIM.FSWALKDOWN);


//Initialize Movement Variables
move_x = 0;
move_y = 0;
collidables=[];
move_speed = 2;


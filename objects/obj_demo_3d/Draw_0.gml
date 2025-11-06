//UPDATE SPRITES IF SELECTION HAS CHANGED

selected_hair = obj_selector.hairstyles[obj_selector.hair_selection];
selected_suit = obj_selector.suits[obj_selector.suit_selection];
selected_gloves = obj_selector.gloves[obj_selector.gloves_selection];
selected_sword = obj_selector.swords[obj_selector.sword_selection];

if (pds.GetSpriteAtIndex(SLOT.HAIR) != selected_hair){
	pds.AddSpriteAtIndex(selected_hair,SLOT.HAIR);
}


var _currentglove = pds.GetSpriteAtIndex(SLOT.GLOVES);
if (_currentglove != 0 && _currentglove != undefined && _currentglove != selected_gloves){
	pds.AddSpriteAtIndex(selected_gloves,SLOT.GLOVES);
}

var _currentsuit = pds.GetSpriteAtIndex(SLOT.SUIT);
if (_currentsuit != 0 && _currentsuit != undefined && _currentsuit != selected_suit){
	pds.AddSpriteAtIndex(selected_suit,SLOT.SUIT);
}

var _currentsword = pds.GetSpriteAtIndex(SLOT.SWORD);
if (_currentsword != 0 && _currentsword != undefined && _currentsword != selected_sword){
	pds.AddSpriteAtIndex(selected_sword,SLOT.SWORD);
}


//TELL THE PAPER DOLL SYSTEM TO ANIMATE AND DRAW ITSELF


pds.Animate()
pds.DrawSelfMatrix(x,y,0,90,0,0,image_xscale,image_yscale,image_yscale,image_angle,image_blend);
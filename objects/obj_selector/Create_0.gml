enum SLOT {
	BODY,
	HAIR,
	BOOTS,
	SHIRT,
	SUIT,
	GLOVES,
	HELMET,
	SHIELD,
	SWORD
}

if (room == room_demo) {
	obj = instance_create_layer(room_width/2,room_height/2,"Instances", obj_demo)
} else {
	obj = instance_create_layer(room_width/2,room_height/1.5,"Instances", obj_demo_3d)
}

selector = dbg_view("Paper Doll System",true,5,80,300,550);

dbg_section("Demo Character",true);

dbg_button("Toggle Helmet",function(){
	with (obj) {
			if (pds.GetSpriteAtIndex(SLOT.HELMET) == spr_Elm_Helmet){
				pds.ClearSpriteAtIndex(SLOT.HELMET);
			} else {
				pds.AddSpriteAtIndex(spr_Elm_Helmet,SLOT.HELMET);
			}
		}
	},
100,50);


dbg_button("Toggle Shield",function(){
	with (obj) {
			if (pds.GetSpriteAtIndex(SLOT.SHIELD) == spr_Elm_Shield){
				pds.ClearSpriteAtIndex(SLOT.SHIELD);
			} else {
				pds.AddSpriteAtIndex(spr_Elm_Shield,SLOT.SHIELD);
			}
		}
	},
100,50);

dbg_button("Toggle Boots",function(){
	with (obj) {
			if (pds.GetSpriteAtIndex(SLOT.BOOTS) == spr_Elm_Metal_Boots){
				pds.ClearSpriteAtIndex(SLOT.BOOTS);
			} else {
				pds.AddSpriteAtIndex(spr_Elm_Metal_Boots,SLOT.BOOTS);
			}
		}
	},
100,50);


dbg_button("Toggle Sword",function(){
	with (obj) {
			if (pds.GetSpriteAtIndex(SLOT.SWORD) == other.swords[other.sword_selection]){
				pds.ClearSpriteAtIndex(SLOT.SWORD);
			} else {
				pds.AddSpriteAtIndex(other.swords[other.sword_selection],SLOT.SWORD);
			}
		}
	},
100,50);


dbg_button("Toggle Gloves",function(){
	with (obj) {
			if (pds.GetSpriteAtIndex(SLOT.GLOVES) == other.gloves[other.gloves_selection]){
				pds.ClearSpriteAtIndex(SLOT.GLOVES);
			} else {
				pds.AddSpriteAtIndex(other.gloves[other.gloves_selection],SLOT.GLOVES);
			}
		}
	},
100,50);


dbg_button("Toggle Clothes",function(){
	with (obj) {
			if (pds.GetSpriteAtIndex(SLOT.SUIT) == other.suits[other.suit_selection]){
				pds.ClearSpriteAtIndex(SLOT.SUIT);
			} else {
				pds.AddSpriteAtIndex(other.suits[other.suit_selection],SLOT.SUIT);
			}
		}
	},
100,50);


enum GLOVES {
	LEATHER,
	IRON,
	COUNT
}


gloves[GLOVES.IRON] = spr_Elm_Gloves_1;
gloves[GLOVES.LEATHER] = spr_Elm_Gloves_2;

gloves_selection = irandom(GLOVES.IRON);
var _ref = ref_create(self.id,"gloves_selection");
dbg_drop_down(_ref,[GLOVES.IRON,GLOVES.LEATHER],["Gauntlets","Gloves"],"Gloves");

enum HAIR {
	SHORT,
	PARTED,
	SPIKY,
}

hairstyles[HAIR.SHORT]	 =	 spr_Elm_Male_Hair_01;
hairstyles[HAIR.PARTED]	 =	 spr_Elm_Male_Hair_02;
hairstyles[HAIR.SPIKY]	 =	 spr_Elm_Male_Hair_03;

hair_selection = irandom(HAIR.SPIKY);
var _ref2 = ref_create(self.id,"hair_selection");
dbg_drop_down(_ref2,[HAIR.SHORT,HAIR.PARTED,HAIR.SPIKY],["Short","Parted","Spiky"],"Hair");


enum SUIT {
	SHIRT,
	FARMER,
	ARMOR,
	COUNT
}

suits[SUIT.SHIRT]	 =	 spr_Elm_Shirt;
suits[SUIT.FARMER]	 =	 spr_Elm_Farmer_Suit;
suits[SUIT.ARMOR]	 =	 spr_Elm_Solid_Suit;

suit_selection = irandom(SUIT.ARMOR);
var _ref3 = ref_create(self.id,"suit_selection");
dbg_drop_down(_ref3,[SUIT.SHIRT,SUIT.FARMER,SUIT.ARMOR],["Shirt","Farmer","Armor"],"Clothes");




enum SWORD {
	IRON,
	STEEL,
	ICE,
	WIND,
	FIRE,
	COUNT	
}

swords[SWORD.IRON]	 =	spr_Elm_Sword_1;
swords[SWORD.STEEL]	 =	spr_Elm_Sword_5;
swords[SWORD.ICE]	 =	spr_Elm_Sword_2;
swords[SWORD.WIND]	 =	spr_Elm_Sword_4;
swords[SWORD.FIRE]	 =	spr_Elm_Sword_3;

sword_selection = irandom(SWORD.FIRE);
var _ref4 = ref_create(self.id,"sword_selection");
dbg_drop_down(
		_ref4,
		[SWORD.IRON,SWORD.STEEL,SWORD.ICE,SWORD.WIND,SWORD.FIRE],
		["Iron Sword","Steel Sword","Ice Sword","Wind Sword","FireSword"],
		"Sword"
	);
	
dbg_section("Effects",true);
dbg_button("Toggle Shake",function(){
with (obj) {
		if (pds.GetShake() == true){
			pds.SetShake(false);
		} else {
			pds.SetShake(true);
		}
	}
},
100,50);

shake_magnitude = 1;
var _ref5 = ref_create(self.id,"shake_magnitude")
dbg_slider(_ref5,0,3,"Shake Magnitude");

alpha = 1;
var _ref6 = ref_create(self.id,"alpha")
dbg_slider(_ref6,0,1,"Alpha");

scale = 1;
var _ref7 = ref_create(self.id,"scale")
dbg_slider(_ref7,-5,5,"Scale");

angle = 0;
var _ref8 = ref_create(self.id,"angle")
dbg_slider(_ref8,0,360,"Rotation");

# 🧍 Paper Doll System for GameMaker

**Paper Doll System for GameMaker** is... a paper doll system for GameMaker.

Using this system, animations are assembled entirely through code and are animated from **unsliced sprite sheets**.  There’s no need to manually assemble different animations using the sprite editor.

Assemble animations using any frame from any region of a sprite sheet, arbitrarily mirror frames, and specify a custom duration (in either milliseconds or game frames) for each animation frame — all with just a few lines of code.

The system integrates with (and includes) **Pixelated Pope’s RetroPaletteSwapper**, allowing arbitrary palette swaps of individual paper doll parts during runtime.

Sprite sheet templates can be created via a function call without editing any code. The system is (in theory) compatible with any grid-based sprite sheet that has a consistent layout.

The system is modular, and uses a **struct/method-based** approach.



The paper doll system will allow for the use of the following default drawing parameters as normal:\
- image_xscale\
- image_yscale\
- image_angle\
- image_blend\
- image_alpha

The following default drawing parameters have no effect on sprites drawn via the paper doll system:\
- image_index\
- image_speed



---

## 🧩 Core Functions

### `AddPDSTemplate()`

```gml
///@desc Adds a new sheet template that you can use for a paper doll system.
///@param _key {string} A one-word key for storing/retrieving the template. No spaces.
///@param _frame_width {real} Width (in pixels) of a single frame on the sprite sheet.
///@param _frame_height {real} Height (in pixels) of a single frame on the sprite sheet.
///@param _sheet_width {real} Number of frames per row on the sprite sheet.
///@param _uses_milliseconds {boolean} Whether to use milliseconds or game frames for durations.
function AddPDSTemplate(_key, _frame_width, _frame_height, _sheet_width, _uses_milliseconds)
```

---

### `PaperDollSystem()` Constructor

```gml
///@desc Returns a new Paper Doll System.
///@param {string} _template_key The sheet template key to use.
function PaperDollSystem(_template_key) constructor
```

---

### `PDSAnimation()` Constructor

```gml
///@desc Returns a blank animation struct.
function PDSAnimation(_name) constructor
```

---

## ⚙️ Paper Doll System Methods

### `.AddSprite()`

```gml
///@desc Adds a sprite at the next available index.
///@param _sprite {asset} The sprite asset to add.
static AddSprite = function(_sprite)
```

---

### `.RemoveSprite()`

```gml
///@desc Removes the first instance of a given sprite and deletes its index.
///@param _sprite {asset} The sprite to remove.
static RemoveSprite = function(_sprite)
```

---

### `.AddSpriteAtIndex()`

```gml
///@desc Adds a sprite at a specific index.
///@param _sprite {asset} The sprite to add.
///@param _index {real} The index to add it at.
static AddSpriteAtIndex = function(_sprite, _index)
```

---

### `.ClearSpriteAtIndex()`

```gml
///@desc Clears the sprite at a given index without deleting the index.
///@param _index {real} The index to clear.
static ClearSpriteAtIndex = function(_index)
```

---

### `.ContainsSprite()`

```gml
///@desc Returns true if the specified sprite is already in use.
///@param _sprite {asset} The sprite to check.
static ContainsSprite = function(_sprite)
```

---

### `.SetAnimation()`

```gml
///@desc Sets the current animation by enumerator/index.
///@param _animation {real} The animation index.
static SetAnimation = function(_animation)
```

---

### `.DrawSelf()`

```gml
///@desc Draws the paper doll system at the instance's x/y using default draw parameters.
static DrawSelf = function()
```

---

### `.DrawSelfExt()`

```gml
///@desc Draws the paper doll system with custom draw parameters.
///@param _x {real} X position.
///@param _y {real} Y position.
///@param _xscale {real} X scale.
///@param _yscale {real} Y scale.
///@param _color {Constant.Colour} Blend color (use c_white for normal).
///@param _alpha {real} Alpha transparency (0–1).
static DrawSelfExt = function(_x, _y, _xscale, _yscale, _color, _alpha)
```

---

### `.SetPaletteSwap()`

```gml
///@desc Sets up a runtime palette swap for a given sprite.
///@param _sprite {asset} The target sprite.
///@param _palette_sprite {asset} The palette sprite to use.
///@param _index {real} Pixel offset into the palette sprite.
static SetPaletteSwap = function(_sprite, _palette_sprite, _index)
```

---

### `.Animate()`

```gml
///@desc Advances the animation frame counter.
static Animate = function()
```

---

### `.AnimationEnd()`

```gml
///@desc Returns true if the current animation has more than one frame and has just finished.
static AnimationEnd = function()
```

---

### `.GetCurrentFrame()`

```gml
///@desc Returns the frame index of the current animation.
static GetAnimationFrame = function()
```

---

### `.SetCurrentFrame()`

```gml
///@desc Sets the current animation frame.
///@param _frame {real} Frame index to set.
static SetCurrentFrame = function(_frame)
```

---

## 🧠 Example Usage

### Game Start

```gml
//Set up a sheet template
AddPDSTemplate("MyTemplate", 64, 64, 16, true);

//Define an animation
enum ANIM {
    WALKRIGHT
}

global.PDSAnimations[ANIM.WALKRIGHT] = new PDSAnimation("Walk Right");
global.PDSAnimations[ANIM.WALKRIGHT].framenumber = [64,65,66,67,68,69];
global.PDSAnimations[ANIM.WALKRIGHT].xscale = [1,1,1,1,1,1];
global.PDSAnimations[ANIM.WALKRIGHT].duration = [135,135,135,135,135,135];

//Prepare Palette Swap Enum
enum HAIRCOLOR {
    DEFAULT,
    BLUE
}
```

---

### CREATE AN OBJECT
### ASSIGN A DUMMY SPRITE TO THE OBJECT.
### SPRITE SHOULD BE SAME SIZE AS A TEMPLATE GRID SQUARE
### USE SPRITE TO SET COLLISION MASK & ORIGIN

### Object Create Event


```gml
//Instantiate a paper doll system for this object.
pds = new PaperDollSystem("MyTemplate");

//Add sprites for the paper doll system to draw
pds.AddSprite(spr_body);
pds.AddSprite(spr_pants);
pds.AddSprite(spr_shirt);
pds.AddSprite(spr_hair);

//Palette Swap the hair
pds.SetPaletteSwap(spr_hair, spr_hair_palette, HAIRCOLOR.BLUE)

//Set initial animation
pds.SetAnimation(ANIM.WALKRIGHT);
```

---

### Object Draw Event

```gml
pds.DrawSelf();
pds.Animate();
```

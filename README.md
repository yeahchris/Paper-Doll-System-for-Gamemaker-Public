# 🧍 Paper Doll System for GameMaker

**Paper Doll System for GameMaker** is... a paper doll system for GameMaker.

Using this system, animations can assembled entirely through code and are animated from **unsliced sprite sheets**.

Assemble animations using any frame from any region of a sprite sheet, arbitrarily mirror frames, and specify a custom duration (in either milliseconds or game frames) for each animation frame — all with just a few lines of code.

Sprite sheet templates can be created via a function call without editing any code. The system is (in theory) compatible with any grid-based sprite sheet that has a consistent layout for its animations.

The system integrates with (and is bundled with) **Pixelated Pope’s RetroPaletteSwapper**, allowing arbitrary palette swaps of individual paper doll parts.

There is a demo project included in the repository, but it uses free assets of very poor quality and overall does a poor job of showing off the system's capabilities. Here is a video demo which uses paid assets:



[![Paper Doll System Demo](https://img.youtube.com/vi/FxvSRFjp75o/0.jpg)](https://www.youtube.com/watch?v=FxvSRFjp75o), 





The paper doll system will honor the following default drawing parameters as normal:
- image_xscale
- image_yscale
- image_angle
- image_blend
- image_alpha

The following default drawing parameters have no effect on sprites drawn via the paper doll system:
- image_index
- image_speed





# Bitmap Font Compiler

The Bitmap Font compiler is used to create a .font file that is a simple binary storage of bitmap fonts. These font files are useful in games where drawing a bitmap font is wanted at the per pixel level.

## Instructions
The compiler requires two files, a fontmap.json file and a font.bmp file. The fontmap.json must be in this format:

```json
[
	{ "letter": "1", "width": 7, "height": 8, "row": 1 },
    { "letter": "2", "width": 7, "height": 8, "row": 1 }
]
```

The letters must be in the order they appear in the font.bmp file. You can have more than one row and the width and height must be the exact size of the letter in the font.bmp file.

The font.bmp file must be created exactly in this way:
* The first character must start exactly at pixel 0,0
* Each character on a row must be seperated by 1 pixel to the right and to the bottom.
* Each character can have unique widths and heights but make sure that the next row is 1 pixel below the tallest character.
* Must be exported as a 24bit bmp with no encoding. Most bitmap programs can write to this format or do so by default.

## Building from Source
* Requires >= [Haxe 4.1.2](https://haxe.org/download).
* Requires the haxelib bmpfont to be installed.
  * From haxelib: `haxelib install bmpformat`
  * From github `haxelib git bmpformat https://github.com/sgalland/bmpfont.git`

To compile run `haxe build.hxml`
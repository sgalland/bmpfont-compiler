import haxe.Json;
import haxe.io.Bytes;
import format.bmp.Tools;
import format.bmp.Reader;
import format.bmp.Data;
import sys.io.File;
import bmpfont.Data.Font;
import ErrorHandler.logWithFailure;

/**
	Reads the font data from the bitmap image.
**/
class FontReader {
	public function new() {}

	/**
		Reads the pixel data from the bitmap file.
		@return Array<Font>
	**/
	public function read(bmpFile:String):Array<Font> {
		var handle = File.read(bmpFile, true);
		var bmpData:Data = new Reader(handle).read();
		handle.close();

		var argbData = Tools.extractARGB(bmpData);
		var fontMapData = File.getContent("fontmap.json");
		var fonts:Array<Font> = Json.parse(fontMapData);

		var currentItem:Font = {};
		var previousItem:Font;
		var index:Int = 0;
		var ARGB_ELEMENTS = 4;
		var captureSymbolData = function(symbol:Font):Bytes {
			var data:Bytes = Bytes.alloc(symbol.width * symbol.height);

			// Stash the currentItem
			previousItem = currentItem;
			currentItem = symbol;

			// Reset the index on row change
			if (previousItem != null && previousItem.row != currentItem.row)
				index = 0;

			var startHeight:Int = symbol.row * (previousItem == null ? 0 : previousItem.height);
			var endHeight:Int = startHeight + symbol.height;

			var startWidth:Int = index * (previousItem == null ? 0 : previousItem.width);
			var endWidth:Int = startWidth + symbol.width;

			for (y in startHeight...endHeight) {
				for (x in startWidth...endWidth) {
					// For each pixel we have to read four components.
					var ploc = (x + (y * bmpData.header.width)) * ARGB_ELEMENTS;

					var a = argbData.get(ploc);
					var r = argbData.get(ploc + 1);
					var g = argbData.get(ploc + 2);
					var b = argbData.get(ploc + 3);

					// If we have a color component insert it
					// into the data set.
					var dataLoc:Int = x + y * currentItem.width;
					if (r != 0 || g != 0 || b != 0) {
						data.set(dataLoc, 1);
						// trace('$ploc: 1');
					} else { // TODO: Is this even necessary to set it to 0??
						data.set(dataLoc, 0);
						// trace('$ploc: 0');
					}
				}
			}

			return data;
		}

		for (font in fonts) {
			font.data = captureSymbolData(font);
			index++;
		}

		return fonts;
	}
}

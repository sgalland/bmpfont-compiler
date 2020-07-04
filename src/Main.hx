import bmpfont.Data.Font;
import haxe.Exception;
import bmpfont.Writer;
import sys.FileSystem.exists;
import ErrorHandler.logWithFailure;

class Main {
	static final FONT_MAP_NAME:String = "fontmap.json";
	static final FONT_FILE_NAME:String = "font.bmp";
	static final FONT_OUTPUT_DEFAULT_NAME:String = "font.fnt";

	static function main() {
		Console.log('<b>Bitmap Font Compiler</>');
		Console.log('https://github.com/sgalland/bmpfont-compiler');

		Console.print('\n');
		Console.log('See github for how to use instructions.');

		var args:Array<String> = Sys.args();
		var outputFileName:String = FONT_OUTPUT_DEFAULT_NAME;

		for (arg in args) {
			switch (arg.substring(0, 1)) {
				case "-o":
					outputFileName = arg.substr(2);
				default:
					logWithFailure('Invalid argument "$arg" was provided');
			}
		}

		if (!exists(FONT_MAP_NAME))
			logWithFailure('File $FONT_MAP_NAME could not be found.');

		if (!exists(FONT_FILE_NAME))
			logWithFailure('File $FONT_FILE_NAME could not be found.');

		var reader = new FontReader();
		var fonts:Array<Font> = reader.read(FONT_FILE_NAME);

		try {
			var writer = new Writer();
			writer.write(outputFileName, fonts);
		} catch (e:Exception) {
			logWithFailure(e.message);
		}

		Console.log("<green>Finished</>");
	}
}

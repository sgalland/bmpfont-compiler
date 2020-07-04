import Sys.exit;

class ErrorHandler {
	public static function logWithFailure(error:String) {
		Console.error(error);
		exit(0);
	}
}

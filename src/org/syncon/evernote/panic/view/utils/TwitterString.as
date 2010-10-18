package  org.syncon.evernote.panic.view.utils {
 
	/**
	 * The TwitterString class assists with the parsing of a tweet to add hyperlinks 
	 * around Links, HashTags, and UserNames in a tweet.
	 * @author Joseph Labrecque
	 * v. 0.1.2
	 */ 
 
	public final class TwitterString {
		private static var _instance:TwitterString = new TwitterString();
 
		public function TwitterString(){
			if (_instance != null){
				throw new Error("TwitterString can only be accessed through TwitterString.instance");
			}
		}
 
		public static function get instance():TwitterString {
			return _instance;
		}
 
		public function parseTweet(t:String):String {
			var step1:String = parseHyperlinks(t);
			step1 = parseHyperlinks1(step1);
			var step2:String = parseUsernames(step1)
			var step3:String = parseHashtags(step2)
			return step3;
		}
 
		private function parseHyperlinks1(t:String):String {
			var urlPattern:RegExp = new RegExp("&lt;", "g")
			var result:String = t.replace(urlPattern, "<");
	/*		  urlPattern = new RegExp("&gt;", "g")
				 for each ( var i : int =0; i < patterns.length; i++) in ['&gt;', '&amp;'] )
				 {
					  result = result.replace(urlPattern, ">");			
				 }*/
			return result;
		}
		
		private function parseUsernames(t:String):String {
			var result:String = t.replace(/(^|\s)#(\w+)/g, "$1#<a href='http://search.twitter.com/search?q=$2' target='_blank'>$2</a>");
			return result;
		}
 
		private function parseHashtags(t:String):String {
			var result:String = t.replace(/(^|\s)@(\w+)/g, "$1@<a href='http://www.twitter.com/$2' target='_blank'>$2</a>");
			return result;
		}
 
		private function parseHyperlinks(t:String):String {
			var urlPattern:RegExp = new RegExp("(((f|ht){1}tp://)[-a-zA-Z0-9@:%_\+.~#?&//=]+)", "g")
			var result:String = t.replace(urlPattern, "<a href='$1' target='_blank'>$1</a>");
			return result;
		}
 
	}
}
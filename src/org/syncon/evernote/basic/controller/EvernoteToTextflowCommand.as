package  org.syncon.evernote.basic.controller
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Command;
	/**
	 * */
	public class EvernoteToTextflowCommand extends Command
	{
		//[Inject] public var apiModel:EvernoteAPIModel;
		[Inject] public var event:EvernoteToTextflowCommandTriggerEvent;
		 public var txt :  String = '' 
		override public function execute():void
		{
			if ( event.type == EvernoteToTextflowCommandTriggerEvent.IMPORT ) 
				this.importEvernoteXML()
			else
				this.exportTextflow()  
		}
		
		public function importEvernoteXML()  : void
		{
			this.txt = event.txt
			this.replaceObvious()
			this.replaceColorNames();
	/*		
			var xml:XML = new XML(this.txt);
			//private function parse():void {
				for each (var t:XML in xml.children()) {
					trace("tag name: "+t.name()+" tag content "+t.text());
				}
			//}
*/
			
			var result : String = this.txt;
			
			event.fxResult( result ) 
				
		}
		
		public function exportTextflow()  : void
		{
			var result : String = '';
			event.fxResult( result ) 			
		}
				
		private function replace(original : String, find :  String, replace : String ) :  String
		{
			var pattern:RegExp =  new RegExp( find,  'gi' );
			return original.replace( pattern, replace ) 
		}
		
		private var preamble1 : String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
		private var preamble2 : String = '<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml.dtd">'
		private var enNoteOpen : String = '<en-note>'
		private var enNoteClose : String = '</en-note>'
		private var clearedBrakents : String = '<br clear="none"/>'	
		private var preamble3 : String = '<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">'
		private function replaceObvious() : void
		{
			var find : Array =  [preamble1,preamble2,preamble3,enNoteOpen,enNoteClose,clearedBrakents]; 
			this.txt = this.txt.replace( '<?xml version="1.0" encoding="UTF-8"?>', '' )
			var replace : Array = ['','','','','', '<br />']; 
			for  ( var i : int = 0; i < replace.length; i++ )
			{
				//find[i] = this.replace( find[i], '"', '\\"' )
				this.txt = this.replace( this.txt,  find[i], replace[i] )
			}
		}
		
		public function replaceColorNames(vgaToHex:Boolean=true) : void
		{
			var prefix : String = 'color: '
			var names : Array = ["AliceBlue","AntiqueWhite","Aqua","Aquamarine","Azure","Beige","Bisque","Black","BlanchedAlmond","Blue","BlueViolet","Brown","BurlyWood","CadetBlue","Chartreuse","Chocolate","Coral","CornflowerBlue","Cornsilk","Crimson","Cyan","DarkBlue","DarkCyan","DarkGoldenRod","DarkGray","DarkGreen","DarkKhaki","DarkMagenta","DarkOliveGreen","Darkorange","DarkOrchid","DarkRed","DarkSalmon","DarkSeaGreen","DarkSlateBlue","DarkSlateGray","DarkTurquoise","DarkViolet","DeepPink","DeepSkyBlue","DimGray","DodgerBlue","FireBrick","FloralWhite","ForestGreen","Fuchsia","Gainsboro","GhostWhite","Gold","GoldenRod","Gray","Green","GreenYellow","HoneyDew","HotPink","IndianRed","Indigo","Ivory","Khaki","Lavender","LavenderBlush","LawnGreen","LemonChiffon","LightBlue","LightCoral","LightCyan","LightGoldenRodYellow","LightGrey","LightGreen","LightPink","LightSalmon","LightSeaGreen","LightSkyBlue","LightSlateGray","LightSteelBlue","LightYellow","Lime","LimeGreen","Linen","Magenta","Maroon","MediumAquaMarine","MediumBlue","MediumOrchid","MediumPurple","MediumSeaGreen","MediumSlateBlue","MediumSpringGreen","MediumTurquoise","MediumVioletRed","MidnightBlue","MintCream","MistyRose","Moccasin","NavajoWhite","Navy","OldLace","Olive","OliveDrab","Orange","OrangeRed","Orchid","PaleGoldenRod","PaleGreen","PaleTurquoise","PaleVioletRed","PapayaWhip","PeachPuff","Peru","Pink","Plum","PowderBlue","Purple","Red","RosyBrown","RoyalBlue","SaddleBrown","Salmon","SandyBrown","SeaGreen","SeaShell","Sienna","Silver","SkyBlue","SlateBlue","SlateGray","Snow","SpringGreen","SteelBlue","Tan","Teal","Thistle","Tomato","Turquoise","Violet","Wheat","White","WhiteSmoke","Yellow","YellowGreen"]
			var hex : Array = ["#F0F8FF","#FAEBD7","#00FFFF","#7FFFD4","#F0FFFF","#F5F5DC","#FFE4C4","#000000","#FFEBCD","#0000FF","#8A2BE2","#A52A2A","#DEB887","#5F9EA0","#7FFF00","#D2691E","#FF7F50","#6495ED","#FFF8DC","#DC143C","#00FFFF","#00008B","#008B8B","#B8860B","#A9A9A9","#006400","#BDB76B","#8B008B","#556B2F","#FF8C00","#9932CC","#8B0000","#E9967A","#8FBC8F","#483D8B","#2F4F4F","#00CED1","#9400D3","#FF1493","#00BFFF","#696969","#1E90FF","#B22222","#FFFAF0","#228B22","#FF00FF","#DCDCDC","#F8F8FF","#FFD700","#DAA520","#808080","#008000","#ADFF2F","#F0FFF0","#FF69B4","#CD5C5C","#4B0082","#FFFFF0","#F0E68C","#E6E6FA","#FFF0F5","#7CFC00","#FFFACD","#ADD8E6","#F08080","#E0FFFF","#FAFAD2","#D3D3D3","#90EE90","#FFB6C1","#FFA07A","#20B2AA","#87CEFA","#778899","#B0C4DE","#FFFFE0","#00FF00","#32CD32","#FAF0E6","#FF00FF","#800000","#66CDAA","#0000CD","#BA55D3","#9370D8","#3CB371","#7B68EE","#00FA9A","#48D1CC","#C71585","#191970","#F5FFFA","#FFE4E1","#FFE4B5","#FFDEAD","#000080","#FDF5E6","#808000","#6B8E23","#FFA500","#FF4500","#DA70D6","#EEE8AA","#98FB98","#AFEEEE","#D87093","#FFEFD5","#FFDAB9","#CD853F","#FFC0CB","#DDA0DD","#B0E0E6","#800080","#FF0000","#BC8F8F","#4169E1","#8B4513","#FA8072","#F4A460","#2E8B57","#FFF5EE","#A0522D","#C0C0C0","#87CEEB","#6A5ACD","#708090","#FFFAFA","#00FF7F","#4682B4","#D2B48C","#008080","#D8BFD8","#FF6347","#40E0D0","#EE82EE","#F5DEB3","#FFFFFF","#F5F5F5","#FFFF00","#9ACD32"];
			if ( vgaToHex ) 
			{
				for  ( var i : int = 0; i < names.length; i++ )
				{
					if ( this.txt.indexOf( prefix+names[i].toString().toLowerCase() ) != -1 ) 
						this.txt = this.replace( this.txt, prefix+names[i], prefix+hex[i] )
				}
			}
		}
		
	}
}
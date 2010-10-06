package  org.syncon.evernote.panic.view
{
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.TextFlow;

	public class HtmlConvertor 
	{
		public function HtmlConvertor()
		{ 
		} 
		 
		public function convert ( txt : String )  :  TextFlow
		{
			return TextConverter.importToFlow(txt, TextConverter.TEXT_FIELD_HTML_FORMAT)
		}
		
		public function export ( textFlow : TextFlow )  :   Object
		{
			 
			return  TextConverter.export( textFlow,
				TextConverter.TEXT_LAYOUT_FORMAT,
				ConversionType.STRING_TYPE).toString()
		}		
		
		public function importHtml( e :   String )  : TextFlow
		{
			return null 
		}
		/**
		 * Takes either plain text
		 * div 
		 * or textflow and returns a text flow
		 * */
		public function convert2 ( txt : String, color : uint, fontSize : Number =12)  :  TextFlow
		{
			if ( txt.toLowerCase().indexOf( '<TextFlow'.toLowerCase()) == 0 )
				return convert( txt ) 
			if ( txt.toLowerCase().indexOf( '<div'.toLowerCase() ) == 0 )
				return importHtml( txt )
				
			var xml: String = '<TextFlow fontFamily="ACaslonProRegularEmbedded"'+
		'fontLookup="embeddedCFF" color="'+uint+'" fontSize="'+fontSize+'" renderingMode="cff" '+
		'whiteSpaceCollapse="preserve" xmlns="http://ns.adobe.com/textLayout/2008">'+
		'<p   fontFamily="ACaslonProRegularEmbedded"  >'+
		'<span>'+txt+'</span>'+
		'</p></TextFlow>';
			
			var textFlow: TextFlow = new TextFlow();
			textFlow = TextConverter.importToFlow(xml, TextConverter.TEXT_LAYOUT_FORMAT);			
			return  textFlow
		}
				
		
	}
}
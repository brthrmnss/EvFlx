package  org.syncon.evernote.panic.view
{
	import flash.text.engine.FontLookup;
	import flash.text.engine.RenderingMode;
	
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.FlowElement;
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
		public function convertTLF ( txt : String,color : uint, fontSize : Number =12 )  :  TextFlow
		{
			var tlf : TextFlow =  TextConverter.importToFlow(txt, TextConverter.TEXT_LAYOUT_FORMAT)
			replaceFonts( tlf, color, fontSize ) 
			
			return tlf
		}		
		
		public function replaceFonts( textFlow: TextFlow , defaultColor : uint, size : int )  : void
		{
			if ( textFlow == null ) 
				return;
			var ee : FlowElement
			textFlow.fontLookup = FontLookup.EMBEDDED_CFF;
			textFlow.renderingMode = RenderingMode.CFF;
			textFlow.fontFamily = 'ACaslonProRegularEmbedded'
			if ( textFlow.textAlign == null ) textFlow.textAlign = 'center' 
			textFlow.mxmlChildren[0].fontFamily = 'ACaslonProRegularEmbedded'
			if ( textFlow.color == null ) { textFlow.color = defaultColor}
			if ( textFlow.fontSize == null ) { textFlow.fontSize = size}		
			
			for each ( var c : Object in textFlow.mxmlChildren ) 
			{
				c.fontFamily =  'ACaslonProRegularEmbedded'
				c.fontWeight =  'normal'
					
				//if ( c.color == null ) { c.color = defaultColor}	
				for each ( var c2 : Object in c.mxmlChildren ) 
				{
					var dee :  FlowElement
					if ( c2 is FlowElement == false ) 
						continue; 
					c2.fontFamily =  'ACaslonProRegularEmbedded'
					c2.fontWeight =  'normal'	
					//if ( c2.color == null ) { c2.color = defaultColor}	
					if ( c2.hasOwnProperty('mxmlChildren' ) == false ) continue; 
					for each ( var c3 : Object in c2.mxmlChildren ) 
					{
						if ( c3 is FlowElement == false ) 
							continue; 							
						c3.fontFamily =  'ACaslonProRegularEmbedded'
						c3.fontWeight =  'normal'		
						//if ( c3.color == null ) { c3.color = defaultColor}	
					}
				}
			}
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
				return convertTLF( txt, color ,  fontSize  ) 
			if ( txt.toLowerCase().indexOf( '<div'.toLowerCase() ) == 0 )
				return importHtml( txt )
			//return importHtml( txt )	
			var xml: String = '<TextFlow fontFamily="ACaslonProRegularEmbedded"'+
		'fontLookup="embeddedCFF"' + ' textAlign="center" ' + 
		' color="'+uint+'" fontSize="'+fontSize+'" renderingMode="cff" '+
		'whiteSpaceCollapse="preserve" xmlns="http://ns.adobe.com/textLayout/2008">'+
		'<p   fontFamily="ACaslonProRegularEmbedded"  >'+
		txt+//'<span>'+txt+'</span>'+
		'</p></TextFlow>';
			
			var textFlow: TextFlow = new TextFlow();
			textFlow = TextConverter.importToFlow(xml, TextConverter.TEXT_LAYOUT_FORMAT);			
			this.replaceFonts( textFlow, color, fontSize )
			return  textFlow
		}
				
		
	}
}
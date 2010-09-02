package  org.syncon.evernote.basic.controller
{
	import flash.events.Event;
	
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;

	/**
	 * */
	public class EvernoteToTextflowCommand_Base 
	{
		//[Inject] public var apiModel:EvernoteAPIModel;
		[Inject] public var event:EvernoteToTextflowCommandTriggerEvent;
		 public var txt :  String = '' 
			 
		public var tf : TextFlow ;//
		
		public var holders : Array = []; 
		  public function execute():void
		{
			if ( event.type == EvernoteToTextflowCommandTriggerEvent.IMPORT ) 
				this.importEvernoteXML()
			else
				this.exportTextflow()  
		}
		
		public function importEvernoteXML()  :  String
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
			this.postProcessStr()
			var result : String = this.txt;
			this.tf = importPt2( this.txt ) 
			if ( event.fxResult != null ) event.fxResult( this.tf, this.holders ) 
				
			return result 
		}
		
		public function exportTextflow()  :  String
		{
			this.txt  = event.txt
			
			this.exportReplaceObvious()
				
				
			//convert to xml, replac spans with things
			this.removeSoftLinks()
				
			this.export_PackageForSending();
			//this.txt = this.event.txt;
			var result : String = this.txt
			if ( event.fxResult != null ) event.fxResult( result ); 			
			return this.txt 
		}
			/**
			 * 
			 * */
			private function removeSoftLinks()  : void
			{
				var ee :   RteHtmlParser_Export = new RteHtmlParser_Export()
				ee.ignoreParagraphSpace = true; 
				//ee.ParseToRTE(this.txt)
				ee.ParseToHTML(this.txt)
				var bim : Object = ee.XMLObject
				this.txt = ee.XMLFormat;
				//this.exportReplaceSoftLists(); 
			}
		
	/*			
		public function postProcessStr() : void
		{
			var ee :  RteHtmlParser = new RteHtmlParser()
			ee.ignoreParagraphSpace = true; 
			ee.ParseToRTE(this.txt)
			ee.ParseToHTML( "<div>"+ee.StringFormat+"</div>" ) ; 
			//var ee : TextConverter
			//this.rtEvernoteToTfRendering.textFlow = TextFlowUtil.importFromString(e );
			var tf :  XML = new XML("<TextFlow  xmlns=\"http://ns.adobe.com/textLayout/2008\"><div id=\"thing\">sdf"+"</div><li></li></TextFlow>" )
			var x :  XMLList = ee.XMLObject.elements('ol')
			x  = ee.XMLObject.f.child("ol")
			
			// tf.appendChild(new XML("<div id=\"thing2\">sdf"+"</div>" ))
			var xl : Object = tf.children()[0]
			var xl2 : Object = tf.div[0]
			tf.children().
			tf.appendChild( ee.XMLObject.div )
			
			//	var ooo : Object = x.toXMLString()
			appendList( x[0], tf.children()[0], false );
			
			this.txt = tf.toXMLString()
		}
		*/
		
		public function postProcessStr() : void
		{
		var ee : RteHtmlParser_Import = new RteHtmlParser_Import()
		ee.ignoreParagraphSpace = true; 
		 
		ee.ParseToRTE(this.txt)
	 
		/*
		ee.ParseToHTML( "<div>"+ee.StringFormat+"</div>" ) ; 
		//var ee : TextConverter
		//this.rtEvernoteToTfRendering.textFlow = TextFlowUtil.importFromString(e );
		var tf :  XML = new XML("<TextFlow  xmlns=\"http://ns.adobe.com/textLayout/2008\"> </TextFlow>" )
		var x :  XMLList = ee.XMLObject.elements('ol')
		x  = ee.XMLObject.f.child("ol")
		
		// tf.appendChild(new XML("<div id=\"thing2\">sdf"+"</div>" ))
		var xl : Object = tf.children()[0]
		var xl2 : Object = tf.div[0]
		var children :   XMLList = ee.XMLObject.div.children()
		//tf.children().
		//tf.appendChild( ee.XMLObject.div )
		var tfRoot : XML = tf; //.children()[0]
		for ( var i : int = 0; i < children.length(); i++ )
		{
			var xml_ : XML = children[i]
			if (  xml_.name() == 'ol' )
			{
				var list : XML = new XML('<div/>')
				appendList( xml_, list , false );
				tfRoot.appendChild(  list )
				//x.insertChildAfter(
			}
			else
			{
				//convert tag
				///<span style="color: #008000;">s the</span>
				//if syle set ... convert it ...
				tfRoot.appendChild( xml_ )
			}

		}*/
		 var xx : Object = ee.XMLObject
		var tf :  XML = new XML("<TextFlow  xmlns=\"http://ns.adobe.com/textLayout/2008\"> </TextFlow>" )
		/*var tf :  XML = new XML(
		'<TextFlow columnCount="inherit" columnGap="inherit" columnWidth="inherit" lineBreak="inherit" paddingBottom="inherit" paddingLeft="inherit" paddingRight="inherit" paddingTop="inherit" verticalAlign="inherit" whiteSpaceCollapse="preserve" xmlns="http://ns.adobe.com/textLayout/2008"><p lineHeight="180%"><span color="#9d9fa2" fontSize="15">dddf</span></p></TextFlow>'
		)*/
		for each ( var xml_ :  XML in  ee.XMLObject.children()  )
		{
			tf.appendChild( xml_ )
		}	
		XML.prettyIndent = 0
		XML.prettyPrinting = false
		this.txt = tf.toXMLString()
		
		this.txt = replace( this.txt,  '•', '             •       ' ) 
	//	this.txt = replace( this.txt,  '>\s<', '' ) 
		}
		
		
		private static function appendList(htmlListNode:XML, tlfXml:XML, isOrdered:Boolean):void {
			//used for ordered lists
			var count:int = 1;
			var listEl : String = isOrdered ? "ol" : "ul";
			
			//get the li tags
			for each (var child:XML in htmlListNode.*) {
				var lineItemXml:XML;
				var listItemContent:String = child.children().toXMLString();
				// Ensure content for list item
				if (listItemContent.length == 0) continue;  
				
				listItemContent = listItemContent.toLowerCase();                        
				listItemContent = listItemContent.replace("<strong>","<span fontWeight='bold'>");
				listItemContent = listItemContent.replace("</strong>","</span>");
				
				if (listItemContent.indexOf("<ul>") > -1) {
					
					var preNestedListText:String = listItemContent.substring(0,listItemContent.indexOf(listEl));
					var nestedList:String = listItemContent.substring(listItemContent.indexOf(listEl), listItemContent.length);
					var nestedListXml:XML = new XML(nestedList);
					
					if(preNestedListText.length > 0) {
						if(isOrdered) {
							tlfXml.appendChild(new XML("<p listitem='true' " +
								"paragraphStartIndent='15' textIndent='-9' paragraphSpaceAfter='10'" +
								"format='list_item'>" + count + ". " + listItemContent +"</p>"));
						} else {
							tlfXml.appendChild(new XML("<p listitem='true' " +
								"paragraphStartIndent='15' textIndent='-9' paragraphSpaceAfter='10'" +
								"format='list_item'>\u2022 " + listItemContent + "</p>"));
						}
					}                                              
					appendList(nestedListXml, tlfXml, false);                   
				} else {
					if(isOrdered) {
						tlfXml.appendChild(new XML(
							"<p listitem='true' " +
							"paragraphStartIndent='15' textIndent='-9' paragraphSpaceAfter='10'" +
							" >" + count + ". " + listItemContent +"</p>"));
					} else {
						//tlfXml.appendChild(new XML("<p>\u2022 ddddddddddddddddddddddddddddddddddddddddddddddddddddd" + listItemContent + "</p>"));
						//tlfXml.appendChild(new XML("\u2022 ddddddddddddddddddddddddddddddddddddddddddddddddddddd" + listItemContent + ""));
						tlfXml.appendChild(new XML("<p  listitem='true'  paragraphStartIndent='15' textIndent='-9' paragraphSpaceAfter='10'  >\u2022 " + listItemContent + "</p>"));
						
						/* tlfXml.appendChild(new XML("<p listitem='true' " +
						"paragraphStartIndent='15' textIndent='-9' paragraphSpaceAfter='10'" +
						">\u2022 ddddddddddddddddddddddddddddddddddddddddddddddddddddd" + listItemContent + "</p>")); */
					}
					count++;
				}
			}    
		}  		
		
		//<HTML><BODY><P ALIGN="left"><FONT FACE="Arial" SIZE="12" COLOR="#000000" LETTERSPACING="0" KERNING="1">Here's theEvernote logo:</FONT></P><P ALIGN="left"><FONT FACE="Arial" SIZE="12" COLOR="#000000" LETTERSPACING="0" KERNING="1">touch</FONT></P><P ALIGN="left"><FONT FACE="Arial" SIZE="12" COLOR="#000000" LETTERSPACING="0" KERNING="1">dfsddfdddgsdfsdfsdf</FONT></P><P ALIGN="left"><FONT FACE="Arial" SIZE="12" COLOR="#000000" LETTERSPACING="0" KERNING="1"></FONT></P><P ALIGN="left"><FONT FACE="Arial" SIZE="12" COLOR="#000000" LETTERSPACING="0" KERNING="1">sdfasdfsdfsdf</FONT></P><P ALIGN="left"><FONT FACE="Arial" SIZE="12" COLOR="#000000" LETTERSPACING="0" KERNING="1"></FONT></P></BODY></HTML>
		private var bodyStart : String = "<HTML><BODY>"
		private var bodyClose : String = "</BODY></HTML>"			
		private var kerning1 : String = ' LETTERSPACING="0" KERNING="1"'
		private var kerning2 : String = ' LETTERSPACING="0" KERNING="0"'
		private var fontFace : String = 'FACE="Arial"'
		private var namespace : String = 'xmlns="http://ns.adobe.com/textLayout/2008"'; 
		private var txtflow : String = 'TextFlow'	
			/*
		private var preamble3 : String = '<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">'
	*/
		private function exportReplaceObvious() : void
		{
			var find : Array =  [bodyStart,bodyClose,kerning1,
				kerning2,fontFace,txtflow, namespace]; 
			//this.txt = this.txt.replace( '<?xml version="1.0" encoding="UTF-8"?>', '' )
			var replace : Array = ['','','','','', 'div', '']; 
			for  ( var i : int = 0; i < replace.length; i++ )
			{
				//find[i] = this.replace( find[i], '"', '\\"' )
				this.txt = this.replace( this.txt,  find[i], replace[i] )
			}
			
			//replace spans without colors
			//use the setp through parse to remove unneded spans 
			this.txt = this.replace( this.txt, '<span>', '<span color="#000000" >' ) ; 
		}
				
		private function export_PackageForSending() : void
		{
			this.txt = preamble1 +preamble3 + enNoteOpen + this.txt + enNoteClose
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
		
 	
		/**
		 * Take string and exports text flow string
		 * */
		static public function Import( txt : String )  :  String
		{
			var cmd : EvernoteToTextflowCommand_Base = 
				new EvernoteToTextflowCommand_Base()
			var event : EvernoteToTextflowCommandTriggerEvent = 
				new EvernoteToTextflowCommandTriggerEvent(
					EvernoteToTextflowCommandTriggerEvent.IMPORT,
					txt, null )
			cmd.event = event
			cmd.importEvernoteXML()		
			return cmd.txt
		}
		
		
		
		/**
		 * Post processing, convert xml to tf object
		 * */
		private function importPt2(str:String):TextFlow
		{
			import flashx.textLayout.conversion.ConversionType;
			import flashx.textLayout.conversion.TextConverter;				
			var flow:TextFlow = 
				TextConverter.importToFlow(str, TextConverter.TEXT_LAYOUT_FORMAT);
			//this function needs to co deep 
			this.checkChildrenImport( flow ) 
			
			/*
			for each ( var oo : Object in flow.mxmlChildren ) 
			{
				if ( oo.hasOwnProperty('mxmlChildren' ) == false ) 
					continue; 
				for each ( var o : Object in oo.mxmlChildren ) 
				{
					if ( o  is SpanElement ) 
					{
						var span : SpanElement = o as SpanElement
						//trace( span.text ) ; 
						//trace( ' ' + cmd.replace( span.text,  'ooooo', '  •  ' )  )
						span.text =  replace( span.text,  'ooooo', '  •  ' ) 
					}
					if ( o  is SpanElement ) 
					{
						span   = o as SpanElement
						var dbg : Array = [span.text , RteHtmlParser_Import.entodo_marker,
							span.text == RteHtmlParser_Import.entodo_marker]
						if ( span.text == RteHtmlParser_Import.entodo_marker )
						{
							var index :  int = span.parent.getChildIndex( span )
							var p : Object = span.parent; 
							span.parent.removeChildAt( index ) 
							
							// add an empty InlineGraphicElement as a placeholder
							var pHolder:InlineGraphicElement = new InlineGraphicElement();
							pHolder.width = 30;
							pHolder.height = 30;
							
							
							//var ee  : InlineGraphicElement
							p.addChildAt(  index, pHolder  ) 
						}
					}					
				}
			}
			*/
			return flow			
		}
	 
		public function checkChildrenImport(flow:Object):void
		{
			if ( flow.hasOwnProperty('mxmlChildren' ) == false ) 
				return; 			
			for each ( var o : Object in flow.mxmlChildren ) 
			{
				 	this.checkChildrenImport( o ) 
					if ( o  is SpanElement ) 
					{
						var span : SpanElement = o as SpanElement
						//trace( span.text ) ; 
						//trace( ' ' + cmd.replace( span.text,  'ooooo', '  •  ' )  )
						span.text =  replace( span.text,  'ooooo', '  •  ' ) 
					}
					if ( o  is SpanElement ) 
					{
						span   = o as SpanElement
						if ( span.text == RteHtmlParser_Import.entodo_marker )
						{
							var index :  int = span.parent.getChildIndex( span )
							var p : Object = span.parent; 
							span.parent.removeChildAt( index ) 
							
							// add an empty InlineGraphicElement as a placeholder
							var pHolder:InlineGraphicElement = new InlineGraphicElement();
							pHolder.width = 15;
							pHolder.height = 15;
						
							pHolder.id = 'en-todo-chk_'+this.holders.length.toString() ;
							this.holders.push( pHolder ) 
							//var ee  : InlineGraphicElement
							p.addChildAt(  index, pHolder  ) 
						}
					}					
				}
		}
	 
		/**
		 * Take string and exports text flow string
		 * */
		static public function Import2( txt : String )  :   TextFlow
		{
			var cmd : EvernoteToTextflowCommand_Base = 
				new EvernoteToTextflowCommand_Base()
			var event : EvernoteToTextflowCommandTriggerEvent = 
				new EvernoteToTextflowCommandTriggerEvent(
					EvernoteToTextflowCommandTriggerEvent.IMPORT,
					txt, null )
			cmd.event = event
			var str : String = cmd.importEvernoteXML()		
			import flashx.textLayout.conversion.ConversionType;
			import flashx.textLayout.conversion.TextConverter;				
			var flow:TextFlow = cmd.importPt2(str)
			return flow
		}		
		
		/**
		 * Takes textflow and exports string
		 * */
		static public function Export( txt : String )  :  String
		{
			var cmd : EvernoteToTextflowCommand_Base = 
				new EvernoteToTextflowCommand_Base()
			var event : EvernoteToTextflowCommandTriggerEvent = 
				new EvernoteToTextflowCommandTriggerEvent(
					EvernoteToTextflowCommandTriggerEvent.EXPORT,
					txt, null )
			cmd.event = event
			cmd.exportTextflow()					
			return cmd.txt
		}		
 
		
		/**
		 * Takes textflow and exports string
		 * */
		static public function Export2( tf :  TextFlow )  :  String
		{
			var ee : TextConverter
			var eee : ConversionType
			var txt :  String = TextConverter.export( tf, 
				TextConverter.TEXT_LAYOUT_FORMAT, 
				ConversionType.STRING_TYPE ).toString()
				//(str, TextConverter.TEXT_LAYOUT_FORMAT);
			var cmd : EvernoteToTextflowCommand_Base = 
				new EvernoteToTextflowCommand_Base()
			var event : EvernoteToTextflowCommandTriggerEvent = 
				new EvernoteToTextflowCommandTriggerEvent(
					EvernoteToTextflowCommandTriggerEvent.EXPORT,
					txt, null )
			cmd.event = event
			cmd.exportTextflow()					
			return cmd.txt
		}		
				
		
		
	}
}
package org.syncon.evernote.basic.controller
{
	import flash.utils.Dictionary;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import mx.utils.StringUtil;
	
	import org.syncon.evernote.basic.vo.StylingVO;
	
	public class RteHtmlParser_Export
	{
		public var SET_P:String = 'DIV';
		public var SET_LI:String = 'LI';
		public var SET_FONT:String = 'SPAN';
		
		public var SET_UL:String = 'UL';
		public var SET_BR:String = 'BR';
		
		public var SET_SPAN : String = 'span'
		public var ignoreParagraphSpace:Boolean = false;
		
		private var out_xml:XML;
		
		public function RteHtmlParser_Export()
		{
		}
		
		// not those line breaks that kills the SQL
		public function get StringFormat():String
		{
			if (!out_xml) return '';
			
			XML.prettyIndent = 0;
			// remove the /n from the string
			// we want a string out!
			var s:String = unescape(unescape(escape(out_xml.children()).split('%0A').join('')));
			XML.prettyIndent = 2;
			
			return s;
		}
		
		// nice looking string
		public function get XMLFormat():String
		{
			if (!out_xml) return '';
			return unescape(out_xml.children().toXMLString());
		}
		
		// the xml
		public function get XMLObject():XML
		{
			return out_xml;
		}
		
		
		//________________________________________________________________________________________________________
		//                                                                                             HTML PARSER
		
		public function ParseToHTML(string:String):void
		{
			//var xml_doc:XMLDocument = new XMLDocument("<BODY>"+string+"</BODY>");
			//text flow wrapps content
			var xml_doc:XMLDocument = new XMLDocument( string );
			
			var nxml:XMLNode = (ignoreParagraphSpace) ? xml_doc.firstChild : manage_space(xml_doc.firstChild);
			
			var xml:XML = XML(nxml.toString());
			var t1:XML;
			
			// Remove all TEXTFORMAT
			for( t1 = xml..TEXTFORMAT[0]; t1 != null; t1 = xml..TEXTFORMAT[0] ) {
				t1.parent().replace( t1.childIndex(), t1.children() );
			}
			
			try {
			//add br tag
			if (SET_BR)
				xml = add_br_tag(xml);
			}
			catch ( e : Error ) {}
			// add ul tag
			xml = add_ul_tag(xml);
			
			// format css
			xml = add_css(xml);
			xml = remove_end_todos(xml);
			xml = remove_strong_and_em( xml ) 
			// format new names
			xml = set_new_name(xml);
			var bb :  XML = xml.child(0)[0]
			RteHtmlParser_Import.promoteEmptyNotes( bb,[ 'span'], true ) 
			xml = clear_extra_styling(xml)
			RteHtmlParser_Import.promoteEmptyNotes( bb,[ 'span'], true ) 
			out_xml = xml;
		}
		
		private function clear_extra_styling(xml:XML):XML
		{
			var x : StylingVO = new StylingVO()
			x.fontSize = 12
			x.color = '#000000'
			 x.fontWeight = 'normal' 
			for each (var i:XML in xml.children() ) 
			{
				clearStyles( i , x.clone()  ) 
			}
			
			return xml;
		}		
		
		private function clearStyles(xml : XML, style :  StylingVO )  : void
		{
			
			for each (var i:XML in xml.children() ) 
			{
				var dbg : Array = [i.@style] 
	 			if ( i.@style == null || i.@style.toString() == '' ) 
				{
					trace();
					clearStyles( i , style.clone()  ) 
					continue; 
				}
				i.@style = i.@style.toString().replace(';;', ';' ) 
				var style_ : String =  String(i.@style)
				var ar : Array  = style_.split(';');				
				
			 var styles  : Array = []; 
				for (var j:uint = 0; j < ar.length; j++) {
					var ta :  Array = ar[j].split(':');
					var name : String = ta[0].toLocaleLowerCase().split(' ').join('');
					var taTrimmed : String = StringUtil.trim(ta[1] );
					ta[1] = taTrimmed
					
					switch (name) 
					{
						/*
						case 'text-align':
							el.@textAlign = taTrimmed;
							break;
						
						case 'font-family':
							el.@fontFamily = ta[1].split("'").join('').split('"').join('');
							break;
						*/
						case 'font-size':
							taTrimmed = taTrimmed.replace('px' , '' ) 
							if ( int( taTrimmed ) == style.fontSize ) 
							{
								trace( 'font redundant ' );
							}
							else
							{
								style.fontSize = int( taTrimmed )
								styles.push( ar )
							}
							break;
				 
						case 'font-weight':
							if (  taTrimmed  == style.fontWeight ) 
							{
								trace( 'font weight redundant ' );
							}
							else
							{
								style.fontWeight =  taTrimmed 
								styles.push( ar )
							}
							break;						
						case 'color':
							//taTrimmed = taTrimmed.replace('px' , '' ) 
							if (  taTrimmed  == style.color ) 
							{
								trace( 'font color redundant ' );
							}
							else
							{
								style.color =  taTrimmed 
								styles.push( ar )
							}
							break; 
					} 
					
					if ( ar.length != styles.length ) 
						trace('dropped ' +( ar.length - styles.length)  + ' styles ' )
					i.@style = styles.join(';');		
					if ( styles.length == 0 ) 
						delete i.@style;
				clearStyles( i , style.clone()  ) 
			}			
		}
		}
		
		private function add_ul_tag(xml:XML):XML
		{
			var t1:XML;
			var t2:XML = new XML(<BODY />);
			//var el:XMLList = xml.children();
			var el:XMLList = xml.descendants( 'p' )
			var ul:XML;
			var li:XML; 
			var inList : Boolean = false; 
			var listByTextIndex :  Dictionary = new Dictionary(true)
			var textIndentByTextIndex :  Dictionary = new Dictionary(true)
			var lastTextIndent : int = 0; 
			for each (t1 in el) {
				var indicator : Array = ['%20%20•%20%20', '  •  ', '•' ] 
				var dbgNames : Array = [t1.name(), t1, t1.children()]
				if ( t1.children() != null )
					var dbgChild0 : Array = [t1.children()[0], indicator.indexOf( t1.children()[0].toString() ) != -1]
				//var dbg : Array = [t1.children()[0].toString()]
					
				if (t1.name() != null && t1.children() != null && 
					t1.name().localName == 'p' && 
					t1.children()[0] != null
					&& indicator.indexOf( t1.children()[0].toString() ) != -1  )
				{
					var textIndent : int = t1.@textIndent
					//set to default at 0 if attribute not found
					inList = textIndentByTextIndex[textIndent]
					if ( textIndentByTextIndex[textIndent]  == null ) 
						textIndentByTextIndex[textIndent] = false; 
					if ( inList == false ) 
					{
						var x : Object =  t1.children()[0].attribute('id')
						textIndentByTextIndex[textIndent] = true
						ul = new XML( <ul /> );
						if ( t1.children()[0].attribute('id') == RteHtmlParser_Import.OL_Implementation  ) 
						{
							ul = new XML( <ol /> );
						}
						
						if ( textIndent == 0 ) 
							t2.appendChild( ul )
						else
						{
							listByTextIndex[lastTextIndent].appendChild( ul )
						}
						listByTextIndex[textIndent] = ul
					}
					ul = listByTextIndex[textIndent] 
					li = new XML( <li /> )
					var bb :Array = [ t1.children()[0],  t1.children()[1],  t1.toXMLString()]
					if (  t1.children()[1] == null ) 
						li.appendChild( '' );
					else
					{
						//li.appendChild( t1.children()[1]);
						//append all children
						for ( var jj : int = 1; jj <   t1.children().length(); jj++ )
						{
							li.appendChild( t1.children()[jj]);
						}
					}
					ul.appendChild( li )
					lastTextIndent = textIndent
				} 				
				else {
					t2.appendChild(t1.copy());
				}
			}
			
			return t2;
		}
		
	/*	
		private function add_ul_tag_old(xml:XML):XML
		{
			var t1:XML;
			var t2:XML = new XML(<BODY />);
			var el:XMLList = xml.children();
			var ul:XML;
			var li:XML; 
			var inList : Boolean = false; 
			var listByTextIndex :  Dictionary = new Dictionary(true)
			var lastIndex : int = 0; 
			for each (t1 in el) {
				
				var dbg : Array = [t1.children()[0].toString()]
				var indicator : Array = ['%20%20•%20%20', '  •  ', '•' ] 
				if (t1.name().localName == 'p' && t1.children()[0] != null
					&& indicator.indexOf( t1.children()[0].toString() ) != -1  )
				{
					if ( inList == false ) 
					{
						var x : Object =  t1.children()[0].attribute('id')
						inList = true
						ul = new XML( <ul /> );
						if ( t1.children()[0].attribute('id') == RteHtmlParser_Import.OL_Implementation  ) 
						{
							ul = new XML( <ol /> );
						}
						t2.appendChild( ul )
						
					}
					li = new XML( <li /> )
					li.appendChild( t1.children()[1]);
					ul.appendChild( li ) 
				} 				
				else {
					t2.appendChild(t1.copy());
				}
			}
			
			return t2;
		}
		
		
		*/
		
		private function add_br_tag(xml:XML):XML
		{
			var br:XML;
			
			for each (var i:XML in xml.children()) {
				if (!has_text(i)) {
					br = copy_attributes(i.descendants('FONT')[0], new XML(<BR />));
					i.parent().replace(i.childIndex(), br);
				}
			}
			return xml;
		}
		
		private function set_new_name(xml:XML):XML
		{
			var t1:XML;
			// set new P
			if (SET_P == null)
			{
				for( t1 = xml..P[0]; t1 != null; t1 = xml..P[0] ) {
					t1.parent().replace(t1.childIndex(), t1.children());
				}
			}
			else if (SET_P.toLocaleUpperCase() != 'P') {
				for( t1 = xml..P[0]; t1 != null; t1 = xml..P[0] ) {
					t1.setName(SET_P);
				}
			}
			// set new UL
			if (SET_UL == null)
			{
				for( t1 = xml..UL[0]; t1 != null; t1 = xml..UL[0] ) {
					t1.parent().replace(t1.childIndex(), t1.children());
				}
			}
			else if (SET_UL.toLocaleUpperCase() != 'UL') {
				for( t1 = xml..UL[0]; t1 != null; t1 = xml..UL[0] ) {
					t1.setName(SET_FONT);
				}
			}
			// set new LI
			if (SET_LI == null)
			{
				for( t1 = xml..LI[0]; t1 != null; t1 = xml..LI[0] ) {
					t1.parent().replace(t1.childIndex(), t1.children());
				}
			}
			else if (SET_LI.toLocaleUpperCase() != 'LI') {
				for( t1 = xml..LI[0]; t1 != null; t1 = xml..LI[0] ) {
					t1.setName(SET_LI);
				}
			}
			// set new FONT
			if (SET_FONT == null)
			{
				for( t1 = xml..FONT[0]; t1 != null; t1 = xml..FONT[0] ) {
					t1.parent().replace(t1.childIndex(), t1.children());
				}
			}
			else if (SET_FONT.toLocaleUpperCase() != 'FONT') {
				for( t1 = xml..FONT[0]; t1 != null; t1 = xml..FONT[0] ) {
					t1.setName(SET_FONT);
					// wierd browser rendering on e.g. <span />
					if (t1 == '') {
						//t1.setChildren('');
						//or you can just replace it with nothing
						t1.parent().replace(t1.childIndex(), '');
					}
				}
			}
			// set new BR
			if (SET_BR == null)
			{
				for( t1 = xml..BR[0]; t1 != null; t1 = xml..BR[0] ) {
					t1.parent().replace(t1.childIndex(), t1.children());
				}
			}
			else if (SET_BR.toLocaleUpperCase() != 'BR') {
				for( t1 = xml..BR[0]; t1 != null; t1 = xml..BR[0] ) {
					t1.setName(SET_BR);
					// if it's closed like this <font /> in html
					// thebrowser might act wierd!
					t1.setChildren('');
				}
			}
			return xml;
		}
		
		private function add_css(xml:XML):XML
		{
			var t1:XML;
			var t2:XML;
			// Find all ALIGN
			for each ( t1 in xml..@textAlign ) {
				t2 = t1.parent();
				t2.@style = "text-align:" + t1 + ";" + t2.@style;
				delete t2.@textAlign;
			}
			// Find all FACE
			//fontFamily
			for each ( t1 in xml..@fontFamily ) {
				t2 = t1.parent();
				t2.@style = "font-family: " + t1 + ";" + t2.@style;
				delete t2.@fontFamily;
			}
			// Find all SIZE 
			for each ( t1 in xml..@fontSize ) {
				t2 = t1.parent();
				var fontSize : String =t1.toString() + "px;"
				if ( t1  =='8.01' )
				{
					fontSize =  'xx-small' 
				}
				if ( t1  ==  '8.01'  )
				{
					fontSize ='xx-small'
				}
				if ( t1  == '24.01'  )
				{
					fontSize = 'x-large'
				}
				if ( t1  ==  '36.01')
				{
					fontSize =  'xx-large' 
				}
				 
				t2.@style = "font-size: " + fontSize+ ";"   + t2.@style;
				delete t2.@fontSize;
			}
			// Find all COLOR 
			for each ( t1 in xml..@color ) {
				t2 = t1.parent();
				t2.@style = "color: " + t1 + ";" + t2.@style;
				delete t2.@color;
			}
			
			// Find all textDecoration 
			for each ( t1 in xml..@textDecoration ) {
				t2 = t1.parent();
				t2.@style = "text-decoration: " + t1 + ";" + t2.@style;
				delete t2.@textDecoration;
			}
			
			// Find all lineThrough 
			for each ( t1 in xml..@lineThrough ) {
				t2 = t1.parent();
				t2.@style = "text-decoration: " + 'line-through' + ";" + t2.@style;
				delete t2.@lineThrough;
			}
			
			// Find all LETTERSPACING 
			for each ( t1 in xml..@letterspacing ) {
				t2 = t1.parent();
				t2.@style = "letter-spacing:" + t1 + "px;" + t2.@style;
				delete t2.@letterspacing;
			}			
			
			// Find all textIndent 
			for each ( t1 in xml..@textIndent ) {
				t2 = t1.parent();
				t2.@style = "padding-left: " + t1 + "px;" + t2.@style;
				delete t2.@textIndent;
			}
			
			// Find all KERNING
			for each ( t1 in xml..@kerning ) {
				t2 = t1.parent();
				// ? css 
				delete t2.@kerning;
			}
			return xml;
		}
		
		//________________________________________________________________________________________________________
		
 
		private function remove_end_todos(xml:XML):XML
		{
			var img:XMLList = xml.descendants('img');
			var p:XML;
			var f:XML;
			
			for each (var i:XML in img) {
				p = new XML(<en-todo />);
				var id : String = i.@id
				if ( id.toString().indexOf('en-todo-chk' ) != -1  )
				{
					if ( id.indexOf('|true') ) 
						p.@checked = true; 
					i.parent().replace(i.childIndex(), p);
				}
				
			}
			
			return xml;
		}		
		
		
		private function remove_strong_and_em(xml:XML):XML
		{
			var span:XMLList = xml.descendants(SET_SPAN);
			var p:XML;
			var f:XML;
			
			//if a span with only the fontweight set, ...
			//....not only ... crap 
			
			//only issue .. place these inside the tag by preference
			for each (var i:XML in span) {
				p = new XML(<strong />);
				var dbg : Array = [ i.attributes().toXMLString(), i.attributes().toString(),  i.attribute('bold') ]
				if ( i.attributes().toString().indexOf( 'bold' ) != -1  )
				{
					if (  i.attributes().toString() == 'bold' ) 
					{
						p.setChildren( i.children() )
						i.parent().replace(i.childIndex(), p);						
					}
					else
					{
						/*
						var oldParent :  Object = i.parent()
						delete i.@fontWeight;
						p.setChildren(  i  ) //this cannot be aftwards, setChildren makes a cop y
						oldParent.replace(i.childIndex(), p);		
						*/
						//var oldParent :  Object = i.parent()
						var oldParent :  Object 
						delete i.@fontWeight;						
						p.setChildren(  i.children()  ) 
						i.setChildren( p);								
						
					}

				}
						
			}
			
			span = xml.descendants(SET_SPAN);
			for each ( i in span) {
				p = new XML(<em />);
				if ( i.attributes().toString().indexOf( 'italic' ) != -1  )
				{
					if (  i.attributes().toString() == 'italic' ) 
					{
						p.setChildren( i.children() )
						i.parent().replace(i.childIndex(), p);						
					}
					else
					{
						/*
						oldParent = i.parent()
						delete i.@fontStyle;
						p.setChildren(  i  )
						oldParent.replace(i.childIndex(), p);		
						*/
						delete i.@fontStyle;						
						p.setChildren(  i.children()  ) 
						i.setChildren( p);								
					}
				}
			}			
			
			this.replaceTagHolderWithTag(xml,  'span', 'baselineShift', 'subscript', 'sub' ) 
			this.replaceTagHolderWithTag(xml,  'span', 'baselineShift', 'superscript', 'sup' ) 			
			/*
			span = xml.descendants(SET_SPAN);
			for each ( i in span) {
				p = new XML(<span />);
				if ( i.attributes().toString().indexOf( 'underline' ) != -1  )
				{
					if (  i.attributes().toString() == 'underline' ) 
					{
						
						p.setChildren( i.children() )
						i.parent().replace(i.childIndex(), p);						
					}
					else
					{
						oldParent = i.parent()
						delete i.@textDecoration;
						p.setChildren(  i  )
						oldParent.replace(i.childIndex(), p);			
					}
				}
			}		
			*/
			return xml;
		}		
				
		private function replaceTagHolderWithTag(xml:XML, findTagType : String, attribute : String, value : String, replaceWithTag :  String) : void
		{
			var span:XMLList = xml.descendants(findTagType);
			var p:XML;
			var f:XML;
			for each (var i:XML in span) {
				p = new XML('<'+replaceWithTag+ '/>');
				var dbg : Array = [ i.attributes().toXMLString(), i.attributes().toString(),  i.attribute('bold') ]
				if ( i.attributes().toString().indexOf( value  ) != -1  )
				{
					if (  i.attributes().toString() ==value ) 
					{
						p.setChildren( i.children() )
						i.parent().replace(i.childIndex(), p);						
					}
				/*	else
					{
						var oldParent :  Object 
						delete i.@fontWeight;						
						p.setChildren(  i.children()  ) 
						i.setChildren( p);								
						
					}*/
				}
			}			
		}
		private function remove_br_tag(xml:XML):XML
		{
			var br:XMLList = xml.descendants(SET_BR);
			var p:XML;
			var f:XML;
			
			for each (var i:XML in br) {
				p = new XML(<P />);
				f = copy_attributes(i, new XML(<FONT />));
				f.setChildren('');
				p.appendChild(f);
				i.parent().replace(i.childIndex(), p);
			}
			
			return xml;
		}
		
		 
		
		private function rename_tags(xml:XML):XML
		{
			var t:XML;
			var el:XMLList;
			
			// set new P
			if (SET_P.toLocaleUpperCase() != 'P' && SET_P != null) {
				el = xml.descendants(SET_P);
				for each (t in el) {
					t.setName('P');
				}
			}
			// set new LI
			if (SET_LI.toLocaleUpperCase() != 'LI' && SET_LI != null) {
				el = xml.descendants(SET_LI);
				for each (t in el) {
					t.setName('LI');
				}
			}
			// set new FONT
			if (SET_FONT.toLocaleUpperCase() != 'FONT' && SET_FONT != null) {
				el = xml.descendants(SET_FONT);
				for each (t in el) {
					t.setName('FONT');
				}
			}
			return xml;
		}
		
		private function add_textformat(xml:XML):XML
		{
			var m:XML = new XML(<BODY />);
			var tf:XML;
			
			for each (var i:XML in xml.children()) {
				tf = new XML(<TEXTFORMAT />);
				//tf.@LEADING = '2';
				tf.appendChild(i.copy());
				m.appendChild(tf);
			}
			
			return m;
		}
		
		
		private function add_ul(xml:XML):XML
		{
			var m:XML = new XML(<BODY />);
			var tf:XML;
			var inList : Boolean = false
			var listXML : XML;
			var liXML : XML;
			for each (var i:XML in xml.children()) {
				/*tf = new XML(<TEXTFORMAT />);
				//tf.@LEADING = '2';
				tf.appendChild(i.copy());
				*/
				var children : XMLList = i.children()
				if ( i.descendants('*').length() > 0 ) 
				{
					
				}
				var firstChild :  XML =  i.children()[0]
					var dbg2 : Array = [firstChild.toString(), firstChild.toXMLString() ]
				if ( firstChild!= null && firstChild.toString() == '•' )   
				{
					if ( inList == false ) 
					{
						listXML = new XML(<UL />);
						m.appendChild(listXML);			
						inList = true; 
					}
					liXML = new XML(<LI />)
					/*
					p = new XML(<P />);
					f = copy_attributes(i, new XML(<FONT />));
					f.setChildren('');
					p.appendChild(f);
					i.parent().replace(i.childIndex(), p);				
					*/
					for   ( var j : int = 1; j < children.length(); j++ )
					{
						liXML.appendChild( children[j] )
					}
					listXML.appendChild(liXML);					
					continue
				}			
				
				if ( inList == true ) 
				{
					//add closing ul before
					inList = false 
				}
				var dbg : Object= [i.children(), i.@p, i.children()[0].children() ] 
				//get all spans, 
				//if first one is  <span fontSize="15">   • </span>, or content contains 'dot' 
				//add this to a ul 
				//inlist = inList
				
				//find element with no 'dot' 
				//end ul , inList === false 
				tf = i; 
				m.appendChild(tf);
			}
			
			return m;
		}		
		
		
		//________________________________________________________________________________________________________
		
		
		
		//________________________________________________________________________________________________________
		//                                                                                              SOME TOOLS
		
		private function has_text(xml:XML):Boolean
		{
			for each (var i:XML in xml.children()) {
				if (i.nodeKind() == 'text') return true;
				else if (has_text(i)) return true;
			}
			
			return false;
		}
		
		private function copy_attributes(x1:XML, x2:XML):XML
		{
			for each (var i:XML in x1.attributes()) {
				x2.@[i.name().localName] = i;
			}
			return x2;
		}
		
		private function manage_space(node:XMLNode):XMLNode
		{
			for each (var n:XMLNode in node.childNodes)
			{
				if (n.nodeType == 3) n.nodeValue = n.nodeValue.split(' ').join('%20');
				if (n.hasChildNodes()) manage_space(n);
			}
			return node;
		}
		
		//________________________________________________________________________________________________________
	}
}
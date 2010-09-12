package org.syncon.evernote.basic.controller
{
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
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
			out_xml = xml;
		}
		
		private function add_ul_tag(xml:XML):XML
		{
			var t1:XML;
			var t2:XML = new XML(<BODY />);
			var el:XMLList = xml.children();
			var ul:XML;
			var li:XML; 
			var inList : Boolean = false; 
			for each (t1 in el) {
				
				
				if (t1.name().localName == 'p' && t1.children()[0] != null
					&& t1.children()[0].toString() == '•' )
				{
					if ( inList == false ) 
					{
						inList = true
						ul = new XML( <ul /> );
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
				t2.@style = "font-family:'" + t1 + "';" + t2.@style;
				delete t2.@fontFamily;
			}
			// Find all SIZE 
			for each ( t1 in xml..@fontSize ) {
				t2 = t1.parent();
				t2.@style = "font-size:" + t1 + "px;" + t2.@style;
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
		
 
		private function remove_ul_tag(xml:XML):XML
		{
			var ul:XMLList = xml.elements(SET_UL);
			
			for each (var i:XML in ul) {
				i.parent().replace(i.childIndex(), i.children());
			}
			
			return xml;
		}
		
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
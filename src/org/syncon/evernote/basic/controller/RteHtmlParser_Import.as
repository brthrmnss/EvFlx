package org.syncon.evernote.basic.controller
{
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import mx.utils.StringUtil;
	
	public class RteHtmlParser_Import
	{
		public var SET_P:String = 'div';
		public var SET_LI:String = 'li';
		public var SET_FONT:String = 'span';
		
		public var SET_UL:String = 'ul';
		public var SET_BR:String = 'br';
		public var SET_STRONG:String = 'strong';
		public var SET_EM:String = 'em';				
		public var SET_EN_TODO:String = 'en-todo';		
		public static var entodo_marker : String = '~!*entodomarker*!~@'
		public var ignoreParagraphSpace:Boolean = false;
		
		private var out_xml:XML;
		
		public function RteHtmlParser_Import()
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
		
		
		//________________________________________________________________________________________________________
		//                                                                                              RTE PARSER
		
		public function ParseToRTE(string:String):void
		{
			//"<BODY>"+string+"</BODY>"
			var xml_doc:XMLDocument = new XMLDocument("<BODY>"+string+"</BODY>");
			var nxml:XMLNode = (ignoreParagraphSpace) ? xml_doc.firstChild : manage_space(xml_doc.firstChild);
			
			var xml:XML = new XML(nxml.toString());
			
			// remove UL
			
			//xml = convertUlToSoftBullets( xml ) 
				
			// remove BR
			xml = remove_br_tag(xml);
			xml = remove_enTodo_tag(xml);
			// format CSS
			xml = remove_css(xml);
			
			xml = remove_strong_tag(xml);
			/*
			// format names
			xml = rename_tags(xml);
			*/
			xml = remove_empty_tags(xml)
			//add TEXTFORMAT
			//xml = add_textformat(xml);
			xml = remove_ul_tag(xml);
			out_xml = xml;
		}
		
		private function remove_ul_tag(xml:XML):XML
		{
			var ul:XMLList = xml.elements(SET_UL);
			
			for each (var i:XML in ul) {
				var spanned :  XMLList = spanElements(  i.children() ) 
				i.parent().replace(i.childIndex(), spanned );
			}
			
			return xml;
		}
		private function spanElements(xml:XMLList):XMLList
		{
			var list : XMLList = new XMLList(<div/>)
			 
			for each (var i:XML in xml.children()) {
				var children : XMLList = i.children()
				 //var wrapper : XML = new XML(<p xmlns="http://ns.adobe.com/textLayout/2008" lineHeight="180%" fontSize="15"  ><span >  •  </span> </p> )
				 var wrapper : XML = new XML(<p xmlns="http://ns.adobe.com/textLayout/2008" lineHeight="180%"><span fontSize="15">ooooo</span></p> )
				//var dbg : Array = [ wrapper[0], wrapper.@span, wrapper.descendants('span' ) , wrapper.descendants() ] 
				wrapper.appendChild(i);	
				 list.appendChild( wrapper );
			}
			
			return list.children()
		}		
			private function convertUlToSoftBullets(xml:XML):XML
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
					
			
		private function remove_br_tag(xml:XML):XML
		{
			var br:XMLList = xml.descendants(SET_BR);
			var p:XML;
			//var f:XML;
			
			for each (var i:XML in br) {
				p = new XML(<span />);
				//p = new XML(<span color="#99cc00">????</span>);
				/*f = copy_attributes(i, new XML(<FONT />));
				f.setChildren('');*/
				//p.appendChild(f);
				i.parent().replace(i.childIndex(), p);
			}
			
			return xml;
		}
		
		
		private function remove_strong_tag(xml:XML):XML
		{
			var strong:XMLList = xml.descendants(SET_STRONG);
			var r:XML;
			//var f:XML;
			
			for each (var i:XML in strong) {
				r = new XML(<span  fontWeight="bold" />);
				r.setChildren( i.children() ) 
				i.parent().replace(i.childIndex(),r);
			}
			 
			var em:XMLList = xml.descendants(SET_EM);
			var p:XML;
			
			for each ( i in em ) {
				p = new XML(<span fontStyle="italic" />);
				p.setChildren( i.children() ) 
				i.parent().replace(i.childIndex(), p);
			}			
			
			//<sub> to baselineShift="subscript"
			var sub:XMLList = xml.descendants('sub');
			for each ( i in sub ) {
				p = new XML(<span baselineShift="subscript" />);
				p.setChildren( i.children() ) 
				i.parent().replace(i.childIndex(), p);
			}				
			
			//<sup> to baselineShift="superscript"
			var sup:XMLList = xml.descendants('sup');
			for each ( i in sup ) {
				p = new XML(<span baselineShift="superscript" />);
				p.setChildren( i.children() ) 
				i.parent().replace(i.childIndex(), p);
			}		
			
			return xml;
		}		
		
		/**
		 * Convert enTodos into spans, they will contain the 
		 * entodo_marker
		 * */
		private function remove_enTodo_tag(xml:XML):XML
		{
			var todos:XMLList = xml.descendants(SET_EN_TODO);
			var p:XML;
			//var f:XML;
			
			for each (var i:XML in todos) {
				var selected : String = i.attribute('checked')
					if ( selected == '' ) 
						selected = 'false' 
				p = new XML('<span id="'+selected+'">'+entodo_marker+'</span>');
				i.parent().replace(i.childIndex(), p);
			}
			
			return xml;
		}		
		
		private function remove_css(xml:XML):XML
		{
			var ar:Array;
			var ta:Array;
			var el:XML;
			var name:String;
			//var capture : Object = xml..@STYLE 
			//var capture2 : Object = xml..@style 
			//var colorsWithHexAttribute:XMLList = xml.( hasOwnProperty( "@style" ) );

			for each ( var i:XML in xml..@style ) {
				el = i.parent();
				var style : String =  String(el.@STYLE)
				ar = String(el.@style).split(';');
				
				for (var j:uint = 0; j < ar.length; j++) {
					ta = ar[j].split(':');
					name = ta[0].toLocaleLowerCase().split(' ').join('');
					var taTrimmed : String = StringUtil.trim(ta[1] );
					ta[1] = taTrimmed
					switch (name) {
						case 'text-align':
						el.@textAlign = taTrimmed;
						break;
						
						case 'font-family':
						el.@fontFamily = ta[1].split("'").join('').split('"').join('');
						break;
						
						case 'font-size':
						el.@fontSize = ta[1].split('px').join('');
						break;
						
						case 'font-weight':
							el.@fontWeight = taTrimmed
							break;						
						case 'color':
						el.@color = taTrimmed;
						break;
						case 'text-decoration':
							if ( taTrimmed == 'line-through' ) 
								el.@lineThrough = true
							else
								el.@textDecoration = taTrimmed
							break;					
						case 'padding-left':
							if ( taTrimmed.indexOf( 'px' ) ) 
								taTrimmed  = taTrimmed.split('px')[0]
							var indentation:int = int( taTrimmed ) 
							el.@textIndent = indentation;		
							break;		
						case 'letter-spacing':
						el.@letterspacing = ta[1].split('px').join('');
						break;
					}
				}
				
				delete el.@style;
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
			
			return xml;
		}		
		
		private function remove_empty_tags(xml:XML):XML
		{
			var t:XML;
			var el:XMLList;
/*			t.toXMLString()
			do 
			{
				
			}*/
			//some do while loop uptile xml strings are equal
			 promoteEmptyNotes( xml, ['span'] )
			 promoteEmptyNotes( xml, ['span'] )
			 promoteEmptyNotes( xml, ['span'] )
			return xml;
		}
		/**
		 * 
		 * if node has no attributes, promot it's children
		 * if node has attributes, but is same as parent tag, which has no unique content prmoti it's children
		 * if addParnt tag is true, promot children 
		 * 
		 * ... simplify: 
		 * if has no attributes, promot children period ... y wrap in a useless tag?
		 * 
		 * If xml contains no content and no attributes, promote its children
		 * 
			<span>
			  <span fontWeight="bold">
			    bold, underline, italic
			  </span>
			</span>
			  ...the span is unnecesarry 
			  <span fontWeight="bold">
			    bold, underline, italic
			  </span> 
		* IF xml contains no content, but has soe attributes, try to merge attributes if parent 
		 * is of the same type 
			<span fontStyle="italic">
			  <span fontWeight="bold">
			    bold, underline, italic
			  </span>
			</span>
			 to:
			<span fontStyle="italic" fontWeight="bold">
			    bold, underline, italic
			  </span>
		 * * 
		 * */
		static public function promoteEmptyNotes(xml:XML, onlyTags : Array = null, pushToPTag : Boolean = false):void
		{		
			for each (var i:XML in xml.children()) {
				//var dbg : Array = [i.toString(), i.valueOf() ] 
				//convert xml to string 
				var childrenXMLString :  String = i.children().toXMLString()
				
				if ( childrenXMLString == '' ) 
					continue; 
				var dbg : Array = [i.children(),  i.attributes(),  i.attributes().length(), i.parent() ]
				//empty would be dropped by tlf anyway  
				var hasNoChildren : Boolean = false 
				hasNoChildren = i.children().length() == 0
				//if has no children, and no content ... remove it 
				/////////////////////////////////////////////////////////////////////////
				var hasAttributes : Boolean = false 
				hasAttributes =  i.attributes().length() != 0			
				var removeableTag : Boolean = false 
				if ( onlyTags != null ) 
					removeableTag = onlyTags.indexOf( i.name().localName ) != -1 			
				//doesn' contain content other than tags
				var noContentOtherThanChildren : Boolean = false; 
				if (childrenXMLString.charAt(0) == '<' && childrenXMLString.charAt(childrenXMLString.length-1) == '>' ) 
					noContentOtherThanChildren = true; 
				if ( noContentOtherThanChildren )
				{
					
					//remove if ? and has no attributes
					if (  removeableTag   )
					{	//continue; 
						if (  i.attributes().length() == 0 ) 
							i.parent().replace( i.childIndex(), i.children() )
						if (   i.attributes().length() != 0 )
						{
							//trace('' + i.name().localName +  ' ' +  i.parent().name().localName + ': ' + childrenXMLString  )
							if ( i.name().localName == i.parent().name().localName )
							{
								//copy attributes to parent then move
								copy_attributesX( i, i.parent() ) 
								i.parent().replace( i.childIndex(), i.children() )
								//trace('same parent type');
							}
						}
					}

					//if it has children 
					if ( i.children().length() > 0  ) 
					{
						var p : XML = i.children()[0].parent()
					}
					if ( p != null )
					{
						var pp : Object = p.toString();
					}
					
					/*	
					for each (var i2:XML in i.children()) 
					{	
						var dbg2 : Array = [i2.toString(), i2.valueOf() ] 
						this.promoteEmptyNotes( i2 ) 
					}
					*/	
				}
				else
				{
					//if parent tags can be shortened, .. shorten them , will copy the children 
					trace('' + i.name().localName +  ' ' +  i.parent().name().localName + ': ' + childrenXMLString  )
					if ( i.name().localName == i.parent().name().localName )
					{
						//copy attributes to parent then move
						copy_attributesX( i, i.parent() ) 
						i.parent().replace( i.childIndex(), i.children() )
						//trace('same parent type');
					}			
					//if it has no attributes == useless tag
					/*
					if ( pushToPTag && hasAttributes == false  &&
						removeableTag &&  i.parent().name().localName == 'p' )
					{
						i.parent().replace( i.childIndex(), i.children() )
					}		*/	
					//u lose nothing here
					if (  hasAttributes == false  && removeableTag  )
					{
						i.parent().replace( i.childIndex(), i.children() )
					}							
				}				

				promoteEmptyNotes( i, onlyTags ) 
			}
			
			//return xml
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
		
		static private function copy_attributesX(x1:XML, x2:XML):XML
		{
			for each (var i:XML in x1.attributes()) {
				x2.@[i.name().localName] = i;
			}
			return x2;
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
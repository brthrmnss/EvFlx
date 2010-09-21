package org.syncon.evernote.panic.vo
{
	public class ProjectVO  
	{
		public var name :  String = ''
		/**
		 * Allows for flexibility
		 * */
		public var name2 : String = ''; 
		public var toolTip : String = ''; 
		public var data : Object = null; 
		public var fx :  Function;
		public var enabled : Boolean = true; 
		
		public var desc : String = ''; 
		public var col2 : String = ''; 
		public var col3 : String = ''; 
		public var img : String = ''; 		
		public var ppl :  Array = []; 
	/*	public var name2 : String = ''; 		*/
		
		public function ProjectVO( name_ : String='', desc : String = '', 
								   col2 : String='', col3 : String = '', 		
								   kids : Array = null, img : String = '' ) 
								 
		{
			this.name = name_
			//this.toolTip = tooltip_
			this.desc = desc
			this.col2 = col2
			this.col3 = col3
				if ( kids != null ) 
			this.ppl = PeopleVO.importPeople( kids ) 		
			this.img = img; 
			super();
		}
		
		public function onInit()  : void
		{
		}
 
	}
}
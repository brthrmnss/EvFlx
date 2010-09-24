package org.syncon.evernote.panic.vo
{
	public class BoardVO  
	{
		public var name :  String = ''
		
		public var desc : String = ''; 
		public var img : String = ''; 		
		public var people :  Array = []; 
		public var projects :  Array = []; 				
		public var layout :  Array = []; 		
	/*	public var name2 : String = ''; 		*/
		public var src :  String = ''; 
		public function BoardVO( name_ : String='', desc : String = '', 
								   		
								    img : String = '' ) 
								 
		{
			this.name = name_
			//this.toolTip = tooltip_
			this.desc = desc
		}
	 
		
		public function export()  : Object
		{
			var o : Object = {}; 
			o.name = this.name; 
			///
			return o; 
		}
		public function importX( x : Object)  : void
		{
			this.name = x.name; 
			var layout : Array = x.layout; 
			var ipmortedLayout : Array = []; 
			for each ( var row : Array in layout ) 
			{
				var hgroup :  Array = new Array()
				ipmortedLayout.push( hgroup ); 
				for each ( var j :    Object in row )
				{
					hgroup.push ( WidgetVO.importX( j )  )
				}
			}
			this.layout = ipmortedLayout
		}		
		
 
	}
}
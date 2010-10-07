package org.syncon.evernote.panic.vo
{
	public class BoardVO  
	{
		public var name :  String = ''
		
		public var desc : String = ''; 
		public var board_password : String = ''; 
		public var board_admin_password :  String = ''; 
		
		public var admin_name : String = ''; 
		public var admin_email :  String = ''; 		
		
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
			o.board_password = this.board_password; 
			o.board_admin_password = this.board_admin_password
				
			o.admin_email = this.admin_email; 
			o.admin_name = this.admin_name		
			o.desc = this.desc; 
			///
			return o; 
		}
		public function importX( x : Object)  : void
		{
			this.name = x.name; 
			this.desc = x.desc
			this.board_password = x.board_password; 
			this.board_admin_password = x.board_admin_password; 
			this.admin_email = x.admin_email; 
			this.admin_name = x.admin_name; 
			
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
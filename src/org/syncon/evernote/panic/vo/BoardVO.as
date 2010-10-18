package org.syncon.evernote.panic.vo
{
	import flash.utils.Dictionary;

	public class BoardVO  
	{
		public var name :  String = ''
		
		public var desc : String = ''; 
		public var board_password : String = ''; 
		public var board_admin_password :  String = ''; 
		
		public var admin_name : String = ''; 
		public var admin_email :  String = ''; 		
		
		public var horizontalGap : Number = 10; // NaN;
		public var verticalGap : Number = 10; // NaN;
		
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
		
		/**
		 * index both arrys 
		 * for each one in my index see if it's there or not .... 
		 * 
		 * */
		public function compare( p :  BoardVO )  : Boolean
		{
			
			var peopleDifferent : Boolean = this.comparePeople( p ) 			
			var different : Boolean = false; 
			
			var removed : Array = []; 
			var indexOld : Dictionary = this.index( this.projects, 'id' ) 
			var indexNew : Dictionary = this.index( p.projects, 'id' ) 
			for ( var id : Object in indexOld ) 
			{
				var old_ : ProjectVO = indexOld[id] as ProjectVO
				var new_ : ProjectVO = indexNew[id] as ProjectVO
				if ( new_ == null ) 
				{
					removed.push( old_ ) 
					continue; 
				}
				//compare, if true, update peple too ..
			  old_.compare( new_, this.people ) //) 
					//old_.findPeople( this.people ) ; 
				indexNew[id] = null
				delete  indexNew[id]
			}
			for (   id  in indexNew ) 
			{
				 new_  = indexNew[id]
				this.projects.push( new_ ) 
			}			
			return different; 
		}
		
		
		public function comparePeople( p :  BoardVO )  : Boolean
		{
			var different : Boolean = false; 
			
			var removed : Array = []; 
			var indexOld : Dictionary = this.index( this.people, 'id' ) 
			var indexNew : Dictionary = this.index( p.people, 'id' ) 
			for ( var id : Object in indexOld ) 
			{
				var old_ :  PersonVO = indexOld[id] as PersonVO
				var new_ : PersonVO = indexNew[id] as PersonVO
				if ( new_ == null ) 
				{
					removed.push( old_ ) 
					continue; 
				}
				//compare, if true, update peple too ..
				  old_.compare( new_ ) 
				indexNew[id] = null
					delete  indexNew[id]
			}
			for (   id  in indexNew ) 
			{
				new_  = indexNew[id]
				this.people.push( new_ ) 
			}			
			return different; 
		}		
		
		
		public function index ( objs : Array, meth : String )  :  Dictionary
		{
			var d : Dictionary = new Dictionary( true ) 
			for ( var i: int = 0; i <objs.length; i++ )
			{
				var o : Object =objs[i]
				d[o[meth] ] = o
			}					
			return d ; 
		}
	}
}
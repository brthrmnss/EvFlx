package org.syncon.evernote.panic.vo
{
	public class WidgetVO  
	{
		static public var IMPORT_CONFIG : String = 'importConfig'
		public var name :  String = ''
		/**
		 * Allows for flexibility
		 * */
		public var type : String = ''; 
		static public var GRAPH : String = 'graph';
		static public var MESSAGE : String = 'message';
		static public var PANE : String = 'pane';
		static public var PROJECT : String = 'project'			
		static public var PROJECT_LIST : String = 'projectList';		
		static public var SPACER : String = 'spacer'	
		static public var ROW : String = 'row'					
		static public var TWITTER_SCROLLER : String = 'twitterScroller'				
		
		public var data : Object = null; 
		public var fx :  Function;
		public var enabled : Boolean = true; 
		
		public var description : String = ''; 
		public var source : String = ''; 
		public var col3 : String = ''; 
		public var refreshTime : Number = -1;
			
		[Transient] public var editing : Boolean = false;
			
	/*	public var name2 : String = ''; 		*/
		public var src :  String = ''; 
		
		public var ui : Object; 
		
		public function WidgetVO( type : String='', settings : Object=null  ) 
		{
			this.type = type
			this.data = settings; 
		}
		
		static public function importX( o:   Object)  :   WidgetVO
		{
			if ( o.hasOwnProperty( 'type' ) == false ) 
				throw 'cannot import invalid widget'; 
			var x : WidgetVO = new WidgetVO( o.type, {} ) 
			for ( var prop : Object in o ) 
			{
				if ( x.hasOwnProperty( prop ) )
					x[prop] = o[prop]
				else
					x.data[prop] = o[prop]	
			}
			return x; 
		}
		
		public var height : Number
		public var width : Number
 
		public function export() : Object
		{
			var o :  Object = {}
			if ( this.name != '' ) o.name = this.name; 
			if ( this.description != '' ) o.description = this.description
			if ( !  isNaN( this.height )  ) o.height = this.height; 
			if ( !  isNaN( this.width  ) ) o.width = this.width				
			if ( this.type != SPACER ) 
			{
				o.source = this.source
				o.refreshTime = this.refreshTime; 
			}
			o.type = this.type; 
			for   ( var prop :  Object in this.data ) 
			{
				o[prop] = this.data[prop]
			}
			
			return o
		}
		
		public function clone() : WidgetVO
		{
			return this; 
		}
	}
}
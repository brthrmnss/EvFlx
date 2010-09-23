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
		static public var TWITTER_SCROLLER : String = 'twitterScroller'				
		
		public var data : Object = null; 
		public var fx :  Function;
		public var enabled : Boolean = true; 
		
		public var desc : String = ''; 
		public var col2 : String = ''; 
		public var col3 : String = ''; 
		public var img : String = ''; 		
		public var ppl :  Array = []; 
	/*	public var name2 : String = ''; 		*/
		public var src :  String = ''; 
		public function WidgetVO( type : String='', settings : Object=null  ) 
		{
			this.type = type
			this.data = settings; 
		}
		
		static public function importPeople(arr: Array)  :  Array
		{
			var  people :  Array = []; 
			for each ( var name : String in arr ) 
			{
				var p : PeopleVO = new PeopleVO()
				p.name = name ; 
				people.push( p ) 
			}
			return people; 
		}
		
		public var height : Number
		public var weight : Number
 
	}
}
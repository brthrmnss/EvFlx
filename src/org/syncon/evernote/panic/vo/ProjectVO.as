package org.syncon.evernote.panic.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	[Event(name="projectUpdated", type="flash.events.Event")] 		
	
	public class ProjectVO  extends  EventDispatcher
	{
		static public var  PROJECT_UPDATED : String = 'projectUpdated';
		
		public function projectUpdated() : void
		{
			this.dispatchEvent( new Event( PROJECT_UPDATED ) )
		}		
		
		public var id : String = ''; 
		
		public var name :  String = ''
		public var desc : String = ''; 
		public var col2 : String = ''; 
		public var col3 : String = ''; 
		public var img : String = ''; 		
		public var ppl :  Array = []; 
	/*	public var name2 : String = ''; 		*/
		public var people_names : Array = []; 
		public function ProjectVO( name_ : String='', desc : String = '', 
								   col2 : String='', col3 : String = '', 		
								   kids : Array = null, img : String = '', 
									people_names : Array = null)  
								 
		{
			this.name = name_
			//this.toolTip = tooltip_
			this.desc = desc
			this.col2 = col2
			this.col3 = col3
			if ( kids != null ) 
			this.ppl = PersonVO.importPeople( kids ) 	
			this.people_names = people_names
			this.img = img; 
			this.id = (new Date()).getTime().toString()+'_'+(Math.random()*100000).toString()
			super();
		}
		
		public function findPeople( allPeople : Array )  : void
		{
			var pplDict :  Dictionary = new Dictionary(true)
			for each ( var p : PersonVO in allPeople ) 
			{
				pplDict[p.id]=p
			}
			this.ppl = []; 
			for each ( var id : String in this.people_names ) 
			{
				if ( pplDict[id] != null ) 
					this.ppl.push( pplDict[id] )
				else
					trace( ' did not find ' + id ) 
			}
		}
		
		public function export()  : Object
		{
			return this; 
		}
		
		 
		public function importX( x : Object)  : void
		{
			for  ( var prop : Object in  x ) 
			{
				if ( x.hasOwnProperty( prop ) )
					this[prop] = x[prop] 
			}			
			/*
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
			*/
		}	
	 
		public function compare( p :  ProjectVO )  : Boolean
		{
			var different : Boolean = false; 
			return different; 
		}
		
		public function update()  : void
		{
			//dispatch some event
		}
	}
}
package org.syncon.evernote.panic.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.utils.ObjectUtil;
	
	import org.syncon.evernote.basic.model.CustomEvent;

	[Event(name="projectUpdated", type="flash.events.Event")] 		
	
	public class ProjectVO  extends  EventDispatcher
	{
		static public var  PROJECT_UPDATED : String = 'projectUpdated';
		
		public function projectUpdated(props : Array) : void
		{
			 
			this.dispatchEvent( new CustomEvent  ( PROJECT_UPDATED, props ) )
		}		
		
		public var id : String = ''; 
		
		public var name :  String = ''
		public var desc : String = ''; 
		public var status : String = ''; 
		public var status2 : String = ''; 
		public var img : String = ''; 		
		public var ppl :  Array = []; 
		
		public var progress : Number =  NaN; 
		
	/*	public var name2 : String = ''; 		*/
		public var people_ids : Array = []; 
		public function ProjectVO( name_ : String='', desc : String = '', 
								   col2 : String='', col3 : String = '', 		
								   kids : Array = null, img : String = '', 
								   people_ids_ : Array = null)  
								 
		{
			this.name = name_
			//this.toolTip = tooltip_
			this.desc = desc
			this.status = col2
			this.status2 = col3
			if ( kids != null ) 
			this.ppl = PersonVO.importPeople( kids ) 	
			this.people_ids = people_ids_
			/*if ( this.ppl != null && people_ids_ ==  null ) 
			{
				people_ids = []; 
				for each ( var p : PersonVO in ppl ) 
				{
					this.people_ids.push( p.id ) 
				}
			}*/
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
			for each ( var id : String in this.people_ids ) 
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
	 
		public function compare( p :  ProjectVO, ppl : Array )  : Boolean
		{
			var different : Boolean = false; 
			var props :  Object = mx.utils.ObjectUtil.getClassInfo( this, ['ppl'], {includeReadOnly:false,includeTransient:false}  )
				var changedProps : Array = []; 
			for  each ( var qName :  QName in props.properties ) 
			{
				var prop : String = qName.localName
				if ( prop == 'ppl' ) continue; 
				if (prop == 'people_ids' ) 
				{
					var result : Array = this.areArraysSame( this[prop], p[prop] )
					if ( result[3] == true ) 
					{
						different = true 
						this[prop] = p[prop] 
						changedProps.push( prop )
						this.findPeople( ppl) 
					}
					continue;
				}
				if ( this[prop] != p[prop]  )
				{
					different = true 
					this[prop] = p[prop] 
					changedProps.push( prop )
				}
			}			
			if ( different )
					this.projectUpdated(changedProps) 
			return different; 
		}
		
		public function areArraysSame(a:Array,b:Array):  Array
		{
			var add : Array = []
			var removed : Array = []; 
			var changed : Array = [];
			var different : Boolean = false; 
			var indexOld :  Dictionary = this.index(a, '' ) 
			var indexNew : Dictionary = this.index(b, '' ) 
			for ( var id : Object in indexOld ) 
			{
				var old_ : Object = indexOld[id] 
				var new_ : Object = indexNew[id] 
				if ( new_ == null ) 
				{
					different = true 
					removed.push( old_ ) 
					continue; 
				}
				//old_.compare( new_ ) 
				indexNew[id] = null
				delete  indexNew[id]
			}
			for (   id  in indexNew ) 
			{
				different = true 
				new_  = indexNew[id]
				add.push( new_ ) 
			}			
			return [add,removed,changed,different ]; 
		}
		
		
		public function index ( objs : Array, meth : String )  :  Dictionary
		{
			var d : Dictionary = new Dictionary( true ) 
			for ( var i: int = 0; i <objs.length; i++ )
			{
				var o : Object =objs[i]
				var index : Object = o
				if ( meth != '' ) index = o[meth] 
				d[index] = o
			}					
			return d ; 
		}
		
		public function update()  : void
		{
			//dispatch some event
		}
	}
}
package  org.syncon.evernote.basic.controller
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.model.Tag2;

 
	public class QuickTagEditorCommand_base  
	{
		[Inject] public var event:QuickTagEditorCommandTriggerEvent;
		private var seqId : int = -1
		private var timerTimeout : Timer = new Timer(3000)
		private var debug : Boolean = true
		private var alert : Boolean = false; 
		private var notAuthenticatedRetryTimer : Timer;
		private var retryCount : int = 0 ;
 
		 
		public var tagHeirarchy : Array = []; 
		public function onLoadTags(e:  Array )  :  String
		{
			var children : Array = []; var roots : Array = []; 
			//var parents : Array = []; 
			var tagsDict : Dictionary  = new Dictionary(true)
			var parentDict : Dictionary  = new Dictionary(true)
			 for each ( var tag :   Tag2 in e ) 
			 {
				 tagsDict[tag.guid] = tag
				 if ( tag.parentGuid == null ) 
				 {
					 
					 roots.push( tag )
				 }
				 else
					 children.push( tag )
			 }
			 
			 //store parents in array and on parent dictionary 
			 for each (   tag   in children ) 
			 {
				 parentDict[tag.parentGuid] = tagsDict[tag.parentGuid]
				//parents.push( tag ) 
			 }						 
			 
			 
			 for each (   tag   in children ) 
			 {
				 var pt : Tag2 = parentDict[tag.parentGuid]
					if ( pt == null ) 
						throw 'error, no parent found'
				if ( pt.children.indexOf( tag ) == -1 ) 
						pt.children.push( tag ) 
			 }			 
			 
			 //all children in children array
			 var txt : String = '';
			 for each (   tag   in roots ) 
			 {			 
				 txt = this.printMe( tag, txt ) 
			 }
			//
			return txt
		}		
		
		private function printMe(t : Tag2, txt : String, indent : String = '' )  :  String
		{
			var indentPlus : String = '\t'
			txt += '\n' +indent+ t.name
			for each ( var tag :   Tag2 in t.children ) 
			{
				txt = this.printMe(tag, txt, indent+indentPlus ) 
			}
			return txt; 
		}
		
		public function makeFakeTags( )  :  Array
		{
			//['aaa', 'bbb', 'ccc'] 
			//[ ['ddd'], ['222', '333'], [] ] 
			makeXLinktoThese( 'aaa', ['ddd'] )  
			makeXLinktoThese( 'bbb', ['222', '333'] )  
			makeXLinktoThese( 'ccc', [])  			
			makeXLinktoThese( '333', ['ggg', 'fff'] )  
			makeXLinktoThese( 'ddd', ['zzz' ] )  
			makeXLinktoThese( 'zzz', ['777', '888' ] )  
			return  this.tagsList;
		}					
 
		private function makeXLinktoThese ( name :  String, children : Array )  : void
		{
			var t : Tag2  = this.find(  name )
			for each ( var childName : String  in children ) 
			{
				var ct : Tag2 = this.find( childName )
				ct.parentGuid = t.guid
				t.children.push( ct ) 
			}
			
		}
		private var flat : Dictionary = new Dictionary(true)
		public var tagsList : Array = []; 
		private function find( name : String )  :  Tag2
		{
			var t : Tag2 = this.flat[name]
			if ( t == null ) 
			{
				t = new Tag2
				t.guid = ( int((Math.random()*1000)) + int( Math.random()*1000) ).toString()
				t.name = name
				this.tagsList.push( t ) 
				this.flat[name] = t
			}
			return t; 
		}
		static public var RENAME_COMMAND: String = ':R:'
		public function onProcess( txt : String, oldTagList_  : Array ) :  Array
		{
			var arr : Array = []
			var oldTagNamesDict : Dictionary = new Dictionary(true)
			for each ( var tag_ :   Tag2 in oldTagList_ ) 
			{
				oldTagNamesDict[tag_.name] = tag_ ;
				
			}
			var lines : Array = txt.split( '\n' ) ;
			var parent : Object; null
			var create : Array = []; var destroy : Array = []
			var descentTree : Array = []; 
			var seenNames : Array = []; 
			var tags :   Array = []; var indentIndex: int = 0; 
			var allTagsByName : Dictionary = new Dictionary();
			var lastIndents : int = 0; var renameDict : Dictionary = new Dictionary(true);
			var roots : Array = []; 
			//var parentToBeDeleted : Boolean = false; //it's embedded for chnage
			for each ( var line : String in lines ) 
			{
				addToParent = null
				if ( line == '' || line == null ) continue; 
				var indents : int = line.split('\t').length-1
				if ( indents > lastIndents )
				{
					descentTree.push( lastTag ) 
					indentIndex = indents
					var addToParent : Object = descentTree[indents-1] 
				}
				if ( indents == lastIndents && indents != 0  )
				{
					  addToParent   = descentTree[indents-1] 
				}				
				if ( indents < lastIndents )
				{
					indentIndex = indents
					for ( var i : int = 0; i < lastIndents - indents; i++ )
					{
						descentTree.pop()
					}
					addToParent   = descentTree[indents-1] 
					
				}	

				var pattern:RegExp = /\t/gi;
				var name : String = line.replace( pattern, ''  ) 
				if (name.indexOf( '---'  ) != -1 )
				{
					if ( name.indexOf( RENAME_COMMAND ) != -1 ) 
					{
						throw 'you are attempting to delete and rename an item on line ' + i + ' Choose 1 Option Only'
					}
					name = name.replace('---', '' )
					destroy.push( name ) 
				}
				//Add items
				if (name.indexOf( '+++'  ) != -1 )
				{
					name = name.replace('+++', '' )
					create.push( name ) 
				}	
				else
				{
					//didactic
					if (oldTagNamesDict[name] == null )
					{
						//throw 'do you wish to create ' + name + ' as new? Please add +++ ' 
						create.push( name ) 
					}
				}
				if (name.indexOf( ':R:'  ) != -1 )
				{
					//check that we have an id for theo ld one, 
					//someone dumb might try to rename a new one and 
					//that'll bork stuff
					//when deleting set guid to null, if guid is null come rename time, ignore this
					//i think a warning is in order, users do not understand
					var renameString :   Array = name.split(':R:'  ) 
					name = name.split(':R:'  )[0]
					var rename : String = renameString[1]
					renameDict[name] = rename 
				}		
				var tag : Tag2 = oldTagNamesDict[name] 
				if ( tag == null )
				{
					create.push( name )
					tag = new Tag2
					tag.name = name
					tag.guid = 'new_'+name; 
				}
				else
				{
					tag = tag.clone()
				}
				if ( seenNames.indexOf( name ) != -1 ) 
					throw 'no duplicates' 

				if ( addToParent != null ) 
				{
					if ( addToParent != null && destroy.indexOf( addToParent.name ) == -1 ) 
					{
						var output : String = ''; 
						for ( i = 0; i <  indents; i++ )
						{
							output += '\t'
						}		
						trace(output + name + ' ('+addToParent.name+')')
						addToParent.children.push( tag ) 
						tag.parentGuid = addToParent.guid; 
					}
					else
					{
						for ( i = 0; i <  indents-1; i++ )
						{
							output += '\t'
						}		
						//running low on time ... if i delete  a parent node ....it gets linked to top? 
						//i would prefer it if floats up one level ... no f- that it's confusing .. 
						//either way is easy ... just get the parents parent guid 
						/**
						 * decison : if deleting a node that is not a root note, it's childen become:
						 * root nodes, or children of the delete node's parent
						 * i say b, b/c if u wanted them to be root, you culd 've place them ther ein the text file
						 * */
						trace(output + name + ' ( removing from '+addToParent.name+')')
						addToParent.children.push( tag ) 
						tag.parentGuid = addToParent.parentGuid; 
					}
					
					//trace( 'will add ' + name + ' to ' + addToParent.name ) 
				}
				else
				{
					roots.push( tag ) 
					trace( name ); 
				}
				seenNames.push( name ) 
				tags.push( tag ) 
				allTagsByName[tag.name] = tag
				//attach to parent ... 
				//who is parent? 
				
				var lastTag : Tag2 = tag; 
				 lastIndents  = indents
			}
			
			//find different ones 
			var diff : Array = []; 
			var relinkTags : Array = []; var createTags : Array = []; 
			for each ( tag in tags ) 
			{
				if ( tag.name == 'fff' ) 
				{
					//trace('fff');
				}
					var oldTag : Tag2 = oldTagNamesDict[tag.name]
					if ( oldTag == null ) 
					{
						createTags.push( oldTag ) 
						trace( 'creating ' + tag.name ) ; 
					}
					//old and link changed
					if (  oldTag != null &&  tag.parentGuid != oldTag.parentGuid )   
					{
						relinkTags.push( oldTag ) 
						trace( 'change link of  ' + tag.name ) ; 						
					}		
					//new and add link
					if ( oldTag == null &&   tag.parentGuid != null )   
					{
						relinkTags.push( oldTag ) 
						trace( 'link new upto ' + tag.name ) ; 						
					}
					//destroy
					if ( destroy.indexOf( tag.name ) != -1 )   
					{
						//relinkTags.push( oldTag ) 
						trace( 'delete ' + tag.name ) ; 						
					}					
			}
			for  ( var oldTagName : String  in renameDict ) 
			{
				var renameTo : String = renameDict[oldTagName]
				//creataeTgs.push( oldTag ) 
				trace( 'rename ' + oldTagName + ' to ' + renameTo ) ; 
			}	
			//export text based array ... use the roots on the NEW array 
			roots
			return arr;
		}				
		
		private function onTimeout(e: TimerEvent)  : void
		{
			this.deReference()
			this.onFault()
		}
		
		private function onFault() : void
		{
			var msg : String = 'Error 8332: '+event.type+' call failed';
			if ( debug ) 
			{
			}
			if ( event.alert ) 
			{
				//Alert.show( msg , 'Error...' )
			}
		}
		
		/**
		 * Clean up event handlers
		 * */
		private function deReference() : void
		{
			this.timerTimeout.removeEventListener(TimerEvent.TIMER, this.onTimeout ) 
			//event.dereference()
				
			if ( event.type == EvernoteAPICommandTriggerEvent.AUTHENTICATE ) 
			{
				//this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.AUTH_GET, this.authenticateResultHandler )
				//this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.AUTH_GET_FAULT, this.authenticateFaultHandler )
			}		
				
		}
 
			
	}
}
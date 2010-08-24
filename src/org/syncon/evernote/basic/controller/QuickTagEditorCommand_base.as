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
		public function onProcess( txt : String, oldTagList_  : Array, automate:Boolean=true ) :  Array
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
			var guidsToTagDict : Dictionary = new Dictionary(true);
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
				//we will recreate the children based on the movements later on
				tag.children = []; 
				if ( seenNames.indexOf( name ) != -1 ) 
					throw 'no duplicates' 

				if ( addToParent != null ) 
				{
					//if parent specified, and parent is not about to be destroyed, and it's not about to be destroy 
					if ( addToParent != null && destroy.indexOf( addToParent.name ) == -1  ) 
					{
						//IF UR not about to be deleted
						if (  destroy.indexOf( tag.name) == -1 )
						{
							var output : String = ''; 
							for ( i = 0; i <  indents; i++ )
							{
								output += '\t'
							}		
							trace(output + name + ' ('+addToParent.name+')')
						 
							if ( addToParent.children.indexOf( tag ) == -1 ) 
								addToParent.children.push( tag ) 
							 
							tag.parentGuid = addToParent.guid;
						}
					}
					//either parent is null, or i'm about to destroy parent node
					else 
					{
						//IF UR not about to be deleted
						if (  destroy.indexOf( tag.name) == -1 )
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
							//1 if parnet pranet exists, if paent prante root node
							 
							if ( addToParent.parentGuid != null ) 
							{
								var foundIndex : int
								if ( guidsToTagDict[addToParent.parentGuid].children.indexOf( tag ) == -1 ) 
									guidsToTagDict[addToParent.parentGuid].children.push( tag ) 
								
							}
							else
							{
								if ( roots.indexOf( tag ) == -1 ) 
									roots.push( tag ) 
							}
							 
							tag.parentGuid = addToParent.parentGuid; 
						}
					}
					
					//trace( 'will add ' + name + ' to ' + addToParent.name ) 
				}
				else
				{
					if ( destroy.indexOf( tag.name ) == -1 ) 
						roots.push( tag ) 
					else
						trace ( ' skippe root ' + name ); 
					trace( name ); 
				}
				seenNames.push( name ) 
				tags.push( tag ) 
				allTagsByName[tag.name] = tag
				guidsToTagDict[tag.guid] = tag
				//attach to parent ... 
				//who is parent? 
				
				var lastTag : Tag2 = tag; 
				 lastIndents  = indents
			}
			this.postTags = tags
			this.postOldTagNamesDict = oldTagNamesDict
				this.postDestroy = destroy
					this.postGuidsToTagDict  = guidsToTagDict
						this.postRoots = roots
							this.postRenameDict = renameDict
			var output_ : Array = processOutput(automate ) 
			return output_
		}				
		
		public var postTags : Array 
		public var postOldTagNamesDict : Dictionary
		public var postDestroy : Array  
		public var postGuidsToTagDict : Dictionary 
		public var postRoots : Array; /// = this.postRoots; 
		public var postRenameDict : Dictionary
		
		public function onStepDone(e:Object) : void
		{
			this.indexProcessing++
				this.processOutput( true ) 
		}
		public function onStepFault(e:Object) : void
		{
			return;
		}
		
		
		
		public var indexProcessing : int = -1; 
		public var fxDone  : Function ; 
		public function processOutput( a :  Boolean )  : Array
		{
			var tag : Tag2; 
			var tags : Array = this.postTags; 
			var oldTagNamesDict : Dictionary = this.postOldTagNamesDict
			var destroy : Array =this.postDestroy ; 
			var guidsToTagDict : Dictionary = this.postGuidsToTagDict
				var roots : Array = this.postRoots; 
				var renameDict : Dictionary = this.postRenameDict
			//find different ones 
			var diff : Array = []; 
			var relinkTags : Array = []; var createTags : Array = []; 
			var tasks : Array = []; 
			var task :  String = ''; 
			if ( indexProcessing != -1  )
			{
				if ( indexProcessing >= tags.length -1 ) 
				{
					trace('complete')
					this.fxDone()
				}
			}		
			else
			{
				if ( a )
					this.indexProcessing = 0 
			}
			
			for  ( var i : int = 0; i <  tags.length; i++ ) 
			{
				  tag  = tags[i] as Tag2
				if ( indexProcessing != -1  )
				{
					if ( i != this.indexProcessing ) 
						continue; 
				}
				if ( tag.name == 'fff' ) 
				{
					//trace('fff');
				}
				var oldTag : Tag2 = oldTagNamesDict[tag.name]
				if ( oldTag == null ) 
				{
					createTags.push( oldTag ) 
					task =  'creating ' + tag.name
					trace(task) ; 
					tasks.push(task)		
						if ( a ) 
						{
							tag.unsetGuid(); 
							this.dispatchEvent( EvernoteAPICommandTriggerEvent.CreateTag( tag , this.onStepDone , this.onStepFault ))
						}
				}
				//old and link changed
				if (  oldTag != null &&  tag.parentGuid != oldTag.parentGuid )   
				{
					relinkTags.push( oldTag ) 
					var parentName : String = 'nothing'; 
					if ( tag.parentGuid != null ) 
						parentName = guidsToTagDict[tag.parentGuid].name
					task = 'change link of ' + tag.name + ' to ' +parentName
					trace(task) ; 
					tasks.push(task)	
					if ( a ) 
					{
						this.dispatchEvent( EvernoteAPICommandTriggerEvent.UpdateTag( tag , this.onStepDone , this.onStepFault ))
					}						
				}		
				//new and add link
				if ( oldTag == null &&   tag.parentGuid != null )   
				{
					relinkTags.push( oldTag ) 
					task ='link new upto ' + tag.name
					trace(task) ; 
					tasks.push(task)		
					if ( a ) 
					{
						this.dispatchEvent( EvernoteAPICommandTriggerEvent.UpdateTag( tag , this.onStepDone , this.onStepFault ))
					}							
				}
				//destroy
				if ( destroy.indexOf( tag.name ) != -1 )   
				{
					//relinkTags.push( oldTag ) 
					task = 'delete ' + tag.name
					trace(task) ; 
					tasks.push(task)				
					if ( a ) 
					{
						this.dispatchEvent( EvernoteAPICommandTriggerEvent.ExpungeTag( tag.guid , this.onStepDone , this.onStepFault ))
					}							
				}					
			}
			for  ( var oldTagName : String  in renameDict ) 
			{
				var renameTo : String = renameDict[oldTagName]
				//creataeTgs.push( oldTag ) 
				task =  'rename ' + oldTagName + ' to ' + renameTo 
				trace(task) ; 
				tasks.push(task)
			}	
			//export text based array ... use the roots on the NEW array 
			//all children in children array
			var txt : String = '';
			for each (   tag   in roots ) 
			{	
				var clonedTagForPrinting : Tag2 = tag.clone()
				if (   renameDict[oldTagName] != null ) 
					clonedTagForPrinting.name =  renameDict[oldTagName]
				txt = this.printMe( tag, txt ) 
			}
			return [[], txt, tasks];
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
 
			
		public var dispatchEvent : Function 
	}
}
package org.syncon.evernote.basic.view
{
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Tag;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.TextFlow;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.controller.EvernoteAPIHelperCommandTriggerEvent;
	import org.syncon.evernote.basic.controller.EvernoteToTextflowCommandTriggerEvent;
	import org.syncon.evernote.basic.controller.NoteListEvent;
	import org.syncon.evernote.basic.controller.SaveNoteCommandTriggerEvent;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.model.EvernoteAPIModelEvent;
	import org.syncon.evernote.basic.vo.MenuAutomationVO;
	import org.syncon.evernote.model.Note2;
	import org.syncon.popups.controller.ShowPopupEvent;
	import org.syncon.popups.controller.default_commands.ShowAlertMessageTriggerEvent;
	import org.syncon.popups.controller.default_commands.ShowConfirmDialogTriggerEvent;

	/**
	 * 
	 * whenin switch mode, you cannot save the normal way , u cannot call that same 
	 * resultfx b/c it wants to go back to list mode .... here you don't actulaly change the m
	 * mode fi the saing is being done automatically ... so send that to temp save
	 * non-blocking save 
	 * 
	 * also you have to udpate everythign whendone .... but by then u've trashed the note, 
	 * params wouldbe great in this instance ... i could find the note from the array?
	 * 
	 * don't ave the not unless its' dirty 
	 * 
	 * would like to have new notes up top so i can think about them 
	 * need x button on notes itemrenderer, some weird focus bug 
	 * 
	 * save teh cursor and scorll position please ....
	 * */
	public class RightSideMediator extends Mediator
	{
		[Inject] public var ui:right_side;
		[Inject] public var model : EvernoteAPIModel;
		static public var StateView : String = 'view'
		static public var StateList : String = ''
		static public var StateEditor : String = 'edit'
		//static public var StateSearch : String = 'search'
		private var switchLoaded : Boolean = false; 
		private var _note :  Note2 = new Note2()
			
		private function set note ( n : Note2 )  : void
		{
			if ( this.switchLoaded ) 
			{
				//this.ui.edit.saveTemp(true); 
				this.switchLoaded = false; 
			}
			this._note = n; 	
		}
		
		private function get note() : Note2 
		{
			return this._note; 
		}
			
			/**
			 * Refernce to note user selected from the list, this ensures the 
			 * list is updated immedeatly 
			 * */
		//private var clickedNote : Note2 = new Note2()
		public var control : Boolean = false; 
		public var shift : Boolean = false; 
		public var numpad0 : Boolean = false; 
		public var allowSimpleLoading : Boolean = false; 
		public function RightSideMediator()
		{
		} 
		
		override public function onRegister():void
		{
			ui.addEventListener( 'clickedNote', this.onNoteClicked ) 
			ui.addEventListener( 'clicked'+'New', this.onNewClicked ) 
			ui.addEventListener( 'clicked'+'List', this.onListClicked ) 
			ui.addEventListener( 'clicked'+'Edit', this.onEditClicked ) 				
			ui.addEventListener( 'clicked'+'Email',this.onEmailClicked ) 
			ui.addEventListener( 'clicked'+'Delete',this.onDeleteClicked ) 
			ui.addEventListener( 'clicked'+'Print', this.onPrintClicked ) 
			ui.addEventListener( 'clicked'+'Save and Close', this.onSaveAndClose ) 				
			
			ui.addEventListener( 'getNoteTagNames', this.onGetNoteTagNames ) 
				
			ui.addEventListener( 'clicked'+'Sort', this.onSort ) 								
				
			/*
			eventMap.mapListener(eventDispatcher, StockPricePopupEvent.SHOW_POPUP, onShowPopup );
			eventMap.mapListener(eventDispatcher, StockPricePopupEvent.HIDE_POPUP, onHidePopup);
			*/
			eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.NOTES_RESULT, this.onNoteResult);
			eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.NOTES_CHANGED, this.onNotesChanged);
			
			eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.SEARCH_RESULT, this.onSearchResult);	
			eventMap.mapListener(eventDispatcher, NoteListEvent.SWITCH_TO_NOTE, this.onSwitchBackToNote);	
			eventMap.mapListener(eventDispatcher, NoteListEvent.CLEARED_NOTES, this.onClearedNotes );				
			
			
			ui.list.notes = this.model.notes; 
			
			ui.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown )
			ui.stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp ) 		
				
			this.ui.lblCtrl.visible = this.ui.lblShift.visible = false; 
		}
		
		public function onKeyDown(e:KeyboardEvent):void
		{
			if ( e.keyCode == Keyboard.CONTROL )
			{
				this.control = true; 		
				this.ui.lblCtrl.visible = true; 
			}
			if ( e.keyCode == Keyboard.SHIFT )
			{
				this.shift = true; 		
				this.ui.lblShift.visible = true; 				
			}			
			if ( e.keyCode == Keyboard.NUMPAD_0 )
			{
				this.numpad0 = true; 		
				//this.ui.lblShift.visible = false; 				
			}				
		}
		public function onKeyUp(e:KeyboardEvent):void
		{
			if ( e.keyCode == Keyboard.CONTROL )
			{
				this.control = false; 	
				this.ui.lblCtrl.visible = false; 				
			}			
			if ( e.keyCode == Keyboard.SHIFT )
			{
				this.shift = false; 		
				this.ui.lblShift.visible = false; 				
			}	
			if ( e.keyCode == Keyboard.NUMPAD_0 )
			{
				this.numpad0 = false; 		
				//this.ui.lblShift.visible = false; 				
			}				
		}
		
		private function onNewNote()  : Note2
		{
			return this.model.createNewNote(); 
		}
		private function onNoteClicked(e:CustomEvent): void
		{
			var note_ : Note2 = e.data as Note2
			
			if ( allowSimpleLoading && shift == false ) 
			{
				
				this.note = note_; 
				//this.clickedNote= note_;
				//if ( this.alt, go to edit );
				ui.currentState = StateView
				ui.view.note = this.note
				
				
				if ( note_.content == null )
				{
					this.dispatch(   EvernoteAPICommandTriggerEvent.GetNote( note.guid,
						true, false, false, false, onNoteLoaded, onNoteNotLoaded  ) )
				}
			}
			
			if ( this.control || allowSimpleLoading == false  ) 
			{
				this.dispatch( new NoteListEvent( NoteListEvent.VIEW_NOTE, note_ ) )
			}
			//ui.view.loading = true; 
		}
			private function onNoteLoaded(note_: Note):void
			{
				//var note__ :  Note2 = new Note2()
				this.model.clone( this.note, note_ )
				this.updatedNote()
				//this.note = note__; 			
				ui.view.note = this.note; 

				this.convertNoteContents();
		
				//ui.view.loading = false; 
			}
			private function onNoteNotLoaded(note:Note):void
			{
				//ui.view.loading = false; 
			}		
		
		private function onGetNoteTagNames(e:CustomEvent): void
		{
			var note_ :  Note2 = e.data as Note2
			this.dispatch(   EvernoteAPICommandTriggerEvent.GetNoteTagNames2(
				note_, null
			) )
			
			//ui.view.loading = true; 
		}
		private function onTagsLoaded(e:Event):void
		{
			//note.dispatchEenet( 'tagsUpdated' ) 
		}
						
		public function convertNoteContents() : void
		{ 
			if ( this.numpad0 ) 
			{
				var msg : String =  this.note.content
				this.dispatch( new   ShowAlertMessageTriggerEvent(
					ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP,  msg) )  
			}			
			
			
			this.dispatch( new EvernoteToTextflowCommandTriggerEvent( 
				EvernoteToTextflowCommandTriggerEvent.IMPORT, this.note.content, 
				noteTextConvertToTf ) )			
		}
		/**
		 * Only occurs after note has been viewed ... 
		 * */
		public function noteTextConvertToTf( e  : TextFlow, chks : Array )  : void
		{
			//this.note.content = e; 
			updateContentText(e, chks )
		}
		public function updateContentText(tf:TextFlow, chks : Array )  : void
		{
			if ( ui.view != null && ui.view.viewer != null ) 
			{
				ui.view.viewer.conversionTFResult( tf, chks )
			}
			if ( ui.edit != null && ui.edit.editor != null ) 
			{
				ui.edit.editor.conversionTFResult( tf , chks )		
			}
		}

		
		private function onNewClicked(e:CustomEvent): void
		{
			if ( this.allowSimpleLoading &&   this.control == false )
			{
				ui.currentState = StateEditor
				ui.edit.note = this.onNewNote(); //note = e.data as Note
			}
			else
			{
				this.dispatch( new NoteListEvent( NoteListEvent.VIEW_NOTE, this.onNewNote() ) )
			}
			//ui.edit.onNew()
		}
		private function onListClicked(e:CustomEvent): void
		{
			ui.currentState =StateList
			this.dispatch( new NoteListEvent( NoteListEvent.DESELECTED  ) )
		}
		/**
		 * Assume data was loaded properly in viewer , 
		 * this is a bad assumption
		 * */
		private function onEditClicked(e:CustomEvent  ): void
		{
			ui.currentState = StateEditor
			//ui.edit.note = e.data as Note			
			if ( ui.edit == null ) 
			{
				import flash.utils.setTimeout; 
				setTimeout( this.onEditClicked, 500, e )
				return;
			}
			ui.edit.note = this.note; 	
			
			if ( this.note.content == null ) 
			{
				//loaded it first
				this.dispatch(   EvernoteAPICommandTriggerEvent.GetNote( note.guid,
					true, false, false, false, onNoteLoadedForEdit, onNoteNotLoaded  ) )
				return; 
			}
			
			this.convertNoteContents()
		}
			private function onNoteLoadedForEdit():void
			{
				this.convertNoteContents()
			}
		
		private function onSort(e:CustomEvent):void
		{
			
			var ee :  MenuAutomationVO = new MenuAutomationVO()
			ee.setupFlat( 
				['Created (newest first)',
					'Created (oldest first)',
					'Updated (newest first)',
					'Updated (oldest first)'],
				['Created (newest first)',
					'Created (oldest first)',
					'Updated (newest first)',
					'Updated (oldest first)'],
				null, 
				['created+', 'created-', 'updated+', 'updated-' ] ,
				[true, true, true, true]
			)
			ee.fx = onSortOption
			var goTo : UIComponent = this.ui.list//.menuButtons.list; //
			goTo =  new  UIComponent;
			goTo.x = this.ui.mouseX;
			goTo.y = this.ui.mouseY;
			this.dispatch( new ShowPopupEvent( ShowPopupEvent.SHOW_POPUP, 'utilsExtraOptionsPopup',[ ee, goTo, '', this.ui.stage.mouseX, this.ui.stage.mouseY ]  ) )  
		}
		
		public function onSortOption(n:String) : void
		{
			if ( n == '' ) 
			{
				
			}
			else if ( n == '' ) 
			{
				
			}
			else if ( n == '' ) 
			{
				
			}
			else if ( n == '' ) 
			{
				
			}			
			 return;
		}

/*		
		private function onSort(e:CustomEvent):void
		{
			
		}		
		*/
		
		/**
		 *  
		 * @param callbackFx
		 * @return if not was saved now or later
		 * 
		 */
		public function saveNote(callbackFx:Function=null) :  Boolean
		{
			if ( this.ui.edit  == null  ) 
				return false;
			if (  this.ui.edit.editor.isDirty() )
			{
				//send real note, and temporary it will be updated later on as necessary 
				var args : Object = this.ui.edit.getTemp()
				this.dispatch( 
					new SaveNoteCommandTriggerEvent( SaveNoteCommandTriggerEvent.SAVE_NOTE, args.note, 
						args.tf, callbackFx, 
						this.saveEditorSwitchedOutNoteFault )
					//this.ui.edit.saveTemp()
				)
					return true
			}			
			return false; 
		}
		
		private function onSaveAndClose(  e:CustomEvent): void
		{
			
			if ( this.saveNote( this.onNoteSaved ) == false ) 
				this.ui.currentState = RightSideMediator.StateList;
			/*
			//ui.view.loading = true; 				
		//	ui.view.note = this.note; 
			this.note.title = e.data.tempTitle; 
			
			
			this.note.tags = this.ui.edit.editor.listTags.tags
			this.note.tagNames = []
			this.note.tagGuids = []
			for each ( var tag :   Tag in  this.ui.edit.editor.listTags.tags )
			{
				//if ( guid != tag.guid ) 
				//	noteCopy.tagGuids.push( guid ) 
				this.note.tagGuids.push( tag.guid )
			}			
			
			var xml : XML = TextConverter.export(  e.data.tempContent as TextFlow,  
			TextConverter.TEXT_LAYOUT_FORMAT, ConversionType.XML_TYPE ) as XML//..toString()
			if ( e.data.hasOwnProperty('save') && e.data.save == false ) 
				return; 
			
			this.dispatch( new EvernoteToTextflowCommandTriggerEvent( 
				EvernoteToTextflowCommandTriggerEvent.EXPORT, 
				 xml.children().toXMLString(),
				onNoteContentConverted ) )
		 
			//this.note = ui.edit
			//ui.view.loading = false; 
				*/
		}
		
		//this implies they want to go back to 'edit' a note, note view it. 
		private function onSwitchBackToNote(e:NoteListEvent, wait : Boolean = true):void
		{
			//return;
 			if ( wait ) 
			{
				this.ui.callLater( this.onSwitchBackToNote, [e,false] ) 
					return; 
			}
			if ( this.control ) 
				return; 
			
				this.saveNote( saveEditorSwitchedOutNoteResult )
		 
			if ( this.note != null ) 
				this.note.selected = false
			this.note = e.data as  Note2;
			this.note.selected = true; 
			this.switchLoaded = true; 
	 		if ( this.model.moreThanXMinutesAgo( 5, this.note.lastRetrievedTime   ) &&
				this.note.newNote() == false )
			{ 
				this.dispatch(   EvernoteAPICommandTriggerEvent.GetNote( note.guid,
					true, false, false, false, onNoteLoaded2, onNoteNotLoaded2  ) )
					
		 }			
			else
			{
				this.onNoteLoaded2( null)
			} 
		}
			private function onNoteLoaded2(note_: Note):void
			{
				if ( note_ != null ) 
				{
				//var note__ :  Note2 = new Note2()
					this.model.clone( this.note, note_ )
					this.updatedNote()
					this.note.lastRetrievedTime = new Date();
				}
					//this.note = note__; 			
				//ui.view.note = this.note; 
				this.onEditClicked( null)
				//this.convertNoteContents();
				//ui.view.loading = false; 
			}
				private function onNoteNotLoaded2(note:Note):void
				{
					//ui.view.loading = false; 
				}				
			private function saveEditorSwitchedOutNoteResult( o:Object):void
			{
				return;
			}					
			private function saveEditorSwitchedOutNoteFault( o:Object):void
			{
				this.dispatch( new   ShowAlertMessageTriggerEvent(ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP, 'Could not save note...') )  
				return;
			}					
			
		/*
			private function onNoteContentConverted(str: String):void
			{
				//var note_ : Note = e.data as Note
				this.note.content = str
				var tempSaveNote : Note2 = new Note2()
				tempSaveNote.guid = this.note.guid
				tempSaveNote.content = str; 
				tempSaveNote.active = true; 
				tempSaveNote.title = this.note.titleOrTempTitle()
					this.dispatch(   EvernoteAPICommandTriggerEvent.UpdateNote( tempSaveNote,
						 onNoteSaved, onNoteSavedFault  ) )
			}			
*/
			private function onNoteSaved( o:Object):void
			{
				//remove temp content....
				//this.model.clone(   this.note )
				this.note.tempContent = ''; this.note.tempTitle = ''; 
				updatedNote()
				this.ui.list.list.list.dataProvider.refresh();
				ui.currentState = RightSideMediator.StateList;
				return;
			}					
			private function onNoteSavedFault( o:Object):void
			{
				var msg : String = 'Could not save note: ' //+ 
				this.dispatch( new   ShowAlertMessageTriggerEvent(ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP,  msg) )  
				//ui.currentState = StateView;
				return;
			}					
			
			
			/**
			 * Notifies lists that note has changed
			 * */
			private function updatedNote() : void
			{
				this.note.noteUpdated() 
				this.note.tagsUpdated()
			}
						
			
		private function onEmailClicked(e:CustomEvent): void
		{
		}
		private function onDeleteClicked(e:CustomEvent): void
		{
			var ee : ShowConfirmDialogTriggerEvent 
			var msg : String =  ''
			var title : String = 'Delete ' +e.data.length+ ' notes?'
			ee = new ShowConfirmDialogTriggerEvent(
				ShowConfirmDialogTriggerEvent.SHOW_CONFIRM_DIALOG_POPUP, msg, 
				this.onDeleteConfirmed, null, title, 'Delete', 'Cancel', [e.data] ) 
			this.dispatch( ee  )  			
		}
			private function onDeleteConfirmed(notes:Array)  : void
			{
				var ee : EvernoteAPIHelperCommandTriggerEvent
				this.dispatch(   EvernoteAPIHelperCommandTriggerEvent.DeleteNotes(  notes ,
					this.onNotesDeleted )  )			
			}
			private function onNotesDeleted(e:Object=null)  : void
			{
				
			}		
		private function onPrintClicked(e:CustomEvent): void
		{
		}		
 		/*
		private function onShowPopup(e:Event):void
		{
			this.popup.show()
		}			
		
		private function onHidePopup(e:Event):void
		{
			this.popup.hide()
		}					
		*/
		private function onNoteResult(e:EvernoteAPIModelEvent) : void
		{
			//need ot now when not to keep selection ... 
			this.ui.currentState = StateList
			this.ui.list.notes = e.data as ArrayCollection
			this.ui.list.list.selectedItems.removeAll() 
		}
		private function onNotesChanged(e:EvernoteAPIModelEvent) : void
		{
			
			
			this.ui.list.notes = e.data as ArrayCollection
			
			this.ui.list.list.selectedItems =  this.ui.list.list.selectedItems ;
			//this.ui.list.list.selectedItems
		}		
		private function onSearchResult(e:EvernoteAPIModelEvent) : void
		{
			this.ui.currentState = StateList
			this.ui.list.notes = e.data as ArrayCollection			
		}		
		
		private function onClearedNotes(e:NoteListEvent):void
		{
			this.ui.currentState = StateList
			this.refreshNoteList()
			//refresh? .. we will refresh the notes automatically if you can make it so it doesn't jump or 
				//remove selections or scroll positions
		}
		
		public function refreshNoteList() : void
		{
			
		}
		
	}
}
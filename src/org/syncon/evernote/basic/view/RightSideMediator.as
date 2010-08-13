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
	 * save teh cursor and scorll position please ....
	 * */
	public class RightSideMediator extends Mediator
	{
		[Inject] public var ui:right_side;
		[Inject] public var model : EvernoteAPIModel;
		static public var StateView : String = 'view'
		static public var StateList : String = ''
		static public var StateEditor : String = 'edit'
		static public var StateSearch : String = 'search'
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
			eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.SEARCH_RESULT, this.onSearchResult);	
			eventMap.mapListener(eventDispatcher, NoteListEvent.SWITCH_TO_NOTE, this.onSwitchBackToNote);	
			
			
			ui.list.notes = this.model.notes; 
			
			ui.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown )
			ui.stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp ) 					
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
		}
		
		private function onNewNote()  : Note2
		{
			return this.model.createNewNote(); 
		}
		private function onNoteClicked(e:CustomEvent): void
		{
			var note_ : Note2 = e.data as Note2
			if ( shift == false ) 
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
			if ( this.control ) 
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
			this.dispatch( new EvernoteToTextflowCommandTriggerEvent( 
				EvernoteToTextflowCommandTriggerEvent.IMPORT, this.note.content, 
				noteTextConvertToTf ) )			
		}
		/**
		 * Only occurs after note has been viewed ... 
		 * */
		public function noteTextConvertToTf( e  : String )  : void
		{
			//this.note.content = e; 
			updateContentText(e)
		}
		public function updateContentText(str:String)  : void
		{
			if ( ui.view != null && ui.view.viewer != null ) 
			{
				ui.view.viewer.conversionResult( str) 
			}
			if ( ui.edit != null && ui.edit.editor != null ) 
			{
				ui.edit.editor.conversionResult( str ) 				
			}
		}

		
		private function onNewClicked(e:CustomEvent): void
		{
			ui.currentState = StateEditor
			ui.edit.note = this.onNewNote(); //note = e.data as Note
			//ui.edit.onNew()
		}
		private function onListClicked(e:CustomEvent): void
		{
			ui.currentState =StateList
		}
		/**
		 * Assume data was loaded properly in viewer , 
		 * this is a bad assumption
		 * */
		private function onEditClicked(e:CustomEvent  ): void
		{
			ui.currentState = StateEditor
			//ui.edit.note = e.data as Note			
			ui.edit.note = this.note; 	
			
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
			var goTo : UIComponent = this.ui.list.menuButtons.list; //
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
		private function onSaveAndClose(  e:CustomEvent): void
		{
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
			/*	
			if ( this.ui.view.viewer != null ) 
				this.ui.view.viewer.txtContents.textFlow = this.ui.edit.editor.txtContents.textFlow;
			*/
			//this.note = ui.edit
			//ui.view.loading = false; 
		}
		
		//this implies they want to go back to 'edit' a note, note view it. 
		private function onSwitchBackToNote(e:NoteListEvent):void
		{
			//if in an edit mode ....
			if ( this.ui.edit != null  ) 
			{
				if (  this.ui.edit.editor.isDirty() )
				{
					var args : Object = this.ui.edit.getTemp()
					this.dispatch( 
						new SaveNoteCommandTriggerEvent( SaveNoteCommandTriggerEvent.SAVE_NOTE, args.note, 
						args.tf, this.saveEditorSwitchedOutNoteResult, 
						this.saveEditorSwitchedOutNoteFault )
					//this.ui.edit.saveTemp()
					)
				}
			}
			if ( this.note != null ) 
				this.note.selected = false
			this.note = e.data as  Note2;
			this.note.selected = true; 
			this.switchLoaded = true; 
		/*	if ( this.note.content == null )
			{*/
				this.dispatch(   EvernoteAPICommandTriggerEvent.GetNote( note.guid,
					true, false, false, false, onNoteLoaded2, onNoteNotLoaded2  ) )
					
				this
		/*	}			
			else
			{
				this.onEditClicked( null)
			}*/
		}
			private function onNoteLoaded2(note_: Note):void
			{
				//var note__ :  Note2 = new Note2()
				this.model.clone( this.note, note_ )
				this.updatedNote()
				//this.note = note__; 			
				//ui.view.note = this.note; 
				this.onEditClicked( null)
				this.convertNoteContents();
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
			
		
			private function onNoteContentConverted(str: String):void
			{
				//var note_ : Note = e.data as Note
				this.note.content = str
				var tempSaveNote : Note2 = new Note2()
				tempSaveNote.guid = this.note.guid
				tempSaveNote.content = str; 
				tempSaveNote.active = true; 
				tempSaveNote.title = this.note.titleOrTempTitle()
			/*	if ( note_.content == null )
				{*/
					this.dispatch(   EvernoteAPICommandTriggerEvent.UpdateNote( tempSaveNote,
						 onNoteSaved, onNoteSavedFault  ) )
				/*}*/
			}			

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
				this.dispatch( new   ShowAlertMessageTriggerEvent(ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP, 'Could not save note') )  
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
			this.ui.currentState = StateList
			this.ui.list.notes = e.data as ArrayCollection
		}
		private function onSearchResult(e:EvernoteAPIModelEvent) : void
		{
			this.ui.currentState = StateSearch
			this.ui.search.notes = e.data as ArrayCollection			
		}		
		
	}
}
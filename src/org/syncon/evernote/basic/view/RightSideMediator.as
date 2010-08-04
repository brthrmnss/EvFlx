package org.syncon.evernote.basic.view
{
	import com.evernote.edam.type.Note;
	
	import flash.events.Event;
	
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.TextFlow;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.controller.EvernoteToTextflowCommandTriggerEvent;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.model.EvernoteAPIModelEvent;
	
	public class RightSideMediator extends Mediator
	{
		[Inject] public var ui:right_side;
		[Inject] public var model : EvernoteAPIModel;
		static public var StateView : String = 'view'
		static public var StateList : String = ''
		static public var StateEditor : String = 'edit'
		static public var StateSearch : String = 'search'
			
		private var note : Note = new Note()
			
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
			/*
			eventMap.mapListener(eventDispatcher, StockPricePopupEvent.SHOW_POPUP, onShowPopup );
			eventMap.mapListener(eventDispatcher, StockPricePopupEvent.HIDE_POPUP, onHidePopup);
			*/
			eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.NOTES_RESULT, this.onNoteResult);
			eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.SEARCH_RESULT, this.onSearchResult);	
			
			ui.list.notes = this.model.notes; 
			
			
		}
		private function onNewNote()  : Note
		{
			
			return this.model.createNewNote(); 
		}
		private function onNoteClicked(e:CustomEvent): void
		{
			var note_ : Note = e.data as Note
			this.note = note_; 
			ui.currentState = StateView
			ui.view.note = e.data as Note
			if ( note_.content == null )
			{
				this.dispatch(   EvernoteAPICommandTriggerEvent.GetNote( note.guid,
					true, false, false, false, onNoteLoaded, onNoteNotLoaded  ) )
			}
			//ui.view.loading = true; 
		}

		private function onNoteLoaded(note_:Note):void
		{
			this.note = note_; 			
			ui.view.note = this.note; 
			this.dispatch( new EvernoteToTextflowCommandTriggerEvent( 
				EvernoteToTextflowCommandTriggerEvent.IMPORT, this.note.content, 
				noteTextConvertToTf ) )
			//ui.view.loading = false; 
		}
		
		
		
		private function onGetNoteTagNames(e:CustomEvent): void
		{
			var note_ : Note = e.data as Note
			this.dispatch(   EvernoteAPICommandTriggerEvent.GetNoteTagNames2(
				note_, null
			) )
			
			//ui.view.loading = true; 
		}
		private function onTagsLoaded(e:Event):void
		{
			//note.dispatchEenet( 'tagsUpdated' ) 
		}
						
		
		/**
		 * Only occurs after note has been viewed ... 
		 * */
		public function noteTextConvertToTf( e  : String )  : void
		{
			this.note.content = e; 
			updateContentText()
		}
		public function updateContentText()  : void
		{
			if ( ui.view != null && ui.view.viewer != null ) 
			{
				ui.view.viewer.conversionResult( this.note.content ) 
			}
			if ( ui.edit != null && ui.edit.editor != null ) 
			{
				ui.edit.editor.conversionResult( this.note.content ) 				
			}
		}
		
		private function onNoteNotLoaded(note:Note):void
		{
			//ui.view.loading = false; 
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
		private function onEditClicked(e:CustomEvent): void
		{
			ui.currentState = StateEditor
			//ui.edit.note = e.data as Note			
			ui.edit.note = this.note; 	
			
			this.updateContentText()
		}
		
		private function onSaveAndClose(  e:CustomEvent): void
		{
			//ui.view.loading = true; 				
		//	ui.view.note = this.note; 
			this.note.title = e.data.title; 
			var xml : XML = TextConverter.export(  e.data.content as TextFlow,  
				TextConverter.TEXT_LAYOUT_FORMAT, ConversionType.XML_TYPE ) as XML//..toString()
			var ee :  TextConverter
			var eee :   ConversionType
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
		
			private function onNoteContentConverted(str: String):void
			{
				//var note_ : Note = e.data as Note
				this.note.content = str
			/*	if ( note_.content == null )
				{*/
					this.dispatch(   EvernoteAPICommandTriggerEvent.UpdateNote( this.note,
						 onNoteSaved, onNoteSavedFault  ) )
				/*}*/
			}			
			
			private function onNoteSaved( o:Object):void
			{
				//ui.currentState = StateView;
				 return;
			}					
			private function onNoteSavedFault( o:Object):void
			{
				//ui.currentState = StateView;
				return;
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
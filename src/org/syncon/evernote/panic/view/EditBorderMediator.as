package  org.syncon.evernote.panic.view
{
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
 
	public class EditBorderMediator extends Mediator  
	{
		[Inject] public var ui:    EditBorder;
		[Inject] public var model : PanicModel;
			
		public var highligtSelectionMode : Boolean = false; 
		
		public function EditBorderMediator()
		{
		} 
		
		override public function onRegister():void
		{
			ui.addEventListener( EditBorder.CLICKED , onClickedHandler ) 	
			ui.addEventListener( EditBorder.CLICKED_REMOVE , onClickedRemoveHandler ) 
			/*	
			ui.addEventListener( EditBorder.CLICKED_LEFT, onClickedRemoveHandler ) 
			ui.addEventListener( EditBorder.CLICKED_RIGHT, onClickedRemoveHandler ) 				
			*/	
			//we don't capture Edit
				//ui.addEventListener( EditBorder.CLICKED_EDIT , onClickedHandler ) 		
			/*
			 ui.addEventListener( EditBorder.CLICKED_EDIT , onClickedHandler ) 		
			 ui.addEventListener( EditBorder.CLICKED_UP , onClickedUpHandler ) 	
			 ui.addEventListener( EditBorder.CLICKED_DOWN , onClickedDownHandler ) 		
			*/
			 eventMap.mapListener(eventDispatcher, PanicModelEvent.HIGHLIGHT_CERTAIN_ITEMS, 
				 this.onHighlighCertainItems);	
			 eventMap.mapListener(eventDispatcher, PanicModelEvent.HIGHLIGHT_CERTAIN_ITEMS_SELECTED, 
				 this.onHighlighCertainItems_Selected);				 
		}
		 
		private function onHighlighCertainItems(e:PanicModelEvent): void
		{
			var highlightTypes :  Array =  e.data as  Array
			if ( highlightTypes.indexOf( this.ui.parentDocument.widgetData.type  ) == -1 )
			{
				leaveSelectionMode()
				return
			}
			this.highligtSelectionMode = true
			this.ui.show()
		}	
		private function onHighlighCertainItems_Selected(e:PanicModelEvent): void
		{
			leaveSelectionMode()
			if ( this.model.editMode )
				this.ui.show()
		}			
			private function leaveSelectionMode()  : void
			{
				this.highligtSelectionMode = false
				this.ui.hide()
			}
		
		private function onClickedHandler(e:CustomEvent): void
		{
			if ( this.highligtSelectionMode ) 
				this.dispatch( new PanicModelEvent( PanicModelEvent.HIGHLIGHT_CERTAIN_ITEMS_SELECTED, this.ui.parentDocument ) )  
		}		
		
		private function onClickedRemoveHandler(e:CustomEvent): void
		{
			//confirm popup
		}				
		
		
		private function onHighlightRows(e:PanicModelEvent): void
		{
			this.ui.hide()
		}	
		
		private function onRowSelected(e:PanicModelEvent): void
		{
			if ( this.model.editMode )
				this.ui.show()
		}			
		

		
		private function onClickedUpHandler(e:CustomEvent): void
		{
			var index : int = this.model.boardHolder.getChildIndex( this.ui.parent ) 
			if ( index != 0 ) 
				this.model.boardHolder.swapElementsAt( index, index-1 ) 
		}
		
		private function onClickedDownHandler(e:CustomEvent): void
		{
			var index : int = this.model.boardHolder.getChildIndex( this.ui.parent ) 
			if ( index != this.model.boardHolder.numChildren-1 ) 
				this.model.boardHolder.swapElementsAt( index, index+1 ) 			
		}		
		 
	}
}
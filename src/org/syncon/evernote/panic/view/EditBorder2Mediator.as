package  org.syncon.evernote.panic.view
{
	import flash.utils.setTimeout;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.popups.controller.ShowPopupEvent;
 
	public class EditBorder2Mediator extends Mediator  
	{
		[Inject] public var ui:    EditBorder2;
		[Inject] public var model : PanicModel;
		
		/**
		 * Flag indicates if we should dispatch clicked event when used
		 * */
		private var highligtSelectionMode : Boolean = false; 
		
		public function EditBorder2Mediator()
		{
		} 
		
		override public function onRegister():void
		{
			 ui.addEventListener( EditBorder2.CLICKED_EDIT , onClickedEditHandler ) 		
			 ui.addEventListener( EditBorder2.CLICKED , onClickedHandler ) 						 
			 ui.addEventListener( EditBorder2.CLICKED_UP , onClickedUpHandler ) 	
			 ui.addEventListener( EditBorder2.CLICKED_DOWN , onClickedDownHandler ) 	
			 ui.addEventListener( EditBorder2.CLICKED_REMOVE , onClickedRemoveHandler ) 
				 				 
				 
			 eventMap.mapListener(eventDispatcher, PanicModelEvent.HIGHLIGHT_CERTAIN_ITEMS, 
				 this.onHighlighCertainItems);		
			 eventMap.mapListener(eventDispatcher, PanicModelEvent.HIGHLIGHT_CERTAIN_ITEMS_SELECTED, 
				 this.onHighlighCertainItems_Selected);			
			 
			 ui.addEventListener( EditBorder2.SHOW , onShowHandler ) 		
			 /**
			 * Show edit is controled by boardrowwidgemediator thi sis confusing 
			 * */
			 
			 eventMap.mapListener(eventDispatcher, PanicModelEvent.CHANGED_SKIN, 
				 this.onSkinChanged );						
			 this.onSkinChanged(null)					 
		}
		 
		public function onSkinChanged(e:PanicModelEvent): void
		{
			//change bg color And that text color for that message
			this.ui.bgColor.color = this.model.backgroundColor; 
			this.ui.txtInstructions.setStyle( 'color', this.model.color ); 
		}				
		
		private function onHighlighCertainItems(e:PanicModelEvent): void
		{
			var highlightTypes :  Array =  e.data as  Array
				
			if ( this.model.editMode )
				this.ui.show()						
	 
			if ( highlightTypes.indexOf( WidgetVO.ROW ) == -1 ) 
			{
				this.ui.hide()
				return; 
			}
			 
			/*		
			//if a type is on a row ... don't highlight that row 
			//go through all elements on row, and see if you can match that type
			var parent : BoardRow = this.ui.parentDocument as  BoardRow
			for ( var z : int =0 ; z < parent.content.numElements; z++ )
			{
				var   j :  UIComponent  = parent.content.getElementAt(z)  as UIComponent
				if ( j is IUIWidget ) 
				{
					if (  highlightTypes.indexOf(  ( j as IUIWidget ).widgetData.type ) != -1  )
					{
						this.ui.hide()
						return
					}
				}
			}
			*/
			
			//if we are adding a row say after, 
			//if we are adding anything else, say, 'to this row'
			this.goToHighlightMode()
		}
		
		public function goToHighlightMode() : void
		{
			this.ui.show()
			this.ui.txtInstructions.visible = true 
			this.highligtSelectionMode = true
			this.ui.highlightBordersOnRollover = true; 
			this.ui.clickableShade.visible = true; 
			this.onShowHandler(null)	
			
			this.ui.holderForEditing.visible = false; 
			//hide up and down arrows 
		}
			
		public function leaveHighlightMode() : void
		{
			this.ui.txtInstructions.visible = false 		
			this.highligtSelectionMode = false
			this.ui.highlightBordersOnRollover = false; 
			this.ui.clickableShade.visible = false;		
			
			this.ui.holderForEditing.visible = true; 
		}		
		
		public function onShowHandler( e :  CustomEvent)  : void
		{	
			var parent : BoardRow = this.ui.parentDocument as  BoardRow
			var dd : Array = [parent.parent.getChildIndex( parent ) ]
			if (   parent.parent.getChildIndex( parent ) == 0  ) 
			{
				this.ui.btnUp.visible = false; 
			}
			else
			{
				this.ui.btnUp.visible = true
			}			
			if ( parent.parent.numChildren -1 == parent.parent.getChildIndex( parent ) ) 
			{
				this.ui.btnDown.visible = false; 
			}
			else
			{
				this.ui.btnDown.visible = true
			}
		}			
		
		private function onHighlighCertainItems_Selected(e:PanicModelEvent): void
		{
			if ( this.model.editMode )
				this.ui.show()
			this.leaveHighlightMode()		
		}			

		private function onClickedHandler(e:CustomEvent): void
		{
			if ( this.highligtSelectionMode ) 
				this.dispatch( new PanicModelEvent( PanicModelEvent.HIGHLIGHT_CERTAIN_ITEMS_SELECTED, this.ui.parentDocument ) ) 
		}
		
		
		private function onClickedEditHandler(e:CustomEvent): void
		{
			
		}
				
		private function onClickedUpHandler(e:CustomEvent): void
		{
			var index : int = this.model.boardHolder.getChildIndex( this.ui.parent ) 
			if ( index != 0 ) 
				this.model.boardHolder.swapElementsAt( index, index-1 ) 
			//redraw arrows
			//this.onShowHandler(null)
			//(this.model.boardHolder.getElementAt( index) as BoardRow).dispatchEvent( 	new CustomEvent( EditBorder2.SHOW ) ) 
			this.ui.callLater( this.updateSwitchedArrows, [index, index-1] ) 		
		}
		
		private function onClickedDownHandler(e:CustomEvent): void
		{
			var index : int = this.model.boardHolder.getChildIndex( this.ui.parent ) 
			if ( index != this.model.boardHolder.numChildren-1 ) 
				this.model.boardHolder.swapElementsAt( index, index+1 ) 	
			
			this.ui.callLater( this.updateSwitchedArrows, [index, index+1] ) 
		/*	this.onShowHandler(null)
			var otherThing :  BoardRow = this.model.boardHolder.getElementAt( index)  as BoardRow ;
				var dd : Object = [this.model.boardHolder.getChildAt( index), this.model.boardHolder.getElementAt( index)    ];
				otherThing.dispatchEvent( 	new CustomEvent( EditBorder2.SHOW ) ) 	*/				
		}		
		 
		private function updateSwitchedArrows(i : int, i2 : int, wait :  Boolean = true) : void
		{
		/*	if ( wait ) { 
				flash.utils.setTimeout( this.updateSwitchedArrows, 500, i, i2, false ) 
				return	
			}*/
		
			//this.onShowHandler(null)
			var otherThing :  BoardRow = this.model.boardHolder.getElementAt( i)  as BoardRow ;
			otherThing.editBorder.dispatchEvent( 	new CustomEvent( EditBorder2.SHOW ) ) 	
			otherThing = this.model.boardHolder.getElementAt( i2)  as BoardRow ;
			otherThing.editBorder.dispatchEvent( 	new CustomEvent( EditBorder2.SHOW ) ) 					
		}
		
		private function onClickedRemoveHandler(e:CustomEvent): void
		{
			//confirm popup
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'popup_confirm', ['Are you sure you want to remove this row? '+
					'This change cannot be undone.', this.onRemoveComponent ] )  )
		}				
		private function onRemoveComponent () : void
		{
			this.model.boardHolder.removeElement( this.ui.parent as IVisualElement) 
			if ( this.model.boardHolder.numChildren == 0 ) 
			{
				this.model.addRow()
			}
		}		
		
		
		
	}
}
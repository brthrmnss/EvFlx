package  org.syncon.evernote.panic.view
{
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.model.BoardModelEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	import spark.components.Group;
	import spark.components.HGroup;
 
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
				
			ui.addEventListener( EditBorder.CLICKED_LEFT , onClickedLeftHandler ) 	
			ui.addEventListener( EditBorder.CLICKED_RIGHT , onClickedRightHandler ) 	
				
			ui.addEventListener( EditBorder.ADJUST_ARROWS , onShowHandler ) 	
			this.onShowHandler(null)	
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
			 eventMap.mapListener(eventDispatcher, BoardModelEvent.HIGHLIGHT_CERTAIN_ITEMS, 
				 this.onHighlighCertainItems);	
			 eventMap.mapListener(eventDispatcher, BoardModelEvent.HIGHLIGHT_CERTAIN_ITEMS_SELECTED, 
				 this.onHighlighCertainItems_Selected);		
			 
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
			if ( highlightTypes.indexOf( this.ui.parentDocument.widgetData.type  ) == -1 )
			{
				leaveSelectionMode()
				return
			}
			this.highligtSelectionMode = true
			this.ui.highlightBordersOnRollover = true; 
			this.ui.show()
			this.ui.txtInstructions.visible = true 	
			this.onShowHandler(null)	
		}	
		private function onHighlighCertainItems_Selected(e:PanicModelEvent): void
		{
			
			leaveSelectionMode()
			if ( this.model.editMode )
				this.ui.show()
		}			
			private function leaveSelectionMode()  : void
			{
				this.ui.highlightBordersOnRollover = false; 
				this.ui.txtInstructions.visible = false 
				this.highligtSelectionMode = false
				this.ui.hide()
			}
		
		private function onClickedHandler(e:CustomEvent): void
		{
			if ( this.highligtSelectionMode ) 
				this.dispatch( new PanicModelEvent( BoardModelEvent.HIGHLIGHT_CERTAIN_ITEMS_SELECTED, this.ui.parentDocument ) )  
		}		
		
		private function onClickedRemoveHandler(e:CustomEvent): void
		{
			//confirm popup
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'popup_confirm', ['Are you sure you want to remove this component? '+
				'This change cannot be undone.', this.onRemoveComponent ] )  )
		}				
			private function onRemoveComponent () : void
			{
				var percentWidth : Number = 100* 1/(this.row.numElements-1)
				for ( var z : int =0 ; z < this.row.numElements; z++ )
				{
					var j : UIComponent  = this.row.getElementAt(z)  as  UIComponent; 
					j.percentWidth = percentWidth
				}					
				this.row.removeElement( this.ui.parent as IVisualElement) 
						
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
		

		/*
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
		*/
		public function get row ()  :  HGroup
		{
			var p :  BoardRow = this.ui.parentDocument.parentDocument as BoardRow
				
			return p.content
		}
		
		private function onClickedLeftHandler(e:CustomEvent): void
		{
			var rowHolder :    HGroup  = this.row
			var index : int = rowHolder.getChildIndex( this.ui.parent ) 
			if ( index != 0 ) 
			{
				rowHolder.swapElementsAt( index, index-1 ) 
				this.ui.callLater( this.updateSwitchedArrows, [index, index-1] )
			}
		}
		
		private function onClickedRightHandler(e:CustomEvent): void
		{
			var rowHolder :    HGroup  = this.row
			var index : int = rowHolder.getChildIndex( this.ui.parent ) 
			if ( index != rowHolder.numChildren-1 ) 
			{
				rowHolder.swapElementsAt( index, index+1 ) 	
				this.ui.callLater( this.updateSwitchedArrows, [index, index+1] )
			}
		}			
		
		private function updateSwitchedArrows(i : int, i2 : int, wait :  Boolean = true) : void
		{
			var rowHolder :    HGroup  = this.row
			var otherThing : Object = rowHolder.getElementAt( i) as Object ;
			otherThing.editBorder.dispatchEvent( new CustomEvent( EditBorder.ADJUST_ARROWS )) 	
			otherThing = rowHolder.getElementAt( i2)  as Object ;
			otherThing.editBorder.dispatchEvent( new CustomEvent( EditBorder.ADJUST_ARROWS )) 					
		}		
		
		public function onShowHandler( e :  CustomEvent)  : void
		{	
			var rowHolder :    HGroup  = this.row
			var parent : UIComponent = this.ui.parentDocument as UIComponent
			//try to set name and desc
			this.ui.lblName.text = this.ui.parentDocument.widgetData.name
			this.ui.lblDesc.text = this.ui.parentDocument.widgetData.description
				this.ui.iconType.iconSkin = WidgetVO.GetXForType( this.ui.parentDocument.widgetData.type, 'icon' ) 
				this.ui.iconType.toolTip = 'Type: ' +WidgetVO.GetXForType( this.ui.parentDocument.widgetData.type, 'name' ) 
					
			var dd : Array = [parent.parent.getChildIndex( parent ) ]
			if (   parent.parent.getChildIndex( parent ) == 0  ) 
			{
				this.ui.btnLeft.visible = false; 
			}
			else
			{
				this.ui.btnLeft.visible = true
			}			
			if ( parent.parent.numChildren -1 == parent.parent.getChildIndex( parent ) ) 
			{
				this.ui.btnRight.visible = false; 
			}
			else
			{
				this.ui.btnRight.visible = true
			}
		}	
		
	}
}
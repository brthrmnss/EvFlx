package  org.syncon.evernote.panic.view
{
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.vo.WidgetVO;
	
	import spark.components.Group;
	
	public class AddWidgetMediator extends Mediator  
	{
		[Inject] public var ui:   AddWidget;
		[Inject] public var model : PanicModel;
		
		private var addingA : String = ''; 
		
		public function AddWidgetMediator()
		{
		} 
		
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, PanicModelEvent.EDIT_MODE_CHANGED, 
				this.onEditModeChanged);	
			this.onEditModeChanged(null)
				
			ui.addEventListener(AddWidget.addItem, onClickedHandler ) 		
			ui.addEventListener('cancelSelect', onCancelHandler ) 		
			
			eventMap.mapListener(eventDispatcher, PanicModelEvent.HIGHLIGHT_CERTAIN_ITEMS_SELECTED, 
				this.onElementSelected);					
		}
		
		private function onEditModeChanged(e:PanicModelEvent): void
		{
			if ( this.model.editMode ) 
				this.ui.show()
			else
				this.ui.hide();
		}
		
		private function onClickedHandler(e:CustomEvent): void
		{
			if ( e.data == WidgetVO.GRAPH ) 
			{
				this.ui.message = 'Select the element to go after'
				this.ui.btnCancel.visible = true; 
				this.dispatch( new PanicModelEvent( PanicModelEvent.HIGHLIGHT_CERTAIN_ITEMS, [WidgetVO.GRAPH, WidgetVO.ROW] )  )
				this.addingA = WidgetVO.GRAPH; 
			}
		}
		
		public function onCancelHandler(e:CustomEvent)  : void
		{
			this.ui.message = ''
			this.ui.list.selectedIndex = -1	
			this.ui.btnCancel.visible = false; 
			this.addingA = null 
			this.dispatch( new PanicModelEvent( PanicModelEvent.HIGHLIGHT_CERTAIN_ITEMS_SELECTED ) ) 
			
		}
		
		private function onElementSelected(e:PanicModelEvent): void
		{
			
			var ui : Object = e.data; 
			var row : BoardRow; 
			if ( addingA == WidgetVO.GRAPH ) 
			{
				
				if ( ui is BoardRow ) 
				{
					row = (ui as BoardRow)
					var x :  Group = row.parent as Group; //.getElementIndex( row )
					var index : int = x.getElementIndex( row ) 
					row = new BoardRow()
					row.percentWidth = 100; 
					x.addElementAt( row, index+1 ) ; //
				}
				else
					row = ui.parentDocument as BoardRow
				
				row.addWidget( GraphWidget.importData( 'new', '', 'new', 'new', 10, 12,  0xFFDDFF )  )
									
			}
			this.ui.message = ''
			this.ui.list.selectedIndex = -1
		}		
	
}
}
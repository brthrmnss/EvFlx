package  org.syncon.evernote.panic.view
{
	import mx.core.UIComponent;
	
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
		private var left : Boolean = true
			
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
			ui.addEventListener('moveWidget', onMoveWidgetHandler ) 		
			
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
			if ( e.data == WidgetVO.MESSAGE ) 
			{
				this.ui.message = 'Select the element to go after'
				this.ui.btnCancel.visible = true; 
				this.dispatch( new PanicModelEvent( PanicModelEvent.HIGHLIGHT_CERTAIN_ITEMS, [ WidgetVO.ROW] )  )
				this.addingA = WidgetVO.MESSAGE; 
			}				
			if ( e.data == WidgetVO.PANE ) 
			{
				this.ui.message = 'Select the element to go after'
				this.ui.btnCancel.visible = true; 
				this.dispatch( new PanicModelEvent( PanicModelEvent.HIGHLIGHT_CERTAIN_ITEMS, [WidgetVO.PANE, WidgetVO.ROW] )  )
				this.addingA = WidgetVO.PANE; 
			}		
			if ( e.data == WidgetVO.PROJECT_LIST ) 
			{
				this.ui.message = 'Select the element to go after'
				this.ui.btnCancel.visible = true; 
				this.dispatch( new PanicModelEvent( PanicModelEvent.HIGHLIGHT_CERTAIN_ITEMS, [ WidgetVO.ROW] )  )
				this.addingA = WidgetVO.PROJECT_LIST; 
			}				
			if ( e.data == WidgetVO.SPACER ) 
			{
				this.ui.message = 'Select the element to go after'
				this.ui.btnCancel.visible = true; 
				this.dispatch( new PanicModelEvent( PanicModelEvent.HIGHLIGHT_CERTAIN_ITEMS, [WidgetVO.ROW] )  )
				this.addingA = WidgetVO.SPACER; 
			}
			if ( e.data == WidgetVO.TWITTER_SCROLLER ) 
			{
				this.ui.message = 'Select the element to go after'
				this.ui.btnCancel.visible = true; 
				this.dispatch( new PanicModelEvent( PanicModelEvent.HIGHLIGHT_CERTAIN_ITEMS, [  WidgetVO.ROW] )  )
				this.addingA = WidgetVO.TWITTER_SCROLLER; 
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
		
		private function onMoveWidgetHandler(e:CustomEvent) : void
		{
			this.left = ! this.left 
			if ( this.left ) 
			{
				this.ui.currentState = 'left'
			}
			else
			{
				this.ui.currentState = 'right'
			}
		}
			
		
		private function onElementSelected(e:PanicModelEvent): void
		{
			
			var ui : Object = e.data; 
			var row : BoardRow; 
			if ( addingA == WidgetVO.GRAPH ) 
			{
				row = getRowOrFindParentRow( ui  )				
				row.addWidget( GraphWidget.importData( 'new', '', 'new', 'new', 10, 12,  0xFFDDFF )  )
			}
			if ( addingA == WidgetVO.PANE ) 
			{
				row = getRowOrFindParentRow( ui  )				
				row.addWidget( PaneWidget.importData( 'Global Alert', '', 'Something1', 15000,  '0x4D4844', '0x0E0E0E' )  )
			}
			if ( addingA == WidgetVO.MESSAGE ) 
			{
				row = getRowOrFindParentRow( ui  )				
				row.addWidget( MessageWidget.importData('Global Alert', '', 'New Alert' , 15000)  )
			}
			if ( addingA == WidgetVO.TWITTER_SCROLLER ) 
			{
				row = getRowOrFindParentRow( ui  )				
				row.addWidget( TwitterScrollerTest2.importData('Twitter Pane', '...', 'Panic Board',  15000)  )
			}
			if ( addingA == WidgetVO.PROJECT_LIST ) 
			{
				row = getRowOrFindParentRow( ui  )				
				row.addWidget( ProjectListWidget.importData('Project Lister', '', 355, 15000)  )
			}			
			if ( addingA == WidgetVO.SPACER ) 
			{
				row = getRowOrFindParentRow( ui  )				
				row.addWidget( SpacerWidget.importData( 'spacer', '', 30  ) )
			}		 
			this.ui.message = ''
			this.ui.list.selectedIndex = -1
		}		
	
		public function getRowOrFindParentRow ( ui :  Object )  : BoardRow
		{
			var row : BoardRow; 
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
					
			return row 
		}
		
}
}
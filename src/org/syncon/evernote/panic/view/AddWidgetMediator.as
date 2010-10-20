package  org.syncon.evernote.panic.view
{
	import mx.core.UIComponent;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.BuildBoardCommandTriggerEvent;
	import org.syncon.evernote.panic.model.BoardModelEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.vo.GalleryWidgetVO;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	import spark.components.Group;
	
	public class AddWidgetMediator extends Mediator  
	{
		[Inject] public var ui:   AddWidget;
		[Inject] public var model : PanicModel;
		
		private var addingA : String = ''; 
		private var left : Boolean = true
			
		/**
		 * Add to rows, index it later
		 * */
		private var rowMode : Boolean = true; 
			
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
			ui.addEventListener(AddWidget.SELECT_GALLERY, onSelectGallery ) 	
			eventMap.mapListener(eventDispatcher, BoardModelEvent.HIGHLIGHT_CERTAIN_ITEMS_SELECTED, 
				this.onElementSelected);		
			eventMap.mapListener(eventDispatcher, BoardModelEvent.CLICKED_BOARD, 
				this.onElementSelected_isBoard);				
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
			var all : Array = [WidgetVO.GRAPH, WidgetVO.MESSAGE, WidgetVO.PANE, WidgetVO.PROJECT_LIST,
				WidgetVO.SPACER, WidgetVO.TWITTER_SCROLLER, WidgetVO.ROW]
			if (rowMode )
			{
				all = [WidgetVO.ROW]
			}
			if ( e.data == WidgetVO.GRAPH ) 
			{
				this.ui.message = 'Select the element to go after'
				this.ui.btnCancel.visible = true; 
				var types : Array = [WidgetVO.GRAPH, WidgetVO.ROW]
				types = all; 
				this.dispatch( new PanicModelEvent( BoardModelEvent.HIGHLIGHT_CERTAIN_ITEMS, types )  )
				this.addingA = WidgetVO.GRAPH; 
			}
			if ( e.data == WidgetVO.MESSAGE ) 
			{
				this.ui.message = 'Select the element to go after'
				this.ui.btnCancel.visible = true; 
				types  = [WidgetVO.ROW]
				types = all; 
				this.dispatch( new PanicModelEvent( BoardModelEvent.HIGHLIGHT_CERTAIN_ITEMS, types )  )
				this.addingA = WidgetVO.MESSAGE; 
			}				
			if ( e.data == WidgetVO.PANE ) 
			{
				this.ui.message = 'Select the element to go after'
				this.ui.btnCancel.visible = true; 
				types = [WidgetVO.PANE, WidgetVO.ROW]
				types = all; 
				this.dispatch( new PanicModelEvent( BoardModelEvent.HIGHLIGHT_CERTAIN_ITEMS, types)  )
				this.addingA = WidgetVO.PANE; 
			}		
			if ( e.data == WidgetVO.PROJECT_LIST ) 
			{
				this.ui.message = 'Select the element to go after'
				this.ui.btnCancel.visible = true; 
				types = [WidgetVO.ROW]
				types = all; 
				this.dispatch( new PanicModelEvent( BoardModelEvent.HIGHLIGHT_CERTAIN_ITEMS, types )  )
				this.addingA = WidgetVO.PROJECT_LIST; 
			}				
			if ( e.data == WidgetVO.SPACER ) 
			{
				this.ui.message = 'Select the element to go after'
				this.ui.btnCancel.visible = true; 
				types = [WidgetVO.ROW]
				types = all; 
				this.dispatch( new PanicModelEvent( BoardModelEvent.HIGHLIGHT_CERTAIN_ITEMS, types )  )
				this.addingA = WidgetVO.SPACER; 
			}
			if ( e.data == WidgetVO.TWITTER_SCROLLER ) 
			{
				this.ui.message = 'Select the element to go after'
				this.ui.btnCancel.visible = true; 
				types = [WidgetVO.ROW]
				types = all; 
				this.dispatch( new PanicModelEvent( BoardModelEvent.HIGHLIGHT_CERTAIN_ITEMS, types )  )
				this.addingA = WidgetVO.TWITTER_SCROLLER; 
			}			
			if ( e.data == WidgetVO.ROW ) 
			{
				this.ui.message = 'Select the row to place the new row after'
				this.ui.btnCancel.visible = true; 
				types = [WidgetVO.ROW]
				this.dispatch( new PanicModelEvent( BoardModelEvent.HIGHLIGHT_CERTAIN_ITEMS, types)  )
				this.addingA = WidgetVO.ROW; 
			}					
		}
		
		public function onCancelHandler(e:CustomEvent)  : void
		{
			this.ui.message = ''
			this.ui.list.selectedIndex = -1	
			this.ui.btnCancel.visible = false; 
			this.addingA = null 
			this.dispatch( new PanicModelEvent( BoardModelEvent.HIGHLIGHT_CERTAIN_ITEMS_SELECTED ) ) 
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
			
		private function onSelectGallery(e:CustomEvent) : void
		{
			 this.dispatch( new ShowPopupEvent( 
				 	ShowPopupEvent.SHOW_POPUP, 'WidgetGallery' ,[this.fxOnSelectElement]) )  
		}
			private function fxOnSelectElement ( e :  GalleryWidgetVO )  : void
			{
				var prop : Object = e.data; 
				if ( prop is Function ) 
					var instructions : Array = prop() as Array
				else
					instructions = prop as Array
				var row : BoardRow; 
				row = getRowOrFindParentRow( this.model.boardHolder  )
				this.dispatch( new BuildBoardCommandTriggerEvent( 
					BuildBoardCommandTriggerEvent.ADD_TO_BOARD, this.model.boardHolder, 
					instructions, false ) 
					)
			}
		
		private function onElementSelected_isBoard(e:BoardModelEvent):void
		{
			this.onElementSelected( new PanicModelEvent('', this.model.boardHolder )  ) 
		}
		/**
		 * shoulds this be a panic event? 
		 * */
		private function onElementSelected(e:PanicModelEvent): void
		{
			this.ui.btnCancel.visible = false; 
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
				row.addWidget( PaneWidget.importData( 'Global Alert', '', 'Something1', '', 15000,  '0x4D4844', '0x0E0E0E' )  )
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
			if ( addingA == WidgetVO.ROW ) 
			{
				row = getRowOrFindParentRow( ui  )		
					//no don't add a rwo to a row 
				/*var rowC :  BoardRow = new BoardRow()
				rowC.percentWidth = 100; 
				row.addWidget( rowC)  */
			}				
			this.ui.message = ''
			this.ui.list.selectedIndex = -1
			this.addingA = ''; 
		}		
	
		public function getRowOrFindParentRow ( ui :  Object )  : BoardRow
		{
			var row : BoardRow; 
			//if clicked board, add it as the last element
			if ( ui == this.model.boardHolder ) 
			{
				row = new BoardRow()
				row.percentWidth = 100; 
				this.model.boardHolder.addElement( row )
				return row; 
			}
			if ( ui is BoardRow ) 
			{
				row = (ui as BoardRow)
			 	if ( rowMode )
				{
					if ( this.addingA != WidgetVO.ROW )
					{
						return row;
					}
				}
					//var x :  Group = row.parent as Group; //.getElementIndex( row )
					var index : int = this.model.boardHolder.getElementIndex( row ) 
					row = new BoardRow()
					row.percentWidth = 100; 
					this.model.boardHolder.addElementAt( row, index+1 ) ; //
				/*else if ( row.content.numChildren <= 1 )
				{
					//return the row 
					row;
				}*/
			}
			else
				row = ui.parentDocument as BoardRow
					
			return row 
		}
		
}
}
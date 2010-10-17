package  org.syncon.evernote.panic.view
{
	import flash.events.Event;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.BoardModelEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	import spark.components.HGroup;
 
	public class BoardRowWidgetMediator extends Mediator implements IWidgetMediator
	{
		[Inject] public var ui: BoardRow;
		[Inject] public var model : PanicModel;
			
		private var _widgetData : WidgetVO = new  WidgetVO
		public function set  widgetData ( w : WidgetVO )  : void { this._widgetData = w }
		public function get   widgetData (  )  : WidgetVO { return this._widgetData; }	
		
		public function BoardRowWidgetMediator()
		{
		} 
		
		override public function onRegister():void
		{
			ui.addEventListener( WidgetEvent.IMPORT_CONFIG, onImportConfig ) 
			this.onImportConfig( null ) 
			ui.addEventListener( BoardRow.ADD_UI, onAddUi ) 					
				
			eventMap.mapListener(eventDispatcher, PanicModelEvent.EDIT_MODE_CHANGED, 
				this.onEditModeChanged);						
			this.onEditModeChanged(null)				
				
			ui.addEventListener( EditBorder2.CLICKED_EDIT, onEditClicked ) 		
			ui.addEventListener( WidgetEvent.AUTOMATE_WIDGET, onAutomateWidget ) 	
			this.onAutomateWidget(null)			
			eventMap.mapListener( eventDispatcher, BoardModelEvent.HORIZONTAL_GAP_CHANGED, onHorizontalGapChanged ) 	
			this.onHorizontalGapChanged(null)						
		}
		 
		
		public function onAutomateWidget( e : WidgetEvent )  : void
		{
			var useSettings : WidgetVO = this.widgetData; 
			if ( e != null && e.data != null) 
				useSettings = e.data; 
			if ( useSettings.data == null ) 
				return; 
			//this.ui.loadedHiehgt = useSettings.height 
		}
				
		
		public function onHorizontalGapChanged( e : BoardModelEvent )  : void
		{
			//return;//
			//this.ui.content.setStyle('horizontalGap', this.model.board.horizontalGap ) ; 
			//var x : Object = this.ui.content.getStyle('gap')
			this.ui.content.gap =  this.model.board.horizontalGap; ;
			//this.ui.content.setStyle('gap', this.model.board.horizontalGap ) ; 			
		}
				
		
		public function onEditModeChanged(e:PanicModelEvent): void
		{
			if ( this.model.editMode ) 
				this.ui.showEdit()
			else
				this.ui.hideEdit(); 
		}		
		
		public function onImportConfig(e:WidgetEvent): void
		{
			/**
			 * remove source from model 
			 * get result 
			 * */
			/*
			if ( this.model.sourced( this.ui.message ) == false ) 
				this.ui.lblMessage.text = this.ui.message.toUpperCase()
			*/
		}		
		 
		public function onAddUi( e :  CustomEvent )  : void
		{
/*			var ui  :  IUIWidget = e.data as IUIWidget; 
			var ui2 : UIComponent = e.data as UIComponent
			ui2.percentHeight = 100; 
			var percentWidth : Number = 100* 1/this.ui.content.numElements+1
			this.ui.content.addElement( ui as IVisualElement ); 
			var hgroup : HGroup = this.ui.content; 
			for ( var z : int =0 ; z < hgroup.numElements; z++ )
			{
				var   j :     UIComponent  = hgroup.getElementAt(z)  as  UIComponent; 
				j.percentWidth = percentWidth
			}	*/		
		}
		
		public function onEditClicked(e: CustomEvent) : void
		{
			throw 'not implemented yet'
			this.widgetData.ui = this.ui; 
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'BoardRowWidgetEditorPopup', [this.widgetData] )  )  
		}		
		
		
		}
}
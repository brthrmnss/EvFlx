package  org.syncon.evernote.panic.view
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.ImportBoardCommandTriggerEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.vo.BoardVO;
	import org.syncon.evernote.panic.vo.ProjectVO;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.popups.controller.ShowPopupEvent;
 
	public class ProjectListWidgetMediator extends Mediator implements IWidgetMediator
	{
		[Inject] public var ui: ProjectListWidget;
		[Inject] public var model : PanicModel;
		
		private var _widgetData : WidgetVO = new  WidgetVO
		public function set  widgetData ( w : WidgetVO )  : void { this._widgetData = w }
		public function get   widgetData (  )  : WidgetVO { return this._widgetData; }	
		
		public function ProjectListWidgetMediator()
		{
			
		} 
		
		override public function onRegister():void
		{
			ui.addEventListener( WidgetEvent.IMPORT_CONFIG, onImportConfig ) 			
			this.onImportConfig( null ) 
				
			eventMap.mapListener(eventDispatcher, PanicModelEvent.EDIT_MODE_CHANGED, 
				this.onEditModeChanged);						
			this.onEditModeChanged(null)	
				
			eventMap.mapListener(eventDispatcher, PanicModelEvent.CHANGED_PEOPLE, 
				this.onRefresh );	
			eventMap.mapListener(eventDispatcher, PanicModelEvent.CHANGED_PROJECTS, 
				this.onRefresh );	
			
			ui.addEventListener( EditBorder.CLICKED_EDIT, onEditClicked ) 		
			ui.addEventListener( WidgetEvent.AUTOMATE_WIDGET, onAutomateWidget ) 	
			this.onAutomateWidget(null)		
			
				
		}
		 
		public function onAutomateWidget( e : WidgetEvent )  : void
		{
			var useSettings : WidgetVO = this.widgetData; 
			if ( e != null && e.data != null) 
				useSettings = e.data; 
			if ( useSettings.data == null ) 
				return; 
			this.ui.list1.height = useSettings.height 
			var testBoard : BoardVO = this.makeUpTestBoard()	
			this.dispatch( new  ImportBoardCommandTriggerEvent(
				ImportBoardCommandTriggerEvent.UPDATE_PEOPLE_AND_PROJECTS, testBoard )
				)
				
			if ( this.timer != null ) this.timer.delay = useSettings.refreshTime; 
			this.setupGetter()
		}
		private var timer :    Timer ;//= new Timer()
		override public function onRemove() : void
		{
			super.onRemove()
			this.timer.stop()
			this.timer.removeEventListener(TimerEvent.TIMER, this.onUpdateMeTimer )
		}
		public function setupGetter()  : void
		{
			if ( this.timer == null ) 
			{
				this.timer = new Timer( this.widgetData.refreshTime, 0 ) 
				
				this.timer.addEventListener(TimerEvent.TIMER, this.onUpdateMeTimer, false, 0, true )
				this.timer.start()
			}
		}
		
		public function onUpdateMeTimer(e:Event) : void
		{
			if ( this.widgetData.editing == false )  
				onAutomateWidget( null ) 
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
			var dbg : Array = this.model.board.projects; 
			for each ( var p : ProjectVO in this.model.board.projects ) 
			{
				if ( p.people_names.length != 0 ) 
				{
					 p.findPeople( this.model.board.people ) 
				}
			}
			this.ui.list1.dataProvider = new ArrayList( this.model.board.projects )
			this.widgetData = this.ui.widgetData; 
		}	
		
		public function onEditClicked(e: CustomEvent) : void
		{
			this.widgetData.ui = this.ui; 
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'ProjectListWidgetEditorPopup', [this.widgetData] )  )  
		}
		
		public function onRefresh(e:Event):void
		{
			this.ui.list1.dataProvider = new ArrayList( this.model.board.projects )
		}
		
		
		private function makeUpTestBoard() :  BoardVO
		{
			var b : BoardVO = this.model.board; 
			return b; 
		}
		
	}
}
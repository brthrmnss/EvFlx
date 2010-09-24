package  org.syncon.evernote.panic.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.vo.ProjectVO;
	import org.syncon.evernote.panic.vo.WidgetVO;
 
	public class ProjectListWidgetMediator extends Mediator implements IWidget
	{
		[Inject] public var ui: ProjectList;
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
			/*eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.AUTHENTICATED, 
				this.onAuthenticated);	*/		
			this.onImportConfig( null ) 
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
	}
}
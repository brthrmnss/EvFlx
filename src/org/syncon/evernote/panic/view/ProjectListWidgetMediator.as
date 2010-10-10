package  org.syncon.evernote.panic.view
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayList;
	import mx.utils.ObjectUtil;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.ExportBoardCommandTriggerEvent;
	import org.syncon.evernote.panic.controller.ImportBoardCommandTriggerEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.vo.BoardVO;
	import org.syncon.evernote.panic.vo.PersonVO;
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
				import  mx.utils.ObjectUtil
			var testBoard :  Object =ObjectUtil.copy( this.makeUpTestBoard() ) as BoardVO
				
			if ( this.model.boardLoaded == false ) 
			{
				this.dispatch( new  ExportBoardCommandTriggerEvent(
					ExportBoardCommandTriggerEvent.EXPORT_BOARD_TO_STIRNG, this.onExportBoard ) ) 
			}
			else
			{
				this.dispatch( new  ImportBoardCommandTriggerEvent(
					ImportBoardCommandTriggerEvent.UPDATE_PEOPLE_AND_PROJECTS ) ) ;
			}
					//	var testBoard :  Object =  this.makeUpTestBoard().cl
			//var x : Object =  ObjectUtil.copy( this.makeUpTestBoard() ) 
	
				
			if ( this.timer != null ) this.timer.delay = useSettings.refreshTime; 
			this.setupGetter()
		}
		
			private function onExportBoard( x : ExportBoardCommandTriggerEvent )  : void
			{
				this.dispatch( new  ImportBoardCommandTriggerEvent(
					ImportBoardCommandTriggerEvent.IMPORT_BOARD, x.result, '', false, false, onBoardImported  )
				)
			}
				private function onBoardImported( testBoard : BoardVO )  : void
				{
					for each (   var project : ProjectVO   in testBoard.projects )
					{
						if ( Math.random() > 0.3 )
						{
							continue
						}
						project.name = ( Math.random()*100000).toString()
							
						if ( Math.random() > 0.3 )
						{
							project.img =this.model.random( this.model.projectPics ).toString()
						}
						if ( Math.random() > 0.3 )
						{
							project.img =this.model.random( this.model.projectPics ).toString()
						}
						if ( Math.random() > 0.3 )
						{
							project.img =this.model.random( this.model.projectPics ).toString()
						}						
						/*if ( Math.random() < 0.3 )
						{
							project.people_ids = this.model.randSet( 8,0, this.model.board.people, 'id' ) ;//this.model.random( this.model.projectPics )
						}	*/					
									
					}					
								
					for each (   var person :  PersonVO   in testBoard.people )
					{
						if ( Math.random() > 0.3 )
						{
							continue
						}
						person.twitter = ( Math.random()*100000).toString()
						
						if ( Math.random() > 0.3 )
						{
							person.src =this.model.random( this.model.peoplePics ).toString()
							//person.src =this.model.random( this.model.projectPics ).toString()
						}
						
						if ( Math.random() > 0.3 )
						{
							person.available = ( Math.random()>0.5) ? true : false 
						}						
						
						/*if ( Math.random() < 0.3 )
						{
						project.people_ids = this.model.randSet( 8,0, this.model.board.people, 'id' ) ;//this.model.random( this.model.projectPics )
						}	*/					
						
					}						
					this.dispatch( new  ImportBoardCommandTriggerEvent(
						ImportBoardCommandTriggerEvent.UPDATE_PEOPLE_AND_PROJECTS,testBoard  )
					)
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
				if ( p.people_ids.length != 0 ) 
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
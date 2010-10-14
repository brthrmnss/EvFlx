package  org.syncon.evernote.panic.view
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayList;
	import mx.utils.ObjectUtil;
	
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
 
	public class ProjectListWidgetMediator extends WidgetMediatorBase
	{
		[Inject] public function set ui  ( i : ProjectListWidget) : void 
		{	this.widgetUI = i  }
		public function get ui () : ProjectListWidget
		{ return this.widgetUI as ProjectListWidget;  }
		
		public function ProjectListWidgetMediator()
		{
		} 
		
		override public function onRegister():void
		{
			super.onRegister();
			this.editPopupName = 'ProjectListWidgetEditorPopup'; 			
			
			this.ui.addEventListener( 'viewPerson', this.onViewPerson)				
				
			eventMap.mapListener(eventDispatcher, PanicModelEvent.CHANGED_PEOPLE, 
				this.onRefresh );	
			eventMap.mapListener(eventDispatcher, PanicModelEvent.CHANGED_PROJECTS, 
				this.onRefresh );	
			
		}
		 
		
		private function onViewPerson(e:CustomEvent) : void
		{
		 	this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
					'PopupEditPerson', [e.data, null, this.model.adminMode ] )  )  				
		}
		
		override public function onSkinChanged(e:PanicModelEvent): void
		{
			if ( this.model.backgroundColor == 0xFFFFFF ) 
			{
				this.ui.bgVisible = false; 
			}
			else
				this.ui.bgVisible = true; 
			this.ui.colorText = this.model.color; 
			this.ui.updateRenderers()
		}				
		
		override public function automateWidget( settings : WidgetVO )  : void
		{
			this.ui.list1.height = settings.height 
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
		}
		
			private function onExportBoard( x : ExportBoardCommandTriggerEvent )  : void
			{
				this.dispatch( new  ImportBoardCommandTriggerEvent(
					ImportBoardCommandTriggerEvent.IMPORT_BOARD, x.result, '', false, false, onBoardImported  )
				)
			}
				private function onBoardImported( testBoard : BoardVO )  : void
				{
					return;
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
						
						/*if ( Math.random() > 0.3 )
						{*/
							project.progress = Math.random()*100
					/*	}		*/						
							if ( Math.random() > 0.3 )
							{
								project.progress = NaN
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
		
	 
		
		override public function onImportConfig(e:WidgetEvent): void
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
			super.onImportConfig( e ); 
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
package  org.syncon.evernote.panic.view.popup.editors
{
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.events.EvernoteServiceEvent;
	import org.syncon.evernote.panic.controller.LoadDataSourceCommandTriggerEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.view.ProjectListWidget;
	import org.syncon.evernote.panic.vo.WidgetVO;
	
	public class ProjectListWidgetEditorPopupMediator extends Mediator
			implements IWidgetEditorMediator
	{
		[Inject] public var ui: ProjectListWidgetEditorPopup;
		[Inject] public var model :  PanicModel;
		
		private var data : WidgetVO; 
		
		public function ProjectListWidgetEditorPopupMediator()
		{
		} 
		
		override public function onRegister():void
		{
			this.ui.addEventListener( WidgetEvent.EDIT_WIDGET, this.onEditWidget ) 
			this.ui.addEventListener( WidgetEvent.TEST_WIDGET, this.onTestWidget) 
			this.ui.addEventListener( WidgetEvent.UPDATE_WIDGET_CONFIG, this.onUpdateWidgetConfig ) 
		}
		
		private function onUpdateWidgetConfig(e:CustomEvent) : void
		{
			this.onTestWidget(null)
			//import it actually sets the data , test is unnecsary
			this.data.ui.importConfig( this.currentConfig() ) ; 
			this.dispatch( new PanicModelEvent( PanicModelEvent.BOARD_CHANGED ) ) 
			this.ui.hide()
		}			
		
		private function onEditWidget(e:CustomEvent) : void
		{
			this.data = e.data as WidgetVO
		}		
		
		private function onTestWidget(e:CustomEvent) : void
		{
			var d : WidgetVO  = this.currentConfig() 
			this.data.ui.dispatchEvent( new WidgetEvent( WidgetEvent.AUTOMATE_WIDGET, null, d ) ) 
		}		
		
		/**
		 * Read settings for text value
		 * */
		public function currentConfig()  :   WidgetVO
		{
			var d : WidgetVO = ProjectListWidget.importData( this.data.name, this.data.description, 
				Number(this.ui.txtMessage.text),  this.data.refreshTime ).widgetData;
			return d ; 	
		}
		
		
	}
}
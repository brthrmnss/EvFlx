package  org.syncon.evernote.panic.view.popup.editors
{
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.evernote.panic.view.ProjectListWidget;
 
	public class ProjectListWidgetEditorPopupMediator extends 
		WidgetEditorPopupMediatorBase
	{
		[Inject] public function set ui  ( i : ProjectListWidgetEditorPopup) : void 
		{	this.editor = i  }
		public function get ui () : ProjectListWidgetEditorPopup
		{ return this.editor as ProjectListWidgetEditorPopup;  }
		
		public function ProjectListWidgetEditorPopupMediator()
		{
		} 
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		override public function onImportEditConfig(e:WidgetEvent) : void
		{
			super.onImportEditConfig( e ) 
			
			this.ui.timer.dataX = this.data ; 
			this.ui.txtMessage.text = this.data.height.toString(); 				
		}		
		
		/**
		 * Read settings for text value
		 * */
		override public function currentConfig()  :   WidgetVO
		{
			var d : WidgetVO = ProjectListWidget.importData( this.data.name, 
				this.data.description, 
				Number(this.ui.txtMessage.text),  this.ui.timer.time ).widgetData;
			return d ; 	
		}
		
		
	}
}
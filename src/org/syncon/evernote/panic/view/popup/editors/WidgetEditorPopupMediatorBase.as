package  org.syncon.evernote.panic.view.popup.editors
{
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.events.EvernoteServiceEvent;
	import org.syncon.evernote.panic.controller.LoadDataSourceCommandTriggerEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.view.GraphWidget;
	import org.syncon.evernote.panic.vo.WidgetVO;
	
	public class WidgetEditorPopupMediatorBase extends Mediator
		implements IWidgetEditorMediator
	{
		public var editor : UIComponent
		
		public var data : WidgetVO; 		
		/**
		 * TRacks if ui componet was changed
		 * */
		public var changed : Boolean = false; 
		public function WidgetEditorPopupMediatorBase()
		{
		} 
		
		override public function onRegister():void
		{
	 		this.editor.addEventListener( WidgetEvent.EDIT_WIDGET, this.onImportEditConfig ) 
			this.editor.addEventListener( WidgetEvent.TEST_WIDGET, this.onTestWidget) 
			this.editor.addEventListener( WidgetEvent.UPDATE_WIDGET_CONFIG, this.onUpdateWidgetConfig ) 
				
			this.editor.addEventListener( 'hide', this.onClose ) 
		}
		
		public function onImportEditConfig(e:WidgetEvent) : void
		{
			this.changed = false; 
			this.data = e.data as WidgetVO
		}
		
		private function onUpdateWidgetConfig(e:CustomEvent) : void
		{
			this.changed = true; 
			this.onTestWidget(null)
			//import it actually sets the data , test is unnecsary
			this.editorObj.ui.importConfig( this.currentConfig() ) ; 
			this.dispatch( new PanicModelEvent( PanicModelEvent.BOARD_CHANGED ) ) 
			this.editorObj.hide()
		}			
		
		public function onClose(e:Event) : void
		{
			if ( this.changed ) return; 
			//replace with original config ...
			this.editorObj.ui.dispatchEvent( new WidgetEvent( WidgetEvent.AUTOMATE_WIDGET, null, this.data ) ) 
		}
		
		public function onTestWidget(e:CustomEvent) : void
		{
			var d : WidgetVO  = this.currentConfig() 
			this.editorObj.ui.dispatchEvent( new WidgetEvent( WidgetEvent.AUTOMATE_WIDGET, null, d ) ) 
		}		
				
		private function get editorObj() : Object
		{
			var e : Object = this.editor as Object
			return e
		}
		
		/**
		 * Read settings for text value
		 * */
		public function currentConfig()  :   WidgetVO
		{
			var d : WidgetVO 
			return d ; 	
		}
		
		
		 
		
	}
}
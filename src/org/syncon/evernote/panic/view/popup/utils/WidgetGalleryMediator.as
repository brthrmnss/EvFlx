package   org.syncon.evernote.panic.view.popup.utils
{
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.view.GraphWidget;
	import org.syncon.evernote.panic.view.utils.AvatarEdit;
	import org.syncon.evernote.panic.view.utils.LoadFile;
	import org.syncon.evernote.panic.vo.ProjectVO;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.popups.controller.ShowPopupEvent;
	import org.syncon.popups.controller.default_commands.ShowAlertMessageTriggerEvent;
	
	public class WidgetGalleryMediator extends Mediator
	{
		[Inject] public var ui:  WidgetGalleryPopup;
		[Inject] public var model :  PanicModel;
		
		public function WidgetGalleryMediator()
		{
			
		} 
		
		override public function onRegister():void
		{
			 this.ui.addEventListener( WidgetGalleryPopup.SELECT_WIDGET, this.onSelectWidget)
			 var	d :   LoadFile = new LoadFile( 
				 'gallery.json', 
				 this.onRecievedFiles, this.onReciedevedFilesFault )
		}
 		/**
		 * Very convient, but rebuilding will be a pain
		 * */
		private function onRecievedFiles(e:Event):void
		{
			var o : Object = e.currentTarget.data; 
			this.ui.list1.dataProvider = new ArrayList( o as Array ) 	
		}
/*		private function onRecievedFiles_Json(e: Object):void
		{
			this.ui.list1.dataProvider = new ArrayList( e as Array ) 	
		}
				*/
		private function onReciedevedFilesFault(e:Event):void
		{
			
		}
		
		private function onSelectWidget(e:CustomEvent) : void
		{
			if ( this.ui.selectedWidget == null ) 
			{
				this.dispatch( new ShowAlertMessageTriggerEvent(ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP, 
					'Select an Item First'  )  	)
				return; 
			}
			//this.hide()
			//this.alpha = 0.6
			//this.bgSquare.visible = true; 
			//this.txtAdding.visible = true; 
			this.ui.fxFade.play([this.ui.bgSquare, this.ui.txtAdding])
			//this.completeFx( this.selectedWidget ) ; 
			setTimeout( this.ui.hide, 1500 );
			setTimeout( this.ui.completeFx, 500, ui.selectedWidget );
			import flash.utils.setTimeout; 		
		}			
	 
 
	}
}
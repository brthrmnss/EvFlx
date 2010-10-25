package  org.syncon.evernote.panic.view.popup.editors
{
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.view.HtmlConvertor;
	import org.syncon.evernote.panic.view.PaneWidget;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	public class PaneWidgetEditorPopupMediator extends 
		WidgetEditorPopupMediatorBase
	{
		[Inject] public function set ui  ( i :  PaneWidgetEditorPopup) : void 
		{	this.editor = i  }
		public function get ui () : PaneWidgetEditorPopup
		{ return this.editor as PaneWidgetEditorPopup;  }
		
		public function PaneWidgetEditorPopupMediator()
		{
		} 
		
		override public function onRegister():void
		{
			super.onRegister();
			mediatorMap.createMediator(this.ui.widget);
			this.ui.widget.removeElement( this.ui.widget.editBorder );
			
			this.ui.addEventListener( PaneWidgetEditorPopup.EDIT_TLF, this.onEditTLF ) 
		}
		
		override public function onImportEditConfig(e:WidgetEvent) : void
		{
			super.onImportEditConfig( e ) 
			this.data = e.data as WidgetVO
				
			this.ui.timer.dataX =  this.data; 
			this.ui.txtMessage.text = this.data.source; 
			this.ui.txtMessageBg.text = this.data.background; 
			this.ui.colorPicker1.selectedColor = this.data.data.color1; 
			this.ui.colorPicker2.selectedColor = this.data.data.color2; 
			
			this.ui.txtCustomGradientBg.text = this.data.data.customGradient; 	
			this.ui.txtCornerRadius.value = int(this.data.data.cornerRadius );  
			
			var d : WidgetVO = this.currentConfig() 
			this.ui.widget.height = this.data.ui.height; 
			this.ui.widget.width = this.data.ui.width;
			this.ui.widget.dispatchEvent( new WidgetEvent( WidgetEvent.AUTOMATE_WIDGET, null, d ) ) 
				
		/*	var ee : HtmlConvertor = new HtmlConvertor()
			this.ui.dit.textFlow = ee.convertTLF( this.ui.txtMessage.text, 0xFFFFFF );*/
			//this.ui.widget.importConfig( d ); 
		}	
		
		/**
		 * Read settings for text value
		 * */
		override public function currentConfig()  :   WidgetVO
		{
			var d : WidgetVO = PaneWidget.importData( this.data.name, this.data.description, 
				this.ui.txtMessage.text, 	this.ui.txtMessageBg.text,  this.ui.timer.time,  
				this.ui.colorPicker1.selectedColor.toString(), 
				this.ui.colorPicker2.selectedColor.toString(), 
				NaN, 
				this.ui.txtCustomGradientBg.text, 
				this.ui.txtCornerRadius.value).widgetData;
			return d ; 	
		}
		
		private function onEditTLF(e:CustomEvent):void
		{
			var ee : HtmlConvertor = new HtmlConvertor()
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP,
				'TLFEditorPopup', 
				[this.ui,   ee.convertTLF( e.data.toString(),  0xFFFFFF ), 
				fxAccept, fxRoll ] 
			)  )  			
		}
		
		public function fxAccept(e:Object):void
		{
			
		}
		
		public function fxRoll(e:Object):void
		{
			
		}		
		
	}
}
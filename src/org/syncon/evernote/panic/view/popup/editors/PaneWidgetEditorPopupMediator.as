package  org.syncon.evernote.panic.view.popup.editors
{
	import flashx.textLayout.elements.TextFlow;
	
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
			
			this.ui.addEventListener( PaneWidgetEditorPopup.EDIT_FORE, this.onEditTLF ) 
			this.ui.addEventListener( PaneWidgetEditorPopup.EDIT_BG, this.onEditTLF2 ) 
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
			this.ui.widget.txt.height = this.ui.widget.txtBg.height = this.ui.widget.height = this.data.ui.height; 
			this.ui.widget.width = this.data.ui.width;
			this.ui.widget.dispatchEvent( new WidgetEvent( WidgetEvent.AUTOMATE_WIDGET, null, d ) ) 
				
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
					fxAdjust, fxAccept , 'Edit the foreground text' ] 
			)  )  			
		}
			//this.ui.txtMessageBg.text = this.data.background; 
			public function fxAdjust(e:String):void
			{
				var d : WidgetVO = this.currentConfig() 
				d.source = e; 
				d.editing = true; 
				//this.ui.widget.dispatchEvent( new WidgetEvent( WidgetEvent.IMPORT_CONFIG, null, d ) )
				this.ui.widget.dispatchEvent( new WidgetEvent( WidgetEvent.AUTOMATE_WIDGET, null, d ) ) 
			}
			public function fxAccept(e: String):void
			{
				 this.data.source = e
				 this.ui.txtMessage.text = this.data.source; 
			}					
 	
		private function onEditTLF2(e:CustomEvent):void
		{
			var ee : HtmlConvertor = new HtmlConvertor()
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP,
				'TLFEditorPopup', 
				[this.ui,   ee.convertTLF( e.data.toString(),  0xFFFFFF ), 
					fxAdjust2, fxAccept2 , 'Edit the background text' ] 
			)  )  			
		}
			//this.ui.txtMessageBg.text = this.data.background; 
			public function fxAdjust2(e:String):void
			{
				var d : WidgetVO = this.currentConfig() 
				d.background = e; 
				this.ui.widget.height = this.data.ui.height; 
				this.ui.widget.width = this.data.ui.width;
				d.editing = true; 
				this.ui.widget.dispatchEvent( new WidgetEvent( WidgetEvent.IMPORT_CONFIG, null, d ) )
				this.ui.widget.dispatchEvent( new WidgetEvent( WidgetEvent.AUTOMATE_WIDGET, null, d ) ) 
			}
			public function fxAccept2(e: String):void
			{
				this.data.background = e
				this.ui.txtMessageBg.text = this.data.background; 					
			}				
	}
}
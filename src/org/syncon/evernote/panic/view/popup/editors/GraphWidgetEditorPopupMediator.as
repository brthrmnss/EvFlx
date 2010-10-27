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
	import org.syncon.evernote.panic.view.GraphWidget;
	import org.syncon.evernote.panic.view.HtmlConvertor;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	public class GraphWidgetEditorPopupMediator extends 
				WidgetEditorPopupMediatorBase
	{
		[Inject] public function set ui  ( i : GraphWidgetEditorPopup) : void 
		{	this.editor = i  }
		public function get ui () : GraphWidgetEditorPopup
		{ return this.editor as GraphWidgetEditorPopup;  }

		public function GraphWidgetEditorPopupMediator()
		{
		} 
		
		override public function onRegister():void
		{
			super.onRegister();
			
			mediatorMap.createMediator(this.ui.widget);
			this.ui.widget.removeElement( this.ui.widget.editBorder );
			
			this.ui.addEventListener( WidgetEvent.TEST_VALUE, this.onTestSource ) 
			this.ui.addEventListener( PaneWidgetEditorPopup.EDIT_BG, this.onEditTLF2 ) 
		}
		
		override public function onImportEditConfig(e:WidgetEvent) : void
		{
			super.onImportEditConfig( e ) 

			this.ui.timer.dataX = this.data ; 
			this.ui.txtTop.text = this.data.data.labelTop; 
			this.ui.txtBottom.text =  this.data.data.labelBottom; 
			this.ui.txtValue.text = this.data.source; 
			this.ui.txtMaximum.text = this.data.data.max
			this.ui.colorPicker.selectedColor = this.data.data.fillColor; 
			this.ui.txtBackground.text = this.data.background; 
			
			this.importIntoPreviewWidget()
		}		
			private function importIntoPreviewWidget()  : void
			{
				var d : WidgetVO = this.currentConfig() 
				this.ui.widget.height = this.data.ui.height; 
				this.ui.widget.width = this.data.ui.width;
				this.ui.widget.dispatchEvent( new WidgetEvent( WidgetEvent.AUTOMATE_WIDGET, null, d ) ) 
			}
 	
		/**
		 * Read settings for text value
		 * */
		override public function currentConfig()  :   WidgetVO
		{
			var d : WidgetVO = GraphWidget.importData( this.data.name, this.data.description, 
				this.ui.txtTop.text, this.ui.txtBottom.text, this.ui.txtValue.text,
				this.ui.txtMaximum.text,  this.ui.colorPicker.selectedColor,
				this.ui.txtBackground.text, this.ui.timer.time ).widgetData;
			return d ; 	
		}
		 
		public function onTestSource(e: CustomEvent) : void
		{
			if ( e.data == 'source' ) 
			{
				this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
					'TestDataSourcePopup',  [this.ui.txtValue.text ] )  )  
			}
		}			
		
		
		
		private function onEditTLF2(e:CustomEvent):void
		{
			//if ( this.check(e.data ) == false ) 
			//	return; 
			
			var ee :  HtmlConvertor = new HtmlConvertor()
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP,
				'TLFEditorPopup', 
				[this.ui,   ee.convertTLF( e.data.toString(),  0xFFFFFF ), 
					fxAdjust2, fxAccept2 , 'Edit the background layer' ] 
			)  )  			
		}
		//this.ui.txtMessageBg.text = this.data.background; 
		public function fxAdjust2(e:String):void
		{
			var d : WidgetVO = this.currentConfig() 
			d.background = e; 
			d.editing = true; 
			this.ui.widget.dispatchEvent( new WidgetEvent( WidgetEvent.IMPORT_CONFIG, null, d ) )
			this.ui.widget.dispatchEvent( new WidgetEvent( WidgetEvent.AUTOMATE_WIDGET, null, d ) ) 
		}
		public function fxAccept2(e: String):void
		{
			this.data.background = e
			this.ui.txtBackground.text = this.data.background; 					
		}			
		
		
	}
}
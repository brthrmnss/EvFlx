package   org.syncon.evernote.panic.controller
{
	import com.adobe.serialization.json.JSON;
	
	import mx.controls.Spacer;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.view.BoardRow;
	import org.syncon.evernote.panic.view.IUIWidget;
	import org.syncon.evernote.panic.vo.BoardVO;
	import org.syncon.evernote.panic.vo.PersonVO;
	import org.syncon.evernote.panic.vo.ProjectVO;
	import org.syncon.evernote.panic.vo.WidgetVO;
	
	import spark.components.Group;
	import spark.components.HGroup;
	
	public class ExportBoardCommand extends Command
	{
		[Inject] public var model: PanicModel;
		[Inject] public var apiModel:  EvernoteAPIModel;				
		[Inject] public var event: ExportBoardCommandTriggerEvent;
		private var board : BoardVO; 
		override public function execute():void
		{
			this.board = this.model.board; 
			if ( event.board != null ) 
				board = this.event.board; 
			
			var layoutExport : Array = []; 
			var target :  Group = this.model.boardHolder
			for ( var i : int =0 ; i < target.numElements; i++ )
			{
				var xxx : Object = target.getElementAt( i ) 
				var   row :     BoardRow  = target.getElementAt( i ) as BoardRow
				var rowExport : Array = []; 
				layoutExport.push( rowExport ) 
				
				var hgroup : HGroup = row.content
				for ( var z : int =0 ; z < hgroup.numElements; z++ )
				{
					var   j :     UIComponent  = hgroup.getElementAt(z)  as UIComponent
					if ( j is IUIWidget ) 
					{
						rowExport.push( ( j as IUIWidget ).exportConfig().export() ) 
					}
					else if ( j is Spacer )  
					{
						rowExport.push( new WidgetVO( WidgetVO.SPACER ).export()  ) 
					}
					
				}
			}	
			var board_ : Object = this.board.export()
			board_.layout =  layoutExport  
			
			var output : Object = {}
			var people : Array = [];
			
			
			for each ( var p : PersonVO in this.model.board.people )
			{
				people.push( p.export() )
			}
			var projects : Array = []; 
			for each ( var project :  ProjectVO  in this.model.board.projects )
			{
				projects.push( project.export() )
			}	
			
			output.board = board_
			output.people = people
			output.projects = projects
				
			var result : String = JSON.encode( output  ) 
				
				
			event.result = result; 
			 
		//if we are saving peopel or proejcts, don't update layout just yet
			if ( event.useUILayout == false )
			{
				//shoot this won't work b/c when you save it again later this will be all null and void .... 
				//clean this up .... save layout explicity 
				if ( this.model.currentBoardJSON == null ) 
					throw 'Nothing was loaded in'
				var dbg : Array = [output.board.layout,this.model.board.layout,
							this.model.currentBoardJSON.board, this.model.currentBoardJSON]
					var eee : Array = dbg.concat([])
				output.board = 		this.model.currentBoardJSON.board.layout
			}
			
			
			if ( event.type == ExportBoardCommandTriggerEvent.EXPORT_BOARD_TO_STIRNG )
			{
				if ( event.fxComplete != null ) event.fxComplete(event)
			}
			if ( event.type == ExportBoardCommandTriggerEvent.SAVE_BOARD )
			{
				if ( event.useUILayout ) this.model.currentBoardJSON = output
				this.model.configNote.content = this.apiModel.wrapContent(result )
				this.dispatch(  
					EvernoteAPICommandTriggerEvent.UpdateNote( 
							this.model.configNote,onNoteSaved, onNoteSavedFault  )  
				)	
			}			
			//this.dispatch( event ) 
				return; 
		}
		 
		
		
		
		private function onNoteSaved( o:Object):void
		{
			//var ee : StatusUpdateEvent 
			StatusUpdateEvent.ChangeStatus( 'Configuration Saved..' )
			//this.alert( 'board saved' ) 
			if ( event.fxComplete != null ) event.fxComplete()
			return;
		}					
		private function onNoteSavedFault( o:Object):void
		{
			var msg : String = 'Could not save note'; 
			this.alert( msg ) 
		}				
		
		private function alert(s:String):void
		{
		/*	this.dispatch( new   ShowAlertMessageTriggerEvent(
				ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP, 
				msg  ) )  */
		}
		
		
		
		
		
		
	}
}
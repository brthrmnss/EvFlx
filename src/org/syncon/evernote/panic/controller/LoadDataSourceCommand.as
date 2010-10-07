package   org.syncon.evernote.panic.controller
{
	import com.adobe.serialization.json.JSON;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.vo.BoardVO;
	
	public class LoadDataSourceCommand extends Command
	{
		[Inject] public var model:PanicModel;
		[Inject] public var event:   LoadDataSourceCommandTriggerEvent;
		override public function execute():void
		{
			//if test used, send test
			if ( event.test != null ) 
			{
				this.release( this.model.random( event.test ).toString() ) 
				return; 
			}
			 if ( this.model.sourced( event.src )  ) 
			 {
				 var ee : LoadDataSource = new LoadDataSource()
					 ee.start( event.src, this.release ); 
			 }
			 else
			 {
				 this.release()
			 }
			 
		}
		
		public function release( result  : String = null, errors : Array = null  ) : void
		{
			if ( result == null )
			{
				result = event.src; 
			}
			
			if ( event.host != null ) 
				event.host[event.property] = result
			if ( event.fxSet != null ) 
				event.fxSet( result ) 
		}
		
		
	}
}
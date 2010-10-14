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
			/**
			 * either 
			 * cleartext
			 * json
			 * html in it
			 * array of cleartext/json
			 * 
			 * confusion
			 * if is sourced, pull in data and check for json array, json object text
			 * */
			
			/**
			 * 
			 * 5,sean, going home on a plane
			 * ['f', 'sean', 'going home on a plane'] ( beggining and end '['
			 * 
			 * 
			 * */
			
			
			var source : String = event.src; 
			if ( source.charAt(0) == '[' && source.charAt( source.length-1) == ']' )
			{
				var json : Object =JSON.decode( source )
				var sources : Array = json as Array
				source =  this.model.random( sources ).toString()
				if ( event.index != null ) 
				{
					source = event.index.increment( sources ).toString() 
				}
			}
			
			
			//if test used, send test
			if ( event.test != null ) 
			{
				var testSources : Array = event.test
				//this.release( this.model.random( event.test ).toString() ) 
				source =  this.model.random( testSources ).toString()
				if ( event.index != null ) 
				{
					source = event.index.increment( testSources ).toString() 
				}					
			}
			
			 if ( this.model.sourced( source )  ) 
			 {
				 var ee : LoadDataSource = new LoadDataSource()
				ee.start( source, this.release ); 
			 }
			 else
			 {
			 	this.release(source)
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
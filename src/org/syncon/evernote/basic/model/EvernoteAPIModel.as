/**
* Main Model for Application 
*/
package org.syncon.evernote.basic.model
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	import flexunit.utils.ArrayList;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.DateField;
	import mx.core.UIComponent;
	
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.mvcs.Actor;

	/**
	 * Dispatched when chart has been changed 
	 */
	[Event(name="tickerUpdated", type="org.robotlegs.stockchart.model.TickerModelEvent")]
	/**
	* keeps track of all popups cleans up
	 * ensures stacking order respected
	*/
	public class   EvernoteAPIModel   extends Actor 
	{
		public function EvernoteAPIModel()
		{
			_notes = new ArrayCollection();
			_searchResult = new ArrayCollection();
		}		
 
		private var _notes :  ArrayCollection ; public function get notes () : ArrayCollection { return this._notes }
		private var _searchResult: ArrayCollection 
  
		
		public function loadNotes(e:Array)  : void
		{
			this.addAllTo( this._notes,  e  ) 
			this.dispatch( new    EvernoteAPIModelEvent( EvernoteAPIModelEvent.NOTES_RESULT, e ) )
		}
		
		
		public function loadSearch(e:Array)  : void
		{
			this.addAllTo( this._searchResult,  e  ) 
			this.dispatch( new    EvernoteAPIModelEvent( EvernoteAPIModelEvent.SEARCH_RESULT, e ) ) 
		}		
 
		private function addAllTo( e:ArrayCollection, arr : Array )  : void
		{
			e.source = arr; 
			e.refresh()
			/*e.disableAutoUpdate()
			e.removeAll()
			e.
			e.enableAutoUpdate()*/
		}
		
	}
}
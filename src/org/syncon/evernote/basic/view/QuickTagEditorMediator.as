package org.syncon.evernote.basic.view
{
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.model.EvernoteAPIModelEvent;
	public class QuickTagEditorMediator extends Mediator
	{
		[Inject] public var ui: Object;
		[Inject] public var model : EvernoteAPIModel;
 
		public function QuickTagEditorMediator()
		{
		} 
		
		override public function onRegister():void
		{
 
		}
		
 
 
	}
}
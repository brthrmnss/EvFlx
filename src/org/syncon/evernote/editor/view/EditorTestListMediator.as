package  org.syncon.evernote.editor.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.controller.EditorTestCommandTriggerEvent;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.editor.view.EditorTestList;
	import org.syncon.evernote.editor.vo.EditorTestCaseVO;
	import org.syncon.utils.Js;

	public class EditorTestListMediator extends Mediator
	{
		[Inject] public var ui:EditorTestList;
		[Inject] public var model : EvernoteAPIModel;
			
		public function EditorTestListMediator()
		{
		} 
		
		override public function onRegister():void
		{
			 ui.addEventListener(EditorTestList.EXPORT_NOTE, this.onExportNote  ) ;
			 this.loadCases()
		}
		
		
		public function loadCases() : void
		{
			var tests : Array = [];
			var test : EditorTestCaseVO = new  EditorTestCaseVO()
			test.importing = true
			test.evernoteXML = '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd"><en-note><p><strong>bolded text</strong></p><p><span style="text-decoration: underline;">underlined text</span></p><p><em>italic </em></p><p><span style="text-decoration: underline;"><em><strong>bold, underline, italic</strong></em></span></p><p>sub<sub>script</sub></p><p>super<sup>sprint</sup></p><p>left</p><p style="text-align: right;">right</p><p><span style="text-decoration: line-through;">strike through </span></p><p>indented</p><p style="padding-left: 30px;">once</p><p>br<br clear="none"/>br</p><ol><li>order</li><li>list</li><li>list</li><li>list</li></ol><p> </p><ul><li>unorderer</li><li>list</li><li>list</li><li>list</li></ul><p> </p><p><en-todo/>checkbox<en-todo checked="true"/></p><p> </p><p><span style="color: #ff9900;">colors</span></p><p>fonts: <span style="font-family: arial,helvetica,sans-serif;">arial</span>, <span style="font-family: georgia,palatino;">georiga </span></p><p><span style="font-size: xx-large;">big </span><span style="font-size: x-large;">bigmed</span>, med, <span style="font-size: xx-small;">small</span></p></en-note>'; 
			test.process()
			tests.push( test ) 
			this.ui.tests = tests
		}
		
		/**
		  
		<?xml version="1.0" encoding="UTF-8"?>
		<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
		<en-note><p><strong>bolded text</strong></p>
		<p><span style="text-decoration: underline;">underlined text</span></p>
		<p><em>italic </em></p>
		<p><span style="text-decoration: underline;"><em><strong>bold, underline, italic</strong></em></span></p>
		<p>sub<sub>script</sub></p>
		<p>super<sup>sprint</sup></p>
		<p>left</p>
		<p style="text-align: right;">right</p>
		<p><span style="text-decoration: line-through;">strike through </span></p>
		<p>indented</p>
		<p style="padding-left: 30px;">once</p>
		<p>br<br clear="none"/>br</p>
		<ol><li>order</li><li>list</li><li>list</li><li>list</li></ol>
		<p> </p>
		<ul><li>unorderer</li><li>list</li><li>list</li><li>list</li></ul>
		<p> </p>
		<p><en-todo/>checkbox<en-todo checked="true"/></p>
		<p> </p>
		<p><span style="color: #ff9900;">colors</span></p>
		<p>fonts: <span style="font-family: arial,helvetica,sans-serif;">arial</span>, <span style="font-family: georgia,palatino;">georiga </span></p>
		<p><span style="font-size: xx-large;">big </span><span style="font-size: x-large;">bigmed</span>, med, <span style="font-size: xx-small;">small</span></p></en-note>
		
		 **/
		 
		private function onExportNote(e:CustomEvent) : void
		{
				var testCase : EditorTestCaseVO = new EditorTestCaseVO()
				testCase = e.data as EditorTestCaseVO;
				this.dispatch( EditorTestCommandTriggerEvent.ExportNote( 
					testCase.exportedBackToEvernoteXML, testCase.index,  exported ) )
		}
		
		private function exported(s : String ) : void
		{
			Js.goToUrl( s ) 
		}
			 /*
				private function expungeInactiveNotesFault(e:Object)  : void
				{
					var event : ShowAlertMessageTriggerEvent = 
						new ShowAlertMessageTriggerEvent( ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP,
							'Could not delete notes' )  
					this.dispatch( event ) 
				}					
 			*/
		
	}
}
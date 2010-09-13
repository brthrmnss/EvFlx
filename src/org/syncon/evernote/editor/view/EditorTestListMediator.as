package  org.syncon.evernote.editor.view
{
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Resource;
	
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
			var test : EditorTestCaseVO = new  EditorTestCaseVO();
		 /*
			test = new  EditorTestCaseVO()
			test.importXML('<p><span style="text-decoration: underline;"><em><strong>bold, underline, italic</strong></em></span></p>' )
			tests.push( test ) 					
			 
			test = new  EditorTestCaseVO()
			test.importing = true
			test.evernoteXML = '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd"><en-note><p><strong>bolded text</strong></p>' +'</en-note>'; 
			test.process()
			tests.push( test ) 			
 
			test = new  EditorTestCaseVO()
			test.importXML('<p><span style="text-decoration: underline;">underlined text</span></p>' )
			tests.push( test ) 				
		 
			test = new  EditorTestCaseVO()
			test.importXML('<p><em>italic </em></p>' )
			tests.push( test ) 					
		 
			test = new  EditorTestCaseVO()
			test.importXML('<p>sub<sub>script</sub></p>' )
			tests.push( test ) 		
			 
			test = new  EditorTestCaseVO()
			test.importXML('<p>super<sup>scrint</sup></p>' )
			tests.push( test ) 		
			 
			test = new  EditorTestCaseVO()
			test.importXML('<p style="text-align:right;">right</p>' )
			tests.push( test ) 		
			 
			 //xml parser eats up white space after words and before tags. 
			//run through from content containing tags, , chck if htere should be space? 
		 
			test = new  EditorTestCaseVO()
			test.importXML('<p><span style="text-decoration: line-through;">strike through </span></p>' )
			tests.push( test ) 	
			 */
			/* 
			test = new  EditorTestCaseVO()
			test.importXML('<p style="padding-left: 30px;">once</p>' )
			tests.push( test ) 						
			
			test = new  EditorTestCaseVO()
			test.importXML('<p>br<br clear="none"/>br</p>' )
			tests.push( test ) 						
		 	 
				*/	
			
			
			/*
				
			test = new  EditorTestCaseVO()
			test.importXML('<p><span style="color: #ff9900;">colors</span></p>' )
			tests.push( test ) 						
			
			test = new  EditorTestCaseVO()
			test.importXML('<p>fonts: <span style="font-family: arial,helvetica,sans-serif;">arial</span>, <span style="font-family: georgia,palatino;">georiga </span></p>' )
			tests.push( test ) 						
			*/
			/* 
			test = new  EditorTestCaseVO()
			test.name = 'font size test' 
			test.importXML('<p><span style="font-size: xx-large;">big </span><span style="font-size: x-large;">bigmed</span>, med, <span style="font-size: xx-small;">small</span></p>' )
			tests.push( test ) 
			 */
			 /*
			test = new  EditorTestCaseVO()
			test.importXML('<ul><li>unorderer</li><li>list</li><li>list</li><li>list</li></ul>' )
			tests.push( test ) 				
				*/
		 /*
			test = new  EditorTestCaseVO('basic list')
			test.importXML('<ol><li>order</li><li>list</li><li>list</li><li>list</li></ol>' )
			tests.push( test ) 		
			*/	
			/*
			test = new  EditorTestCaseVO('remove random formatting')
			test.importXML('<ol><li>order</li><li>list</li><li>list</li><li><span style="font-size: 12px;">asd</span></li><li>list</li></ol>', 
				'<ol><li>order</li><li>list</li><li>list</li><li>asd</li><li>list</li></ol>' )
			tests.push( test ) 						
			*/	
				
			
			/* //fails test attributes are dropped on asd
			test = new  EditorTestCaseVO('remove random formatting')
			test.importXML('<ol><li><span style="font-size: 12px;">a<span style="font-weight: bold;">sd</span></span></li><li>list</li></ol>', 
				 )
			tests.push( test ) 	
			*/	/*
			test = new  EditorTestCaseVO('simplify weight into strong tags that breaks a li element in half')
			test.description = 'If you have a nested span, it must be removed, and attributes have to be copied consistently'
			test.description += '... fix: when you append content from li to spans, you must copy all xml children, not just the first one'
			test.importXML('<ol><li>list</li><li><span style="font-size: 12px;">a<span style="font-weight: bold;">sd</span></span></li><li>list</li></ol>', 
				'<ol><li>list</li><li>a<strong>sd</strong></li><li>list</li></ol>' )
			tests.push( test ) 		
				*/
 /*
			test = new  EditorTestCaseVO('nested list')
			test.importXML('<ol><li>order</li><li>list</li><ol><li>lisgt</li></ol><li>list</li></ol>' )
			tests.push( test ) 		
	 
			test = new  EditorTestCaseVO('double nested list')
			test.importXML('<ol><li>order</li><li>list</li><ul><li>sdf</li><ol><li>lisgt</li></ol></ul><li>list</li></ol>' )
			tests.push( test ) 
				*/
			/*	
			test = new  EditorTestCaseVO('bizarre spacing')
			test.description = 'These types of things can cause errors'; 
			test.importXML('  <p><span>       </span>   </p>' )
			tests.push( test ) 	
				*/
			/*
			test = new  EditorTestCaseVO('bizarre spacing attempt 2')
			test.description = 'trying to recreate error '; 
			test.importXML('  <p><span> <ul>asdf<li>asdf2</li></ul>      </span>   </p>' )
			tests.push( test ) 	
				 
			test = new  EditorTestCaseVO('nested lists not top level drops them')
			test.description = 'trying to recreate error '; 
			test.importXML('  <p><ul>asdfb<li>asdfa</li></ul>   </p><ul>asdf<li>asdf2</li></ul>' )
			tests.push( test ) 						
			 *//*
			test = new  EditorTestCaseVO()
			test.importing = true
			test.evernoteXML = '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd"><en-note><p><strong>bolded text</strong></p><p><span style="text-decoration: underline;">underlined text</span></p><p><em>italic </em></p><p><span style="text-decoration: underline;"><em><strong>bold, underline, italic</strong></em></span></p><p>sub<sub>script</sub></p><p>super<sup>sprint</sup></p><p>left</p><p style="text-align: right;">right</p><p><span style="text-decoration: line-through;">strike through </span></p><p>indented</p><p style="padding-left: 30px;">once</p><p>br<br clear="none"/>br</p><ol><li>order</li><li>list</li><li>list</li><li>list</li></ol><p> </p><ul><li>unorderer</li><li>list</li><li>list</li><li>list</li></ul><p> </p><p><en-todo/>checkbox<en-todo checked="true"/></p><p> </p><p><span style="color: #ff9900;">colors</span></p><p>fonts: <span style="font-family: arial,helvetica,sans-serif;">arial</span>, <span style="font-family: georgia,palatino;">georiga </span></p><p><span style="font-size: xx-large;">big </span><span style="font-size: x-large;">bigmed</span>, med, <span style="font-size: xx-small;">small</span></p></en-note>'; 
			test.process()
			tests.push( test ) 				
		 */
			/*
			test = new  EditorTestCaseVO('indented list')
			test.importXML( '<p>asdfasdf</p><blockquote><ul><li>sdf</li><li>sd<br clear="none"/><ul><li>fsd</li></ul></li><li>fs</li><li>df</li></ul></blockquote>' )
			tests.push( test ) 	
			*/
			test = new  EditorTestCaseVO('image')
			
			var note : Note  = new Note()
			note.guid = '1a1981bb-e1de-4d42-bf5a-ca2249e120f7'
			var res :  Array = []; 
			note.resources = res
			var resource : Resource = new Resource()
			resource.guid = 'f6d005e3-4ee3-49aa-a9a0-1225ebd1c70f'; 
			res.push( resource ) 	
			test.associatedNote = note
			test.importXML( '<en-media hash="e43ff460e7645dc9748bd936d3389763" type="image/gif"/>' )

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
		
		private function exported(s :  EditorTestCommandTriggerEvent ) : void
		{
			Js.goToUrl( s.url ) 
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
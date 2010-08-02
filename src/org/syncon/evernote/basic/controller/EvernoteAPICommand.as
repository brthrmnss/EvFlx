package  org.syncon.evernote.basic.controller
{
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Notebook;
	import com.evernote.edam.type.Tag;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	import mx.controls.DateField;
	import mx.core.ClassFactory;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.events.EvernoteServiceEvent;
	import org.syncon.evernote.services.EvernoteService;
	/**
	 * Test quing of unauthenticated commands 
	 * test defreserencing
	 * 
	 * */
	public class EvernoteAPICommand extends Command
	{
		[Inject] public var apiModel:EvernoteAPIModel;
		[Inject] public var service: EvernoteService;
		[Inject] public var event:EvernoteAPICommandTriggerEvent;
		private var seqId : int = -1
		private var timerTimeout : Timer = new Timer(3000)
		private var debug : Boolean = true
		private var alert : Boolean = false; 
		private var notAuthenticatedRetryTimer : Timer;
		private var retryCount : int = 0 ;
		//private var unauthenticatedEventStore
		
		private function onRetry(e:TimerEvent):void
		{
			if ( retryCount > 3 ) 
			{
				trace(' failed to ' + this.event.type ) 
				this.deReference()
				return; 
			}
			if ( this.service.auth == null )
			{
				this.retryCount++;
				this.notAuthenticatedRetryTimer.start()
				return; 
			}
			this.notAuthenticatedRetryTimer.stop()
			this.execute();
		}
		
		override public function execute():void
		{
			//pre pocessing, if not authenticated store events, this is not a singleton ... mabe on model? 
			//
			if ( this.service.auth == null  && event.type != EvernoteAPICommandTriggerEvent.AUTHENTICATE   )
			{
				notAuthenticatedRetryTimer = new Timer(2000)
				notAuthenticatedRetryTimer.addEventListener(TimerEvent.TIMER, this.onRetry )
				notAuthenticatedRetryTimer.start()
				trace('not authenticated')
				return;
			}
			if ( event.type != EvernoteAPICommandTriggerEvent.AUTHENTICATE ) 
				this.seqId = this.service.incrementSequence()
			//functionSuccess = event.fxSuccess
			//functionFault = event.fxFault; 
			this.timerTimeout.start();
			this.timerTimeout.addEventListener(TimerEvent.TIMER, this.onTimeout ) 
			/*
			if ( event.type == EvernoteAPICommandTriggerEvent.CREATE_LINKED_NOTEBOOK_TRIGGER ) 
			{
				this.service.createLinkedNotebook( null )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.CREATE_LINKED_NOTEBOOK, this.onCreatedNotebook )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.CREATE_LINKED_NOTEBOOK_FAULT, this.onCreateLinkedNotebookFault )
			}
			*/
			if ( event.type == EvernoteAPICommandTriggerEvent.AUTHENTICATE ) 
			{
				this.service.getAuth( event.login, event.password )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.AUTH_GET, this.authenticateResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.AUTH_GET_FAULT, this.authenticateFaultHandler )
			}				
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_SYNC_STATE ) 
			{
				this.service.getSyncState(  )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_SYNC_STATE, this.getSyncStateResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_SYNC_STATE_FAULT, this.getSyncStateFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_SYNC_CHUNK ) 
			{
				this.service.getSyncChunk( event.afterUSN, event.maxEntries, event.fullSyncOnly )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_SYNC_CHUNK, this.getSyncChunkResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_SYNC_CHUNK_FAULT, this.getSyncChunkFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.LIST_NOTEBOOKS ) 
			{
				this.service.listNotebooks(  )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.LIST_NOTEBOOKS, this.listNotebooksResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.LIST_NOTEBOOKS_FAULT, this.listNotebooksFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_NOTEBOOK ) 
			{
				this.service.getNotebook( event.guid )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_NOTEBOOK, this.getNotebookResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_NOTEBOOK_FAULT, this.getNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_DEFAULT_NOTEBOOK ) 
			{
				this.service.getDefaultNotebook(  )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_DEFAULT_NOTEBOOK, this.getDefaultNotebookResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_DEFAULT_NOTEBOOK_FAULT, this.getDefaultNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.CREATE_NOTEBOOK ) 
			{
				this.service.createNotebook( event.notebook )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.CREATE_NOTEBOOK, this.createNotebookResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.CREATE_NOTEBOOK_FAULT, this.createNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.UPDATE_NOTEBOOK ) 
			{
				this.service.updateNotebook( event.notebook )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.UPDATE_NOTEBOOK, this.updateNotebookResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.UPDATE_NOTEBOOK_FAULT, this.updateNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.EXPUNGE_NOTEBOOK ) 
			{
				this.service.expungeNotebook( event.guid )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.EXPUNGE_NOTEBOOK, this.expungeNotebookResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.EXPUNGE_NOTEBOOK_FAULT, this.expungeNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.LIST_TAGS ) 
			{
				this.service.listTags(  )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.LIST_TAGS, this.listTagsResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.LIST_TAGS_FAULT, this.listTagsFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.LIST_TAGS_BY_NOTEBOOK ) 
			{
				this.service.listTagsByNotebook( event.notebookGuid )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.LIST_TAGS_BY_NOTEBOOK, this.listTagsByNotebookResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.LIST_TAGS_BY_NOTEBOOK_FAULT, this.listTagsByNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_TAG ) 
			{
				this.service.getTag( event.guid )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_TAG, this.getTagResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_TAG_FAULT, this.getTagFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.CREATE_TAG ) 
			{
				this.service.createTag( event.tag )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.CREATE_TAG, this.createTagResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.CREATE_TAG_FAULT, this.createTagFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.UPDATE_TAG ) 
			{
				this.service.updateTag( event.tag )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.UPDATE_TAG, this.updateTagResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.UPDATE_TAG_FAULT, this.updateTagFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.UNTAG_ALL ) 
			{
				this.service.untagAll( event.guid )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.UNTAG_ALL, this.untagAllResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.UNTAG_ALL_FAULT, this.untagAllFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.EXPUNGE_TAG ) 
			{
				this.service.expungeTag( event.guid )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.EXPUNGE_TAG, this.expungeTagResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.EXPUNGE_TAG_FAULT, this.expungeTagFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.LIST_SEARCHES ) 
			{
				this.service.listSearches(  )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.LIST_SEARCHES, this.listSearchesResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.LIST_SEARCHES_FAULT, this.listSearchesFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_SEARCH ) 
			{
				this.service.getSearch( event.guid )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_SEARCH, this.getSearchResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_SEARCH_FAULT, this.getSearchFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.CREATE_SEARCH ) 
			{
				this.service.createSearch( event.search )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.CREATE_SEARCH, this.createSearchResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.CREATE_SEARCH_FAULT, this.createSearchFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.UPDATE_SEARCH ) 
			{
				this.service.updateSearch( event.search )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.UPDATE_SEARCH, this.updateSearchResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.UPDATE_SEARCH_FAULT, this.updateSearchFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.EXPUNGE_SEARCH ) 
			{
				this.service.expungeSearch( event.guid )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.EXPUNGE_SEARCH, this.expungeSearchResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.EXPUNGE_SEARCH_FAULT, this.expungeSearchFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.FIND_NOTES ) 
			{
				this.service.findNotes( event.filter, event.offset, event.maxNotes )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.FIND_NOTES, this.findNotesResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.FIND_NOTES_FAULT, this.findNotesFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.FIND_NOTE_COUNTS ) 
			{
				this.service.findNoteCounts( event.filter, event.withTrash )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.FIND_NOTE_COUNTS, this.findNoteCountsResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.FIND_NOTE_COUNTS_FAULT, this.findNoteCountsFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_NOTE ) 
			{
				this.service.getNote( event.guid, event.withContent, event.withResourcesData, event.withResourcesRecognition, event.withResourcesAlternateData )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_NOTE, this.getNoteResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_NOTE_FAULT, this.getNoteFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_NOTE_CONTENT ) 
			{
				this.service.getNoteContent( event.guid )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_NOTE_CONTENT, this.getNoteContentResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_NOTE_CONTENT_FAULT, this.getNoteContentFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_NOTE_SEARCH_TEXT ) 
			{
				this.service.getNoteSearchText( event.guid )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_NOTE_SEARCH_TEXT, this.getNoteSearchTextResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_NOTE_SEARCH_TEXT_FAULT, this.getNoteSearchTextFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_NOTE_TAG_NAMES ) 
			{
				this.service.getNoteTagNames( event.guid )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_NOTE_TAG_NAMES, this.getNoteTagNamesResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_NOTE_TAG_NAMES_FAULT, this.getNoteTagNamesFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.CREATE_NOTE ) 
			{
				this.service.createNote( event.note )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.CREATE_NOTE, this.createNoteResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.CREATE_NOTE_FAULT, this.createNoteFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.UPDATE_NOTE ) 
			{
				this.service.updateNote( event.note )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.UPDATE_NOTE, this.updateNoteResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.UPDATE_NOTE_FAULT, this.updateNoteFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.DELETE_NOTE ) 
			{
				this.service.deleteNote( event.guid )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.DELETE_NOTE, this.deleteNoteResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.DELETE_NOTE_FAULT, this.deleteNoteFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.EXPUNGE_NOTE ) 
			{
				this.service.expungeNote( event.guid )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.EXPUNGE_NOTE, this.expungeNoteResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.EXPUNGE_NOTE_FAULT, this.expungeNoteFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.EXPUNGE_NOTES ) 
			{
				this.service.expungeNotes( event.noteGuids )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.EXPUNGE_NOTES, this.expungeNotesResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.EXPUNGE_NOTES_FAULT, this.expungeNotesFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.EXPUNGE_INACTIVE_NOTES ) 
			{
				this.service.expungeInactiveNotes(  )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.EXPUNGE_INACTIVE_NOTES, this.expungeInactiveNotesResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.EXPUNGE_INACTIVE_NOTES_FAULT, this.expungeInactiveNotesFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.COPY_NOTE ) 
			{
				this.service.copyNote( event.noteGuid, event.toNotebookGuid )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.COPY_NOTE, this.copyNoteResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.COPY_NOTE_FAULT, this.copyNoteFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.LIST_NOTE_VERSIONS ) 
			{
				this.service.listNoteVersions( event.noteGuid )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.LIST_NOTE_VERSIONS, this.listNoteVersionsResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.LIST_NOTE_VERSIONS_FAULT, this.listNoteVersionsFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_NOTE_VERSION ) 
			{
				this.service.getNoteVersion( event.noteGuid, event.updateSequenceNum, event.withResourcesData, event.withResourcesRecognition, event.withResourcesAlternateData )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_NOTE_VERSION, this.getNoteVersionResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_NOTE_VERSION_FAULT, this.getNoteVersionFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_RESOURCE ) 
			{
				this.service.getResource( event.guid, event.withData, event.withRecognition, event.withAttributes, event.withAlternateData )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_RESOURCE, this.getResourceResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_RESOURCE_FAULT, this.getResourceFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.UPDATE_RESOURCE ) 
			{
				this.service.updateResource( event.resource )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.UPDATE_RESOURCE, this.updateResourceResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.UPDATE_RESOURCE_FAULT, this.updateResourceFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_RESOURCE_DATA ) 
			{
				this.service.getResourceData( event.guid )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_RESOURCE_DATA, this.getResourceDataResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_RESOURCE_DATA_FAULT, this.getResourceDataFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_RESOURCE_BY_HASH ) 
			{
				this.service.getResourceByHash( event.noteGuid, event.contentHash, event.withData, event.withRecognition, event.withAlternateData )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_RESOURCE_BY_HASH, this.getResourceByHashResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_RESOURCE_BY_HASH_FAULT, this.getResourceByHashFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_RESOURCE_RECOGNITION ) 
			{
				this.service.getResourceRecognition( event.guid )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_RESOURCE_RECOGNITION, this.getResourceRecognitionResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_RESOURCE_RECOGNITION_FAULT, this.getResourceRecognitionFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_RESOURCE_ALTERNATE_DATA ) 
			{
				this.service.getResourceAlternateData( event.guid )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_RESOURCE_ALTERNATE_DATA, this.getResourceAlternateDataResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_RESOURCE_ALTERNATE_DATA_FAULT, this.getResourceAlternateDataFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_RESOURCE_ATTRIBUTES ) 
			{
				this.service.getResourceAttributes( event.guid )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_RESOURCE_ATTRIBUTES, this.getResourceAttributesResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_RESOURCE_ATTRIBUTES_FAULT, this.getResourceAttributesFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_ACCOUNT_SIZE ) 
			{
				this.service.getAccountSize(  )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_ACCOUNT_SIZE, this.getAccountSizeResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_ACCOUNT_SIZE_FAULT, this.getAccountSizeFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_ADS ) 
			{
				this.service.getAds( event.adParameters )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_ADS, this.getAdsResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_ADS_FAULT, this.getAdsFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_RANDOM_AD ) 
			{
				this.service.getRandomAd( event.adParameters )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_RANDOM_AD, this.getRandomAdResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_RANDOM_AD_FAULT, this.getRandomAdFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_PUBLIC_NOTEBOOK ) 
			{
				this.service.getPublicNotebook( event.userId, event.publicUri )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_PUBLIC_NOTEBOOK, this.getPublicNotebookResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_PUBLIC_NOTEBOOK_FAULT, this.getPublicNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.CREATE_SHARED_NOTEBOOK ) 
			{
				this.service.createSharedNotebook( event.sharedNotebook )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.CREATE_SHARED_NOTEBOOK, this.createSharedNotebookResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.CREATE_SHARED_NOTEBOOK_FAULT, this.createSharedNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.LIST_SHARED_NOTEBOOKS ) 
			{
				this.service.listSharedNotebooks(  )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.LIST_SHARED_NOTEBOOKS, this.listSharedNotebooksResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.LIST_SHARED_NOTEBOOKS_FAULT, this.listSharedNotebooksFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.EXPUNGE_SHARED_NOTEBOOKS ) 
			{
				this.service.expungeSharedNotebooks( event.sharedNotebookIds )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.EXPUNGE_SHARED_NOTEBOOKS, this.expungeSharedNotebooksResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.EXPUNGE_SHARED_NOTEBOOKS_FAULT, this.expungeSharedNotebooksFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.CREATE_LINKED_NOTEBOOK ) 
			{
				this.service.createLinkedNotebook( event.linkedNotebook )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.CREATE_LINKED_NOTEBOOK, this.createLinkedNotebookResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.CREATE_LINKED_NOTEBOOK_FAULT, this.createLinkedNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.UPDATE_LINKED_NOTEBOOK ) 
			{
				this.service.updateLinkedNotebook( event.linkedNotebook )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.UPDATE_LINKED_NOTEBOOK, this.updateLinkedNotebookResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.UPDATE_LINKED_NOTEBOOK_FAULT, this.updateLinkedNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.LIST_LINKED_NOTEBOOKS ) 
			{
				this.service.listLinkedNotebooks(  )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.LIST_LINKED_NOTEBOOKS, this.listLinkedNotebooksResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.LIST_LINKED_NOTEBOOKS_FAULT, this.listLinkedNotebooksFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.EXPUNGE_LINKED_NOTEBOOK ) 
			{
				this.service.expungeLinkedNotebook( event.linkedNotebookId )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.EXPUNGE_LINKED_NOTEBOOK, this.expungeLinkedNotebookResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.EXPUNGE_LINKED_NOTEBOOK_FAULT, this.expungeLinkedNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.AUTHENTICATE_TO_SHARED_NOTEBOOK ) 
			{
				this.service.authenticateToSharedNotebook( event.shareKey )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.AUTHENTICATE_TO_SHARED_NOTEBOOK, this.authenticateToSharedNotebookResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.AUTHENTICATE_TO_SHARED_NOTEBOOK_FAULT, this.authenticateToSharedNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_SHARED_NOTEBOOK_BY_AUTH ) 
			{
				this.service.getSharedNotebookByAuth(  )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_SHARED_NOTEBOOK_BY_AUTH, this.getSharedNotebookByAuthResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.GET_SHARED_NOTEBOOK_BY_AUTH_FAULT, this.getSharedNotebookByAuthFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.EMAIL_NOTE ) 
			{
				this.service.emailNote( event.parameters )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.EMAIL_NOTE, this.emailNoteResultHandler )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.EMAIL_NOTE_FAULT, this.emailNoteFaultHandler )
			}			
				
		}
/*
		private function onCreatedNotebook(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber())
					return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data)
			//this.model.x = e.data
			this.deReference()			
		}		
		
		private function onCreateLinkedNotebookFault(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber())
				return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data)
			this.onFault()
			this.deReference()
		}
*/
		
		private function authenticateResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			//this.model.remotingReady = true; 
			this.deReference()			
		}		
		private function authenticateFaultHandler(e:EvernoteServiceEvent)  : void
		{
			//if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}		
		

		private function getSyncStateResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function getSyncStateFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function getSyncChunkResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function getSyncChunkFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function listNotebooksResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function listNotebooksFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function getNotebookResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function getNotebookFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function getDefaultNotebookResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function getDefaultNotebookFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function createNotebookResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function createNotebookFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function updateNotebookResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function updateNotebookFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function expungeNotebookResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function expungeNotebookFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function listTagsResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function listTagsFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function listTagsByNotebookResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function listTagsByNotebookFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function getTagResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function getTagFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function createTagResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function createTagFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function updateTagResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function updateTagFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function untagAllResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function untagAllFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function expungeTagResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function expungeTagFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function listSearchesResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function listSearchesFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function getSearchResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function getSearchFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function createSearchResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function createSearchFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function updateSearchResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function updateSearchFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function expungeSearchResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function expungeSearchFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function findNotesResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			this.apiModel.loadNotes( e.data.notes  as Array );
			this.deReference()			
		}		
			private function findNotesFaultHandler(e:EvernoteServiceEvent)  : void
			{
				if ( seqId != this.service.getSequenceNumber()) return; 			
				if ( this.event.fxFault != null ) this.event.fxFault(e.data);
				this.onFault(); this.deReference()
			}
		private function findNoteCountsResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function findNoteCountsFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function getNoteResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function getNoteFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function getNoteContentResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function getNoteContentFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function getNoteSearchTextResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function getNoteSearchTextFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function getNoteTagNamesResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			if ( this.event.note != null ) 
			{
				this.event.note.e.dispatchEvent( new Event( 'updatedTags' )  ) 
			}
			this.deReference()			
		}		
		private function getNoteTagNamesFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function createNoteResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function createNoteFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function updateNoteResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function updateNoteFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function deleteNoteResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function deleteNoteFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function expungeNoteResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function expungeNoteFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function expungeNotesResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function expungeNotesFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function expungeInactiveNotesResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function expungeInactiveNotesFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function copyNoteResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function copyNoteFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function listNoteVersionsResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function listNoteVersionsFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function getNoteVersionResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function getNoteVersionFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function getResourceResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function getResourceFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function updateResourceResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function updateResourceFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function getResourceDataResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function getResourceDataFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function getResourceByHashResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function getResourceByHashFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function getResourceRecognitionResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function getResourceRecognitionFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function getResourceAlternateDataResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function getResourceAlternateDataFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function getResourceAttributesResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function getResourceAttributesFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function getAccountSizeResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function getAccountSizeFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function getAdsResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function getAdsFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function getRandomAdResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function getRandomAdFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function getPublicNotebookResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function getPublicNotebookFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function createSharedNotebookResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function createSharedNotebookFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function listSharedNotebooksResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function listSharedNotebooksFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function expungeSharedNotebooksResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function expungeSharedNotebooksFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function createLinkedNotebookResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function createLinkedNotebookFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function updateLinkedNotebookResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function updateLinkedNotebookFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function listLinkedNotebooksResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function listLinkedNotebooksFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function expungeLinkedNotebookResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function expungeLinkedNotebookFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function authenticateToSharedNotebookResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function authenticateToSharedNotebookFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function getSharedNotebookByAuthResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function getSharedNotebookByAuthFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}
		private function emailNoteResultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()			
		}		
		private function emailNoteFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}		
		
		
		
		private function onTimeout(e:TimerEvent)  : void
		{
			this.deReference()
			this.onFault()
		}
				
		
		private function onFault() : void
		{
			var msg : String = 'Error 8332: '+event.type+' call failed';
			if ( debug ) 
			{
				
			}
			if ( event.alert ) 
			{
				var ee : Alert
				Alert.show( msg , 'Error...' )
			}
		}
		
		/**
		 * Clean up event handlers
		 * */
		private function deReference() : void
		{
			this.timerTimeout.removeEventListener(TimerEvent.TIMER, this.onTimeout ) 
			//event.dereference()
				
			if ( event.type == EvernoteAPICommandTriggerEvent.AUTHENTICATE ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.AUTH_GET, this.authenticateResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.AUTH_GET_FAULT, this.authenticateFaultHandler )
			}		
				
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_SYNC_STATE ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_SYNC_STATE, this.getSyncStateResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_SYNC_STATE_FAULT, this.getSyncStateFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_SYNC_CHUNK ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_SYNC_CHUNK, this.getSyncChunkResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_SYNC_CHUNK_FAULT, this.getSyncChunkFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.LIST_NOTEBOOKS ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.LIST_NOTEBOOKS, this.listNotebooksResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.LIST_NOTEBOOKS_FAULT, this.listNotebooksFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_NOTEBOOK ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_NOTEBOOK, this.getNotebookResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_NOTEBOOK_FAULT, this.getNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_DEFAULT_NOTEBOOK ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_DEFAULT_NOTEBOOK, this.getDefaultNotebookResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_DEFAULT_NOTEBOOK_FAULT, this.getDefaultNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.CREATE_NOTEBOOK ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.CREATE_NOTEBOOK, this.createNotebookResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.CREATE_NOTEBOOK_FAULT, this.createNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.UPDATE_NOTEBOOK ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.UPDATE_NOTEBOOK, this.updateNotebookResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.UPDATE_NOTEBOOK_FAULT, this.updateNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.EXPUNGE_NOTEBOOK ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.EXPUNGE_NOTEBOOK, this.expungeNotebookResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.EXPUNGE_NOTEBOOK_FAULT, this.expungeNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.LIST_TAGS ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.LIST_TAGS, this.listTagsResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.LIST_TAGS_FAULT, this.listTagsFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.LIST_TAGS_BY_NOTEBOOK ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.LIST_TAGS_BY_NOTEBOOK, this.listTagsByNotebookResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.LIST_TAGS_BY_NOTEBOOK_FAULT, this.listTagsByNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_TAG ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_TAG, this.getTagResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_TAG_FAULT, this.getTagFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.CREATE_TAG ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.CREATE_TAG, this.createTagResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.CREATE_TAG_FAULT, this.createTagFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.UPDATE_TAG ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.UPDATE_TAG, this.updateTagResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.UPDATE_TAG_FAULT, this.updateTagFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.UNTAG_ALL ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.UNTAG_ALL, this.untagAllResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.UNTAG_ALL_FAULT, this.untagAllFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.EXPUNGE_TAG ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.EXPUNGE_TAG, this.expungeTagResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.EXPUNGE_TAG_FAULT, this.expungeTagFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.LIST_SEARCHES ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.LIST_SEARCHES, this.listSearchesResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.LIST_SEARCHES_FAULT, this.listSearchesFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_SEARCH ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_SEARCH, this.getSearchResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_SEARCH_FAULT, this.getSearchFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.CREATE_SEARCH ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.CREATE_SEARCH, this.createSearchResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.CREATE_SEARCH_FAULT, this.createSearchFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.UPDATE_SEARCH ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.UPDATE_SEARCH, this.updateSearchResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.UPDATE_SEARCH_FAULT, this.updateSearchFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.EXPUNGE_SEARCH ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.EXPUNGE_SEARCH, this.expungeSearchResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.EXPUNGE_SEARCH_FAULT, this.expungeSearchFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.FIND_NOTES ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.FIND_NOTES, this.findNotesResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.FIND_NOTES_FAULT, this.findNotesFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.FIND_NOTE_COUNTS ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.FIND_NOTE_COUNTS, this.findNoteCountsResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.FIND_NOTE_COUNTS_FAULT, this.findNoteCountsFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_NOTE ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_NOTE, this.getNoteResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_NOTE_FAULT, this.getNoteFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_NOTE_CONTENT ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_NOTE_CONTENT, this.getNoteContentResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_NOTE_CONTENT_FAULT, this.getNoteContentFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_NOTE_SEARCH_TEXT ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_NOTE_SEARCH_TEXT, this.getNoteSearchTextResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_NOTE_SEARCH_TEXT_FAULT, this.getNoteSearchTextFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_NOTE_TAG_NAMES ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_NOTE_TAG_NAMES, this.getNoteTagNamesResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_NOTE_TAG_NAMES_FAULT, this.getNoteTagNamesFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.CREATE_NOTE ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.CREATE_NOTE, this.createNoteResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.CREATE_NOTE_FAULT, this.createNoteFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.UPDATE_NOTE ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.UPDATE_NOTE, this.updateNoteResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.UPDATE_NOTE_FAULT, this.updateNoteFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.DELETE_NOTE ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.DELETE_NOTE, this.deleteNoteResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.DELETE_NOTE_FAULT, this.deleteNoteFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.EXPUNGE_NOTE ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.EXPUNGE_NOTE, this.expungeNoteResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.EXPUNGE_NOTE_FAULT, this.expungeNoteFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.EXPUNGE_NOTES ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.EXPUNGE_NOTES, this.expungeNotesResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.EXPUNGE_NOTES_FAULT, this.expungeNotesFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.EXPUNGE_INACTIVE_NOTES ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.EXPUNGE_INACTIVE_NOTES, this.expungeInactiveNotesResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.EXPUNGE_INACTIVE_NOTES_FAULT, this.expungeInactiveNotesFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.COPY_NOTE ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.COPY_NOTE, this.copyNoteResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.COPY_NOTE_FAULT, this.copyNoteFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.LIST_NOTE_VERSIONS ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.LIST_NOTE_VERSIONS, this.listNoteVersionsResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.LIST_NOTE_VERSIONS_FAULT, this.listNoteVersionsFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_NOTE_VERSION ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_NOTE_VERSION, this.getNoteVersionResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_NOTE_VERSION_FAULT, this.getNoteVersionFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_RESOURCE ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_RESOURCE, this.getResourceResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_RESOURCE_FAULT, this.getResourceFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.UPDATE_RESOURCE ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.UPDATE_RESOURCE, this.updateResourceResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.UPDATE_RESOURCE_FAULT, this.updateResourceFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_RESOURCE_DATA ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_RESOURCE_DATA, this.getResourceDataResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_RESOURCE_DATA_FAULT, this.getResourceDataFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_RESOURCE_BY_HASH ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_RESOURCE_BY_HASH, this.getResourceByHashResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_RESOURCE_BY_HASH_FAULT, this.getResourceByHashFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_RESOURCE_RECOGNITION ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_RESOURCE_RECOGNITION, this.getResourceRecognitionResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_RESOURCE_RECOGNITION_FAULT, this.getResourceRecognitionFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_RESOURCE_ALTERNATE_DATA ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_RESOURCE_ALTERNATE_DATA, this.getResourceAlternateDataResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_RESOURCE_ALTERNATE_DATA_FAULT, this.getResourceAlternateDataFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_RESOURCE_ATTRIBUTES ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_RESOURCE_ATTRIBUTES, this.getResourceAttributesResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_RESOURCE_ATTRIBUTES_FAULT, this.getResourceAttributesFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_ACCOUNT_SIZE ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_ACCOUNT_SIZE, this.getAccountSizeResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_ACCOUNT_SIZE_FAULT, this.getAccountSizeFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_ADS ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_ADS, this.getAdsResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_ADS_FAULT, this.getAdsFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_RANDOM_AD ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_RANDOM_AD, this.getRandomAdResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_RANDOM_AD_FAULT, this.getRandomAdFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_PUBLIC_NOTEBOOK ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_PUBLIC_NOTEBOOK, this.getPublicNotebookResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_PUBLIC_NOTEBOOK_FAULT, this.getPublicNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.CREATE_SHARED_NOTEBOOK ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.CREATE_SHARED_NOTEBOOK, this.createSharedNotebookResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.CREATE_SHARED_NOTEBOOK_FAULT, this.createSharedNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.LIST_SHARED_NOTEBOOKS ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.LIST_SHARED_NOTEBOOKS, this.listSharedNotebooksResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.LIST_SHARED_NOTEBOOKS_FAULT, this.listSharedNotebooksFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.EXPUNGE_SHARED_NOTEBOOKS ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.EXPUNGE_SHARED_NOTEBOOKS, this.expungeSharedNotebooksResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.EXPUNGE_SHARED_NOTEBOOKS_FAULT, this.expungeSharedNotebooksFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.CREATE_LINKED_NOTEBOOK ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.CREATE_LINKED_NOTEBOOK, this.createLinkedNotebookResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.CREATE_LINKED_NOTEBOOK_FAULT, this.createLinkedNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.UPDATE_LINKED_NOTEBOOK ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.UPDATE_LINKED_NOTEBOOK, this.updateLinkedNotebookResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.UPDATE_LINKED_NOTEBOOK_FAULT, this.updateLinkedNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.LIST_LINKED_NOTEBOOKS ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.LIST_LINKED_NOTEBOOKS, this.listLinkedNotebooksResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.LIST_LINKED_NOTEBOOKS_FAULT, this.listLinkedNotebooksFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.EXPUNGE_LINKED_NOTEBOOK ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.EXPUNGE_LINKED_NOTEBOOK, this.expungeLinkedNotebookResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.EXPUNGE_LINKED_NOTEBOOK_FAULT, this.expungeLinkedNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.AUTHENTICATE_TO_SHARED_NOTEBOOK ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.AUTHENTICATE_TO_SHARED_NOTEBOOK, this.authenticateToSharedNotebookResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.AUTHENTICATE_TO_SHARED_NOTEBOOK_FAULT, this.authenticateToSharedNotebookFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.GET_SHARED_NOTEBOOK_BY_AUTH ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_SHARED_NOTEBOOK_BY_AUTH, this.getSharedNotebookByAuthResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.GET_SHARED_NOTEBOOK_BY_AUTH_FAULT, this.getSharedNotebookByAuthFaultHandler )
			}
			if ( event.type == EvernoteAPICommandTriggerEvent.EMAIL_NOTE ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.EMAIL_NOTE, this.emailNoteResultHandler )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.EMAIL_NOTE_FAULT, this.emailNoteFaultHandler )
			}		
		}
		
		/**Function that can create a command event from strict params**/
		/*public function createLinkedNotebook( args  : Array, fxSuccess : Function=null,
											  fxFault : Function=null, alert:Boolean=false, alertMessage : String = ''  ) : void
		{
			this.dispatch( EvernoteAPICommandTriggerEvent.CreateLinkedNotebook( null ) )
		}
*/
	
		/*
		static public function GetSyncChunk(afterUSN:int, maxEntries:int=0, fullSyncOnly:Boolean=false, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.GetSyncChunk( afterUSN, maxEntries, fullSyncOnly );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function GetNotebook(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.GetNotebook( guid );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function CreateNotebook(notebook:Notebook, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.CreateNotebook( notebook );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function UpdateNotebook(notebook:Notebook, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.UpdateNotebook( notebook );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function ExpungeNotebook(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.ExpungeNotebook( guid );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function ListTagsByNotebook(notebookGuid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.ListTagsByNotebook( notebookGuid );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function GetTag(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.GetTag( guid );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function CreateTag(tag:Tag, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.CreateTag( tag );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function UpdateTag(tag:Tag, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.UpdateTag( tag );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function UntagAll(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.UntagAll( guid );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function ExpungeTag(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.ExpungeTag( guid );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function GetSearch(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.GetSearch( guid );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function CreateSearch(search:SavedSearch, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.CreateSearch( search );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function UpdateSearch(search:SavedSearch, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.UpdateSearch( search );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function ExpungeSearch(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.ExpungeSearch( guid );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function FindNotes(filter:NoteFilter, offset:int=0, maxNotes:int=0, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.FindNotes( filter, offset, maxNotes );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function FindNoteCounts(filter:NoteFilter, withTrash:Boolean=false, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.FindNoteCounts( filter, withTrash );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function GetNote(guid:String, withContent:Boolean=false, withResourcesData:Boolean=false, withResourcesRecognition:Boolean=false, withResourcesAlternateData:Boolean=false, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.GetNote( guid, withContent, withResourcesData, withResourcesRecognition, withResourcesAlternateData );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function GetNoteContent(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.GetNoteContent( guid );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function GetNoteSearchText(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.GetNoteSearchText( guid );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function GetNoteTagNames(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.GetNoteTagNames( guid );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function CreateNote(note:Note, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.CreateNote( note );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function UpdateNote(note:Note, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.UpdateNote( note );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function DeleteNote(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.DeleteNote( guid );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function ExpungeNote(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.ExpungeNote( guid );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function ExpungeNotes(noteGuids:Array, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.ExpungeNotes( noteGuids );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function CopyNote(noteGuid:String, toNotebookGuid:String="", fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.CopyNote( noteGuid, toNotebookGuid );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function ListNoteVersions(noteGuid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.ListNoteVersions( noteGuid );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function GetNoteVersion(noteGuid:String, updateSequenceNum:int=0, withResourcesData:Boolean=false, withResourcesRecognition:Boolean=false, withResourcesAlternateData:Boolean=false, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.GetNoteVersion( noteGuid, updateSequenceNum, withResourcesData, withResourcesRecognition, withResourcesAlternateData );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function GetResource(guid:String, withData:Boolean=false, withRecognition:Boolean=false, withAttributes:Boolean=false, withAlternateData:Boolean=false, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.GetResource( guid, withData, withRecognition, withAttributes, withAlternateData );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function UpdateResource(resource:Resource, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.UpdateResource( resource );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function GetResourceData(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.GetResourceData( guid );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function GetResourceByHash(noteGuid:String, contentHash:ByteArray=null, withData:Boolean=false, withRecognition:Boolean=false, withAlternateData:Boolean=false, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.GetResourceByHash( noteGuid, contentHash, withData, withRecognition, withAlternateData );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function GetResourceRecognition(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.GetResourceRecognition( guid );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function GetResourceAlternateData(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.GetResourceAlternateData( guid );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function GetResourceAttributes(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.GetResourceAttributes( guid );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function GetAds(adParameters:AdParameters, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.GetAds( adParameters );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function GetRandomAd(adParameters:AdParameters, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.GetRandomAd( adParameters );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function GetPublicNotebook(userId:String, publicUri:String="", fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.GetPublicNotebook( userId, publicUri );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function CreateSharedNotebook(sharedNotebook:SharedNotebook, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.CreateSharedNotebook( sharedNotebook );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function ExpungeSharedNotebooks(sharedNotebookIds:Array, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.ExpungeSharedNotebooks( sharedNotebookIds );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function CreateLinkedNotebook(linkedNotebook:LinkedNotebook, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.CreateLinkedNotebook( linkedNotebook );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function UpdateLinkedNotebook(linkedNotebook:LinkedNotebook, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.UpdateLinkedNotebook( linkedNotebook );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function ExpungeLinkedNotebook(linkedNotebookId:Number, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.ExpungeLinkedNotebook( linkedNotebookId );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function String(shareKey:String, authenticationToken:String="", fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.String( shareKey );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}
		
		static public function EmailNote(parameters:NoteEmailParameters, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = EvernoteAPICommandTriggerEvent.EmailNote( parameters );
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			this.dispatch(e)
		}		
		*/
		
		/**
		 * Maps user store commands 
		 * */
		static public function mapCommands(commandMap :  Object) : void
		{
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.AUTHENTICATE, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );			
 
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_SYNC_STATE, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_SYNC_CHUNK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.LIST_NOTEBOOKS, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_NOTEBOOK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_DEFAULT_NOTEBOOK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.CREATE_NOTEBOOK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.UPDATE_NOTEBOOK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.EXPUNGE_NOTEBOOK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.LIST_TAGS, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.LIST_TAGS_BY_NOTEBOOK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_TAG, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.CREATE_TAG, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.UPDATE_TAG, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.UNTAG_ALL, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.EXPUNGE_TAG, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.LIST_SEARCHES, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_SEARCH, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.CREATE_SEARCH, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.UPDATE_SEARCH, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.EXPUNGE_SEARCH, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.FIND_NOTES, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.FIND_NOTE_COUNTS, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_NOTE, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_NOTE_CONTENT, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_NOTE_SEARCH_TEXT, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_NOTE_TAG_NAMES, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.CREATE_NOTE, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.UPDATE_NOTE, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.DELETE_NOTE, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.EXPUNGE_NOTE, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.EXPUNGE_NOTES, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.EXPUNGE_INACTIVE_NOTES, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.COPY_NOTE, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.LIST_NOTE_VERSIONS, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_NOTE_VERSION, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_RESOURCE, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.UPDATE_RESOURCE, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_RESOURCE_DATA, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_RESOURCE_BY_HASH, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_RESOURCE_RECOGNITION, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_RESOURCE_ALTERNATE_DATA, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_RESOURCE_ATTRIBUTES, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_ACCOUNT_SIZE, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_ADS, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_RANDOM_AD, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_PUBLIC_NOTEBOOK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.CREATE_SHARED_NOTEBOOK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.LIST_SHARED_NOTEBOOKS, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.EXPUNGE_SHARED_NOTEBOOKS, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.CREATE_LINKED_NOTEBOOK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.UPDATE_LINKED_NOTEBOOK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.LIST_LINKED_NOTEBOOKS, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.EXPUNGE_LINKED_NOTEBOOK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.AUTHENTICATE_TO_SHARED_NOTEBOOK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_SHARED_NOTEBOOK_BY_AUTH, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.EMAIL_NOTE, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );			
			
			
		}
			
	}
}
package air.update
{
   import air.update.events.DownloadErrorEvent;
   import air.update.events.StatusFileUpdateErrorEvent;
   import air.update.events.StatusFileUpdateEvent;
   import air.update.events.StatusUpdateErrorEvent;
   import air.update.events.StatusUpdateEvent;
   import air.update.events.UpdateEvent;
   import air.update.logging.Logger;
   import air.update.states.UpdateState;
   import air.update.ui.UpdaterUI;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.ProgressEvent;
   import flash.filesystem.File;
   
   public class ApplicationUpdaterUI extends EventDispatcher
   {
      
      private static var logger:Logger = Logger.getLogger("air.update.ApplicationUpdaterUI");
      
      private var isUpdaterUIInitialized:Boolean;
      
      private var applicationUpdater:UpdaterUI;
      
      public function ApplicationUpdaterUI()
      {
         super();
         this.applicationUpdater = new UpdaterUI();
         this.applicationUpdater.addEventListener(UpdateEvent.INITIALIZED,this.dispatchProxy);
         this.applicationUpdater.addEventListener(ErrorEvent.ERROR,this.dispatchError);
         this.applicationUpdater.addEventListener(UpdateEvent.CHECK_FOR_UPDATE,this.dispatchProxy);
         this.applicationUpdater.addEventListener(StatusUpdateEvent.UPDATE_STATUS,this.dispatchProxy);
         this.applicationUpdater.addEventListener(UpdateEvent.DOWNLOAD_START,this.dispatchProxy);
         this.applicationUpdater.addEventListener(ProgressEvent.PROGRESS,this.dispatchProxy);
         this.applicationUpdater.addEventListener(UpdateEvent.DOWNLOAD_COMPLETE,this.dispatchProxy);
         this.applicationUpdater.addEventListener(UpdateEvent.BEFORE_INSTALL,this.dispatchProxy);
         this.applicationUpdater.addEventListener(StatusUpdateErrorEvent.UPDATE_ERROR,this.dispatchProxy);
         this.applicationUpdater.addEventListener(DownloadErrorEvent.DOWNLOAD_ERROR,this.dispatchProxy);
         this.applicationUpdater.addEventListener(StatusFileUpdateEvent.FILE_UPDATE_STATUS,this.dispatchProxy);
         this.applicationUpdater.addEventListener(StatusFileUpdateErrorEvent.FILE_UPDATE_ERROR,this.dispatchProxy);
      }
      
      public function get delay() : Number
      {
         return this.applicationUpdater.delay;
      }
      
      public function addResources(param1:String, param2:Object) : void
      {
         this.applicationUpdater.addResources(param1,param2);
      }
      
      public function get isFirstRun() : Boolean
      {
         return this.applicationUpdater.isFirstRun;
      }
      
      public function set delay(param1:Number) : void
      {
         this.applicationUpdater.delay = param1;
      }
      
      public function get localeChain() : Array
      {
         return this.applicationUpdater.localeChain;
      }
      
      public function installFromAIRFile(param1:File) : void
      {
         this.applicationUpdater.installFromAIRFile(param1);
      }
      
      public function get isFileUpdateVisible() : Boolean
      {
         return this.applicationUpdater.isFileUpdateVisible;
      }
      
      public function set updateURL(param1:String) : void
      {
         this.applicationUpdater.updateURL = param1;
      }
      
      public function get isNewerVersionFunction() : Function
      {
         return this.applicationUpdater.isNewerVersionFunction;
      }
      
      public function set localeChain(param1:Array) : void
      {
         this.applicationUpdater.localeChain = param1;
      }
      
      public function initialize() : void
      {
         this.applicationUpdater.initialize();
      }
      
      public function set isUnexpectedErrorVisible(param1:Boolean) : void
      {
         this.applicationUpdater.isUnexpectedErrorVisible = param1;
      }
      
      public function get configurationFile() : File
      {
         return this.applicationUpdater.configurationFile;
      }
      
      public function get isDownloadProgressVisible() : Boolean
      {
         return this.applicationUpdater.isDownloadProgressVisible;
      }
      
      protected function dispatchProxy(param1:Event) : void
      {
         if(param1.type == UpdateEvent.INITIALIZED)
         {
            this.isUpdaterUIInitialized = true;
         }
         if(param1 is ErrorEvent)
         {
            if(hasEventListener(param1.type))
            {
               dispatchEvent(param1);
            }
         }
         else
         {
            dispatchEvent(param1);
         }
      }
      
      public function set isFileUpdateVisible(param1:Boolean) : void
      {
         this.applicationUpdater.isFileUpdateVisible = param1;
      }
      
      public function get wasPendingUpdate() : Boolean
      {
         return this.applicationUpdater.wasPendingUpdate;
      }
      
      public function get updateDescriptor() : XML
      {
         return this.applicationUpdater.updateDescriptor;
      }
      
      public function set isNewerVersionFunction(param1:Function) : void
      {
         this.applicationUpdater.isNewerVersionFunction = param1;
      }
      
      public function get isUnexpectedErrorVisible() : Boolean
      {
         return this.applicationUpdater.isUnexpectedErrorVisible;
      }
      
      public function get currentVersion() : String
      {
         return this.applicationUpdater.currentVersion;
      }
      
      public function get previousVersion() : String
      {
         return this.applicationUpdater.previousVersion;
      }
      
      public function cancelUpdate() : void
      {
         this.applicationUpdater.cancelUpdate();
      }
      
      public function set configurationFile(param1:File) : void
      {
         this.applicationUpdater.configurationFile = param1;
      }
      
      public function get isUpdateInProgress() : Boolean
      {
         return this.applicationUpdater.currentState != UpdateState.getStateName(UpdateState.READY);
      }
      
      public function get updateURL() : String
      {
         return this.applicationUpdater.updateURL;
      }
      
      public function get isInstallUpdateVisible() : Boolean
      {
         return this.applicationUpdater.isInstallUpdateVisible;
      }
      
      public function get previousApplicationStorageDirectory() : File
      {
         return this.applicationUpdater.previousApplicationStorageDirectory;
      }
      
      public function set isDownloadProgressVisible(param1:Boolean) : void
      {
         this.applicationUpdater.isDownloadProgressVisible = param1;
      }
      
      protected function dispatchError(param1:ErrorEvent) : void
      {
         if(!this.isUpdaterUIInitialized)
         {
            dispatchEvent(param1);
         }
      }
      
      public function set isInstallUpdateVisible(param1:Boolean) : void
      {
         this.applicationUpdater.isInstallUpdateVisible = param1;
      }
      
      public function set isDownloadUpdateVisible(param1:Boolean) : void
      {
         this.applicationUpdater.isDownloadUpdateVisible = param1;
      }
      
      public function get isDownloadUpdateVisible() : Boolean
      {
         return this.applicationUpdater.isDownloadUpdateVisible;
      }
      
      public function set isCheckForUpdateVisible(param1:Boolean) : void
      {
         this.applicationUpdater.isCheckForUpdateVisible = param1;
      }
      
      public function checkNow() : void
      {
         this.applicationUpdater.checkNow();
      }
      
      public function get isCheckForUpdateVisible() : Boolean
      {
         return this.applicationUpdater.isCheckForUpdateVisible;
      }
   }
}


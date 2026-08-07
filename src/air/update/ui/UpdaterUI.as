package air.update.ui
{
   import air.update.ApplicationUpdater;
   import air.update.events.UpdateEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.filesystem.File;
   
   public class UpdaterUI extends ApplicationUpdater
   {
      
      private var uiLoader:EmbeddedUILoader;
      
      public function UpdaterUI()
      {
         super();
      }
      
      override public function installFromAIRFile(param1:File) : void
      {
         this.showUI();
         super.installFromAIRFile(param1);
      }
      
      public function get isFileUpdateVisible() : Boolean
      {
         return configuration.isFileUpdateVisible;
      }
      
      public function addResources(param1:String, param2:Object) : void
      {
         if(Boolean(this.uiLoader) && this.uiLoader.initialized)
         {
            this.uiLoader.addResources(param1,param2);
         }
      }
      
      public function get isUnexpectedErrorVisible() : Boolean
      {
         return configuration.isUnexpectedErrorVisible;
      }
      
      public function set isFileUpdateVisible(param1:Boolean) : void
      {
         configuration.isFileUpdateVisible = param1;
      }
      
      public function set isUnexpectedErrorVisible(param1:Boolean) : void
      {
         configuration.isUnexpectedErrorVisible = param1;
      }
      
      override public function installUpdate() : void
      {
         this.hideUI();
         super.installUpdate();
      }
      
      override public function checkForUpdate() : void
      {
         this.hideUI();
         super.checkForUpdate();
      }
      
      private function onUILoadComplete(param1:Event) : void
      {
         dispatch(new UpdateEvent(UpdateEvent.INITIALIZED));
      }
      
      public function get isDownloadProgressVisible() : Boolean
      {
         return configuration.isDownloadProgressVisible;
      }
      
      public function set localeChain(param1:Array) : void
      {
         if(Boolean(this.uiLoader) && this.uiLoader.initialized)
         {
            this.uiLoader.setLocaleChain(param1);
         }
      }
      
      public function get localeChain() : Array
      {
         if(Boolean(this.uiLoader) && this.uiLoader.initialized)
         {
            return this.uiLoader.getLocaleChain();
         }
         return [];
      }
      
      public function get isInstallUpdateVisible() : Boolean
      {
         return configuration.isInstallUpdateVisible;
      }
      
      private function hideUI() : void
      {
         if(Boolean(this.uiLoader) && this.uiLoader.initialized)
         {
            this.uiLoader.hideWindow();
         }
      }
      
      private function showUI() : void
      {
         if(Boolean(this.uiLoader) && this.uiLoader.initialized)
         {
            this.uiLoader.showWindow();
         }
      }
      
      override public function cancelUpdate() : void
      {
         this.hideUI();
         super.cancelUpdate();
      }
      
      public function set isDownloadProgressVisible(param1:Boolean) : void
      {
         configuration.isDownloadProgressVisible = param1;
      }
      
      public function set isDownloadUpdateVisible(param1:Boolean) : void
      {
         configuration.isDownloadUpdateVisible = param1;
      }
      
      public function set isInstallUpdateVisible(param1:Boolean) : void
      {
         configuration.isInstallUpdateVisible = param1;
      }
      
      override public function downloadUpdate() : void
      {
         this.hideUI();
         super.downloadUpdate();
      }
      
      override public function checkNow() : void
      {
         this.showUI();
         super.checkNow();
      }
      
      public function get isDownloadUpdateVisible() : Boolean
      {
         return configuration.isDownloadUpdateVisible;
      }
      
      override protected function onInitializationComplete() : void
      {
         this.uiLoader = new EmbeddedUILoader();
         this.uiLoader.applicationUpdater = this;
         this.uiLoader.addEventListener(IOErrorEvent.IO_ERROR,function(param1:Event):void
         {
            throw new Error("Cannot load UI");
         });
         this.uiLoader.addEventListener(Event.COMPLETE,this.onUILoadComplete);
         this.uiLoader.load();
      }
      
      public function set isCheckForUpdateVisible(param1:Boolean) : void
      {
         configuration.isCheckForUpdateVisible = param1;
      }
      
      public function get isCheckForUpdateVisible() : Boolean
      {
         return configuration.isCheckForUpdateVisible;
      }
   }
}


package air.update.ui
{
   import air.update.logging.Logger;
   import flash.desktop.NativeApplication;
   import flash.display.Loader;
   import flash.display.NativeWindow;
   import flash.display.NativeWindowInitOptions;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.system.ApplicationDomain;
   import flash.system.Capabilities;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   
   public class EmbeddedUILoader extends EventDispatcher
   {
      
      private static var logger:Logger = Logger.getLogger("air.update.ui.EmbeddedUILoader");
      
      private var loader:Loader;
      
      private var _initialized:Boolean;
      
      private var uiPath:String;
      
      private var DialogBytes:Class = EmbeddedUILoader_DialogBytes;
      
      private var uiWindow:NativeWindow;
      
      private var appUpdater:UpdaterUI;
      
      private var isExiting:Boolean;
      
      private var applicationDialogs:Object;
      
      public function EmbeddedUILoader()
      {
         super();
         this.watchOpenedWindows();
         NativeApplication.nativeApplication.addEventListener(Event.EXITING,this.onExiting,false,int.MAX_VALUE);
      }
      
      private function setupResourceManager() : void
      {
         var resMgr:ResourceManagerReflection = null;
         var RESOURCE_BUNDLE_NAME:String = null;
         var addApplicationResourceBundles:Function = function():void
         {
            var _loc3_:Object = null;
            var _loc1_:Array = resMgr.getLocales();
            var _loc2_:int = 0;
            while(_loc2_ < _loc1_.length)
            {
               _loc3_ = resMgr.getResourceBundleContent(_loc1_[_loc2_],RESOURCE_BUNDLE_NAME);
               if(_loc3_)
               {
                  addResources(_loc1_[_loc2_],_loc3_);
               }
               _loc2_++;
            }
         };
         resMgr = ResourceManagerReflection.getInstance();
         if(!resMgr.hasResourceManager())
         {
            return;
         }
         resMgr.addEventListener(Event.CHANGE,function(param1:Event):void
         {
            addApplicationResourceBundles();
            setLocaleChain(resMgr.localeChain);
         });
         RESOURCE_BUNDLE_NAME = "ApplicationUpdaterDialogs";
         addApplicationResourceBundles();
         this.setLocaleChain(resMgr.localeChain);
      }
      
      public function addResources(param1:String, param2:Object) : void
      {
         if(this.applicationDialogs != null)
         {
            this.applicationDialogs.addResources(param1,param2);
         }
      }
      
      public function setLocaleChain(param1:Array) : void
      {
         if(this.applicationDialogs != null)
         {
            this.applicationDialogs.setLocaleChain(param1);
         }
      }
      
      private function onWindowClose(param1:Event) : void
      {
         if(this.uiWindow != null && !this.uiWindow.closed && NativeApplication.nativeApplication.openedWindows.length == 1)
         {
            logger.fine("UpdateUI is last window standing. Action: Close & Exit");
            this.onExiting(param1);
         }
         else
         {
            this.watchOpenedWindows();
         }
      }
      
      private function watchOpenedWindows() : void
      {
         var _loc2_:NativeWindow = null;
         logger.fine("Check opened windows");
         var _loc1_:uint = 0;
         while(_loc1_ < NativeApplication.nativeApplication.openedWindows.length)
         {
            _loc2_ = NativeApplication.nativeApplication.openedWindows[_loc1_];
            logger.fine("Opened window [" + _loc1_ + "] " + (_loc2_.title ? _loc2_.title : "-- no title --"));
            if(_loc2_ != this.uiWindow)
            {
               _loc2_.removeEventListener(Event.CLOSE,this.onWindowClose);
               if(!_loc2_.closed)
               {
                  _loc2_.addEventListener(Event.CLOSE,this.onWindowClose);
               }
            }
            _loc1_++;
         }
      }
      
      public function showWindow() : void
      {
         var screenX:Number;
         var screenY:Number;
         var options:NativeWindowInitOptions;
         if(this.uiWindow != null)
         {
            logger.fine("window already created");
            return;
         }
         this.isExiting = false;
         logger.fine("Creating UI window");
         screenX = Capabilities.screenResolutionX;
         screenY = Capabilities.screenResolutionY;
         options = new NativeWindowInitOptions();
         options.resizable = false;
         options.maximizable = false;
         this.uiWindow = new NativeWindow(options);
         this.uiWindow.addEventListener(Event.CLOSING,function(param1:Event):void
         {
            logger.fine("Closing UI window." + (isExiting ? " Exiting" : " Not exiting, just hide"));
            if(!isExiting)
            {
               param1.preventDefault();
            }
            else
            {
               uiWindow = null;
            }
            if(appUpdater.currentState != "PENDING_INSTALLING")
            {
               appUpdater.cancelUpdate();
            }
         });
         this.uiWindow.visible = false;
         this.uiWindow.width = 1024;
         this.uiWindow.height = 800;
         this.uiWindow.x = (screenX - 530) / 2;
         this.uiWindow.y = (screenY - 230) / 2;
         this.uiWindow.stage.align = StageAlign.TOP_LEFT;
         this.uiWindow.stage.scaleMode = StageScaleMode.NO_SCALE;
         this.uiWindow.stage.addChild(this.loader);
      }
      
      private function onUILoadError(param1:Event) : void
      {
         logger.severe("SWF Loading complete");
         dispatchEvent(param1);
      }
      
      public function getLocaleChain() : Array
      {
         if(this.applicationDialogs == null)
         {
            return [];
         }
         return this.applicationDialogs.getLocaleChain();
      }
      
      private function removeCloseListeners() : void
      {
         var _loc2_:NativeWindow = null;
         var _loc1_:uint = 0;
         while(_loc1_ < NativeApplication.nativeApplication.openedWindows.length)
         {
            _loc2_ = NativeApplication.nativeApplication.openedWindows[_loc1_];
            _loc2_.removeEventListener(Event.CLOSE,this.onWindowClose);
            _loc1_++;
         }
      }
      
      public function get initialized() : Boolean
      {
         return this._initialized;
      }
      
      public function hideWindow() : void
      {
         logger.fine("Hide window");
         if(this.uiWindow != null)
         {
            this.uiWindow.visible = false;
         }
      }
      
      private function onExiting(param1:Event) : void
      {
         logger.fine("Exiting: " + this.uiWindow);
         this.isExiting = true;
         this.unload();
      }
      
      private function onUILoadInit(param1:Event) : void
      {
         logger.fine("SWF Loading complete. Waiting for ApplicationComplete");
         this.loader.content.addEventListener("windowComplete",this.onUIApplicationComplete,true);
      }
      
      public function load() : void
      {
         if(this.loader != null)
         {
            return;
         }
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.onUILoadInit);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onUILoadError);
         var _loc1_:ByteArray = new this.DialogBytes() as ByteArray;
         if(_loc1_.length == 0)
         {
            dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
            return;
         }
         var _loc2_:LoaderContext = new LoaderContext(false,new ApplicationDomain());
         _loc2_.allowLoadBytesCodeExecution = true;
         this.showWindow();
         this.loader.loadBytes(_loc1_,_loc2_);
      }
      
      public function set applicationUpdater(param1:UpdaterUI) : void
      {
         this.appUpdater = param1;
      }
      
      private function onUIApplicationComplete(param1:Event) : void
      {
         logger.fine("Application loading complete.");
         this.applicationDialogs = (param1.currentTarget as Object).application;
         this.applicationDialogs.setApplicationUpdater(this.appUpdater);
         this.setupResourceManager();
         this._initialized = true;
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function unload() : void
      {
         logger.fine("unload " + this.uiWindow);
         if(this.uiWindow != null && !this.uiWindow.closed)
         {
            if(this.appUpdater.currentState != "PENDING_INSTALLING")
            {
               this.appUpdater.cancelUpdate();
            }
            if(this.applicationDialogs != null)
            {
               this.applicationDialogs.setApplicationUpdater(null);
            }
            this.uiWindow.close();
            this.uiWindow = null;
         }
      }
   }
}


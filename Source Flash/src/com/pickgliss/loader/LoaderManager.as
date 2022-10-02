package com.pickgliss.loader
{
   import flash.events.EventDispatcher;
   import flash.external.ExternalInterface;
   import flash.net.URLVariables;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   
   public class LoaderManager extends EventDispatcher
   {
      
      public static const ALLOW_MUTI_LOAD_COUNT:int = 8;
      
      public static const LOAD_FROM_LOCAL:int = 2;
      
      public static const LOAD_FROM_WEB:int = 1;
      
      public static const LOAD_NOT_SET:int = 0;
      
      private static var _instance:LoaderManager;
       
      
      private var _loadMode:int = 0;
      
      private var _loaderIdCounter:int = 0;
      
      private var _loaderSaveByID:Dictionary;
      
      private var _loaderSaveByPath:Dictionary;
      
      private var _loadingLoaderList:Vector.<BaseLoader>;
      
      private var _waitingLoaderList:Vector.<BaseLoader>;
      
      public function LoaderManager()
      {
         super();
         this._loaderSaveByID = new Dictionary();
         this._loaderSaveByPath = new Dictionary();
         this._loadingLoaderList = new Vector.<BaseLoader>();
         this._waitingLoaderList = new Vector.<BaseLoader>();
         this.initLoadMode();
      }
      
      public static function get Instance() : LoaderManager
      {
         if(_instance == null)
         {
            _instance = new LoaderManager();
         }
         return _instance;
      }
      
      public function creatLoaderByType(param1:String, param2:int, param3:URLVariables, param4:String, param5:ApplicationDomain) : BaseLoader
      {
         var _loc6_:BaseLoader = null;
         switch(param2)
         {
            case BaseLoader.BITMAP_LOADER:
               _loc6_ = new BitmapLoader(this.getNextLoaderID(),param1);
               break;
            case BaseLoader.TEXT_LOADER:
               _loc6_ = new TextLoader(this.getNextLoaderID(),param1,param3);
               break;
            case BaseLoader.DISPLAY_LOADER:
               _loc6_ = new DisplayLoader(this.getNextLoaderID(),param1);
               break;
            case BaseLoader.BYTE_LOADER:
               _loc6_ = new BaseLoader(this.getNextLoaderID(),param1);
               break;
            case BaseLoader.COMPRESS_TEXT_LOADER:
               _loc6_ = new CompressTextLoader(this.getNextLoaderID(),param1,param3);
               break;
            case BaseLoader.MODULE_LOADER:
               _loc6_ = new ModuleLoader(this.getNextLoaderID(),param1,param5);
               break;
            case BaseLoader.REQUEST_LOADER:
               _loc6_ = new RequestLoader(this.getNextLoaderID(),param1,param3,param4);
               break;
            case BaseLoader.COMPRESS_REQUEST_LOADER:
               _loc6_ = new CompressRequestLoader(this.getNextLoaderID(),param1,param3,param4);
         }
         return _loc6_;
      }
      
      public function getLoadMode() : int
      {
         return this._loadMode;
      }
      
      public function creatLoader(param1:String, param2:int, param3:URLVariables = null, param4:String = "GET", param5:ApplicationDomain = null) : *
      {
         var _loc6_:BaseLoader = null;
         param1 = param1.toLowerCase();
         var _loc7_:String = this.fixedVariablesURL(param1,param2,param3);
         _loc6_ = this.getLoaderByURL(_loc7_,param3);
         if(_loc6_ == null)
         {
            _loc6_ = this.creatLoaderByType(_loc7_,param2,param3,param4,param5);
         }
         else
         {
            _loc6_.domain = param5;
         }
         if(param2 != BaseLoader.REQUEST_LOADER && param2 != BaseLoader.COMPRESS_REQUEST_LOADER && param2 != BaseLoader.BITMAP_LOADER)
         {
            this._loaderSaveByID[_loc6_.id] = _loc6_;
            this._loaderSaveByPath[_loc6_.url] = _loc6_;
         }
         return _loc6_;
      }
      
      public function creatLoaderOriginal(param1:String, param2:int, param3:URLVariables = null, param4:String = "GET") : *
      {
         var _loc5_:BaseLoader = null;
         var _loc6_:String = this.fixedVariablesURL(param1,param2,param3);
         _loc5_ = this.getLoaderByURL(_loc6_,param3);
         if(_loc5_ == null)
         {
            _loc5_ = this.creatLoaderByType(_loc6_,param2,param3,param4,null);
         }
         if(param2 != BaseLoader.REQUEST_LOADER && param2 != BaseLoader.COMPRESS_REQUEST_LOADER && param2 != BaseLoader.BITMAP_LOADER)
         {
            this._loaderSaveByID[_loc5_.id] = _loc5_;
            this._loaderSaveByPath[_loc5_.url] = _loc5_;
         }
         return _loc5_;
      }
      
      public function creatAndStartLoad(param1:String, param2:int, param3:URLVariables = null) : BaseLoader
      {
         var _loc4_:BaseLoader = this.creatLoader(param1,param2,param3);
         this.startLoad(_loc4_);
         return _loc4_;
      }
      
      public function getLoaderByID(param1:int) : BaseLoader
      {
         return this._loaderSaveByID[param1];
      }
      
      public function getLoaderByURL(param1:String, param2:URLVariables) : BaseLoader
      {
         return this._loaderSaveByPath[param1];
      }
      
      public function getNextLoaderID() : int
      {
         return this._loaderIdCounter++;
      }
      
      public function saveFileToLocal(param1:BaseLoader) : void
      {
      }
      
      public function startLoad(param1:BaseLoader, param2:Boolean = false) : void
      {
         if(param1)
         {
            param1.addEventListener(LoaderEvent.COMPLETE,this.__onLoadFinish);
         }
         if(param1.isComplete)
         {
            param1.dispatchEvent(new LoaderEvent(LoaderEvent.COMPLETE,param1));
            return;
         }
         var _loc3_:ByteArray = LoaderSavingManager.loadCachedFile(param1.url,true);
         if(_loc3_)
         {
            param1.loadFromBytes(_loc3_);
            return;
         }
         if(this._loadingLoaderList.length >= ALLOW_MUTI_LOAD_COUNT && !param2 || this.getLoadMode() == LOAD_NOT_SET)
         {
            if(this._waitingLoaderList.indexOf(param1) == -1)
            {
               this._waitingLoaderList.push(param1);
            }
         }
         else
         {
            if(this._loadingLoaderList.indexOf(param1) == -1)
            {
               this._loadingLoaderList.push(param1);
            }
            if(this.getLoadMode() == LOAD_FROM_WEB || param1.type == BaseLoader.TEXT_LOADER)
            {
               param1.loadFromWeb();
            }
            else if(this.getLoadMode() == LOAD_FROM_LOCAL)
            {
               param1.getFilePathFromExternal();
            }
         }
      }
      
      private function __onLoadFinish(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadFinish);
         this._loadingLoaderList.splice(this._loadingLoaderList.indexOf(param1.loader),1);
         this.tryLoadWaiting();
      }
      
      private function initLoadMode() : void
      {
         if(!ExternalInterface.available)
         {
            this.setFlashLoadWeb();
            return;
         }
         ExternalInterface.addCallback("SetFlashLoadExternal",this.setFlashLoadExternal);
         setTimeout(this.setFlashLoadWeb,200);
      }
      
      private function onExternalLoadStop(param1:int, param2:String) : void
      {
         var _loc3_:BaseLoader = this.getLoaderByID(param1);
         _loc3_.loadFromExternal(param2);
      }
      
      private function setFlashLoadExternal() : void
      {
         this._loadMode = LOAD_FROM_LOCAL;
         ExternalInterface.addCallback("ExternalLoadStop",this.onExternalLoadStop);
         this.tryLoadWaiting();
      }
      
      private function setFlashLoadWeb() : void
      {
         this._loadMode = LOAD_FROM_WEB;
         this.tryLoadWaiting();
      }
      
      private function tryLoadWaiting() : void
      {
         var _loc2_:BaseLoader = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._waitingLoaderList.length)
         {
            if(this._loadingLoaderList.length < ALLOW_MUTI_LOAD_COUNT)
            {
               _loc2_ = this._waitingLoaderList.shift();
               this.startLoad(_loc2_);
            }
            _loc1_++;
         }
      }
      
      public function setup(param1:LoaderContext, param2:String) : void
      {
         DisplayLoader.Context = param1;
         TextLoader.TextLoaderKey = param2;
         LoaderSavingManager.setup();
      }
      
      private function fixedVariablesURL(param1:String, param2:int, param3:URLVariables) : String
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:* = null;
         if(param2 != BaseLoader.REQUEST_LOADER && param2 != BaseLoader.COMPRESS_REQUEST_LOADER)
         {
            _loc4_ = "";
            if(param3 == null)
            {
               param3 = new URLVariables();
            }
            if(param2 == BaseLoader.BYTE_LOADER || param2 == BaseLoader.DISPLAY_LOADER || param2 == BaseLoader.BITMAP_LOADER || param2 == BaseLoader.MODULE_LOADER)
            {
               param3["lv"] = LoaderSavingManager.Version;
            }
            else if(param2 == BaseLoader.COMPRESS_TEXT_LOADER || param2 == BaseLoader.TEXT_LOADER)
            {
               param3["rnd"] = TextLoader.TextLoaderKey;
            }
            _loc5_ = 0;
            for(_loc6_ in param3)
            {
               if(_loc5_ >= 1)
               {
                  _loc4_ += "&" + _loc6_ + "=" + param3[_loc6_];
               }
               else
               {
                  _loc4_ += _loc6_ + "=" + param3[_loc6_];
               }
               _loc5_++;
            }
            return param1 + "?" + _loc4_;
         }
         return param1;
      }
   }
}

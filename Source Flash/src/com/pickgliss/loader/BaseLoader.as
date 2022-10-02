package com.pickgliss.loader
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.external.ExternalInterface;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.system.ApplicationDomain;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   
   [Event(name="complete",type="com.pickgliss.loader.LoaderEvent")]
   [Event(name="loadError",type="com.pickgliss.loader.LoaderEvent")]
   [Event(name="progress",type="com.pickgliss.loader.LoaderEvent")]
   public class BaseLoader extends EventDispatcher
   {
      
      public static const BITMAP_LOADER:int = 0;
      
      public static const BYTE_LOADER:int = 3;
      
      public static const DISPLAY_LOADER:int = 1;
      
      public static const TEXT_LOADER:int = 2;
      
      public static const MODULE_LOADER:int = 4;
      
      public static const COMPRESS_TEXT_LOADER:int = 5;
      
      public static const REQUEST_LOADER:int = 6;
      
      public static const COMPRESS_REQUEST_LOADER:int = 7;
      
      public static const TRY_LOAD_TIMES:int = 3;
       
      
      public var loadCompleteMessage:String;
      
      public var loadErrorMessage:String;
      
      public var loadProgressMessage:String;
      
      protected var _args:URLVariables;
      
      protected var _id:int;
      
      protected var _isComplete:Boolean;
      
      protected var _isSuccess:Boolean;
      
      protected var _loader:URLLoader;
      
      protected var _progress:Number = 0;
      
      protected var _request:URLRequest;
      
      protected var _url:String;
      
      protected var _isLoading:Boolean;
      
      protected var _requestMethod:String;
      
      protected var _currentLoadPath:String;
      
      private var _currentTryTime:int = 0;
      
      protected var _starTime:int;
      
      public var analyzer:DataAnalyzer;
      
      public var domain:ApplicationDomain;
      
      public function BaseLoader(param1:int, param2:String, param3:URLVariables = null, param4:String = "GET")
      {
         super();
         this._url = param2;
         this._args = param3;
         this._id = param1;
         this._loader = new URLLoader();
         this._requestMethod = param4;
      }
      
      public function get args() : URLVariables
      {
         return this._args;
      }
      
      public function get content() : *
      {
         return this._loader.data;
      }
      
      public function getFilePathFromExternal() : void
      {
         ExternalInterface.call("ExternalLoadStart",this._id,this._url);
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get isComplete() : Boolean
      {
         return this._isComplete;
      }
      
      public function get isSuccess() : Boolean
      {
         return this._isSuccess;
      }
      
      public function unload() : void
      {
         this._loader.close();
      }
      
      public function loadFromExternal(param1:String) : void
      {
         this.startLoad(param1);
      }
      
      public function loadFromBytes(param1:ByteArray) : void
      {
         this._starTime = getTimer();
      }
      
      public function loadFromWeb() : void
      {
         this.startLoad(this._url);
      }
      
      public function get progress() : Number
      {
         return this._progress;
      }
      
      public function get type() : int
      {
         return BYTE_LOADER;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function set url(param1:String) : void
      {
         this._url = param1;
      }
      
      public function get isLoading() : Boolean
      {
         return this._isLoading;
      }
      
      public function set isLoading(param1:Boolean) : void
      {
         this._isLoading = param1;
      }
      
      protected function __onDataLoadComplete(param1:Event) : void
      {
         this.removeEvent();
         this._loader.close();
         this.fireCompleteEvent();
      }
      
      protected function fireCompleteEvent() : void
      {
         this._progress = 1;
         dispatchEvent(new LoaderEvent(LoaderEvent.PROGRESS,this));
         this._isSuccess = true;
         this._isComplete = true;
         this._isLoading = false;
         this.domain = null;
         dispatchEvent(new LoaderEvent(LoaderEvent.COMPLETE,this));
      }
      
      protected function __onIOError(param1:IOErrorEvent) : void
      {
         this.onLoadError();
      }
      
      protected function __onProgress(param1:ProgressEvent) : void
      {
         this._progress = param1.bytesLoaded / param1.bytesTotal;
         if(this.loadProgressMessage)
         {
            this.loadProgressMessage = this.loadProgressMessage.replace("{progress}",String(Math.round(this._progress * 100)));
         }
         dispatchEvent(new LoaderEvent(LoaderEvent.PROGRESS,this));
      }
      
      protected function __onStatus(param1:HTTPStatusEvent) : void
      {
         if(param1.status > 399)
         {
            this.onLoadError();
         }
      }
      
      protected function addEvent() : void
      {
         this._loader.addEventListener(Event.COMPLETE,this.__onDataLoadComplete);
         this._loader.addEventListener(ProgressEvent.PROGRESS,this.__onProgress);
         this._loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.__onStatus);
         this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.__onIOError);
      }
      
      protected function getLoadDataFormat() : String
      {
         return URLLoaderDataFormat.BINARY;
      }
      
      protected function onLoadError() : void
      {
         if(this._currentTryTime < TRY_LOAD_TIMES)
         {
            ++this._currentTryTime;
            this._isLoading = false;
            this.startLoad(this._currentLoadPath);
         }
         else
         {
            this.removeEvent();
            this._loader.close();
            this._isComplete = true;
            this._isLoading = false;
            this._isSuccess = false;
            dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_ERROR,this));
            dispatchEvent(new LoaderEvent(LoaderEvent.COMPLETE,this));
         }
      }
      
      protected function fireErrorEvent() : void
      {
         dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_ERROR,this));
      }
      
      protected function removeEvent() : void
      {
         this._loader.removeEventListener(Event.COMPLETE,this.__onDataLoadComplete);
         this._loader.removeEventListener(ProgressEvent.PROGRESS,this.__onProgress);
         this._loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.__onStatus);
         this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.__onIOError);
      }
      
      protected function startLoad(param1:String) : void
      {
         if(this._isLoading)
         {
            return;
         }
         this.addEvent();
         this._currentLoadPath = param1;
         this._loader.dataFormat = this.getLoadDataFormat();
         this._request = new URLRequest(param1);
         this._request.method = this._requestMethod;
         this._request.data = this._args;
         this._isLoading = true;
         this._loader.load(this._request);
         this._starTime = getTimer();
      }
   }
}

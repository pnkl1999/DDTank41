package com.pickgliss.loader
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoaderDataFormat;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   
   public class DisplayLoader extends BaseLoader
   {
      
      public static var Context:LoaderContext;
       
      
      protected var _displayLoader:Loader;
      
      public function DisplayLoader(param1:int, param2:String)
      {
         this._displayLoader = new Loader();
         super(param1,param2,null);
      }
      
      override public function loadFromBytes(param1:ByteArray) : void
      {
         super.loadFromBytes(param1);
         this._displayLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.__onContentLoadComplete);
         this._displayLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.__onIoError);
         if(this.type == BaseLoader.MODULE_LOADER)
         {
            this._displayLoader.loadBytes(param1,Context);
         }
         else
         {
            this._displayLoader.loadBytes(param1);
         }
      }
      
      private function __onIoError(param1:IOErrorEvent) : void
      {
         this._displayLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.__onIoError);
         throw new Error(param1.text + " url: " + _url);
      }
      
      protected function __onContentLoadComplete(param1:Event) : void
      {
         this._displayLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.__onContentLoadComplete);
         this._displayLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.__onIoError);
         fireCompleteEvent();
         this._displayLoader.unload();
         this._displayLoader = null;
      }
      
      override protected function __onDataLoadComplete(param1:Event) : void
      {
         removeEvent();
         _loader.close();
         if(_loader.data.length == 0)
         {
            return;
         }
         LoaderSavingManager.cacheFile(_url,_loader.data,true);
         this.loadFromBytes(_loader.data);
      }
      
      override public function get content() : *
      {
         return this._displayLoader.content;
      }
      
      override protected function getLoadDataFormat() : String
      {
         return URLLoaderDataFormat.BINARY;
      }
      
      override public function get type() : int
      {
         return BaseLoader.DISPLAY_LOADER;
      }
   }
}

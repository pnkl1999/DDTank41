package com.pickgliss.loader
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class LoaderQueue extends EventDispatcher
   {
       
      
      private var _loaders:Vector.<BaseLoader>;
      
      public function LoaderQueue()
      {
         super();
         this._loaders = new Vector.<BaseLoader>();
      }
      
      public function addLoader(param1:BaseLoader) : void
      {
         this._loaders.push(param1);
      }
      
      public function start() : void
      {
         var _loc1_:int = this._loaders.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(this._loaders == null)
            {
               return;
            }
            this._loaders[_loc2_].addEventListener(LoaderEvent.COMPLETE,this.__loadComplete);
            LoaderManager.Instance.startLoad(this._loaders[_loc2_]);
            _loc2_++;
         }
         if(_loc1_ == 0)
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._loaders = null;
      }
      
      public function removeEvent() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._loaders.length)
         {
            this._loaders[_loc1_].removeEventListener(LoaderEvent.COMPLETE,this.__loadComplete);
            _loc1_++;
         }
      }
      
      public function get length() : int
      {
         return this._loaders.length;
      }
      
      public function get loaders() : Vector.<BaseLoader>
      {
         return this._loaders;
      }
      
      private function __loadComplete(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener(LoaderEvent.COMPLETE,this.__loadComplete);
         if(this.isComplete)
         {
            this.removeEvent();
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      public function get isComplete() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._loaders.length)
         {
            if(!this._loaders[_loc1_].isComplete)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
   }
}

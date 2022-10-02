package com.pickgliss.loader
{
   import com.pickgliss.ui.core.Disposeable;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   [Event(name="complete",type="flash.events.Event")]
   [Event(name="change",type="flash.events.Event")]
   public class QueueLoader extends EventDispatcher implements Disposeable
   {
       
      
      private var _loaders:Vector.<BaseLoader>;
      
      public function QueueLoader()
      {
         super();
         this._loaders = new Vector.<BaseLoader>();
      }
      
      public function addLoader(param1:BaseLoader) : void
      {
         this._loaders.push(param1);
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
            this._loaders[_loc1_].removeEventListener(LoaderEvent.COMPLETE,this.__loadNext);
            _loc1_++;
         }
      }
      
      public function isAllComplete() : Boolean
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
      
      public function isLoading() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._loaders.length)
         {
            if(this._loaders[_loc1_].isLoading)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function get completeCount() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this._loaders.length)
         {
            if(this._loaders[_loc2_].isComplete)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function get length() : int
      {
         return this._loaders.length;
      }
      
      public function get loaders() : Vector.<BaseLoader>
      {
         return this._loaders;
      }
      
      public function start() : void
      {
         this.tryLoadNext();
      }
      
      private function __loadNext(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener(LoaderEvent.COMPLETE,this.__loadNext);
         dispatchEvent(new Event(Event.CHANGE));
         this.tryLoadNext();
      }
      
      private function tryLoadNext() : void
      {
         if(this._loaders == null)
         {
            return;
         }
         var _loc1_:int = this._loaders.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(!this._loaders[_loc2_].isComplete)
            {
               this._loaders[_loc2_].addEventListener(LoaderEvent.COMPLETE,this.__loadNext);
               LoaderManager.Instance.startLoad(this._loaders[_loc2_]);
               return;
            }
            _loc2_++;
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}

package ddt.utils
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   [Event(name="close",type="flash.events.Event")]
   [Event(name="change",type="flash.events.Event")]
   [Event(name="complete",type="flash.events.Event")]
   public final class QueueLoaderUtil extends EventDispatcher implements Disposeable
   {
       
      
      private var _loaders:Vector.<BaseLoader>;
      
      private var _isSmallLoading:Boolean;
      
      public function QueueLoaderUtil()
      {
         super();
         this._loaders = new Vector.<BaseLoader>();
      }
      
      public function addLoader(param1:BaseLoader) : void
      {
         this._loaders.push(param1);
      }
      
      public function start(param1:Boolean = true) : void
      {
         this._isSmallLoading = param1;
         if(this._isSmallLoading)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener("close",this.__onClose);
         }
         this.tryLoadNext();
      }
      
      public function reset() : void
      {
         this.removeEvent();
         this._loaders.splice(0,this._loaders.length);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._loaders = null;
      }
      
      public function removeEvent() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this._loaders.length)
         {
            this._loaders[_loc1_].removeEventListener("complete",this.__loadNext);
            if(this._isSmallLoading)
            {
               this._loaders[_loc1_].removeEventListener("progress",this.__progress);
            }
            _loc1_++;
         }
      }
      
      public function isAllComplete() : Boolean
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
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
         _loc1_ = 0;
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
         _loc1_ = 0;
         while(_loc1_ < this._loaders.length)
         {
            if(this._loaders[_loc1_].isComplete)
            {
               _loc2_++;
            }
            _loc1_++;
         }
         return _loc2_;
      }
      
      public function get length() : int
      {
         return this._loaders.length;
      }
      
      public function get loaders() : Vector.<BaseLoader>
      {
         return this._loaders;
      }
      
      private function __loadNext(param1:LoaderEvent) : void
      {
         var _loc2_:BaseLoader = param1.loader as BaseLoader;
         _loc2_.removeEventListener("complete",this.__loadNext);
         if(this._isSmallLoading)
         {
            _loc2_.removeEventListener("progress",this.__progress);
         }
         dispatchEvent(new Event("change"));
         this.tryLoadNext();
      }
      
      private function __progress(param1:LoaderEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = this._loaders.length;
         var _loc4_:Number = ((_loc3_ = this.completeCount) / _loc2_ + 1 / _loc2_ * param1.loader.progress) * 100;
         UIModuleSmallLoading.Instance.progress = _loc4_;
         if(_loc4_ < 100)
         {
            UIModuleSmallLoading.Instance.show();
         }
      }
      
      private function tryLoadNext() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = this._loaders.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(!this._loaders[_loc1_].isComplete)
            {
               this._loaders[_loc1_].addEventListener("complete",this.__loadNext);
               if(this._isSmallLoading)
               {
                  this._loaders[_loc1_].addEventListener("progress",this.__progress);
               }
               LoaderManager.Instance.startLoad(this._loaders[_loc1_]);
               return;
            }
            _loc1_++;
         }
         this.reset();
         dispatchEvent(new Event("complete"));
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener("close",this.__onClose);
      }
      
      private function __onClose(param1:Event) : void
      {
         this.reset();
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener("close",this.__onClose);
         dispatchEvent(new Event("close"));
      }
   }
}

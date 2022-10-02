package trainer.controller
{
   import com.pickgliss.toplevel.StageReferance;
   import flash.events.Event;
   import trainer.data.Step;
   
   public class NewHandQueue
   {
      
      private static var _instance:NewHandQueue;
       
      
      private var _queue:Array;
      
      private var _isDelay:Boolean;
      
      public function NewHandQueue(param1:NewHandQueueEnforcer)
      {
         super();
         this._queue = new Array();
         this._isDelay = false;
         StageReferance.stage.addEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      public static function get Instance() : NewHandQueue
      {
         if(!_instance)
         {
            _instance = new NewHandQueue(new NewHandQueueEnforcer());
         }
         return _instance;
      }
      
      public function push(param1:Step) : void
      {
         this._queue.push(param1);
         if(this._queue.length == 1)
         {
            this._queue[0].prepare();
         }
      }
      
      private function __enterFrame(param1:Event) : void
      {
         var _loc2_:Step = null;
         if(this._isDelay)
         {
            _loc2_ = this._queue[0];
            --_loc2_.delay;
            if(_loc2_.delay <= 0)
            {
               _loc2_.prepare();
               this._isDelay = false;
            }
         }
         else
         {
            this.execute();
         }
      }
      
      private function execute() : void
      {
         var _loc1_:Step = null;
         if(!this._queue)
         {
            return;
         }
         if(this._queue.length > 0)
         {
            _loc1_ = this._queue[0];
            if(_loc1_.execute())
            {
               if(_loc1_.ID != Step.POP_LOST)
               {
                  NewHandGuideManager.Instance.progress = _loc1_.ID;
               }
               _loc1_.finish();
               _loc1_.dispose();
               if(this._queue)
               {
                  this._queue.shift();
                  this.next();
               }
            }
         }
      }
      
      private function next() : void
      {
         var _loc1_:Step = null;
         if(this._queue.length > 0)
         {
            _loc1_ = this._queue[0];
            if(_loc1_.delay > 0)
            {
               this._isDelay = true;
            }
            else
            {
               _loc1_.prepare();
            }
         }
      }
      
      public function dispose() : void
      {
         StageReferance.stage.removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         _instance = null;
         this._queue = null;
      }
   }
}

class NewHandQueueEnforcer
{
    
   
   function NewHandQueueEnforcer()
   {
      super();
   }
}

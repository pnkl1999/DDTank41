package game.actions
{
   import ddt.manager.SocketManager;
   import flash.utils.getQualifiedClassName;
   
   public class ActionManager
   {
       
      
      private var _queue:Array;
      
      public function ActionManager()
      {
         super();
         this._queue = new Array();
      }
      
      public function act(param1:BaseAction) : void
      {
         var _loc3_:BaseAction = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._queue.length)
         {
            _loc3_ = this._queue[_loc2_];
            if(_loc3_.connect(param1))
            {
               return;
            }
            if(_loc3_.canReplace(param1))
            {
               param1.prepare();
               this._queue[_loc2_] = param1;
               return;
            }
            _loc2_++;
         }
         this._queue.push(param1);
         if(this._queue.length == 1)
         {
            param1.prepare();
         }
      }
      
      public function execute() : void
      {
         var _loc1_:BaseAction = null;
         if(this._queue.length > 0)
         {
            _loc1_ = this._queue[0];
            if(!_loc1_.isFinished)
            {
               _loc1_.execute();
            }
            else
            {
               this._queue.shift();
               if(this._queue.length > 0)
               {
                  this._queue[0].prepare();
               }
            }
         }
      }
      
      public function traceAllRemainAction(param1:String = "") : void
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < this._queue.length)
         {
            _loc4_ = getQualifiedClassName(this._queue[_loc3_]);
            _loc5_ = _loc4_.split("::");
            _loc2_ += _loc5_[_loc5_.length - 1] + " | ";
            _loc3_++;
         }
         SocketManager.Instance.out.sendErrorMsg("客户端卡死了" + param1 + " : " + _loc2_);
      }
      
      public function get actionCount() : int
      {
         return this._queue.length;
      }
      
      public function executeAtOnce() : void
      {
         var _loc1_:BaseAction = null;
         for each(_loc1_ in this._queue)
         {
            _loc1_.executeAtOnce();
         }
      }
      
      public function clear() : void
      {
         var _loc1_:BaseAction = null;
         for each(_loc1_ in this._queue)
         {
            _loc1_.cancel();
         }
         this._queue = [];
      }
   }
}

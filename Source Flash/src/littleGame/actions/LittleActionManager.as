package littleGame.actions
{
   import ddt.ddt_internal;
   
   use namespace ddt_internal;
   
   public class LittleActionManager
   {
       
      
      ddt_internal var _queue:Array;
      
      public function LittleActionManager()
      {
         super();
         this._queue = new Array();
      }
      
      public function act(action:LittleAction) : void
      {
         var c:LittleAction = null;
         for(var i:int = 0; i < this._queue.length; i++)
         {
            c = this._queue[i];
            if(c.connect(action))
            {
               return;
            }
            if(c.canReplace(action))
            {
               action.prepare();
               this._queue[i] = action;
               return;
            }
         }
         this._queue.push(action);
         if(this._queue.length == 1)
         {
            action.prepare();
         }
      }
      
      public function execute() : void
      {
         var c:LittleAction = null;
         if(this._queue.length > 0)
         {
            c = this._queue[0];
            if(!c.isFinished)
            {
               c.execute();
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
      
      public function dispose() : void
      {
         var action:LittleAction = null;
         for each(action in this._queue)
         {
            action.cancel();
         }
         this._queue = null;
      }
   }
}

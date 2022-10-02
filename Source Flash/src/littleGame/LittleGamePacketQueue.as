package littleGame
{
   import ddt.interfaces.IProcessObject;
   import ddt.manager.ProcessManager;
   import ddt.manager.SocketManager;
   import flash.events.Event;
   import littleGame.events.LittleGameSocketEvent;
   
   public class LittleGamePacketQueue implements IProcessObject
   {
      
      private static var _ins:LittleGamePacketQueue;
       
      
      private var _executable:Array;
      
      public var _waitlist:Array;
      
      private var _lifeTime:int;
      
      private var _onProcess:Boolean = false;
      
      public function LittleGamePacketQueue()
      {
         super();
      }
      
      public static function get Instance() : LittleGamePacketQueue
      {
         return _ins = _ins || new LittleGamePacketQueue();
      }
      
      public function addQueue(event:LittleGameSocketEvent) : void
      {
         this._waitlist.push(event);
      }
      
      public function startup() : void
      {
         ProcessManager.Instance.addObject(this);
      }
      
      public function shutdown() : void
      {
         ProcessManager.Instance.removeObject(this);
      }
      
      public function setLifeTime(time:int) : void
      {
         this._lifeTime = time;
      }
      
      public function reset() : void
      {
         this._executable = [];
         this._waitlist = [];
      }
      
      public function dispose() : void
      {
      }
      
      public function get onProcess() : Boolean
      {
         return this._onProcess;
      }
      
      public function set onProcess(val:Boolean) : void
      {
         this._onProcess = val;
      }
      
      public function get running() : Boolean
      {
         return this._onProcess;
      }
      
      public function process(rate:Number) : void
      {
         var count:int = 0;
         var i:int = 0;
         var j:int = 0;
         var evt:LittleGameSocketEvent = null;
         ++this._lifeTime;
         if(this.running)
         {
            count = 0;
            for(i = 0; i < this._waitlist.length; i++)
            {
               evt = this._waitlist[i];
               if(evt.pkg.extend2 > this._lifeTime)
               {
                  break;
               }
               this._executable.push(evt);
               count++;
            }
            this._waitlist.splice(0,count);
            count = 0;
            for(j = 0; j < this._executable.length; j++)
            {
               if(this.running)
               {
                  this.dispatchEvent(this._executable[j]);
                  count++;
               }
            }
            this._executable.splice(0,count);
         }
      }
      
      private function dispatchEvent(event:Event) : void
      {
         try
         {
            SocketManager.Instance.dispatchEvent(event);
         }
         catch(err:Error)
         {
            SocketManager.Instance.out.sendErrorMsg("type:" + event.type + "msg:" + err.message + "\r\n" + err.getStackTrace());
            trace(event.type,err.message,err.getStackTrace());
         }
      }
   }
}

package littleGame.clock
{
   import ddt.interfaces.IProcessObject;
   import ddt.manager.ProcessManager;
   import ddt.manager.SocketManager;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import littleGame.LittleGameManager;
   import littleGame.events.LittleGameSocketEvent;
   
   public class Clock extends EventDispatcher implements IProcessObject
   {
       
      
      private var _deltas:Vector.<TimeDelta>;
      
      private var _maxDeltas:Number;
      
      private var _syncTimeDelta:int;
      
      private var _responsePending:Boolean;
      
      private var _timeRequestSent:Number;
      
      private var _latency:int;
      
      private var _latencyError:int;
      
      private var _backgroundWaitTime:int;
      
      private var _backgroundTimer:Timer;
      
      private var _bursting:Boolean;
      
      private var _lockedInServerTime:Boolean;
      
      private var _onProcess:Boolean;
      
      private var _internalClock:int;
      
      public function Clock()
      {
         super();
         this._maxDeltas = 10;
      }
      
      public function start(start:int, pingDelay:int = -1, burst:Boolean = true) : void
      {
         if(this.running)
         {
            return;
         }
         if(pingDelay != -1)
         {
            this._backgroundTimer = new Timer(pingDelay);
            this._backgroundTimer.addEventListener(TimerEvent.TIMER,this.__onTimer);
            this._backgroundTimer.start();
         }
         this._internalClock = start;
         this._deltas = new Vector.<TimeDelta>();
         this._lockedInServerTime = false;
         this._responsePending = false;
         this._bursting = burst;
         this.addEvent();
         ProcessManager.Instance.addObject(this);
         this.ping();
      }
      
      public function ping() : void
      {
         this._timeRequestSent = this._internalClock;
         LittleGameManager.Instance.ping(this._timeRequestSent);
      }
      
      private function addEvent() : void
      {
         SocketManager.Instance.addEventListener(LittleGameSocketEvent.PONG,this.__pong);
      }
      
      private function __pong(event:LittleGameSocketEvent) : void
      {
         var serverTimeStamp:int = event.pkg.readInt();
         this.addTimeDelta(this._timeRequestSent,this._internalClock,serverTimeStamp);
         this._responsePending = false;
         if(this._bursting)
         {
            if(this._deltas.length >= this._maxDeltas)
            {
               this._bursting = false;
            }
            this.ping();
         }
      }
      
      private function addTimeDelta(clientSendTime:int, clientReceiveTime:int, serverTime:int) : void
      {
         var latency:Number = (clientReceiveTime - clientSendTime) / 2;
         var clientServerDelta:int = serverTime - clientReceiveTime;
         var timeSyncDelta:int = clientServerDelta + latency;
         var delta:TimeDelta = new TimeDelta(latency,timeSyncDelta);
         this._deltas.push(delta);
         if(this._deltas.length > this._maxDeltas)
         {
            this._deltas.shift();
         }
         this.recalculate();
      }
      
      private function recalculate() : void
      {
         var tmp_deltas:Vector.<TimeDelta> = this._deltas.slice(0);
         tmp_deltas.sort(this.compare);
         var medianLatency:int = this.determineMedian(tmp_deltas);
         this.pruneOutliers(tmp_deltas,medianLatency,1.5);
         this._latency = this.determineAverageLatency(tmp_deltas);
         if(!this._lockedInServerTime)
         {
            this._syncTimeDelta = this.determineAverage(tmp_deltas);
            this._lockedInServerTime = this._deltas.length == this._maxDeltas;
         }
      }
      
      private function determineAverage(deltas:Vector.<TimeDelta>) : int
      {
         var td:TimeDelta = null;
         var total:Number = 0;
         for(var i:Number = 0; i < deltas.length; i++)
         {
            td = deltas[i];
            total += td.timeSyncDelta;
         }
         return total / deltas.length;
      }
      
      private function determineAverageLatency(deltas:Vector.<TimeDelta>) : int
      {
         var td:TimeDelta = null;
         var total:int = 0;
         for(var i:int = 0; i < deltas.length; i++)
         {
            td = deltas[i];
            total += td.latency;
         }
         var lat:int = total / deltas.length;
         this._latencyError = Math.abs(TimeDelta(deltas[deltas.length - 1]).latency - lat);
         return lat;
      }
      
      private function pruneOutliers(deltas:Vector.<TimeDelta>, median:int, threshold:Number) : void
      {
         var td:TimeDelta = null;
         var maxValue:Number = median * threshold;
         for(var i:Number = deltas.length - 1; i >= 0; i--)
         {
            td = deltas[i];
            if(td.latency <= maxValue)
            {
               break;
            }
            deltas.splice(i,1);
         }
      }
      
      private function determineMedian(deltas:Vector.<TimeDelta>) : int
      {
         var ind:Number = NaN;
         if(deltas.length % 2 == 0)
         {
            ind = deltas.length / 2 - 1;
            return (deltas[ind].latency + deltas[ind + 1].latency) / 2;
         }
         ind = Math.floor(deltas.length / 2);
         return deltas[ind].latency;
      }
      
      private function compare(a:TimeDelta, b:TimeDelta) : Number
      {
         if(a.latency < b.latency)
         {
            return -1;
         }
         if(a.latency > b.latency)
         {
            return 1;
         }
         return 0;
      }
      
      private function removeEvent() : void
      {
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
         this._internalClock += rate;
      }
      
      private function __onTimer(event:TimerEvent) : void
      {
         if(!this._responsePending && !this._bursting)
         {
            this.ping();
         }
         trace("clock_onMark" + this._internalClock + ";" + this._syncTimeDelta);
      }
      
      public function get time() : Number
      {
         return this._internalClock + this._syncTimeDelta;
      }
      
      public function get latency() : int
      {
         return this._latency;
      }
      
      public function get latencyError() : int
      {
         return this._latencyError;
      }
      
      public function get maxDeltas() : Number
      {
         return this._maxDeltas;
      }
      
      public function set maxDeltas(val:Number) : void
      {
         this._maxDeltas = val;
      }
   }
}

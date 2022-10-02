package times.data
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import times.TimesController;
   
   public class TimesStatistics
   {
       
      
      private var _stayTime:Vector.<int>;
      
      private var _timer:Timer;
      
      private var _controller:TimesController;
      
      public function TimesStatistics()
      {
         super();
         this._controller = TimesController.Instance;
         this._stayTime = new Vector.<int>(5);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timerTick);
      }
      
      public function get stayTime() : Vector.<int>
      {
         return this._stayTime;
      }
      
      private function __timerTick(param1:TimerEvent) : void
      {
         this._stayTime[this._controller.currentPointer] += 1;
      }
      
      public function startTick() : void
      {
         if(this._timer && !this._timer.running)
         {
            this._stayTime = new Vector.<int>(5);
            this._timer.start();
         }
      }
      
      public function stopTick() : void
      {
         if(this._timer && this._timer.running)
         {
            this._timer.stop();
         }
      }
      
      public function dispose() : void
      {
         this._controller = null;
         this._stayTime = null;
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__timerTick);
            this._timer = null;
         }
      }
   }
}

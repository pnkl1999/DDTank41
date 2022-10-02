package com.pickgliss.action
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class TickOrderQueueAction extends OrderQueueAction
   {
       
      
      private var _interval:uint;
      
      private var _tickTimer:Timer;
      
      private var _delay:uint;
      
      private var _delayTimer:Timer;
      
      public function TickOrderQueueAction(param1:Array, param2:uint = 100, param3:uint = 0, param4:uint = 0)
      {
         this._interval = param2;
         this._delay = param3;
         super(param1,param4);
      }
      
      override public function act() : void
      {
         if(this._delay > 0)
         {
            this._delayTimer = new Timer(this._delay,1);
            this._delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayTimerComplete);
            this._delayTimer.start();
         }
         else
         {
            super.act();
         }
      }
      
      private function onDelayTimerComplete(param1:TimerEvent) : void
      {
         this.removeDelayTimer();
         super.act();
      }
      
      private function removeDelayTimer() : void
      {
         if(this._delayTimer)
         {
            this._delayTimer.stop();
            this._delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayTimerComplete);
            this._delayTimer = null;
         }
      }
      
      override protected function actOne() : void
      {
         var _loc1_:IAction = _actList[_count] as IAction;
         this.startTickTimer();
         _loc1_.act();
      }
      
      private function startTickTimer() : void
      {
         this._tickTimer = new Timer(this._interval,1);
         this._tickTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTickTimerComplete);
         this._tickTimer.start();
      }
      
      private function onTickTimerComplete(param1:TimerEvent) : void
      {
         this.removeTickTimer();
         actNext();
      }
      
      private function removeTickTimer() : void
      {
         if(this._tickTimer)
         {
            this._tickTimer.stop();
            this._tickTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTickTimerComplete);
            this._tickTimer = null;
         }
      }
      
      override protected function onLimitTimerComplete(param1:TimerEvent) : void
      {
         this.removeTickTimer();
         super.onLimitTimerComplete(param1);
      }
      
      override public function cancel() : void
      {
         this.removeTickTimer();
         super.cancel();
      }
   }
}

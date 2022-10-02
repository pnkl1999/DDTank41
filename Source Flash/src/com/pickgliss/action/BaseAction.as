package com.pickgliss.action
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class BaseAction implements IAction
   {
       
      
      protected var _completeFun:Function;
      
      protected var _acting:Boolean;
      
      private var _limitTimer:Timer;
      
      private var _timeOut:uint;
      
      public function BaseAction(param1:uint = 0)
      {
         super();
      }
      
      public function act() : void
      {
         if(this._timeOut > 0)
         {
            this.startLimitTimer();
         }
      }
      
      public function setCompleteFun(param1:Function) : void
      {
         this._completeFun = param1;
      }
      
      private function startLimitTimer() : void
      {
         this.removeLimitTimer();
         this._limitTimer = new Timer(this._timeOut,1);
         this._limitTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onLimitTimerComplete);
         this._limitTimer.start();
      }
      
      protected function onLimitTimerComplete(param1:TimerEvent) : void
      {
         this.removeLimitTimer();
         if(this._acting)
         {
            this.cancel();
            this.execComplete();
         }
      }
      
      private function removeLimitTimer() : void
      {
         if(this._limitTimer)
         {
            this._limitTimer.stop();
            this._limitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onLimitTimerComplete);
            this._limitTimer = null;
         }
      }
      
      public function get acting() : Boolean
      {
         return this._acting;
      }
      
      public function cancel() : void
      {
         this.removeLimitTimer();
         this._acting = false;
      }
      
      protected function execComplete() : void
      {
         this.removeLimitTimer();
         if(this._completeFun is Function)
         {
            this._completeFun(this);
         }
      }
   }
}

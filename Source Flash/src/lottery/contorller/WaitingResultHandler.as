package lottery.contorller
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   [Event(name="complete",type="flash.events.Event")]
   public class WaitingResultHandler extends EventDispatcher
   {
       
      
      private var _onCompleteCall:Function;
      
      private var _waitTimer:Timer;
      
      private var _isTimeComptele:Boolean;
      
      private var _isResultComptele:Boolean;
      
      private var _result:Object;
      
      public function WaitingResultHandler(param1:Number, param2:Function)
      {
         super();
         this._onCompleteCall = param2;
         this._isTimeComptele = false;
         this._isResultComptele = false;
         this._waitTimer = new Timer(param1,1);
         this._waitTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
      }
      
      public function get isComptele() : Boolean
      {
         return this._isResultComptele && this._isTimeComptele;
      }
      
      public function wait() : void
      {
         this._waitTimer.reset();
         this._waitTimer.start();
      }
      
      public function finish() : void
      {
         this._waitTimer.stop();
         this._isTimeComptele = true;
         this._isResultComptele = true;
         this.fireComptele();
      }
      
      public function get result() : Object
      {
         return this._result;
      }
      
      public function setResult(param1:Object) : void
      {
         this._result = param1;
         this._isResultComptele = true;
         if(this.isComptele)
         {
            this.fireComptele();
         }
      }
      
      private function __timerComplete(param1:TimerEvent) : void
      {
         this._waitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         this._isTimeComptele = true;
         if(this.isComptele)
         {
            this.fireComptele();
         }
      }
      
      public function dispose() : void
      {
         this._waitTimer.reset();
         this._waitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         this._waitTimer = null;
         this._result = null;
         this._isTimeComptele = false;
         this._isResultComptele = false;
         this._onCompleteCall = null;
      }
      
      private function fireComptele() : void
      {
         if(this._onCompleteCall != null)
         {
            this._onCompleteCall(this._result);
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}

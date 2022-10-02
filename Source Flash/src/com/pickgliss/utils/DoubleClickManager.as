package com.pickgliss.utils
{
   import com.pickgliss.events.InteractiveEvent;
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public final class DoubleClickManager
   {
      
      private static var _instance:DoubleClickManager;
       
      
      private const DoubleClickSpeed:uint = 350;
      
      private var _timer:Timer;
      
      private var _currentTarget:InteractiveObject;
      
      private var _ctrlKey:Boolean;
      
      public function DoubleClickManager()
      {
         super();
         this.init();
      }
      
      public static function get Instance() : DoubleClickManager
      {
         if(!_instance)
         {
            _instance = new DoubleClickManager();
         }
         return _instance;
      }
      
      public function enableDoubleClick(param1:InteractiveObject) : void
      {
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.__mouseDownHandler);
      }
      
      public function disableDoubleClick(param1:InteractiveObject) : void
      {
         param1.removeEventListener(MouseEvent.MOUSE_DOWN,this.__mouseDownHandler);
      }
      
      private function init() : void
      {
         this._timer = new Timer(this.DoubleClickSpeed,1);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerCompleteHandler);
      }
      
      private function getEvent(param1:String) : InteractiveEvent
      {
         var _loc2_:InteractiveEvent = new InteractiveEvent(param1);
         _loc2_.ctrlKey = this._ctrlKey;
         return _loc2_;
      }
      
      private function __timerCompleteHandler(param1:TimerEvent) : void
      {
         this._currentTarget.dispatchEvent(this.getEvent(InteractiveEvent.CLICK));
      }
      
      private function __mouseDownHandler(param1:MouseEvent) : void
      {
         this._ctrlKey = param1.ctrlKey;
         if(this._timer.running)
         {
            this._timer.stop();
            if(this._currentTarget != param1.currentTarget)
            {
               return;
            }
            param1.stopImmediatePropagation();
            this._currentTarget.dispatchEvent(this.getEvent(InteractiveEvent.DOUBLE_CLICK));
         }
         else
         {
            this._timer.reset();
            this._timer.start();
            this._currentTarget = param1.currentTarget as InteractiveObject;
         }
      }
      
      public function clearTarget() : void
      {
         if(this._timer)
         {
            this._timer.stop();
         }
         this._currentTarget = null;
      }
   }
}

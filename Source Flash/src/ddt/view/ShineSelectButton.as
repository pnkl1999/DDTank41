package ddt.view
{
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ShineSelectButton extends SelectedButton
   {
       
      
      private var _shineBg:DisplayObject;
      
      private var _timer:Timer;
      
      private var _delay:int = 200;
      
      public function ShineSelectButton()
      {
         this._timer = new Timer(this._delay);
         super();
      }
      
      public function set delay(param1:int) : void
      {
         this._delay = param1;
      }
      
      public function set shineBg(param1:DisplayObject) : void
      {
         ObjectUtils.disposeObject(this._shineBg);
         this._shineBg = param1;
         addChild(this._shineBg);
         this._shineBg.visible = false;
      }
      
      public function shine() : void
      {
         this._timer.reset();
         this._timer.addEventListener(TimerEvent.TIMER,this.__onTimer);
         this._timer.start();
      }
      
      public function stopShine() : void
      {
         if(this._timer && this._timer.running)
         {
            this._timer.reset();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__onTimer);
            this._timer.stop();
            this._shineBg.visible = false;
         }
      }
      
      override public function dispose() : void
      {
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__onTimer);
            this._timer = null;
         }
         if(this._shineBg)
         {
            ObjectUtils.disposeObject(this._shineBg);
            this._shineBg = null;
         }
         super.dispose();
      }
      
      private function __onTimer(param1:TimerEvent) : void
      {
         this._shineBg.visible = this._timer.currentCount % 2 == 1;
      }
   }
}

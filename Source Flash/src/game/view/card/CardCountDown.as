package game.view.card
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class CardCountDown extends Sprite implements Disposeable
   {
       
      
      private var _bitmapDatas:Vector.<BitmapData>;
      
      private var _timer:Timer;
      
      private var _totalSeconds:uint;
      
      private var _digit:Bitmap;
      
      private var _tenDigit:Bitmap;
      
      private var _isPlaySound:Boolean;
      
      public function CardCountDown()
      {
         super();
         this.init();
      }
      
      public function tick(param1:uint, param2:Boolean = true) : void
      {
         this._totalSeconds = param1;
         this._isPlaySound = param2;
         this._timer.repeatCount = this._totalSeconds;
         this.__updateView();
         this._timer.start();
      }
      
      private function init() : void
      {
         this._digit = new Bitmap();
         this._tenDigit = new Bitmap();
         this._bitmapDatas = new Vector.<BitmapData>();
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__updateView);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__onTimerComplete);
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            this._bitmapDatas.push(ComponentFactory.Instance.creatBitmapData("asset.takeoutCard.CountDownNum_" + String(_loc1_)));
            _loc1_++;
         }
      }
      
      private function __updateView(param1:TimerEvent = null) : void
      {
         var _loc2_:int = this._timer.repeatCount - this._timer.currentCount;
         if(_loc2_ <= 4)
         {
            if(this._isPlaySound)
            {
               SoundManager.instance.stop("067");
               SoundManager.instance.play("067");
            }
         }
         else if(this._isPlaySound)
         {
            SoundManager.instance.play("014");
         }
         this._tenDigit.bitmapData = this._bitmapDatas[int(_loc2_ / 10)];
         this._digit.bitmapData = this._bitmapDatas[_loc2_ % 10];
         this._digit.x = this._tenDigit.width - 14;
         addChild(this._digit);
         addChild(this._tenDigit);
      }
      
      private function __onTimerComplete(param1:TimerEvent) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function dispose() : void
      {
         var _loc1_:BitmapData = null;
         this._timer.removeEventListener(TimerEvent.TIMER,this.__updateView);
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onTimerComplete);
         this._timer.stop();
         this._timer = null;
         for each(_loc1_ in this._bitmapDatas)
         {
            _loc1_.dispose();
            _loc1_ = null;
         }
         if(this._digit && this._digit.parent)
         {
            this._digit.parent.removeChild(this._digit);
         }
         if(this._tenDigit && this._tenDigit.parent)
         {
            this._tenDigit.parent.removeChild(this._tenDigit);
         }
         this._digit = null;
         this._tenDigit = null;
         if(this.parent)
         {
            parent.removeChild(this);
         }
      }
   }
}

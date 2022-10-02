package game.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import game.GameManager;
   
   [Event(name="complete",type="flash.events.Event")]
   public class CountDownView extends Sprite
   {
       
      
      private var _countDown:ScaleFrameImage;
      
      private var _timer:Timer;
      
      private var _totalTime:int;
      
      private var _isPlayerSound:Boolean;
      
      private var _alreadyTime:int;
      
      public function CountDownView(param1:int, param2:Boolean = true)
      {
         super();
         this._isPlayerSound = param2;
         this._totalTime = param1;
         this.initView();
      }
      
      public function get alreadyTime() : int
      {
         return this._alreadyTime;
      }
      
      private function initView() : void
      {
         this._countDown = ComponentFactory.Instance.creatComponentByStylename("asset.game.countDownAsset");
         addChild(this._countDown);
      }
      
      public function reset() : void
      {
         this._countDown.setFrame(this._totalTime);
      }
      
      public function startCountDown(param1:int) : void
      {
         this.stopCountDown();
         this._totalTime = param1;
         this._countDown.setFrame(this._totalTime);
         this._countDown.visible = true;
         this._timer = new Timer(1000,this._totalTime);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timer);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         this._timer.start();
         this._alreadyTime = this._totalTime;
      }
      
      public function pause() : void
      {
         this._timer.reset();
      }
      
      public function stopCountDown() : void
      {
         if(this._timer)
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.__timer);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
            if(this._timer.running)
            {
               SoundManager.instance.stop("067");
            }
            this._timer.reset();
            this._timer = null;
         }
      }
      
      private function __timer(param1:TimerEvent) : void
      {
         this._alreadyTime = this._totalTime - this._timer.currentCount;
         this._countDown.setFrame(this._alreadyTime);
         GameManager.Instance.Current.selfGamePlayer.shootTime = this._timer.currentCount;
         if(this._alreadyTime <= 10)
         {
            GameManager.Instance.Current.selfGamePlayer.showMark(this._alreadyTime);
         }
         if(this._alreadyTime <= 4)
         {
            if(this._isPlayerSound)
            {
               SoundManager.instance.stop("067");
               SoundManager.instance.play("067");
            }
         }
         else if(this._isPlayerSound)
         {
            SoundManager.instance.play("014");
         }
      }
      
      private function __timerComplete(param1:TimerEvent) : void
      {
         this._alreadyTime = 0;
         this.stopCountDown();
         this._countDown.visible = false;
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function dispose() : void
      {
         this.stopCountDown();
         this._alreadyTime = this._totalTime;
         if(this._timer)
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.__timer);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         }
         this._timer = null;
         this._countDown.dispose();
         this._countDown = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}

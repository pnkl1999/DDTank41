package ddt.view.roulette
{
   import ddt.manager.SoundManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class TurnSoundControl extends EventDispatcher
   {
       
      
      private var _timer:Timer;
      
      private var _isPlaySound:Boolean = false;
      
      private var _oneArray:Array;
      
      private var _threeArray:Array;
      
      private var _number:int = 0;
      
      public function TurnSoundControl(param1:IEventDispatcher = null)
      {
         this._oneArray = ["127","128","129","130","131"];
         this._threeArray = ["130","131","133","132","135","134","129","128","127","132","135","134","129","128","127"];
         super(param1);
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._timer = new Timer(6000);
         this._timer.stop();
      }
      
      private function initEvent() : void
      {
         this._timer.addEventListener(TimerEvent.TIMER,this._timerOne);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this._timerComplete);
      }
      
      private function _timerOne(param1:TimerEvent) : void
      {
         SoundManager.instance.stop("124");
         SoundManager.instance.play("124");
      }
      
      private function _timerComplete(param1:TimerEvent) : void
      {
      }
      
      public function playSound() : void
      {
         if(!this._isPlaySound)
         {
            this._isPlaySound = true;
            this._timer.delay = 6000;
            this._timer.reset();
            this._timer.start();
            SoundManager.instance.play("124");
         }
      }
      
      public function playOneStep() : void
      {
         var _loc1_:String = this._oneArray[this._number];
         SoundManager.instance.play(_loc1_);
         this._number = this._number >= 4 ? int(int(0)) : int(int(this._number + 1));
      }
      
      public function playThreeStep(param1:int) : void
      {
         var _loc2_:String = this._threeArray[param1];
         SoundManager.instance.play(_loc2_);
      }
      
      public function stop() : void
      {
         this._isPlaySound = false;
         this._timer.stop();
         SoundManager.instance.stop("124");
      }
      
      public function dispose() : void
      {
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this._timerOne);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this._timerComplete);
            this._timer = null;
         }
         this._oneArray = null;
         this._threeArray = null;
      }
   }
}

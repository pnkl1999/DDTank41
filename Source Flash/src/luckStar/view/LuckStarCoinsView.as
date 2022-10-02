package luckStar.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class LuckStarCoinsView extends Sprite implements Disposeable
   {
      
      private static const MAX_NUM_WIDTH:int = 8;
      
      private static const BUFFER_TIME:int = 50;
      
      private static const WIDTH:int = 25;
       
      
      private var _num:Vector.<ScaleFrameImage>;
      
      private var len:int = 4;
      
      private var coinsNum:int;
      
      private var notFirst:Boolean = false;
      
      private var time:Timer;
      
      private var oldCoins:int;
      
      public function LuckStarCoinsView()
      {
         super();
         this._num = new Vector.<ScaleFrameImage>();
         this.time = new Timer(BUFFER_TIME);
         this.time.addEventListener(TimerEvent.TIMER_COMPLETE,this.__onComplete);
         this.time.addEventListener(TimerEvent.TIMER,this.__onTimer);
         this.time.stop();
         this.setupCount();
      }
      
      public function set count(param1:int) : void
      {
         if(this.coinsNum == param1)
         {
            return;
         }
         if(this.coinsNum != this.oldCoins && this.notFirst)
         {
            this.initCoinsStyle();
         }
         this.coinsNum = param1;
         this.updateCount();
      }
      
      private function setupCount() : void
      {
         var _loc2_:int = 0;
         while(this.len > this._num.length)
         {
            this._num.unshift(this.createCoinsNum(10));
         }
         while(this.len < this._num.length)
         {
            ObjectUtils.disposeObject(this._num.shift());
         }
         var _loc1_:int = MAX_NUM_WIDTH - this.len;
         _loc2_ = _loc1_ / 2 * WIDTH;
         var _loc3_:int = 0;
         while(_loc3_ < this.len)
         {
            this._num[_loc3_].x = _loc2_;
            _loc2_ += WIDTH;
            _loc3_++;
         }
      }
      
      private function updateCount() : void
      {
         var _loc1_:int = this.coinsNum.toString().length;
         if(_loc1_ != this.len)
         {
            this.len = _loc1_;
            this.setupCount();
         }
         if(this.coinsNum - this.oldCoins <= 0)
         {
            this.initCoinsStyle();
         }
         else if(!this.notFirst)
         {
            this.notFirst = true;
            this.initCoinsStyle();
         }
         else
         {
            this.play();
         }
      }
      
      private function __onTimer(param1:TimerEvent) : void
      {
         ++this.oldCoins;
         if(this.oldCoins > this.coinsNum)
         {
            this.oldCoins = this.coinsNum;
         }
         var _loc2_:Array = this.oldCoins.toString().split("");
         if(this.len > _loc2_.length)
         {
            _loc2_.unshift("0");
         }
         this.updateCoinsView(_loc2_);
      }
      
      private function __onComplete(param1:TimerEvent) : void
      {
         this.time.stop();
         this.oldCoins = this.coinsNum;
      }
      
      private function initCoinsStyle() : void
      {
         var _loc1_:Array = this.coinsNum.toString().split("");
         this.updateCoinsView(_loc1_);
         this.oldCoins = this.coinsNum;
      }
      
      private function updateCoinsView(param1:Array) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.len)
         {
            if(param1[_loc2_] == 0)
            {
               param1[_loc2_] = 10;
            }
            this._num[_loc2_].setFrame(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      private function play() : void
      {
         this.time.stop();
         this.time.reset();
         this.time.repeatCount = this.coinsNum - this.oldCoins;
         this.time.start();
      }
      
      private function createCoinsNum(param1:int = 0) : ScaleFrameImage
      {
         var _loc2_:ScaleFrameImage = ComponentFactory.Instance.creatComponentByStylename("luckyStar.view.CoinsNum");
         _loc2_.setFrame(param1);
         addChild(_loc2_);
         return _loc2_;
      }
      
      public function dispose() : void
      {
         this.time.stop();
         this.time.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onComplete);
         this.time.removeEventListener(TimerEvent.TIMER,this.__onTimer);
         this.time = null;
         while(this._num.length)
         {
            ObjectUtils.disposeObject(this._num.shift());
         }
         this._num = null;
      }
   }
}

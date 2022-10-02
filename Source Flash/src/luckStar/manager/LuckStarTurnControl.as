package luckStar.manager
{
   import ddt.view.roulette.TurnSoundControl;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import luckStar.cell.LuckStarCell;
   
   public class LuckStarTurnControl extends EventDispatcher
   {
      
      public static const SPEEDUP_RATE:int = -60;
      
      public static const SPEEDDOWN_RATE:int = 40;
      
      public static const PLAY_SOUNDTHREESTEP_NUMBER:int = 14;
      
      public static const TURNCOMPLETE:String = "turn_complete";
      
      public static const TYPE_SPEED_UP:int = 1;
      
      public static const TYPE_SPEED_UNCHANGE:int = 2;
      
      public static const TYPE_SPEED_DOWN:int = 3;
      
      public static const SHADOW_NUMBER:int = 3;
      
      public static const DOWN_SUB_SHADOW_BOL:int = 9;
       
      
      private var _goodsList:Vector.<LuckStarCell>;
      
      private var _sound:TurnSoundControl;
      
      private var _delay:Array;
      
      private var _moveTime:Array;
      
      private var _nowDelayTime:int = 1000;
      
      private var _turnTypeTimeSum:int = 0;
      
      private var _timer:Timer;
      
      private var _turnType:int = 0;
      
      private var _stepTime:int;
      
      private var _isStopTurn:Boolean = true;
      
      private var _selectedGoodsNumber:Number;
      
      private var _moderationNumber:Number;
      
      private var _startModerationNumber:Number;
      
      private var _turnStop:Boolean;
      
      private var _sparkleNumber:Number;
      
      private var _turnContinue:Boolean;
      
      public function LuckStarTurnControl(param1:IEventDispatcher = null)
      {
         this._delay = [300,30,500];
         this._moveTime = [1000,2000];
         super(param1);
         this.init();
      }
      
      private function init() : void
      {
         this._timer = new Timer(100,1);
         this._timer.stop();
         this._sound = new TurnSoundControl();
      }
      
      private function __onTimerComplete(param1:TimerEvent) : void
      {
         this._updateTurnType(this.nowDelayTime);
         this.nowDelayTime += this._stepTime;
         this._nextNode();
         this._startTimer(this.nowDelayTime);
      }
      
      private function _nextNode() : void
      {
         if(!this._isStopTurn)
         {
            this.sparkleNumber += 1;
            this._goodsList[this.sparkleNumber].setSparkle();
            this._clearPrevSelct(this.sparkleNumber,this.prevSelected);
            if(this.nowDelayTime > SPEEDDOWN_RATE && this.turnType == TYPE_SPEED_UP)
            {
               this._sound.stop();
               this._sound.playOneStep();
            }
            else if(this.turnType == TYPE_SPEED_DOWN && this._moderationNumber <= PLAY_SOUNDTHREESTEP_NUMBER)
            {
               this._sound.stop();
               this._sound.playThreeStep(this._moderationNumber);
            }
            else
            {
               this._sound.playSound();
            }
         }
      }
      
      private function _updateTurnType(param1:int) : void
      {
         switch(this.turnType)
         {
            case TYPE_SPEED_UP:
               if(param1 <= this._delay[1])
               {
                  this.turnType = TYPE_SPEED_UNCHANGE;
               }
               break;
            case TYPE_SPEED_UNCHANGE:
               if(this._turnTypeTimeSum >= this._moveTime[0] && this._sparkleNumber == this._startModerationNumber)
               {
                  this.turnType = TYPE_SPEED_DOWN;
               }
               break;
            case TYPE_SPEED_DOWN:
               --this._moderationNumber;
               if(this._moderationNumber <= 0)
               {
                  this.turnComplete();
               }
         }
      }
      
      private function _clearPrevSelct(param1:int, param2:int) : void
      {
         var _loc4_:int = 0;
         var _loc3_:int = param1 - param2 < 0 ? int(param1 - param2 + this._goodsList.length) : int(param1 - param2);
         if(_loc3_ == 1)
         {
            this._goodsList[param2].selected = false;
         }
         else
         {
            _loc4_ = param1 - 1 < 0 ? int(param1 - 1 + this._goodsList.length) : int(param1 - 1);
            this._goodsList[_loc4_].setGreep();
            this._goodsList[param2].selected = false;
         }
      }
      
      public function turn(param1:Vector.<LuckStarCell>, param2:int) : void
      {
         this.turnType = TYPE_SPEED_UP;
         this._goodsList = param1;
         this.selectedGoodsNumber = param2;
         this.startTurn();
         this._startTimer(this.nowDelayTime);
      }
      
      public function set turnContinue(param1:Boolean) : void
      {
         this._turnContinue = param1;
      }
      
      public function get turnContinue() : Boolean
      {
         return this._turnContinue;
      }
      
      private function startTurn() : void
      {
         this._isStopTurn = false;
         this._turnStop = false;
         --this.sparkleNumber;
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__onTimerComplete);
      }
      
      public function stopTurn() : void
      {
         this._turnStop = true;
         this._turnContinue = false;
      }
      
      private function turnComplete() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._goodsList.length)
         {
            this._goodsList[_loc1_].selected = false;
            _loc1_++;
         }
         this._isStopTurn = true;
         this._timer.stop();
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onTimerComplete);
         dispatchEvent(new Event(TURNCOMPLETE));
      }
      
      private function _startTimer(param1:int) : void
      {
         if(!this._isStopTurn)
         {
            this._timer.delay = param1;
            this._timer.reset();
            this._timer.start();
         }
      }
      
      public function set nowDelayTime(param1:int) : void
      {
         this._turnTypeTimeSum += this._nowDelayTime;
         this._nowDelayTime = param1;
      }
      
      public function set turnType(param1:int) : void
      {
         this._turnType = param1;
         this._turnTypeTimeSum = 0;
         switch(this._turnType)
         {
            case TYPE_SPEED_UP:
               this._nowDelayTime = this._delay[0];
               this._stepTime = SPEEDUP_RATE;
               break;
            case TYPE_SPEED_UNCHANGE:
               this._nowDelayTime = this._delay[1];
               this._stepTime = 0;
               break;
            case TYPE_SPEED_DOWN:
               this._nowDelayTime = this._delay[1];
               this._stepTime = SPEEDDOWN_RATE;
         }
      }
      
      public function set selectedGoodsNumber(param1:int) : void
      {
         this._selectedGoodsNumber = param1;
         this._moderationNumber = (this._delay[2] - this._delay[1]) / SPEEDDOWN_RATE;
         var _loc2_:int = this._selectedGoodsNumber - this._moderationNumber;
         while(_loc2_ < 0)
         {
            _loc2_ += this._goodsList.length;
         }
         this._startModerationNumber = _loc2_;
      }
      
      public function set sparkleNumber(param1:int) : void
      {
         this._sparkleNumber = param1;
         if(this._sparkleNumber >= this._goodsList.length)
         {
            this._sparkleNumber = 0;
         }
      }
      
      private function get prevSelected() : int
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         switch(this._turnType)
         {
            case TYPE_SPEED_UP:
               _loc1_ = this.sparkleNumber == 0 ? int(this._goodsList.length - 1) : int(this._sparkleNumber - 1);
               break;
            case TYPE_SPEED_UNCHANGE:
               _loc1_ = this.sparkleNumber - SHADOW_NUMBER < 0 ? int(this.sparkleNumber - SHADOW_NUMBER + this._goodsList.length) : int(this.sparkleNumber - SHADOW_NUMBER);
               break;
            case TYPE_SPEED_DOWN:
               if(this._moderationNumber > DOWN_SUB_SHADOW_BOL)
               {
                  _loc1_ = this.sparkleNumber - SHADOW_NUMBER < 0 ? int(this.sparkleNumber - SHADOW_NUMBER + this._goodsList.length) : int(this.sparkleNumber - SHADOW_NUMBER);
               }
               else
               {
                  _loc2_ = this._moderationNumber >= 7 ? int(this._moderationNumber - 6) : int(1);
                  _loc1_ = this.sparkleNumber - _loc2_ < 0 ? int(this.sparkleNumber - _loc2_ + this._goodsList.length) : int(this._sparkleNumber - _loc2_);
                  if(this._moderationNumber >= 8)
                  {
                     this._goodsList[_loc1_ + 1 >= this._goodsList.length ? 0 : _loc1_ + 1].selected = false;
                  }
               }
         }
         return _loc1_;
      }
      
      public function get turnType() : int
      {
         return this._turnType;
      }
      
      public function get nowDelayTime() : int
      {
         return this._nowDelayTime;
      }
      
      public function get sparkleNumber() : int
      {
         return this._sparkleNumber;
      }
      
      public function get isTurn() : Boolean
      {
         return !this._isStopTurn;
      }
      
      public function dispose() : void
      {
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onTimerComplete);
            this._timer = null;
         }
         if(this._sound)
         {
            this._sound.dispose();
            this._sound = null;
         }
      }
   }
}

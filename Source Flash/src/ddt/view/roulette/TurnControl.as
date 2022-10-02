package ddt.view.roulette
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class TurnControl extends EventDispatcher
   {
      
      public static const TURNCOMPLETE:String = "turn_complete";
      
      public static const TYPE_SPEED_UP:int = 1;
      
      public static const TYPE_SPEED_UNCHANGE:int = 2;
      
      public static const TYPE_SPEED_DOWN:int = 3;
      
      public static const MINTIME_PLAY_SOUNDONESTEP:int = 30;
      
      public static const PLAY_SOUNDTHREESTEP_NUMBER:int = 14;
      
      public static const SHADOW_NUMBER:int = 3;
      
      public static const DOWN_SUB_SHADOW_BOL:int = 9;
      
      public static const SPEEDUP_RATE:int = -60;
      
      public static const SPEEDDOWN_RATE:int = 30;
       
      
      private var _goodsList:Vector.<RouletteGoodsCell>;
      
      private var _turnType:int = 1;
      
      private var _timer:Timer;
      
      private var _timerII:Timer;
      
      private var _isStopTurn:Boolean = false;
      
      private var _nowDelayTime:int = 1000;
      
      private var _sparkleNumber:int = 0;
      
      private var _delay:Array;
      
      private var _moveTime:Array;
      
      private var _selectedGoodsNumber:int = 0;
      
      private var _turnTypeTimeSum:int = 0;
      
      private var _stepTime:int = 0;
      
      private var _startModerationNumber:int = 0;
      
      private var _moderationNumber:int = 0;
      
      private var _sound:TurnSoundControl;
      
      public function TurnControl(param1:IEventDispatcher = null)
      {
         this._delay = [500,30,500];
         this._moveTime = [2000,3000,2000];
         super(param1);
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._timer = new Timer(100,1);
         this._timer.stop();
         this._sound = new TurnSoundControl();
         this._timerII = new Timer(600);
         this._timerII.stop();
      }
      
      public function set autoMove(param1:Boolean) : void
      {
         if(param1)
         {
            this._timerII.start();
         }
         else
         {
            this._timerII.stop();
         }
      }
      
      private function initEvent() : void
      {
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this._timeComplete);
         this._timerII.addEventListener(TimerEvent.TIMER,this._timerIITimer);
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
      
      private function _nextNode() : void
      {
         if(!this._isStopTurn)
         {
            this.sparkleNumber += 1;
            this._goodsList[this.sparkleNumber].setSparkle();
            this._clearPrevSelct(this.sparkleNumber,this.prevSelected);
            if(this.nowDelayTime > MINTIME_PLAY_SOUNDONESTEP && this.turnType == TYPE_SPEED_UP)
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
      
      private function _clearPrevSelct(param1:int, param2:int) : void
      {
         var _loc4_:int = 0;
         var _loc3_:int = param1 - param2 < 0 ? int(int(param1 - param2 + this._goodsList.length)) : int(int(param1 - param2));
         if(_loc3_ == 1)
         {
            this._goodsList[param2].selected = false;
         }
         else
         {
            _loc4_ = param1 - 1 < 0 ? int(int(param1 - 1 + this._goodsList.length)) : int(int(param1 - 1));
            this._goodsList[_loc4_].setGreep();
            this._goodsList[param2].selected = false;
         }
      }
      
      private function _timeComplete(param1:TimerEvent) : void
      {
         this._updateTurnType(this.nowDelayTime);
         this.nowDelayTime += this._stepTime;
         this._nextNode();
         this._startTimer(this.nowDelayTime);
      }
      
      private function _timerIITimer(param1:TimerEvent) : void
      {
         this._goodsList[this.sparkleNumber].setGreep();
         this._goodsList[this.sparkleNumber].selected = false;
         this.sparkleNumber += 1;
         if(this.sparkleNumber == this._goodsList.length)
         {
            this.sparkleNumber = 0;
         }
         this._goodsList[this.sparkleNumber].setSparkle();
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
               if(this._turnTypeTimeSum >= this._moveTime[1] && this._sparkleNumber == this._startModerationNumber)
               {
                  this.turnType = TYPE_SPEED_DOWN;
               }
               break;
            case TYPE_SPEED_DOWN:
               --this._moderationNumber;
               if(this._moderationNumber <= 0)
               {
                  this.stopTurn();
               }
         }
      }
      
      public function startTurn() : void
      {
         this._isStopTurn = false;
         --this.sparkleNumber;
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this._timeComplete);
      }
      
      public function stopTurn() : void
      {
         this._isStopTurn = true;
         this._timer.stop();
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this._timeComplete);
         this._turnComplete();
      }
      
      private function _turnComplete() : void
      {
         dispatchEvent(new Event(TurnControl.TURNCOMPLETE));
      }
      
      public function turnPlate(param1:Vector.<RouletteGoodsCell>, param2:int) : void
      {
         this.turnType = TYPE_SPEED_UP;
         this._goodsList = param1;
         this.selectedGoodsNumber = param2;
         this.startTurn();
         this._startTimer(this.nowDelayTime);
      }
      
      public function turnPlateII(param1:Vector.<RouletteGoodsCell>) : void
      {
         this._goodsList = param1;
         this.autoMove = true;
      }
      
      public function set sparkleNumber(param1:int) : void
      {
         this._sparkleNumber = param1;
         if(this._sparkleNumber >= this._goodsList.length)
         {
            this._sparkleNumber = 0;
         }
      }
      
      public function get sparkleNumber() : int
      {
         return this._sparkleNumber;
      }
      
      private function get prevSelected() : int
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         switch(this._turnType)
         {
            case TYPE_SPEED_UP:
               _loc1_ = this.sparkleNumber == 0 ? int(int(this._goodsList.length - 1)) : int(int(this._sparkleNumber - 1));
               break;
            case TYPE_SPEED_UNCHANGE:
               _loc1_ = this.sparkleNumber - SHADOW_NUMBER < 0 ? int(int(this.sparkleNumber - SHADOW_NUMBER + this._goodsList.length)) : int(int(this.sparkleNumber - SHADOW_NUMBER));
               break;
            case TYPE_SPEED_DOWN:
               if(this._moderationNumber > DOWN_SUB_SHADOW_BOL)
               {
                  _loc1_ = this.sparkleNumber - SHADOW_NUMBER < 0 ? int(int(this.sparkleNumber - SHADOW_NUMBER + this._goodsList.length)) : int(int(this.sparkleNumber - SHADOW_NUMBER));
               }
               else
               {
                  _loc2_ = this._moderationNumber >= 7 ? int(int(this._moderationNumber - 6)) : int(int(1));
                  _loc1_ = this.sparkleNumber - _loc2_ < 0 ? int(int(this.sparkleNumber - _loc2_ + this._goodsList.length)) : int(int(this._sparkleNumber - _loc2_));
                  if(this._moderationNumber >= 8)
                  {
                     this._goodsList[_loc1_ + 1 >= this._goodsList.length ? 0 : _loc1_ + 1].selected = false;
                  }
               }
         }
         return _loc1_;
      }
      
      public function set nowDelayTime(param1:int) : void
      {
         this._turnTypeTimeSum += this._nowDelayTime;
         this._nowDelayTime = param1;
      }
      
      public function get nowDelayTime() : int
      {
         return this._nowDelayTime;
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
      
      public function get turnType() : int
      {
         return this._turnType;
      }
      
      public function set goodsList(param1:Vector.<RouletteGoodsCell>) : void
      {
         this._goodsList = param1;
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
      
      public function dispose() : void
      {
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this._timeComplete);
            this._timerII.removeEventListener(TimerEvent.TIMER,this._timerIITimer);
            this._timer = null;
         }
         if(this._sound)
         {
            this._sound.stop();
            this._sound.dispose();
            this._sound = null;
         }
      }
   }
}

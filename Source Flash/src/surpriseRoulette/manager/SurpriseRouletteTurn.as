package surpriseRoulette.manager
{
   import ddt.view.roulette.TurnSoundControl;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import surpriseRoulette.view.SurpriseRouletteCell;
   
   public class SurpriseRouletteTurn extends EventDispatcher
   {
      
      private static const ZERO:Number = 1;
      
      private static const ONE:Number = 1.1;
      
      private static const TWO:Number = 1.2;
      
      private static const THREE:Number = 1.3;
      
      public static const COMPLETE:String = "surpriseRouletteTurnComplete";
      
      public static const TYPE_SPEED_UP:int = 1;
      
      public static const TYPE_SPEED_UNCHANGE:int = 2;
      
      public static const TYPE_SPEED_DOWN:int = 3;
      
      public static const MINTIME_PLAY_SOUNDONESTEP:int = 30;
      
      public static const PLAY_SOUNDTHREESTEP_NUMBER:int = 14;
      
      public static const SPEEDUP_RATE:int = -60;
      
      public static const SPEEDDOWN_RATE:int = 30;
       
      
      private var _goodsList:Vector.<SurpriseRouletteCell>;
      
      private var _turnType:int = 1;
      
      private var _timer:Timer;
      
      private var _isStopTurn:Boolean = false;
      
      private var _nowDelayTime:int;
      
      private var _sparkleNumber:int = 0;
      
      private var _delay:Array;
      
      private var _turnTypeTimeSum:int = 0;
      
      private var _stepTime:int = 0;
      
      private var _startModerationNumber:int = 0;
      
      private var _moderationNumber:int = 0;
      
      private var _sound:TurnSoundControl;
      
      public function SurpriseRouletteTurn(param1:IEventDispatcher = null)
      {
         this._delay = [500,30,500];
         super(param1);
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._timer = new Timer(100,1);
         this._timer.stop();
         this._sound = new TurnSoundControl();
      }
      
      private function initEvent() : void
      {
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this._timeComplete);
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
            this._goodsList[this._sparkleNumber].setEffect(THREE);
            this._clearPrevSelct(this._sparkleNumber);
            if(this._nowDelayTime > MINTIME_PLAY_SOUNDONESTEP && this._turnType == TYPE_SPEED_UP)
            {
               this._sound.stop();
               this._sound.playOneStep();
            }
            else if(this._turnType == TYPE_SPEED_DOWN && this._moderationNumber <= PLAY_SOUNDTHREESTEP_NUMBER)
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
      
      private function _clearPrevSelct(param1:int) : void
      {
         if(this._turnType == TYPE_SPEED_UNCHANGE)
         {
            this._goodsList[this.getNum(param1 - 1)].setEffect(TWO);
            this._goodsList[this.getNum(param1 - 2)].setEffect(ONE);
            this._goodsList[this.getNum(param1 - 3)].setEffect(ZERO);
         }
         else
         {
            this._goodsList[this.getNum(param1 - 1)].setEffect(ZERO);
            this._goodsList[this.getNum(param1 - 2)].setEffect(ZERO);
            this._goodsList[this.getNum(param1 - 3)].setEffect(ZERO);
         }
      }
      
      private function getNum(param1:int) : int
      {
         if(param1 < 0)
         {
            return param1 + this._goodsList.length;
         }
         return param1;
      }
      
      private function _timeComplete(param1:TimerEvent) : void
      {
         this._updateTurnType(this._nowDelayTime);
         this.nowDelayTime += this._stepTime;
         this._nextNode();
         this._startTimer(this._nowDelayTime);
      }
      
      private function _updateTurnType(param1:int) : void
      {
         switch(this._turnType)
         {
            case TYPE_SPEED_UP:
               if(param1 <= this._delay[1])
               {
                  this.turnType = TYPE_SPEED_UNCHANGE;
               }
               break;
            case TYPE_SPEED_UNCHANGE:
               if(this._turnTypeTimeSum >= 3000 && this._sparkleNumber == this._startModerationNumber)
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
         dispatchEvent(new Event(COMPLETE));
      }
      
      public function turnPlate(param1:Vector.<SurpriseRouletteCell>, param2:int) : void
      {
         this.turnType = TYPE_SPEED_UP;
         this._goodsList = param1;
         this.selectedGoodsNumber(param2);
         this.startTurn();
         this._startTimer(this._nowDelayTime);
      }
      
      public function get sparkleNumber() : int
      {
         return this._sparkleNumber;
      }
      
      public function set sparkleNumber(param1:int) : void
      {
         this._sparkleNumber = param1;
         if(this._sparkleNumber >= this._goodsList.length)
         {
            this._sparkleNumber = 0;
         }
      }
      
      public function get nowDelayTime() : int
      {
         return this._nowDelayTime;
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
      
      public function selectedGoodsNumber(param1:int) : void
      {
         this._moderationNumber = (this._delay[2] - this._delay[1]) / SPEEDDOWN_RATE;
         var _loc2_:int = param1 - this._moderationNumber;
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

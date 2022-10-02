package roulette
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.roulette.TurnSoundControl;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   
   public class RouletteFrame extends Sprite implements Disposeable
   {
      
      public static const TYPE_SPEED_UP:int = 1;
      
      public static const TYPE_SPEED_UNCHANGE:int = 2;
      
      public static const TYPE_SPEED_DOWN:int = 3;
      
      public static const SHADOW_NUMBER:int = 1;
      
      public static const DOWN_SUB_SHADOW_BOL:int = 3;
      
      public static const GLINT_ONE_TIME:int = 3000;
      
      public static const SPEEDUP_RATE:int = -70;
      
      public static const SPEEDDOWN_RATE:int = 40;
      
      public static const MINTIME_PLAY_SOUNDONESTEP:int = 30;
      
      public static const PLAY_SOUNDTHREESTEP_NUMBER:int = 14;
      
      private static const ESCkeyCode:int = 27;
       
      
      private var _rouletteBG:Bitmap;
      
      private var _rechargeableBG:Bitmap;
      
      private var _recurBG:Bitmap;
      
      private var _goodsList:Vector.<RouletteCell>;
      
      private var _glintView:LeftRouletteGlintView;
      
      private var _pointArray:Array;
      
      private var _pointNumArr:Array;
      
      private var _isStopTurn:Boolean = false;
      
      private var _turnSlectedNumber:int;
      
      private var _timer:Timer;
      
      private var _moderationNumber:int = 0;
      
      private var _nowDelayTime:int = 1000;
      
      private var _turnType:int = 1;
      
      private var _delay:Array;
      
      private var _moveTime:Array;
      
      private var _selectedGoodsNumber:int = 0;
      
      private var _turnTypeTimeSum:int = 0;
      
      private var _stepTime:int = 0;
      
      private var _startModerationNumber:int = 0;
      
      private var _arrNum:Array;
      
      private var _close:SelectedButton;
      
      private var _help:SelectedButton;
      
      private var _start:SelectedButton;
      
      private var _exchange:SelectedButton;
      
      private var _numbmpVec:Vector.<Bitmap>;
      
      private var _pointLength:Array;
      
      private var _sound:TurnSoundControl;
      
      private var _isSend:Boolean;
      
      private var _sparkleNumber:int = 0;
      
      public function RouletteFrame()
      {
         this._delay = [600,50,600];
         this._moveTime = [2000,3000,2000];
         this._pointLength = [6,20];
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc5_:Bitmap = null;
         var _loc4_:int = 0;
         _loc1_ = null;
         _loc2_ = null;
         _loc3_ = 0;
         _loc5_ = null;
         var _loc6_:Bitmap = null;
         var _loc7_:RouletteCell = null;
         this.getAllNumPoint();
         this.getAllGoodsPoint();
         _loc1_ = new Array();
         _loc1_.push(0,0,0,0,60,60,60,80,-60,-60,-70,-60,0,0,0,0,60,60,50,60);
         _loc2_ = new Array();
         _loc2_.push(0,60,120,180,240,300);
         this._goodsList = new Vector.<RouletteCell>();
         this._sound = new TurnSoundControl();
         this._timer = new Timer(100,1);
         this._timer.stop();
         this._rouletteBG = ComponentFactory.Instance.creatBitmap("asset.roulette.TurnplateMainView");
         addChild(this._rouletteBG);
         this._rechargeableBG = ComponentFactory.Instance.creatBitmap("asset.roulette.rechargeable");
         addChild(this._rechargeableBG);
         this._recurBG = ComponentFactory.Instance.creatBitmap("asset.roulette.recur");
         this._recurBG.smoothing = true;
         this._recurBG.rotation = -60;
         addChild(this._recurBG);
         this._arrNum = new Array();
         this._arrNum = LeftGunRouletteManager.instance.ArrNum;
         this._numbmpVec = new Vector.<Bitmap>();
         _loc3_ = 0;
         while(_loc3_ < this._arrNum.length)
         {
            _loc5_ = ComponentFactory.Instance.creatBitmap("asset.roulette.number.bg" + this._arrNum[_loc3_]);
            _loc5_.x = this._pointNumArr[_loc3_].x;
            _loc5_.y = this._pointNumArr[_loc3_].y;
            _loc5_.rotation = _loc1_[_loc3_];
            _loc5_.smoothing = true;
            addChild(_loc5_);
            this._numbmpVec.push(_loc5_);
            _loc3_++;
         }
         this._start = ComponentFactory.Instance.creatComponentByStylename("roulette.startBtn");
         this._exchange = ComponentFactory.Instance.creatComponentByStylename("roulette.exchangeBtn");
         this._close = ComponentFactory.Instance.creatComponentByStylename("roulette.closeBtn");
         this._help = ComponentFactory.Instance.creatComponentByStylename("roulette.helpBtn");
         addChild(this._start);
         this._start.transparentEnable = true;
         addChild(this._exchange);
         this._exchange.transparentEnable = true;
         addChild(this._close);
         addChild(this._help);
         this._exchange.visible = false;
         this._exchange.mouseEnabled = false;
         _loc4_ = 0;
         while(_loc4_ <= 5)
         {
            _loc6_ = ComponentFactory.Instance.creatBitmap("asset.awardSystem.roulette.CellBGAsset");
            _loc7_ = new RouletteCell(_loc6_);
            _loc7_.x = this._pointArray[_loc4_].x;
            _loc7_.y = this._pointArray[_loc4_].y;
            _loc7_.rotation = _loc2_[_loc4_];
            _loc7_.selected = false;
            _loc7_.cellBG = false;
            addChild(_loc7_);
            this._goodsList.push(_loc7_);
            _loc4_++;
         }
         this._glintView = new LeftRouletteGlintView(this._pointArray);
         addChild(this._glintView);
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LEFT_GUN_ROULETTE_START,this._getItem);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this._timeComplete);
         this._start.addEventListener(MouseEvent.CLICK,this.__startHandler);
         this._exchange.addEventListener(MouseEvent.CLICK,this.__exchangeHandler);
         this._close.addEventListener(MouseEvent.CLICK,this.__closeHandler);
         this._help.addEventListener(MouseEvent.CLICK,this.__helpHandler);
         addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
      }
      
      private function __keyDownHandler(param1:KeyboardEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.keyCode == ESCkeyCode && this._close.mouseEnabled)
         {
            this.dispose();
         }
      }
      
      private function getAllGoodsPoint() : void
      {
         var _loc2_:Point = null;
         this._pointArray = new Array();
         var _loc1_:int = 0;
         while(_loc1_ < this._pointLength[0])
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("roulette.aperture.point" + _loc1_);
            this._pointArray.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function getAllNumPoint() : void
      {
         var _loc2_:Point = null;
         this._pointNumArr = new Array();
         var _loc1_:int = 0;
         while(_loc1_ < this._pointLength[1])
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("roulette.number.point" + _loc1_);
            this._pointNumArr.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function test() : void
      {
         this._isSend = this.isSendNotice("1.5");
         var _loc3_:Array = new Array();
         var _loc4_:String = this._arrNum[0] + "." + this._arrNum[2];
         var _loc5_:String = this._arrNum[4] + "." + this._arrNum[6];
         var _loc6_:String = this._arrNum[8] + "." + this._arrNum[10];
         var _loc7_:String = this._arrNum[12] + "." + this._arrNum[14];
         var _loc8_:String = this._arrNum[16] + "." + this._arrNum[18];
         _loc3_.push(_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,"0");
         this.turnSlectedNumber = _loc3_.indexOf("1.5");
         if(this.turnSlectedNumber == -1)
         {
            return;
         }
         removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
         this.turnPlate(this.turnSlectedNumber);
      }
      
      private function _getItem(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:String = _loc2_.readUTF();
         this._isSend = this.isSendNotice(_loc4_);
         if(_loc3_ <= 0)
         {
            this._start.visible = this._start.mouseEnabled = false;
            this._exchange.visible = this._exchange.mouseEnabled = true;
            dispatchEvent(new RouletteFrameEvent(RouletteFrameEvent.ROULETTE_VISIBLE,_loc4_,null));
         }
         var _loc5_:Array = new Array();
         var _loc6_:String = this._arrNum[0] + "." + this._arrNum[2];
         var _loc7_:String = this._arrNum[4] + "." + this._arrNum[6];
         var _loc8_:String = this._arrNum[8] + "." + this._arrNum[10];
         var _loc9_:String = this._arrNum[12] + "." + this._arrNum[14];
         var _loc10_:String = this._arrNum[16] + "." + this._arrNum[18];
         _loc5_.push(_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,"0");
         this.turnSlectedNumber = _loc5_.indexOf(_loc4_);
         if(this.turnSlectedNumber == -1)
         {
            return;
         }
         removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
         this.turnPlate(this.turnSlectedNumber);
      }
      
      private function isSendNotice(param1:String) : Boolean
      {
         var _loc2_:Array = param1.split(".");
         var _loc3_:int = int(_loc2_[0]);
         if(_loc3_ >= 2)
         {
            return true;
         }
         return false;
      }
      
      private function _timeComplete(param1:TimerEvent) : void
      {
         this.updateTurnType(this.nowDelayTime);
         this.nowDelayTime += this._stepTime;
         this.nextNode();
         this.startTimer(this.nowDelayTime);
      }
      
      private function __startHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.stopMusic();
         SoundManager.instance.play("008");
         this._glintView.stopGlint();
         this._exchange.mouseEnabled = false;
         this._exchange.visible = false;
         SocketManager.Instance.out.sendStartTurn_LeftGun();
      }
      
      private function __exchangeHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._start.mouseEnabled = false;
         this._start.visible = false;
         dispatchEvent(new RouletteFrameEvent(RouletteFrameEvent.BUTTON_CLICK));
      }
      
      private function __closeHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function __helpHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         LeftGunRouletteManager.instance.showhelpFrame();
      }
      
      private function updateTurnType(param1:int) : void
      {
         var _loc2_:int = this.turnSlectedNumber;
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
      
      private function startTimer(param1:int) : void
      {
         if(!this._isStopTurn)
         {
            this._timer.delay = param1;
            this._timer.reset();
            this._timer.start();
         }
      }
      
      private function nextNode() : void
      {
         if(!this._isStopTurn)
         {
            this.sparkleNumber += 1;
            if(this.sparkleNumber == -1)
            {
               return;
            }
            this._goodsList[this.sparkleNumber].setSparkle();
            this.clearPrevSelct(this.sparkleNumber,this.prevSelected);
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
      
      private function turnPlate(param1:int) : void
      {
         this.turnType = TYPE_SPEED_UP;
         this.selectedGoodsNumber = param1;
         this.startTurn();
         this.startTimer(this.nowDelayTime);
      }
      
      private function startTurn() : void
      {
         this._isStopTurn = false;
         --this.sparkleNumber;
         this._start.mouseEnabled = this._exchange.mouseEnabled = this._help.mouseEnabled = this._close.mouseEnabled = false;
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this._timeComplete);
      }
      
      private function stopTurn() : void
      {
         this._isStopTurn = true;
         this._timer.stop();
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this._timeComplete);
         this._turnComplete();
      }
      
      private function _turnComplete() : void
      {
         SoundManager.instance.playMusic("140");
         SoundManager.instance.play("126");
         this._start.mouseEnabled = this._exchange.mouseEnabled = this._close.mouseEnabled = this._help.mouseEnabled = true;
         this._goodsList[this.turnSlectedNumber].selected = false;
         this._glintView.showThreeCell(this.turnSlectedNumber);
         SocketManager.Instance.out.sendEndTurn_LeftGun();
         this._start.visible = this._start.mouseEnabled = this.turnSlectedNumber == 5 ? Boolean(Boolean(true)) : Boolean(Boolean(false));
         this._exchange.visible = this._exchange.mouseEnabled = this.turnSlectedNumber == 5 ? Boolean(Boolean(false)) : Boolean(Boolean(true));
         addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
      }
      
      private function clearPrevSelct(param1:int, param2:int) : void
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
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LEFT_GUN_ROULETTE_START,this._getItem);
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this._timeComplete);
         this._start.removeEventListener(MouseEvent.CLICK,this.__startHandler);
         this._exchange.removeEventListener(MouseEvent.CLICK,this.__exchangeHandler);
         this._close.removeEventListener(MouseEvent.CLICK,this.__closeHandler);
         this._help.removeEventListener(MouseEvent.CLICK,this.__helpHandler);
         removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.removeEvent();
         if(this._rouletteBG)
         {
            ObjectUtils.disposeObject(this._rouletteBG);
         }
         this._rouletteBG = null;
         if(this._rechargeableBG)
         {
            ObjectUtils.disposeObject(this._rechargeableBG);
         }
         this._rechargeableBG = null;
         if(this._recurBG)
         {
            ObjectUtils.disposeObject(this._recurBG);
         }
         this._recurBG = null;
         if(this._goodsList && this._goodsList.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < this._goodsList.length)
            {
               if(this._goodsList[_loc1_])
               {
                  ObjectUtils.disposeObject(this._goodsList[_loc1_]);
               }
               this._goodsList[_loc1_] = null;
               _loc1_++;
            }
         }
         this._goodsList = null;
         if(this._glintView)
         {
            ObjectUtils.disposeObject(this._glintView);
         }
         this._glintView = null;
         if(this._close)
         {
            ObjectUtils.disposeObject(this._close);
         }
         this._close = null;
         if(this._help)
         {
            ObjectUtils.disposeObject(this._help);
         }
         this._help = null;
         if(this._start)
         {
            ObjectUtils.disposeObject(this._start);
         }
         this._start = null;
         if(this._exchange)
         {
            ObjectUtils.disposeObject(this._exchange);
         }
         this._exchange = null;
         if(this._numbmpVec && this._numbmpVec.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this._numbmpVec.length)
            {
               if(this._numbmpVec[_loc2_])
               {
                  ObjectUtils.disposeObject(this._numbmpVec[_loc2_]);
               }
               this._numbmpVec[_loc2_] = null;
               _loc2_++;
            }
         }
         this._numbmpVec = null;
         if(this._timer)
         {
            this._timer = null;
         }
         if(this._sound)
         {
            this._sound.stop();
            this._sound.dispose();
            this._sound = null;
         }
         SoundManager.instance.playMusic("062");
         LeftGunRouletteManager.instance.setRouletteFramenull();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get turnSlectedNumber() : int
      {
         return this._turnSlectedNumber;
      }
      
      public function set turnSlectedNumber(param1:int) : void
      {
         this._turnSlectedNumber = param1;
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
                  _loc2_ = this._moderationNumber >= 3 ? int(int(this._moderationNumber - 2)) : int(int(1));
                  _loc1_ = this.sparkleNumber - _loc2_ < 0 ? int(int(this.sparkleNumber - _loc2_ + this._goodsList.length)) : int(int(this._sparkleNumber - _loc2_));
                  if(this._moderationNumber >= 6)
                  {
                     this._goodsList[_loc1_ + 1 >= this._goodsList.length ? 0 : _loc1_ + 1].selected = false;
                  }
               }
         }
         return _loc1_;
      }
   }
}

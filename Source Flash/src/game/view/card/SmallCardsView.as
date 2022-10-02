package game.view.card
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Quint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import game.GameManager;
   import game.model.GameInfo;
   import game.model.Player;
   import road7th.comm.PackageIn;
   import room.RoomManager;
   import room.model.RoomInfo;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class SmallCardsView extends Sprite implements Disposeable
   {
      
      public static const SMALL_CARD_TIME:uint = 5;
      
      public static const SMALL_CARD_CNT:uint = 9;
      
      public static const SMALL_CARD_COLUMNS:uint = 3;
      
      public static const SMALL_CARD_MAX_SELECTED_CNT:uint = 1;
      
      public static const SMALL_CARD_REQUEST_CARD:uint = 100;
      
      public static const SMALL_CARD_VIEW_TIME:uint = 1;
      
      public static const ON_ALL_COMPLETE_CNT:uint = 2;
       
      
      protected var _cards:Vector.<LuckyCard>;
      
      protected var _posArr:Vector.<Point>;
      
      protected var _gameInfo:GameInfo;
      
      protected var _roomInfo:RoomInfo;
      
      protected var _resultCards:Array;
      
      protected var _selectedCnt:int;
      
      protected var _selectCompleted:Boolean;
      
      protected var _countDownView:CardCountDown;
      
      protected var _countDownTime:int = 5;
      
      protected var _cardCnt:int = 9;
      
      protected var _cardColumns:int = 3;
      
      protected var _viewTime:int = 1;
      
      protected var _timerForView:Timer;
      
      protected var _title:Bitmap;
      
      protected var _onAllComplete:int;
      
      protected var _canTakeOut:Boolean;
      
      public function SmallCardsView()
      {
         super();
         this.init();
      }
      
      protected function init() : void
      {
         this._selectedCnt = 0;
         this._selectCompleted = false;
         this._timerForView = new Timer(1000,this._viewTime);
         this._timerForView.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerForViewComplete);
         this._cards = new Vector.<LuckyCard>();
         this._posArr = new Vector.<Point>();
         this._gameInfo = GameManager.Instance.Current;
         this._roomInfo = RoomManager.Instance.current;
         this._resultCards = this._gameInfo.resultCard.concat();
         this._title = ComponentFactory.Instance.creatBitmap("asset.takeoutCard.TitleBitmap");
         this._countDownView = new CardCountDown();
         PositionUtils.setPos(this._countDownView,"takeoutCard.SmallCardViewCountDownPos");
         addChild(this._countDownView);
         this._countDownView.tick(this._countDownTime);
         addChild(this._title);
         this.createCards();
         var _loc1_:int = 0;
         while(_loc1_ < this._resultCards.length)
         {
            this.__takeOut(this._resultCards[_loc1_]);
            _loc1_++;
         }
         this.initEvent();
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GET_CARD_GUILD))
         {
            SocketManager.Instance.out.syncWeakStep(Step.GET_CARD_GUILD);
            NewHandContainer.Instance.showArrow(ArrowType.GET_CARD,-45,"trainer.getCardArrowPos","asset.trainer.getCardTipAsset","trainer.getCardTipPos");
         }
      }
      
      protected function initEvent() : void
      {
         addEventListener(Event.ADDED_TO_STAGE,this.startTween);
         if(this._countDownView)
         {
            this._countDownView.addEventListener(Event.COMPLETE,this.__countDownComplete);
         }
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_TAKE_OUT,this.__takeOut);
      }
      
      protected function removeEvents() : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.startTween);
         if(this._countDownView)
         {
            this._countDownView.removeEventListener(Event.COMPLETE,this.__countDownComplete);
         }
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_TAKE_OUT,this.__takeOut);
         this._timerForView.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerForViewComplete);
      }
      
      protected function __countDownComplete(param1:Event) : void
      {
         ++this._onAllComplete;
         if(this._countDownView)
         {
            this._countDownView.removeEventListener(Event.COMPLETE,this.__countDownComplete);
         }
         if(!this._canTakeOut)
         {
            this._timerForView.start();
            return;
         }
         if(!this._selectCompleted && this._canTakeOut)
         {
            GameInSocketOut.sendBossTakeOut(SMALL_CARD_REQUEST_CARD);
            return;
         }
         if(this._onAllComplete == ON_ALL_COMPLETE_CNT)
         {
            this._timerForView.start();
         }
      }
      
      protected function __timerForViewComplete(param1:* = null) : void
      {
         if(this._gameInfo)
         {
            this._gameInfo.resetResultCard();
         }
         this._resultCards = null;
         this._timerForView.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerForViewComplete);
         if(!this._canTakeOut)
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
         if(this._onAllComplete == ON_ALL_COMPLETE_CNT)
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      protected function createCards() : void
      {
         var _loc3_:Point = null;
         var _loc1_:Point = null;
         _loc3_ = null;
         var _loc4_:LuckyCard = null;
         _loc1_ = new Point(26,25);
         var _loc2_:int = 0;
         while(_loc2_ < this._cardCnt)
         {
            _loc3_ = new Point();
            if(this._roomInfo.type == RoomInfo.DUNGEON_ROOM || this._roomInfo.type == RoomInfo.FRESHMAN_ROOM || this._roomInfo.type == RoomInfo.ACADEMY_DUNGEON_ROOM)
            {
               _loc4_ = new LuckyCard(_loc2_,LuckyCard.WITHIN_GAME_CARD);
               _loc4_.allowClick = this._canTakeOut = this._gameInfo.selfGamePlayer.BossCardCount > 0;
            }
            else if(this._roomInfo.type == RoomInfo.FIGHT_LIB_ROOM)
            {
               _loc4_ = new LuckyCard(_loc2_,LuckyCard.AFTER_GAME_CARD);
               _loc4_.allowClick = this._canTakeOut = true;
            }
            else
            {
               _loc4_ = new LuckyCard(_loc2_,LuckyCard.AFTER_GAME_CARD);
               _loc4_.allowClick = this._canTakeOut = this._gameInfo.selfGamePlayer.GetCardCount > 0;
            }
            _loc3_.x = _loc2_ % this._cardColumns * (_loc1_.x + _loc4_.width) + 87;
            _loc3_.y = int(_loc2_ / this._cardColumns) * (_loc1_.y + _loc4_.height) + 32;
            _loc4_.x = _loc1_.x + _loc4_.width + 87;
            _loc4_.y = _loc1_.y + _loc4_.height + 32;
            _loc4_.msg = LanguageMgr.GetTranslation("tank.gameover.DisableGetCard");
            addChild(_loc4_);
            this._posArr.push(_loc3_);
            this._cards.push(_loc4_);
            _loc2_++;
         }
      }
      
      protected function __takeOut(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc3_:Boolean = false;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Player = null;
         if(this._cards.length > 0)
         {
            _loc2_ = param1.pkg;
            _loc3_ = _loc2_.readBoolean();
            _loc4_ = _loc2_.readByte();
            if(_loc4_ == 50)
            {
               return;
            }
            _loc5_ = _loc2_.readInt();
            _loc6_ = _loc2_.readInt();
            _loc7_ = this._gameInfo.findPlayer(_loc2_.extend1);
            if(_loc7_)
            {
               this._cards[_loc4_].play(_loc7_,_loc5_,_loc6_,false);
               if(_loc7_.isSelf)
               {
                  ++this._onAllComplete;
                  ++this._selectedCnt;
                  this._selectCompleted = this._selectedCnt >= SMALL_CARD_MAX_SELECTED_CNT;
                  if(this._selectCompleted)
                  {
                     this.__disabledAllCards();
                  }
                  if(this._onAllComplete == ON_ALL_COMPLETE_CNT)
                  {
                     this._timerForView.start();
                  }
               }
            }
         }
         else
         {
            this._resultCards.push(param1);
         }
      }
      
      protected function __disabledAllCards(param1:Event = null) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._cards.length)
         {
            this._cards[_loc2_].enabled = false;
            _loc2_++;
         }
      }
      
      protected function startTween(param1:Event = null) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.startTween);
         var _loc2_:int = 0;
         while(_loc2_ < SMALL_CARD_CNT)
         {
            TweenLite.to(this._cards[_loc2_],0.8,{
               "startAt":{
                  "x":this._posArr[4].x,
                  "y":this._posArr[4].y
               },
               "x":this._posArr[_loc2_].x,
               "y":this._posArr[_loc2_].y,
               "ease":Quint.easeOut,
               "onComplete":this.cardTweenComplete,
               "onCompleteParams":[this._cards[_loc2_]]
            });
            _loc2_++;
         }
      }
      
      protected function cardTweenComplete(param1:LuckyCard) : void
      {
         TweenLite.killTweensOf(param1);
         param1.enabled = true;
      }
      
      public function dispose() : void
      {
         var _loc1_:LuckyCard = null;
         this.removeEvents();
         for each(_loc1_ in this._cards)
         {
            _loc1_.dispose();
         }
         ObjectUtils.disposeObject(this._countDownView);
         ObjectUtils.disposeObject(this._title);
         if(this._timerForView)
         {
            this._timerForView.stop();
            this._timerForView = null;
         }
         this._title = null;
         this._cards = null;
         this._posArr = null;
         this._gameInfo = null;
         this._roomInfo = null;
         this._resultCards = null;
         this._countDownView = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}

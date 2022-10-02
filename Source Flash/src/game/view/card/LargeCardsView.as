package game.view.card
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Quint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import game.model.Player;
   import road7th.comm.PackageIn;
   import room.RoomManager;
   
   public class LargeCardsView extends SmallCardsView
   {
      
      public static const LARGE_CARD_TIME:uint = 15;
      
      public static const LARGE_CARD_CNT:uint = 21;
      
      public static const LARGE_CARD_COLUMNS:uint = 7;
      
      public static const LARGE_CARD_VIEW_TIME:uint = 1;
       
      
      private var _systemToken:Boolean;
      
      private var _showCardInfos:Array;
      
      private var _instructionTxt:Bitmap;
      
      protected var _cardGetNote:DisplayObject;
      
      public function LargeCardsView()
      {
         super();
      }
      
      override protected function init() : void
      {
         _countDownTime = LARGE_CARD_TIME;
         _cardCnt = LARGE_CARD_CNT;
         _cardColumns = LARGE_CARD_COLUMNS;
         _viewTime = LARGE_CARD_VIEW_TIME;
         super.init();
         PositionUtils.setPos(_title,"takeoutCard.LargeCardViewTitlePos");
         PositionUtils.setPos(_countDownView,"takeoutCard.LargeCardViewCountDownPos");
         this._instructionTxt = ComponentFactory.Instance.creatBitmap("asset.takeoutCard.InstructionBitmap");
         addChild(this._instructionTxt);
         if(_gameInfo.selfGamePlayer.hasGardGet)
         {
            this.drawCardGetNote();
         }
      }
      
      private function drawCardGetNote() : void
      {
         this._cardGetNote = addChild(ComponentFactory.Instance.creat("asset.core.payBuffAsset73.note"));
         PositionUtils.setPos(this._cardGetNote,"takeoutCard.LargeCardView.CardGetNotePos");
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SHOW_CARDS,this.__showAllCard);
         RoomManager.Instance.addEventListener(RoomManager.PAYMENT_TAKE_CARD,__disabledAllCards);
      }
      
      override protected function __takeOut(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc3_:Boolean = false;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:Player = null;
         if(_cards.length > 0)
         {
            _loc2_ = param1.pkg;
            _loc3_ = _loc2_.readBoolean();
            if(!this._systemToken && _loc3_)
            {
               this._systemToken = true;
               __disabledAllCards();
            }
            _loc4_ = _loc2_.readByte();
            if(_loc4_ == 50)
            {
               return;
            }
            _loc5_ = _loc2_.readInt();
            _loc6_ = _loc2_.readInt();
            _loc7_ = _loc2_.readBoolean();
            _loc8_ = _gameInfo.findPlayer(_loc2_.extend1);
            if(_loc2_.clientId == _gameInfo.selfGamePlayer.playerInfo.ID)
            {
               _loc8_ = _gameInfo.selfGamePlayer;
            }
            if(_loc8_)
            {
               _cards[_loc4_].play(_loc8_,_loc5_,_loc6_,_loc7_);
               if(_loc8_.isSelf)
               {
                  ++_selectedCnt;
                  _selectCompleted = _selectedCnt >= _loc8_.GetCardCount;
                  if(_selectedCnt == 2)
                  {
                     this.changeCardsToPayType();
                  }
                  if(_selectedCnt >= 3)
                  {
                     __disabledAllCards();
                     return;
                  }
               }
            }
            if(_loc3_)
            {
               this.showAllCard();
            }
         }
         else
         {
            _resultCards.push(param1);
         }
      }
      
      private function changeCardsToPayType() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < _cards.length)
         {
            _cards[_loc1_].isPayed = true;
            _loc1_++;
         }
      }
      
      private function __showAllCard(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:Object = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         this._showCardInfos = [];
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new Object();
            _loc5_.index = _loc2_.readByte();
            _loc5_.templateID = _loc2_.readInt();
            _loc5_.count = _loc2_.readInt();
            this._showCardInfos.push(_loc5_);
            _loc4_++;
         }
         this.showAllCard();
      }
      
      override protected function __timerForViewComplete(param1:* = null) : void
      {
         _timerForView.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerForViewComplete);
         if(_gameInfo)
         {
            _gameInfo.resetResultCard();
         }
         _resultCards = null;
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function showAllCard() : void
      {
         var _loc1_:uint = 0;
         LayerManager.Instance.clearnGameDynamic();
         if(this._showCardInfos && this._showCardInfos.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < this._showCardInfos.length)
            {
               _cards[uint(this._showCardInfos[_loc1_].index)].play(null,int(this._showCardInfos[_loc1_].templateID),this._showCardInfos[_loc1_].count,false);
               _loc1_++;
            }
         }
         _timerForView.reset();
         _timerForView.start();
      }
      
      override protected function createCards() : void
      {
         var _loc3_:Point = null;
         var _loc4_:LuckyCard = null;
         var _loc1_:Point = null;
         _loc3_ = null;
         _loc4_ = null;
         _loc1_ = new Point(26,25);
         var _loc2_:int = 0;
         while(_loc2_ < _cardCnt)
         {
            _loc3_ = new Point();
            _loc4_ = new LuckyCard(_loc2_,LuckyCard.AFTER_GAME_CARD);
            _loc3_.x = _loc2_ % _cardColumns * (_loc1_.x + _loc4_.width);
            _loc3_.y = int(_loc2_ / _cardColumns) * (_loc1_.y + _loc4_.height);
            _loc4_.x = (_loc1_.x + _loc4_.width) * 3;
            _loc4_.y = _loc1_.y + _loc4_.height;
            _loc4_.allowClick = _gameInfo.selfGamePlayer.GetCardCount > 0;
            _loc4_.msg = LanguageMgr.GetTranslation("tank.gameover.DisableGetCard");
            addChild(_loc4_);
            _posArr.push(_loc3_);
            _cards.push(_loc4_);
            _loc2_++;
         }
      }
      
      override protected function startTween(param1:Event = null) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.startTween);
         var _loc2_:int = 0;
         while(_loc2_ < LARGE_CARD_CNT)
         {
            TweenLite.to(_cards[_loc2_],0.8,{
               "startAt":{
                  "x":_posArr[10].x,
                  "y":_posArr[10].y
               },
               "x":_posArr[_loc2_].x,
               "y":_posArr[_loc2_].y,
               "ease":Quint.easeOut,
               "onComplete":cardTweenComplete,
               "onCompleteParams":[_cards[_loc2_]]
            });
            _loc2_++;
         }
      }
      
      override protected function __countDownComplete(param1:Event) : void
      {
         _countDownView.removeEventListener(Event.COMPLETE,this.__countDownComplete);
         GameInSocketOut.sendGameTakeOut(100);
         __disabledAllCards();
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._cardGetNote);
         this._cardGetNote = null;
         this._showCardInfos = null;
         ObjectUtils.disposeObject(this._instructionTxt);
         this._instructionTxt = null;
         super.dispose();
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SHOW_CARDS,this.__showAllCard);
         RoomManager.Instance.removeEventListener(RoomManager.PAYMENT_TAKE_CARD,__disabledAllCards);
      }
   }
}

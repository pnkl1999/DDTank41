package game.view.experience
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quint;
   import com.greensock.plugins.MotionBlurPlugin;
   import com.greensock.plugins.TweenPlugin;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.events.GameEvent;
   import ddt.manager.EnthrallManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.BlurFilter;
   import flash.text.Font;
   import game.GameManager;
   import game.model.GameInfo;
   import game.model.Living;
   import game.model.Player;
   import game.view.card.LargeCardsView;
   import game.view.card.SmallCardsView;
   import game.view.card.TakeOutCardController;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   [Event(name="expshowed",type="ddt.events.GameEvent")]
   public class ExpView extends Sprite implements Disposeable
   {
      
      public static const GAME_OVER_TYPE_0:uint = 0;
      
      public static const GAME_OVER_TYPE_1:uint = 1;
      
      public static const GAME_OVER_TYPE_2:uint = 2;
      
      public static const GAME_OVER_TYPE_3:uint = 3;
      
      public static const GAME_OVER_TYPE_4:uint = 4;
      
      public static const GAME_OVER_TYPE_5:uint = 5;
      
      public static const GAME_OVER_TYPE_6:uint = 6;
       
      
      private var _bg:Bitmap;
      
      private var _leftView:ExpLeftView;
      
      private var _rightView:Sprite;
      
      private var _shape:Shape;
      
      private var _resultSeal:ExpResultSeal;
      
      private var _titleBitmap:Bitmap;
      
      private var _fightView:ExpFightExpItem;
      
      private var _attatchView:ExpAttatchExpItem;
      
      private var _exploitView:ExpExploitItem;
      
      private var _totalView:ExpTotalItem;
      
      private var _cardController:TakeOutCardController;
      
      private var _smallCardsView:SmallCardsView;
      
      private var _largeCardsView:LargeCardsView;
      
      private var _blurStep:int;
      
      private var _blurFilter:BlurFilter;
      
      private var _totalExp:int;
      
      private var _totalExploit:int;
      
      private var _fightNums:Array;
      
      private var _attatchNums:Array;
      
      private var _exploitNums:Array;
      
      private var _gameInfo:GameInfo;
      
      private var _isOnlyLeftOut:Boolean;
      
      private var _isNoCardView:Boolean;
      
      private var _luckyExp:Boolean = false;
      
      private var _luckyOffer:Boolean = false;
      
      private var _expObj:Object;
      
      public function ExpView(param1:Bitmap = null)
      {
         super();
         this._bg = param1;
      }
      
      public function show() : void
      {
         this._gameInfo = GameManager.Instance.Current;
         var _loc1_:SelfInfo = PlayerManager.Instance.Self;
         this._cardController = new TakeOutCardController();
         var _loc2_:Player = this._gameInfo.findPlayerByPlayerID(_loc1_.ID);
         if(RoomManager.Instance.current.selfRoomPlayer.isViewer || !_loc2_)
         {
            this.onAllComplete();
            return;
         }
         ExpTweenManager.Instance.isPlaying = true;
         LayerManager.Instance.clearnGameDynamic();
         LayerManager.Instance.clearnStageDynamic();
         Font.registerFont(ClassUtils.uiSourceDomain.getDefinition("game.crazyTank.view.ExpViewFont1") as Class);
         var _loc3_:Object = this._expObj = this._gameInfo.selfGamePlayer.expObj;
         if(_loc3_ && _loc3_.hasOwnProperty("luckyExp") && _loc3_.luckyExp > 0)
         {
            this._luckyExp = true;
         }
         if(_loc3_ && _loc3_.hasOwnProperty("luckyOffer") && _loc3_.luckyOffer > 0)
         {
            this._luckyOffer = true;
         }
         switch(_loc3_.gameOverType)
         {
            case GAME_OVER_TYPE_0:
               this.onAllComplete();
               return;
            case GAME_OVER_TYPE_1:
               SoundManager.instance.play(!!this._gameInfo.selfGamePlayer.isWin ? "063" : "064");
               this._fightNums = [_loc3_.killGP,_loc3_.hertGP,_loc3_.fightGP,_loc3_.ghostGP];
               this._attatchNums = [_loc3_.gpForVIP,_loc3_.gpForConsortia,_loc3_.gpForSpouse,_loc3_.gpForServer,_loc3_.gpForApprenticeOnline,_loc3_.gpForApprenticeTeam,_loc3_.gpForDoubleCard,_loc3_.gpForPower,_loc3_.consortiaSkill];
               this._exploitNums = [_loc3_.offerFight,_loc3_.offerDoubleCard,_loc3_.offerVIP,_loc3_.offerService,_loc3_.offerBuff,_loc3_.offerConsortia];
               this.setDefyInfo();
               break;
            case GAME_OVER_TYPE_2:
               SoundManager.instance.play(!!this._gameInfo.selfGamePlayer.isWin ? "063" : "064");
               this._isOnlyLeftOut = true;
               break;
            case GAME_OVER_TYPE_3:
               SoundManager.instance.play(!!this._gameInfo.selfGamePlayer.isWin ? "063" : "064");
               if(this._bg)
               {
                  addChild(this._bg);
               }
               this.changeDark();
               this.onAllComplete();
               return;
            case GAME_OVER_TYPE_4:
               SoundManager.instance.play(!!this._gameInfo.selfGamePlayer.isWin ? "063" : "064");
               this._fightNums = [_loc3_.killGP,_loc3_.hertGP,_loc3_.fightGP,_loc3_.ghostGP];
               this._attatchNums = [_loc3_.gpForVIP,_loc3_.gpForSpouse,_loc3_.gpForServer,_loc3_.gpForApprenticeOnline,_loc3_.gpForApprenticeTeam,_loc3_.gpForDoubleCard,_loc3_.consortiaSkill];
               break;
            case GAME_OVER_TYPE_5:
               if(this._gameInfo.roomType == RoomInfo.FIGHT_LIB_ROOM)
               {
                  this.onAllComplete();
                  return;
               }
               this._isNoCardView = true;
               SoundManager.instance.play(!!this._gameInfo.selfGamePlayer.isWin ? "063" : "064");
               this._fightNums = [_loc3_.killGP,_loc3_.hertGP,_loc3_.fightGP,_loc3_.ghostGP];
               this._attatchNums = [_loc3_.gpForVIP,_loc3_.gpForSpouse,_loc3_.gpForServer,_loc3_.gpForApprenticeOnline,_loc3_.gpForApprenticeTeam,_loc3_.gpForDoubleCard,_loc3_.consortiaSkill];
               break;
            case GAME_OVER_TYPE_6:
               this._fightNums = [_loc3_.killGP,_loc3_.hertGP,_loc3_.fightGP,_loc3_.ghostGP];
               SoundManager.instance.play(!!this._gameInfo.selfGamePlayer.isWin ? "063" : "064");
               this._attatchNums = [_loc3_.gpForVIP,_loc3_.gpForSpouse,_loc3_.gpForServer,_loc3_.gpForApprenticeOnline,_loc3_.gpForApprenticeTeam,_loc3_.gpForDoubleCard,_loc3_.consortiaSkill];
         }
         this.validateData(this._fightNums);
         this.validateData(this._attatchNums);
         this._blurFilter = new BlurFilter();
         TweenPlugin.activate([MotionBlurPlugin]);
         this._rightView = new Sprite();
         PositionUtils.setPos(this._rightView,"experience.RightViewPos");
         if(this._bg)
         {
            addChild(this._bg);
         }
         this.changeDark();
         addChild(this._rightView);
         this.leftView();
         if(this._isOnlyLeftOut)
         {
            ExpTweenManager.Instance.appendTween(TweenMax.to(this,0.5,{
               "onComplete":this.onAllComplete,
               "onStart":this.fastComplete
            }));
         }
         else
         {
            this.resultSealView();
            this.titleView();
            this.fightView();
            this.attatchView();
            this.exploitView();
            ExpTweenManager.Instance.appendTween(TweenMax.to(this,2,{
               "onComplete":this.onAllComplete,
               "onStart":this.fastComplete
            }));
         }
         ExpTweenManager.Instance.startTweens();
      }
      
      protected function __clickHandler(param1:MouseEvent) : void
      {
         this.showCard();
      }
      
      private function validateData(param1:Array) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if(isNaN(param1[_loc2_]))
            {
               param1[_loc2_] = 0;
            }
            _loc2_++;
         }
      }
      
      private function fastComplete() : void
      {
         if(this._totalView)
         {
            this._totalView.playGreenLight();
         }
         ExpTweenManager.Instance.speedRecover();
      }
      
      private function changeDark() : void
      {
         this._shape = new Shape();
         this._shape.graphics.beginFill(0,1);
         this._shape.graphics.drawRect(-2,-2,1002,602);
         this._shape.graphics.endFill();
         this._shape.alpha = 0;
         TweenMax.to(this._shape,0.5,{"alpha":0.8});
         addChild(this._shape);
      }
      
      private function leftView() : void
      {
         this._leftView = new ExpLeftView();
         this._leftView.alpha = 0;
         addChild(this._leftView);
         ExpTweenManager.Instance.appendTween(TweenMax.to(this._leftView,0.5,{"alpha":1}));
      }
      
      private function resultSealView() : void
      {
         var _loc1_:String = !!this._gameInfo.selfGamePlayer.isWin ? ExpResultSeal.WIN : ExpResultSeal.LOSE;
         this._resultSeal = new ExpResultSeal(_loc1_,this._luckyExp,this._luckyOffer);
         this._rightView.addChild(this._resultSeal);
         ExpTweenManager.Instance.appendTween(TweenMax.from(this._resultSeal,0.5,{
            "x":1000,
            "ease":Quint.easeIn,
            "motionBlur":{
               "strength":2,
               "quality":1
            },
            "onComplete":this.blurTween
         }),-0.4);
      }
      
      private function titleView() : void
      {
         this._titleBitmap = ComponentFactory.Instance.creatBitmap("asset.experience.rightViewTitleBg");
         this._rightView.addChildAt(this._titleBitmap,0);
         ExpTweenManager.Instance.appendTween(TweenMax.from(this._titleBitmap,0.5,{
            "x":1000,
            "ease":Quint.easeIn,
            "motionBlur":{
               "strength":2,
               "quality":1
            }
         }));
      }
      
      private function fightView() : void
      {
         var checkZero:Function = null;
         checkZero = function():void
         {
            if(_fightNums.every(equalsZero))
            {
               _totalView.updateTotalExp(0);
            }
         };
         this._fightView = new ExpFightExpItem(this._fightNums);
         this._fightView.addEventListener(Event.CHANGE,this.__updateTotalExp);
         ExpTweenManager.Instance.appendTween(TweenMax.from(this._fightView,0.5,{
            "x":1000,
            "ease":Quint.easeIn,
            "motionBlur":{
               "strength":2,
               "quality":1
            }
         }));
         this._fightView.createView();
         this._rightView.addChildAt(this._fightView,0);
         this._totalView = new ExpTotalItem();
         this._rightView.addChild(this._totalView);
         ExpTweenManager.Instance.appendTween(TweenMax.from(this._totalView,0.5,{
            "x":1000,
            "ease":Quint.easeIn,
            "motionBlur":{
               "strength":2,
               "quality":1
            },
            "onComplete":checkZero
         }),-1);
      }
      
      private function attatchView() : void
      {
         this._attatchView = new ExpAttatchExpItem(this._attatchNums);
         this._attatchView.addEventListener(Event.CHANGE,this.__updateTotalExp);
         ExpTweenManager.Instance.appendTween(TweenMax.from(this._attatchView,0.5,{
            "x":1000,
            "ease":Quint.easeIn,
            "motionBlur":{
               "strength":2,
               "quality":1
            },
            "onStart":this._totalView.playRedLight
         }));
         this._attatchView.createView();
         this._rightView.addChild(this._attatchView);
      }
      
      private function exploitView() : void
      {
         var checkZero:Function = null;
         checkZero = function():void
         {
            if(_exploitNums.every(equalsZero))
            {
               _totalView.updateTotalExploit(0);
            }
         };
         if(!this._exploitNums || this._exploitNums.length == 0)
         {
            return;
         }
         this._exploitView = new ExpExploitItem(this._exploitNums);
         this._exploitView.addEventListener(Event.CHANGE,this.__updateTotalExploit);
         ExpTweenManager.Instance.appendTween(TweenMax.from(this._exploitView,0.5,{
            "x":1000,
            "ease":Quint.easeIn,
            "motionBlur":{
               "strength":2,
               "quality":1
            },
            "onStart":this._totalView.playRedLight,
            "onComplete":checkZero
         }));
         this._exploitView.createView();
         this._rightView.addChild(this._exploitView);
      }
      
      private function __updateTotalExp(param1:Event) : void
      {
         var _loc2_:int = 0;
         this._totalExp = this._fightView.targetValue;
         if(this._expObj && this._expObj.hasOwnProperty("luckyExp"))
         {
            this._totalExp += this._expObj.luckyExp;
         }
         if(param1.currentTarget == this._attatchView)
         {
            this._totalExp += this._attatchView.targetValue;
         }
         if(EnthrallManager.getInstance().isEnthrall && TimeManager.Instance.totalGameTime >= EnthrallManager.STATE_3)
         {
            _loc2_ = GameManager.Instance.Current.selfGamePlayer.expObj.gainGP;
            if(this._totalExp >= _loc2_)
            {
               this._totalView.updateTotalExp(_loc2_);
            }
            else
            {
               this._totalView.updateTotalExp(this._totalExp);
            }
         }
         else
         {
            this._totalView.updateTotalExp(this._totalExp);
         }
      }
      
      private function equalsZero(param1:*, param2:int, param3:Array) : Boolean
      {
         return param1 == 0;
      }
      
      private function __updateTotalExploit(param1:Event) : void
      {
         this._totalExploit += param1.currentTarget.targetValue;
         if(this._expObj && this._expObj.hasOwnProperty("luckyOffer"))
         {
            this._totalView.updateTotalExploit(param1.currentTarget.targetValue + this._expObj.luckyOffer);
         }
         else
         {
            this._totalView.updateTotalExploit(param1.currentTarget.targetValue);
         }
      }
      
      public function close() : void
      {
         this._cardController.setState();
      }
      
      public function showCard() : void
      {
         this._cardController.showSmallCardView = this.showSmallCardView;
         this._cardController.showLargeCardView = this.showLargeCardView;
         this._cardController.tryShowCard();
      }
      
      private function onAllComplete() : void
      {
         ExpTweenManager.Instance.completeTweens();
         ExpTweenManager.Instance.deleteTweens();
         this._cardController.setup(this._gameInfo,RoomManager.Instance.current);
         this._cardController.disposeFunc = this.dispose;
         dispatchEvent(new GameEvent(GameEvent.EXPSHOWED,null));
      }
      
      private function showSmallCardView(param1:DisplayObject) : void
      {
         var view:DisplayObject = null;
         var addCardView:Function = null;
         view = param1;
         addCardView = function():void
         {
            TweenMax.killTweensOf(_rightView);
            addChild(view);
         };
         if(this._rightView)
         {
            TweenMax.to(this._rightView,0.4,{
               "x":"1000",
               "ease":Quint.easeOut,
               "onComplete":addCardView
            });
         }
         else
         {
            addCardView();
         }
      }
      
      private function showLargeCardView(param1:DisplayObject) : void
      {
         var view:DisplayObject = null;
         var addCardView:Function = null;
         view = param1;
         addCardView = function():void
         {
            TweenMax.killTweensOf(_rightView);
            TweenMax.killTweensOf(_leftView);
            addChild(view);
         };
         if(this._rightView)
         {
            TweenMax.to(this._rightView,0.4,{
               "x":"1000",
               "ease":Quint.easeOut,
               "onComplete":addCardView
            });
         }
         else
         {
            addCardView();
         }
         if(this._leftView)
         {
            TweenMax.to(this._leftView,0.4,{
               "x":"-1000",
               "ease":Quint.easeOut
            });
         }
      }
      
      private function blurTween(param1:Event = null) : void
      {
         if(this._blurStep == 0)
         {
            addEventListener(Event.ENTER_FRAME,this.blurTween);
         }
         switch(this._blurStep)
         {
            case 0:
               this._blurFilter.blurX = this._blurFilter.blurY = 10;
               filters = [this._blurFilter];
               x -= 10;
               y -= 6;
               scaleY = scaleX = 1.01;
               break;
            case 1:
               this._blurFilter.blurY = 5;
               filters = [this._blurFilter];
               y += 6;
               scaleY = 1.005;
               break;
            default:
               filters = [];
               x += 10;
               scaleY = scaleX = 1;
               removeEventListener(Event.ENTER_FRAME,this.blurTween);
         }
         ++this._blurStep;
      }
      
      private function setDefyInfo() : void
      {
         var _loc4_:Living = null;
         var _loc5_:Player = null;
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         for each(_loc4_ in this._gameInfo.livings)
         {
            _loc5_ = _loc4_ as Player;
            if(_loc5_ == null)
            {
               return;
            }
            if(_loc5_.isWin)
            {
               _loc1_.unshift(_loc5_.playerInfo.NickName);
            }
            else
            {
               _loc2_.unshift(_loc5_.playerInfo.NickName);
            }
         }
         _loc3_[0] = _loc1_;
         _loc3_[1] = _loc2_;
         RoomManager.Instance.setRoomDefyInfo(_loc3_);
      }
      
      public function dispose() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.blurTween);
         if(this._fightView)
         {
            this._fightView.removeEventListener(Event.CHANGE,this.__updateTotalExp);
         }
         if(this._attatchView)
         {
            this._attatchView.removeEventListener(Event.CHANGE,this.__updateTotalExp);
         }
         if(this._exploitView)
         {
            this._exploitView.removeEventListener(Event.CHANGE,this.__updateTotalExploit);
         }
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(this._leftView)
         {
            this._leftView.dispose();
            this._leftView = null;
         }
         if(this._resultSeal)
         {
            this._resultSeal.dispose();
            this._resultSeal = null;
         }
         if(this._titleBitmap)
         {
            this._titleBitmap.parent.removeChild(this._titleBitmap);
            this._titleBitmap.bitmapData.dispose();
            this._titleBitmap = null;
         }
         if(this._fightView)
         {
            this._fightView.dispose();
            this._fightView = null;
         }
         if(this._attatchView)
         {
            this._attatchView.dispose();
            this._attatchView = null;
         }
         if(this._exploitView)
         {
            this._exploitView.dispose();
            this._exploitView = null;
         }
         if(this._totalView)
         {
            this._totalView.dispose();
            this._totalView = null;
         }
         if(this._smallCardsView)
         {
            this._smallCardsView.dispose();
            this._smallCardsView = null;
         }
         if(this._rightView)
         {
            removeChild(this._rightView);
         }
         this._cardController = null;
         this._rightView = null;
         this._blurFilter = null;
         this._fightNums = null;
         this._attatchNums = null;
         this._exploitNums = null;
         this._shape = null;
         this._gameInfo = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}

package luckStar.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.bossbox.AwardsView;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import luckStar.cell.LuckStarCell;
   import luckStar.event.LuckStarEvent;
   import luckStar.manager.LuckStarManager;
   import luckStar.manager.LuckStarTurnControl;
   import shop.manager.ShopBuyManager;
   import store.HelpFrame;
   import store.HelpPrompt;
   
   public class LuckStarFrame extends Frame
   {
      
      private static const MAX_CELL:int = 14;
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _superLuckyStarBg:Bitmap;
      
      private var _luckyStarCount:int = 10;
      
      private var _cell:Vector.<LuckStarCell>;
      
      private var _startBtn:BaseButton;
      
      private var _stopBtn:BaseButton;
      
      private var _autoCheck:SelectedCheckButton;
      
      private var _numText:FilterFrameText;
      
      private var _coinsView:LuckStarCoinsView;
      
      private var _rankView:LuckStarRankView;
      
      private var _buyBtn:BaseButton;
      
      private var _helpBtn:BaseButton;
      
      private var _explain:FilterFrameText;
      
      private var _coins:FilterFrameText;
      
      private var _coinsAward:FilterFrameText;
      
      private var _awardAction:MovieClip;
      
      private var _turnControl:LuckStarTurnControl;
      
      private var _select:int;
      
      private var _rewardList:Array;
      
      private var _turnComplete:Boolean = true;
      
      private var _helpNumText:FilterFrameText;
      
      private var _helpRewardPrice:FilterFrameText;
      
      private var _getRewardPrice:int;
      
      private var _frame:BaseAlerFrame;
      
      private var _alert:BaseAlerFrame;
      
      public function LuckStarFrame()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc2_:LuckStarCell = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("luckyStar.view.scale9ImageBg");
         this._superLuckyStarBg = ComponentFactory.Instance.creatBitmap("luckyStar.view.SuperLuckyStarBg");
         this._autoCheck = ComponentFactory.Instance.creatComponentByStylename("luckyStar.view.AutoOpenButton");
         this._numText = ComponentFactory.Instance.creatComponentByStylename("luckyStar.view.starNumText");
         this._startBtn = ComponentFactory.Instance.creat("luckyStar.view.TurnStartBtn");
         this._startBtn.tipData = LanguageMgr.GetTranslation("ddt.luckStar.buttonTip");
         this._stopBtn = ComponentFactory.Instance.creat("luckyStar.view.TurnStopBtn");
         this._stopBtn.tipData = LanguageMgr.GetTranslation("ddt.luckStar.stopBtnTip");
         this._coinsView = ComponentFactory.Instance.creatCustomObject("luckyStar.view.luckyStarCoinsView");
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("luckyStar.view.BoxBtn");
         this._buyBtn.tipData = LanguageMgr.GetTranslation("ddt.luckStar.buyLuckStar");
         this._rankView = new LuckStarRankView();
         PositionUtils.setPos(this._rankView,"luckyStar.view.rankViewPos");
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("luckyStar.view.HelpBtn");
         this._getRewardPrice = ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.LUCKYSTAR_ID).getItemPrice(1).moneyValue / 2;
         this._explain = ComponentFactory.Instance.creatComponentByStylename("luckyStar.view.explainText");
         this._explain.text = LanguageMgr.GetTranslation("ddt.luckStar.explain",this._getRewardPrice);
         this._coins = ComponentFactory.Instance.creatComponentByStylename("luckyStar.view.coinsText");
         this._coins.text = this._getRewardPrice + LanguageMgr.GetTranslation("money");
         this._coinsAward = ComponentFactory.Instance.creatComponentByStylename("luckyStar.view.coinsAwardText");
         this._coinsAward.text = LanguageMgr.GetTranslation("ddt.luckStar.explainAward");
         this._turnControl = new LuckStarTurnControl();
         addToContent(this._bg);
         addToContent(this._helpBtn);
         addToContent(this._superLuckyStarBg);
         addToContent(this._startBtn);
         addToContent(this._stopBtn);
         addToContent(this._coinsView);
         addToContent(this._buyBtn);
         addToContent(this._numText);
         addToContent(this._autoCheck);
         addToContent(this._rankView);
         addToContent(this._explain);
         addToContent(this._coins);
         addToContent(this._coinsAward);
         this._rewardList = [];
         this._cell = new Vector.<LuckStarCell>();
         var _loc1_:int = 0;
         while(_loc1_ < MAX_CELL)
         {
            _loc2_ = new LuckStarCell();
            _loc2_.selected = false;
            PositionUtils.setPos(_loc2_,"luckyStar.view.cellPos" + _loc1_);
            _loc2_.addEventListener(LuckStarEvent.LUCKYSTAR_EVENT,this.__onPlayActionEnd);
            this._cell.push(_loc2_);
            addToContent(_loc2_);
            _loc1_++;
         }
         this._autoCheck.addEventListener(Event.SELECT,this.__selectedChanged);
         this._startBtn.addEventListener(MouseEvent.CLICK,this.__onStartLuckyStar);
         this._stopBtn.addEventListener(MouseEvent.CLICK,this.__onStopLuckyStar);
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.__onBuyLuckyStar);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__onHelpClick);
         this._turnControl.addEventListener(LuckStarTurnControl.TURNCOMPLETE,this.__onTurnComplete);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.__onbagUpdate);
         this.updateCellInfo();
         this.updateLuckyStarCount();
         this.updateLuckyStarCoins();
         this.aotuButton = false;
      }
      
      private function __onHelpClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:HelpPrompt = ComponentFactory.Instance.creat("luckyStar.view.HelpPrompt");
         var _loc3_:HelpFrame = ComponentFactory.Instance.creat("luckyStar.view.HelpFrame");
         _loc3_.setView(_loc2_);
         _loc3_.titleText = LanguageMgr.GetTranslation("store.view.HelpButtonText");
         if(!this._helpNumText)
         {
            this._helpNumText = ComponentFactory.Instance.creat("luckyStar.view.HelpNumText");
         }
         if(!this._helpRewardPrice)
         {
            this._helpRewardPrice = ComponentFactory.Instance.creat("luckyStar.view.HelpNumText");
         }
         PositionUtils.setPos(this._helpRewardPrice,"luckyStar.view.helpRewardPricePos");
         this._helpNumText.text = LuckStarManager.Instance.model.minUseNum.toString();
         this._helpRewardPrice.text = this._coins.text;
         _loc3_.addChild(this._helpRewardPrice);
         _loc3_.addChild(this._helpNumText);
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __selectedChanged(param1:Event) : void
      {
         SoundManager.instance.play("008");
         if(this._turnControl.turnContinue == this._autoCheck.selected)
         {
            return;
         }
         this._turnControl.turnContinue = this._autoCheck.selected;
         if(this._turnControl.isTurn)
         {
            if(this._autoCheck.selected)
            {
               this.aotuButton = true;
            }
            else
            {
               this.aotuButton = false;
            }
         }
      }
      
      public function getAwardGoods(param1:InventoryItemInfo) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._cell.length)
         {
            if(this._cell[_loc2_].info.TemplateID == param1.TemplateID)
            {
               this._select = _loc2_;
            }
            _loc2_++;
         }
         this._rewardList.push(param1);
         this.startTurn();
      }
      
      private function __onPlayActionEnd(param1:LuckStarEvent) : void
      {
         if(param1.code == LuckStarEvent.CELL_ACTION_COMPLETE)
         {
            SocketManager.Instance.out.sendLuckyStarTurnComplete();
            if(this._cell[this._select].isMaxAward)
            {
               LuckStarManager.Instance.model.coins = 1000;
            }
            if(this._autoCheck.selected && this._luckyStarCount > 0 && LuckStarManager.Instance.isOpen)
            {
               this.turnLuckyStar();
            }
            else
            {
               this.showAward();
            }
         }
      }
      
      private function showAward() : void
      {
         if(!LuckStarManager.Instance.isOpen)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.luckStar.activityOver"));
         }
         SoundManager.instance.resumeMusic();
         this._turnComplete = true;
         this.aotuButton = false;
         if(this._rewardList.length > 1)
         {
            this.showAwardFrame();
            return;
         }
         this._rewardList.splice(0,this._rewardList.length);
      }
      
      private function showAwardFrame() : void
      {
         if(this._frame)
         {
            return;
         }
         this._frame = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.ItemPreviewListFrame");
         var _loc1_:AwardsView = new AwardsView();
         _loc1_.goodsList = this._rewardList;
         _loc1_.boxType = 4;
         var _loc2_:FilterFrameText = ComponentFactory.Instance.creat("bagandinfo.awardsFFT");
         _loc2_.text = LanguageMgr.GetTranslation("roulette.tipTxt4");
         var _loc3_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("dice.reward.title"));
         _loc3_.showCancel = false;
         _loc3_.moveEnable = false;
         this._frame.info = _loc3_;
         this._frame.addToContent(_loc1_);
         this._frame.addToContent(_loc2_);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__onFrameClose);
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __onFrameClose(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         BaseAlerFrame(param1.currentTarget).removeEventListener(FrameEvent.RESPONSE,this.__onFrameClose);
         ObjectUtils.disposeObject(param1.currentTarget);
         this._frame = null;
         this._rewardList.splice(0,this._rewardList.length);
      }
      
      private function __onTurnComplete(param1:Event) : void
      {
         this._cell[this._select].selected = false;
         if(this._cell[this._select].isMaxAward)
         {
            this._autoCheck.selected = false;
         }
         this._cell[this._select].playAction();
      }
      
      private function __onStartLuckyStar(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(LuckStarManager.Instance.isOpen)
         {
            this.turnLuckyStar();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.luckStar.activityOver"));
         }
      }
      
      private function __onStopLuckyStar(param1:MouseEvent) : void
      {
         this.aotuButton = false;
      }
      
      private function set aotuButton(param1:Boolean) : void
      {
         if(param1)
         {
            this._startBtn.enable = false;
            if(this._autoCheck.selected)
            {
               this._stopBtn.visible = true;
               this._startBtn.visible = false;
            }
         }
         else
         {
            this._startBtn.visible = true;
            if(!this._turnControl.isTurn)
            {
               this._startBtn.enable = true;
            }
            this._autoCheck.selected = false;
            this._stopBtn.visible = false;
         }
      }
      
      private function turnLuckyStar() : void
      {
         if(this._luckyStarCount <= 0)
         {
            this.helpBuyAlert();
         }
         else
         {
            this.aotuButton = true;
            SocketManager.Instance.out.sendLuckyStarTurn();
         }
      }
      
      private function helpBuyAlert() : void
      {
         this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("church.churchScene.SceneUI.info"),LanguageMgr.GetTranslation("ddt.luckStar.notLuckStar"),"","",true,true,true,LayerManager.BLCAK_BLOCKGOUND);
         this._alert.moveEnable = false;
         this._alert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._alert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         ObjectUtils.disposeObject(this._alert);
         this._alert = null;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.buyStar();
         }
      }
      
      private function startTurn() : void
      {
         SoundManager.instance.pauseMusic();
         this._turnComplete = false;
         this.aotuButton = true;
         this.playCoinsAction();
         this._turnControl.turnContinue = this._autoCheck.selected;
         this._turnControl.turn(this._cell,this._select - 1);
      }
      
      private function playCoinsAction() : void
      {
         if(this._awardAction)
         {
            this._awardAction.stop();
            this._awardAction.removeEventListener(Event.ENTER_FRAME,this.disposeAwardAction);
         }
         ObjectUtils.disposeObject(this._awardAction);
         this._awardAction = null;
         this._awardAction = ComponentFactory.Instance.creat("luckyStar.view.CoinsAwardAction");
         PositionUtils.setPos(this._awardAction,"luckyStar.view.awardActionPos");
         addToContent(this._awardAction);
         this._awardAction.gotoAndPlay(1);
         this._awardAction.addEventListener(Event.ENTER_FRAME,this.disposeAwardAction);
      }
      
      private function disposeAwardAction(param1:Event) : void
      {
         if(this._awardAction.currentFrame == this._awardAction.totalFrames - 1)
         {
            if(this._awardAction)
            {
               this._awardAction.stop();
               this._awardAction.removeEventListener(Event.ENTER_FRAME,this.disposeAwardAction);
            }
            ObjectUtils.disposeObject(this._awardAction);
            this._awardAction = null;
         }
      }
      
      public function __onBuyLuckyStar(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.buyStar();
      }
      
      private function buyStar() : void
      {
         var _loc1_:ShopItemInfo = ShopManager.Instance.getShopItemByTemplateID(EquipType.LUCKYSTAR_ID,3);
         ShopBuyManager.Instance.buy(_loc1_.GoodsID);//,_loc1_.isDiscount,_loc1_.getItemPrice(1).PriceType);
      }
      
      public function __onbagUpdate(param1:BagEvent) : void
      {
         this.updateLuckyStarCount();
      }
      
      private function updateLuckyStarCount() : void
      {
         var _loc1_:int = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.LUCKYSTAR_ID);
         if(this._luckyStarCount != _loc1_)
         {
            this._luckyStarCount = _loc1_;
            this._numText.text = this._luckyStarCount.toString();
         }
      }
      
      public function updateCellInfo() : void
      {
         var _loc1_:int = LuckStarManager.Instance.model.goods.length;
         if(!this._cell)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < MAX_CELL && _loc2_ < _loc1_)
         {
            this._cell[_loc2_].info = LuckStarManager.Instance.model.goods[_loc2_];
			this._cell[_loc2_].info.Quality = ItemManager.Instance.getTemplateById(this._cell[_loc2_].info.TemplateID).Quality;
            this._cell[_loc2_].count = LuckStarManager.Instance.model.goods[_loc2_].Count;
            _loc2_++;
         }
      }
      
      public function updateMinUseNum() : void
      {
         this._rankView.updateHelpText();
      }
      
      public function updateLuckyStarCoins() : void
      {
         if(LuckStarManager.Instance.model.coins != 0)
         {
            this._coinsView.count = LuckStarManager.Instance.model.coins;
         }
      }
      
      public function updateRankInfo() : void
      {
         this._rankView.lastUpdateTime();
         this._rankView.updateSelfInfo();
         this._rankView.updateRankInfo();
         this.updateActivityDate();
      }
      
      public function updateActivityDate() : void
      {
         this._rankView.updateActivityDate();
      }
      
      public function updatePlayActionList() : void
      {
         this._rankView.updateNewAwardList();
      }
      
      public function updateNewAwardList(param1:String, param2:int, param3:int) : void
      {
         this._rankView.insertNewAwardItem(param1,param2,param3);
      }
      
      public function get isTurn() : Boolean
      {
         return !this._turnComplete;
      }
      
      override public function dispose() : void
      {
         var _loc1_:LuckStarCell = null;
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.__onbagUpdate);
         this._startBtn.removeEventListener(MouseEvent.CLICK,this.__onStartLuckyStar);
         this._stopBtn.removeEventListener(MouseEvent.CLICK,this.__onStopLuckyStar);
         this._autoCheck.removeEventListener(Event.SELECT,this.__selectedChanged);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__onHelpClick);
         this._buyBtn.removeEventListener(MouseEvent.CLICK,this.__onBuyLuckyStar);
         this._turnControl.removeEventListener(LuckStarTurnControl.TURNCOMPLETE,this.__onTurnComplete);
         if(this._frame)
         {
            this._frame.removeEventListener(FrameEvent.RESPONSE,this.__onFrameClose);
            ObjectUtils.disposeObject(this._frame);
            this._frame = null;
         }
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._superLuckyStarBg);
         this._superLuckyStarBg = null;
         ObjectUtils.disposeObject(this._startBtn);
         this._startBtn = null;
         ObjectUtils.disposeObject(this._stopBtn);
         this._stopBtn = null;
         while(this._cell.length)
         {
            _loc1_ = this._cell.pop();
            _loc1_.removeEventListener(LuckStarEvent.LUCKYSTAR_EVENT,this.__onPlayActionEnd);
            ObjectUtils.disposeObject(_loc1_);
         }
         this._rewardList = null;
         this._cell = null;
         ObjectUtils.disposeObject(this._autoCheck);
         this._autoCheck = null;
         ObjectUtils.disposeObject(this._numText);
         this._numText = null;
         ObjectUtils.disposeObject(this._coinsView);
         this._coinsView = null;
         ObjectUtils.disposeObject(this._rankView);
         this._rankView = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         ObjectUtils.disposeObject(this._buyBtn);
         this._buyBtn = null;
         ObjectUtils.disposeObject(this._explain);
         this._explain = null;
         ObjectUtils.disposeObject(this._coins);
         this._coins = null;
         ObjectUtils.disposeObject(this._coinsAward);
         this._coinsAward = null;
         ObjectUtils.disposeObject(this._helpNumText);
         this._helpNumText = null;
         ObjectUtils.disposeObject(this._helpRewardPrice);
         this._helpRewardPrice = null;
         if(this._awardAction)
         {
            this._awardAction.stop();
            this._awardAction.removeEventListener(Event.ENTER_FRAME,this.disposeAwardAction);
         }
         ObjectUtils.disposeObject(this._awardAction);
         this._awardAction = null;
         if(this._turnControl)
         {
            this._turnControl.dispose();
            this._turnControl = null;
         }
         super.dispose();
      }
   }
}

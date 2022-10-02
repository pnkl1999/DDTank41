package store.fineStore.view.pageBringUp
{
   import bagAndInfo.bag.RichesButton;
   import bagAndInfo.cell.LockableBagCell;
   import baglocked.BaglockedManager;
   import com.greensock.TweenLite;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CEvent;
   import ddt.events.CellEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.utils.HelpFrameUtils;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   import flash.utils.setTimeout;
   import latentEnergy.LatentEnergyEvent;
   import latentEnergy.LatentEnergyManager;
   import shop.view.BuySingleGoodsView;
   import store.FineBringUpController;
   import store.forge.ForgeRightBgView;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class FineBringUpView extends Sprite implements Disposeable, IObserver
   {
       
      
      private var _leftBg:MovieClip;
      
      private var _rightBgView:ForgeRightBgView;
      
      private var _bgCell:Bitmap;
      
      private var _upgrade:MovieClip;
      
      private var _eatExp:MovieClip;
      
      private var _bringUpItemCell:FineBringUpCell;
      
      private var _bagList:FineBringUpBagListView;
      
      private var _rightDrapSprite:FineBringUpRightDragSprite;
      
      private var _leftDrapSprite:FineBringUpLeftDragSprite;
      
      private var _buyExpBtn:SimpleBitmapButton;
      
      private var _bringUpEatAllBtn:SimpleBitmapButton;
      
      private var _bringUpEatBtn:SimpleBitmapButton;
      
      private var _bringUpLockBtn:SelectedButton;
      
      private var _mouseLockImg:Sprite;
      
      private var _mouseEatImg:Sprite;
      
      private var _isEatStatus:Boolean = false;
      
      private var _helpBtn:BaseButton;
      
      private var _progress:MovieClip;
      
      private var _progressTips:OneLineTip;
      
      private var _progressTxt:FilterFrameText;
      
      private var _listData:BagInfo;
      
      private var _usingEatMouse:Boolean = false;
      
      private var _moneyBoard:Sprite;
      
      private var showMoneyBG:MutipleImage;
      
      private var moneyTxt:FilterFrameText;
      
      private var bindMoneyTxt:FilterFrameText;
      
      private var medelTxt:FilterFrameText;
      
      private var _moneyButton:RichesButton;
      
      private var _bindMoneyButton:RichesButton;
      
      private var _medelButton:RichesButton;
      
      private var _scrollPanel:ListPanel;
      
      private var _refreshTooFast:Boolean = false;
      
      public function FineBringUpView()
      {
         super();
         this.initView();
         this.initEvent();
         this.createAcceptDragSprite();
      }
      
      public function update(param1:Object) : void
      {
         var _loc2_:int = FineBringUpController.getInstance().progress(param1 as InventoryItemInfo);
         if(this._progress.totalFrames >= _loc2_)
         {
            this._progress && this._progress.gotoAndStop(_loc2_);
            this._progressTxt && (this._progressTxt.text = _loc2_.toString() + "%");
         }
         else
         {
            this._progress && this._progress.gotoAndStop(0);
            this._progressTxt && (this._progressTxt.text = "0%");
         }
      }
      
      private function initView() : void
      {
         this._leftBg = ComponentFactory.Instance.creat("asset.store.bringup.leftBg");
         PositionUtils.setPos(this._leftBg,"storeBringUp.leftBgPos");
         this._leftBg.gotoAndStop(1);
         addChild(this._leftBg);
         this._rightBgView = new ForgeRightBgView();
         this._rightBgView.hideMoney();
         this._rightBgView.title1("");
         this._rightBgView.title2("");
         this._rightBgView.showStoreBagViewText(LanguageMgr.GetTranslation("tank.view.bagII.rightTip"),"",false);
         this._rightBgView.equipmentTipText().x = this._rightBgView.equipmentTipText().x - 40;
         this._rightBgView.bgFrame(2);
         PositionUtils.setPos(this._rightBgView,"storeBringUp.rightBgViewPos");
         addChild(this._rightBgView);
         this._bagList = new FineBringUpBagListView(BagInfo.EQUIPBAG,7,63);
         BringupScrollCell._bringupContent = this._bagList;
         this._scrollPanel = ComponentFactory.Instance.creat("bringup.scrollPanel");
         this._scrollPanel.vectorListModel.clear();
         this._scrollPanel.vectorListModel.appendAll([{}]);
         addChild(this._scrollPanel);
         this.refreshBagList();
         this._bgCell = ComponentFactory.Instance.creatBitmap("equipretrieve.trieveCell1");
         PositionUtils.setPos(this._bgCell,"storeBringUp.itemCellPos");
         addChild(this._bgCell);
         this._bringUpItemCell = new FineBringUpCell(0);
         this._bringUpItemCell.info = null;
         this._bringUpItemCell.register(this);
         this._bringUpItemCell.x = this._bgCell.x + 22;
         this._bringUpItemCell.y = this._bgCell.y + 24;
         addChild(this._bringUpItemCell);
         this._upgrade = ComponentFactory.Instance.creat("asset.strength.weaponUpgrades");
         this._upgrade.mouseEnabled = false;
         this._upgrade.mouseChildren = false;
         this._upgrade.x = this._bringUpItemCell.x + this._bringUpItemCell.width * 0.5;
         this._upgrade.y = this._bringUpItemCell.y + this._bringUpItemCell.height * 0.5;
         this._upgrade.gotoAndStop(this._upgrade.totalFrames);
         addChild(this._upgrade);
         this._eatExp = ComponentFactory.Instance.creat("accet.strength.starMovie");
         this._eatExp.mouseEnabled = false;
         this._eatExp.mouseChildren = false;
         PositionUtils.setPos(this._eatExp,"storeBringUp.expEatMCPos");
         this._eatExp.gotoAndStop(this._eatExp.totalFrames);
         addChild(this._eatExp);
         this._progress = ComponentFactory.Instance.creat("asset.store.bringup.progressbar");
         PositionUtils.setPos(this._progress,"storeBringUp.progressPos");
         this._progress.stop();
         addChild(this._progress);
         this._progressTips = new OneLineTip();
         this._progressTips.tipData = "0/0";
         this._progressTxt = ComponentFactory.Instance.creatComponentByStylename("ddt.store.view.exalt.StoreExaltProgressBar.percentage");
         PositionUtils.setPos(this._progressTxt,"storeBringUp.progressTxtPos");
         this._progressTxt.mouseEnabled = false;
         this._progressTxt.text = "0%";
         addChild(this._progressTxt);
         this._bringUpEatAllBtn = ComponentFactory.Instance.creat("storeBringUp.bringUpEatAllBtn");
         addChild(this._bringUpEatAllBtn);
         this._bringUpEatBtn = ComponentFactory.Instance.creat("storeBringUp.bringUpEatBtn");
         addChild(this._bringUpEatBtn);
         this._bringUpLockBtn = ComponentFactory.Instance.creat("bringup.lock.checkBoxBtn");
         addChild(this._bringUpLockBtn);
         this._mouseLockImg = new Sprite();
         this._mouseLockImg.addChild(ComponentFactory.Instance.creatBitmap("asset.store.bringup.lockCursor"));
         this._mouseEatImg = new Sprite();
         this._mouseEatImg.addChild(ComponentFactory.Instance.creatBitmap("asset.store.bringup.feedIcon"));
         this._helpBtn = HelpFrameUtils.Instance.simpleHelpButton(this,"ddtstore.HelpButton",null,LanguageMgr.GetTranslation("store.view.HelpButtonText"),"asset.store.bringup.help",404,484);
         PositionUtils.setPos(this._helpBtn,"storeFine.bringup.helpPos");
         this._buyExpBtn = ComponentFactory.Instance.creat("storeBringUp.buyExpBtn");
         this._buyExpBtn.tipStyle = "ddt.view.tips.OneLineTip";
         this._buyExpBtn.tipGapV = 6;
         this._buyExpBtn.tipGapH = 6;
         this._buyExpBtn.tipDirctions = "0,1,2";
         this._buyExpBtn.tipData = LanguageMgr.GetTranslation("tank.view.bagII.bringup.expBuyBtnTips");
         addChild(this._buyExpBtn);
         this._moneyBoard = new Sprite();
         this._moneyBoard.x = 414;
         this._moneyBoard.y = 49;
         addChild(this._moneyBoard);
         this.showMoneyBG = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.MoneyPanelBg");
         this._moneyBoard.addChild(this.showMoneyBG);
         this.moneyTxt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.TicketText");
         this._moneyBoard.addChild(this.moneyTxt);
         this._moneyButton = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreBagView.GoldButton");
         this._moneyButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GoldDirections");
         this._moneyBoard.addChild(this._moneyButton);
         this.bindMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.GiftText");
         this._moneyBoard.addChild(this.bindMoneyTxt);
         this._bindMoneyButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.bag.GiftButton");
         this._bindMoneyButton = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreBagView.GiftButton");
         var _loc1_:int = 6000;
         var _loc2_:int = int(ServerConfigManager.instance.VIPExtraBindMoneyUpper[PlayerManager.Instance.Self.VIPLevel - 1]);
         if(PlayerManager.Instance.Self.IsVIP)
         {
            this._bindMoneyButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GiftDirections",(_loc1_ + _loc2_).toString());
         }
         else
         {
            this._bindMoneyButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GiftDirections",_loc1_.toString());
         }
         this._moneyBoard.addChild(this._bindMoneyButton);
         this._medelButton = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreBagView.MoneyButton");
         this._medelButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.MedalDirections",ServerConfigManager.instance.getBindBidLimit(PlayerManager.Instance.Self.Grade,PlayerManager.Instance.Self.VIPLevel));
         this._moneyBoard.addChild(this._medelButton);
         this.medelTxt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagView.GoldText");
         PositionUtils.setPos(this.medelTxt,"ddtstore.bringUp.GoldPos");
         this._moneyBoard.addChild(this.medelTxt);
         this.updateMoney();
         this.equipChangeHandler(null);
      }
      
      private function initEvent() : void
      {
         this._bagList.addEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler,false,0,true);
         this._bagList.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick,false,0,true);
         this._bringUpItemCell.addEventListener(Event.CHANGE,this.equipChangeHandler,false,0,true);
         this._progress.addEventListener(MouseEvent.ROLL_OVER,this.onProgressOver);
         this._progress.addEventListener(MouseEvent.ROLL_OUT,this.onProgressOut);
         this._bringUpEatAllBtn.addEventListener(MouseEvent.CLICK,this.onEatAllClick);
         this._bringUpEatBtn.addEventListener(MouseEvent.CLICK,this.onEatBtnClick);
         this._bringUpLockBtn.addEventListener(MouseEvent.CLICK,this.onLockBtnClick);
         FineBringUpController.getInstance().addEventListener(FineBringUpController.EAT_MOUSE_STATUS_CHANGE,this.onBringUpEatResult);
         PlayerManager.Instance.addEventListener("bring_up",this.__updateInventorySlot);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         this._buyExpBtn.addEventListener(MouseEvent.CLICK,this.onBuyExpBtnClick);
      }
      
      private function removeEvent() : void
      {
         this._bagList.removeEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler);
         this._bagList.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._bringUpItemCell.removeEventListener(Event.CHANGE,this.equipChangeHandler);
         this._progress.addEventListener(MouseEvent.ROLL_OVER,this.onProgressOver);
         this._progress.addEventListener(MouseEvent.ROLL_OUT,this.onProgressOut);
         this._bringUpEatAllBtn.removeEventListener(MouseEvent.CLICK,this.onEatAllClick);
         this._bringUpEatBtn.removeEventListener(MouseEvent.CLICK,this.onEatBtnClick);
         this._bringUpLockBtn.removeEventListener(MouseEvent.CLICK,this.onLockBtnClick);
         FineBringUpController.getInstance().removeEventListener(FineBringUpController.EAT_MOUSE_STATUS_CHANGE,this.onBringUpEatResult);
         PlayerManager.Instance.removeEventListener("bring_up",this.__updateInventorySlot);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         this._buyExpBtn.removeEventListener(MouseEvent.CLICK,this.onBuyExpBtnClick);
      }
      
      private function __updateInventorySlot(param1:CEvent) : void
      {
         if(FineBringUpController.getInstance().onSending)
         {
            return;
         }
         this._listData = FineBringUpController.getInstance().getCanBringUpData();
         this._bagList.setData(this._listData);
         var _loc2_:InventoryItemInfo = PlayerManager.Instance.Self.getBag(BagInfo.STOREBAG).getItemAt(0);
         if(_loc2_ == null)
         {
            this._bringUpItemCell.info = _loc2_;
            return;
         }
         if(!(this._bringUpItemCell == null || FineBringUpController.getInstance().needPlayMovie == false))
         {
            if(this._bringUpItemCell.lastLevel < int(_loc2_.Property1))
            {
               this._upgrade.play();
            }
            else
            {
               this._eatExp.play();
            }
         }
         this._bringUpItemCell && (this._bringUpItemCell.info = _loc2_);
      }
      
      protected function onProgressOut(param1:MouseEvent) : void
      {
         this._progressTips && this._progressTips.parent && removeChild(this._progressTips);
      }
      
      protected function onProgressOver(param1:MouseEvent) : void
      {
         var _loc2_:ItemTemplateInfo = this._bringUpItemCell.info;
         var _loc3_:String = FineBringUpController.getInstance().progressTipData(this._bringUpItemCell.info);
         this._progressTips.tipData = _loc3_;
         this._progressTips.x = mouseX;
         this._progressTips.y = mouseY;
         addChild(this._progressTips);
      }
      
      public function __propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["Money"] || param1.changedProperties["Gold"] || param1.changedProperties["Gift"] || param1.changedProperties["medal"])
         {
            this.updateMoney();
         }
      }
      
      private function updateMoney() : void
      {
         this.moneyTxt.text = String(PlayerManager.Instance.Self.Money);
         this.bindMoneyTxt.text = String(PlayerManager.Instance.Self.Gift);
      }
      
      protected function onBuyExpBtnClick(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         var onBuy:Function = null;
         onBuy = function(param1:Object):void
         {
            FineBringUpController.getInstance().buyExp(param1.type,param1.num);
         };
         if(this._bringUpItemCell.info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.bringup.PleaseSelect"),0,false,1);
            return;
         }
         var expData:Array = FineBringUpController.getInstance().expDataArr(this._bringUpItemCell.info);
         if(expData[1] == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.bringup.topLevel"),0,false,1);
            return;
         }
         FineBringUpController.getInstance().hideNewHandTip();
         var buyView:BuySingleGoodsView = new BuySingleGoodsView();
         LayerManager.Instance.addToLayer(buyView,3,true,1);
      }
      
      protected function onBringUpEatResult(param1:CEvent) : void
      {
         var e:CEvent = param1;
         var __info:InventoryItemInfo = null;
         if(this._refreshTooFast)
         {
            return;
         }
         this._refreshTooFast = true;
         TweenLite.delayedCall(1.5,function():void
         {
            _refreshTooFast = false;
         });
         if(e.data == "submited")
         {
            this.refreshBagList();
            __info = PlayerManager.Instance.Self.getBag(BagInfo.STOREBAG).getItemAt(0);
            this._bringUpItemCell && (this._bringUpItemCell.info = __info);
            this._listData = FineBringUpController.getInstance().getCanBringUpData();
            this._bagList.setData(this._listData);
         }
         if(this._isEatStatus == true)
         {
            setTimeout(this.eatStatusChange,75);
         }
      }
      
      protected function onEatBtnClick(param1:MouseEvent) : void
      {
         if(FineBringUpController.getInstance().isMaxLevel(this._bringUpItemCell.info as InventoryItemInfo))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.bringup.maxLevel"),0,true,1);
         }
         else
         {
            this._bringUpLockBtn.mouseEnabled = false;
            this._bringUpEatAllBtn.mouseEnabled = false;
            FineBringUpController.getInstance().hideNewHandTip();
            this._isEatStatus = true;
            param1.stopImmediatePropagation();
            this.eatStatusChange();
         }
      }
      
      private function eatStatusChange() : void
      {
         this._usingEatMouse = !this._usingEatMouse;
         if(this._usingEatMouse)
         {
            Mouse.hide();
            if(this._mouseEatImg == null)
            {
               this._mouseEatImg = new Sprite();
               this._mouseEatImg.addChild(ComponentFactory.Instance.creatBitmap("asset.store.bringup.feedIcon"));
            }
            StageReferance.stage.addChild(this._mouseEatImg);
            this._mouseEatImg.mouseChildren = this._mouseEatImg.mouseEnabled = false;
            this._mouseEatImg.x = StageReferance.stage.mouseX - this._mouseEatImg.width * 0.5;
            this._mouseEatImg.y = StageReferance.stage.mouseY - this._mouseEatImg.height * 0.5;
            this._mouseEatImg.startDrag(false);
            StageReferance.stage.addEventListener(MouseEvent.CLICK,this.onEatMouseClick);
            this._bagList.removeEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler);
            this._bagList.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         }
         else
         {
            Mouse.show();
            if(this._mouseEatImg)
            {
               this._mouseEatImg.parent && StageReferance.stage.removeChild(this._mouseEatImg);
               this._mouseEatImg.stopDrag();
               FineBringUpController.getInstance().usingLock = false;
               this._bringUpLockBtn && (this._bringUpLockBtn.mouseEnabled = true);
               this._bringUpEatAllBtn && (this._bringUpEatAllBtn.mouseEnabled = true);
            }
            StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.onEatMouseClick);
            if(this._bagList)
            {
               this._bagList.addEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler,false,0,true);
               this._bagList.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick,false,0,true);
            }
         }
      }
      
      protected function onEatMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:LockableBagCell = param1.target as LockableBagCell;
         if(_loc2_ && _loc2_.info)
         {
            if(_loc2_.cellLocked)
            {
               return;
            }
            this.onEatClick(_loc2_.info as InventoryItemInfo);
            this._usingEatMouse = false;
            StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.onEatMouseClick);
            Mouse.show();
            if(this._mouseEatImg)
            {
               this._mouseEatImg.parent && StageReferance.stage.removeChild(this._mouseEatImg);
               this._mouseEatImg.stopDrag();
               FineBringUpController.getInstance().usingLock = false;
               this._bringUpLockBtn && (this._bringUpLockBtn.mouseEnabled = true);
               this._bringUpEatAllBtn && (this._bringUpEatAllBtn.mouseEnabled = true);
            }
         }
         else
         {
            this._isEatStatus = false;
            this.eatStatusChange();
         }
      }
      
      private function onEatClick(param1:InventoryItemInfo) : void
      {
         if(FineBringUpController.getInstance().isMaxLevel(this._bringUpItemCell.info as InventoryItemInfo))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.bringup.maxLevel"),0,true,1);
         }
         else
         {
            this._bringUpItemCell && FineBringUpController.getInstance().eatBtnClick(this._bringUpItemCell.info as InventoryItemInfo,param1);
         }
      }
      
      protected function onEatAllClick(param1:MouseEvent) : void
      {
         if(FineBringUpController.getInstance().isMaxLevel(this._bringUpItemCell.info as InventoryItemInfo))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.bringup.maxLevel"),0,true,1);
         }
         else
         {
            FineBringUpController.getInstance().eatAllBtnClick(this._bringUpItemCell.info as InventoryItemInfo);
         }
      }
      
      private function onLockBtnClick(param1:MouseEvent) : void
      {
         this._bringUpEatBtn.mouseEnabled = false;
         param1.stopImmediatePropagation();
         this.lockStatusChange();
      }
      
      private function lockStatusChange() : void
      {
         this._bringUpLockBtn.selected = FineBringUpController.getInstance().usingLock = !FineBringUpController.getInstance().usingLock;
         if(FineBringUpController.getInstance().usingLock)
         {
            Mouse.hide();
            StageReferance.stage.addChild(this._mouseLockImg);
            this._mouseLockImg.mouseChildren = this._mouseLockImg.mouseEnabled = false;
            this._mouseLockImg.x = StageReferance.stage.mouseX - this._mouseLockImg.width * 0.5;
            this._mouseLockImg.y = StageReferance.stage.mouseY - this._mouseLockImg.height * 0.5;
            this._mouseLockImg.startDrag(false);
            StageReferance.stage.addEventListener(MouseEvent.CLICK,this.onLockMouseClick);
            this._bagList.removeEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler);
            this._bagList.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         }
         else
         {
            this._bringUpEatBtn && (this._bringUpEatBtn.mouseEnabled = true);
            Mouse.show();
            if(this._mouseLockImg)
            {
               this._mouseLockImg.parent && StageReferance.stage.removeChild(this._mouseLockImg);
               this._mouseLockImg.stopDrag();
            }
            StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.onLockMouseClick);
            if(this._bagList)
            {
               this._bagList.addEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler,false,0,true);
               this._bagList.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick,false,0,true);
            }
         }
      }
      
      protected function onLockMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:LockableBagCell = param1.target as LockableBagCell;
         if(param1.target is FineBringUpCell)
         {
            this.lockStatusChange();
         }
         if(_loc2_ && _loc2_.info)
         {
            _loc2_.cellLocked = !_loc2_.cellLocked;
            (_loc2_.info as InventoryItemInfo).cellLocked = _loc2_.cellLocked;
            GameInSocketOut.sendBringUpLockStatusUpdate(_loc2_.bagType,(_loc2_.info as InventoryItemInfo).Place,_loc2_.cellLocked);
         }
         else
         {
            this.lockStatusChange();
         }
      }
      
      private function createAcceptDragSprite() : void
      {
         this._leftDrapSprite = new FineBringUpLeftDragSprite();
         this._leftDrapSprite.mouseEnabled = false;
         this._leftDrapSprite.mouseChildren = false;
         this._leftDrapSprite.graphics.beginFill(0,0);
         this._leftDrapSprite.graphics.drawRect(0,0,347,404);
         this._leftDrapSprite.graphics.endFill();
         PositionUtils.setPos(this._leftDrapSprite,"storeBringUp.dragLeftPos");
         addChild(this._leftDrapSprite);
         this._rightDrapSprite = new FineBringUpRightDragSprite();
         this._rightDrapSprite.mouseEnabled = false;
         this._rightDrapSprite.mouseChildren = false;
         this._rightDrapSprite.graphics.beginFill(0,0);
         this._rightDrapSprite.graphics.drawRect(0,0,374,407);
         this._rightDrapSprite.graphics.endFill();
         PositionUtils.setPos(this._rightDrapSprite,"storeBringUp.dragRightPos");
         addChild(this._rightDrapSprite);
      }
      
      public function refreshBagList() : void
      {
         this._listData = FineBringUpController.getInstance().getCanBringUpData();
         this._bagList.setData(this._listData);
      }
      
      private function cellClickHandler(param1:CellEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:LockableBagCell = param1.data as LockableBagCell;
         _loc2_.dragStart();
      }
      
      protected function __cellDoubleClick(param1:CellEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:String = "";
         _loc2_ = LatentEnergyManager.EQUIP_MOVE;
         var _loc3_:LatentEnergyEvent = new LatentEnergyEvent(_loc2_);
         var _loc4_:LockableBagCell = param1.data as LockableBagCell;
         _loc4_.cellLocked = false;
         _loc3_.info = _loc4_.info as InventoryItemInfo;
         _loc3_.moveType = 1;
         FineBringUpController.getInstance().dispatchEvent(_loc3_);
      }
      
      private function equipChangeHandler(param1:Event) : void
      {
         if(this._bringUpEatAllBtn == null || this._bringUpEatBtn == null)
         {
            return;
         }
         if(this._bringUpItemCell.info)
         {
            this._bringUpEatAllBtn.enable = true;
            this._bringUpEatBtn.enable = true;
         }
         else
         {
            this._bringUpEatAllBtn.enable = false;
            this._bringUpEatBtn.enable = false;
         }
      }
      
      public function dispose() : void
      {
         Mouse.show();
         this.removeEvent();
         NewHandContainer.Instance.clearArrowByID(ArrowType.BRING_UP);
         if(this._scrollPanel)
         {
            this._scrollPanel.vectorListModel.clear();
            ObjectUtils.disposeObject(this._scrollPanel);
            this._scrollPanel = null;
         }
         BringupScrollCell._bringupContent = null;
         if(this._bagList != null)
         {
            ObjectUtils.disposeObject(this._bagList);
            this._bagList = null;
         }
         if(this._bringUpItemCell != null)
         {
            ObjectUtils.disposeObject(this._bringUpItemCell);
            this._bringUpItemCell = null;
         }
         if(this._leftBg != null)
         {
            ObjectUtils.disposeObject(this._leftBg);
            this._leftBg = null;
         }
         if(this._progress != null)
         {
            ObjectUtils.disposeObject(this._progress);
            this._progress = null;
         }
         if(this._progressTxt != null)
         {
            ObjectUtils.disposeObject(this._progressTxt);
            this._progressTxt = null;
         }
         ObjectUtils.disposeObject(this._rightBgView);
         this._rightBgView = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         ObjectUtils.disposeObject(this._mouseLockImg);
         this._mouseLockImg = null;
         ObjectUtils.disposeObject(this._mouseEatImg);
         this._mouseEatImg = null;
         if(this._bringUpEatAllBtn != null)
         {
            ObjectUtils.disposeObject(this._bringUpEatAllBtn);
            this._bringUpEatAllBtn = null;
         }
         if(this._bringUpEatBtn != null)
         {
            ObjectUtils.disposeObject(this._bringUpEatBtn);
            this._bringUpEatBtn = null;
         }
         if(this.showMoneyBG != null)
         {
            ObjectUtils.disposeObject(this.showMoneyBG);
            this.showMoneyBG = null;
         }
         if(this.medelTxt != null)
         {
            ObjectUtils.disposeObject(this.medelTxt);
            this.medelTxt = null;
         }
         if(this.moneyTxt != null)
         {
            ObjectUtils.disposeObject(this.moneyTxt);
            this.moneyTxt = null;
         }
         if(this.bindMoneyTxt != null)
         {
            ObjectUtils.disposeObject(this.bindMoneyTxt);
            this.bindMoneyTxt = null;
         }
         if(this._moneyButton != null)
         {
            ObjectUtils.disposeObject(this._moneyButton);
            this._moneyButton = null;
         }
         if(this._bindMoneyButton != null)
         {
            ObjectUtils.disposeObject(this._bindMoneyButton);
            this._bindMoneyButton = null;
         }
         if(this._medelButton != null)
         {
            ObjectUtils.disposeObject(this._medelButton);
            this._medelButton = null;
         }
         if(this._buyExpBtn != null)
         {
            ObjectUtils.disposeObject(this._buyExpBtn);
            this._buyExpBtn = null;
         }
      }
   }
}

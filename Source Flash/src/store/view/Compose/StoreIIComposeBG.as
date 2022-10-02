package store.view.Compose
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.StoneType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.view.common.BuyItemButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import store.HelpFrame;
   import store.HelpPrompt;
   import store.IStoreViewBG;
   import store.ShowSuccessRate;
   import store.StoneCell;
   import store.StoreCell;
   import store.StoreDragInArea;
   import store.view.ConsortiaRateManager;
   import store.view.shortcutBuy.ShortcutBuyFrame;
   import store.view.strength.MySmithLevel;
   import trainer.controller.NewHandQueue;
   import trainer.controller.WeakGuildManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class StoreIIComposeBG extends Sprite implements IStoreViewBG
   {
      
      private static const ITEMS:Array = [11004,11008,11012,11016];
      
      public static const COMPOSE_TOP:int = 50;
       
      
      private var _area:StoreDragInArea;
      
      private var _items:Array;
      
      private var _bg:MutipleImage;
      
      private var _compose_btn:BaseButton;
      
      private var _composeHelp:BaseButton;
      
      private var _cpsShine:MovieImage;
      
      private var cpsArr:MutipleImage;
      
      private var _cBuyluckyBtn:BuyItemButton;
      
      private var _buyStoneBtn:BaseButton;
      
      private var _pointArray:Vector.<Point>;
      
      private var _showSuccessRate:ShowSuccessRate;
      
      private var _consortiaSmith:MySmithLevel;
      
      public var composeRate:Array;
      
      public function StoreIIComposeBG()
      {
         this.composeRate = [0.8,0.5,0.3,0.1,0.05];
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         var _loc1_:int = 0;
         var _loc6_:StoreCell = null;
         _loc1_ = 0;
         _loc6_ = null;
         this._items = new Array();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("store.ComposeBG");
         addChild(this._bg);
         this._compose_btn = ComponentFactory.Instance.creatComponentByStylename("store.ComposeBtn");
         addChild(this._compose_btn);
         this._composeHelp = ComponentFactory.Instance.creatComponentByStylename("store.StrengthNodeBtn");
         addChild(this._composeHelp);
         this.cpsArr = ComponentFactory.Instance.creatComponentByStylename("store.ArrowHeadComposeTip");
         addChild(this.cpsArr);
         this._cpsShine = ComponentFactory.Instance.creatComponentByStylename("store.StrengthButtonShine");
         this._cpsShine.mouseEnabled = false;
         this._cpsShine.mouseChildren = false;
         addChild(this._cpsShine);
         this._cBuyluckyBtn = ComponentFactory.Instance.creatComponentByStylename("store.BuyLuckyComposeBtn");
         this._cBuyluckyBtn.setup(EquipType.LUCKY,2,true);
         addChild(this._cBuyluckyBtn);
         this._buyStoneBtn = ComponentFactory.Instance.creatComponentByStylename("store.BuyComposeStoneBtn");
         addChild(this._buyStoneBtn);
         this._consortiaSmith = ComponentFactory.Instance.creatCustomObject("store.MySmithLevel");
         addChild(this._consortiaSmith);
         this.getCellsPoint();
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            if(_loc1_ == 0)
            {
               _loc6_ = new ComposeStoneCell([StoneType.LUCKY],_loc1_);
            }
            else if(_loc1_ == 1)
            {
               _loc6_ = new ComposeItemCell(_loc1_);
            }
            else if(_loc1_ == 2)
            {
               _loc6_ = new ComposeStoneCell([StoneType.COMPOSE],_loc1_);
            }
            _loc6_.x = this._pointArray[_loc1_].x;
            _loc6_.y = this._pointArray[_loc1_].y;
            _loc6_.addEventListener(Event.CHANGE,this.__itemInfoChange);
            addChild(_loc6_);
            this._items.push(_loc6_);
            _loc1_++;
         }
         this._area = new StoreDragInArea(this._items);
         addChildAt(this._area,0);
         this.hide();
         this.hideArr();
         this._showSuccessRate = ComponentFactory.Instance.creatCustomObject("store.ShowSuccessRate");
         var _loc2_:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.ComposeStonStrip");
         var _loc3_:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.LuckSignStrip");
         var _loc4_:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.ConsortiaAddStrip");
         var _loc5_:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.noVIPAllNumStrip");
         if(PlayerManager.Instance.Self.ConsortiaID == 0)
         {
            _loc4_ = LanguageMgr.GetTranslation("tank.view.store.consortiaRateI");
         }
         this._showSuccessRate.showAllTips(_loc2_,_loc3_,_loc4_,_loc5_);
         addChild(this._showSuccessRate);
      }
      
      private function getCellsPoint() : void
      {
         var _loc2_:Point = null;
         this._pointArray = new Vector.<Point>();
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("store.Composepoint" + _loc1_);
            this._pointArray.push(_loc2_);
            _loc1_++;
         }
      }
      
      public function dragDrop(param1:BagCell) : void
      {
         var _loc3_:StoreCell = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:InventoryItemInfo = param1.info as InventoryItemInfo;
         for each(_loc3_ in this._items)
         {
            if(_loc3_.info == _loc2_)
            {
               _loc3_.info = null;
               param1.locked = false;
               return;
            }
         }
         for each(_loc3_ in this._items)
         {
            if(_loc3_)
            {
               if(_loc3_ is StoneCell)
               {
                  if(_loc3_.info == null)
                  {
                     if((_loc3_ as StoneCell).types.indexOf(_loc2_.Property1) > -1 && _loc2_.CategoryID == 11)
                     {
                        SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,_loc3_.index,_loc2_.Count,true);
                        DragManager.acceptDrag(_loc3_,DragEffect.NONE);
                        return;
                     }
                  }
               }
               else if(_loc3_ is ComposeItemCell)
               {
                  if(_loc2_.getRemainDate() <= 0)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
                  }
                  else
                  {
                     if(_loc2_.AgilityCompose == COMPOSE_TOP && _loc2_.DefendCompose == COMPOSE_TOP && _loc2_.AttackCompose == COMPOSE_TOP && _loc2_.LuckCompose == COMPOSE_TOP)
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.ComposeItemCell.up"));
                        return;
                     }
                     if(param1.info.CanCompose)
                     {
                        SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,_loc3_.index,_loc2_.Count,true);
                        DragManager.acceptDrag(_loc3_,DragEffect.NONE);
                        return;
                     }
                  }
               }
            }
         }
         if(EquipType.isComposeStone(_loc2_) || _loc2_.CategoryID == 11 && _loc2_.Property1 == StoneType.SOULSYMBOL || _loc2_.CategoryID == 11 && _loc2_.Property1 == StoneType.LUCKY)
         {
            for each(_loc3_ in this._items)
            {
               if(_loc3_ is StoneCell && (_loc3_ as StoneCell).types.indexOf(_loc2_.Property1) > -1 && _loc2_.CategoryID == 11)
               {
                  SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,_loc3_.index,_loc2_.Count,true);
                  DragManager.acceptDrag(_loc3_,DragEffect.NONE);
                  return;
               }
            }
         }
      }
      
      public function startShine(param1:int) : void
      {
         if(param1 != 3)
         {
            this._items[param1].startShine();
         }
      }
      
      public function refreshData(param1:Dictionary) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         for(_loc2_ in param1)
         {
            _loc3_ = int(_loc2_);
            if(_loc3_ < this._items.length)
            {
               this._items[_loc3_].info = PlayerManager.Instance.Self.StoreBag.items[_loc3_];
            }
         }
      }
      
      public function updateData() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this._items[_loc1_].info = PlayerManager.Instance.Self.StoreBag.items[_loc1_];
            _loc1_++;
         }
      }
      
      public function stopShine() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this._items[_loc1_].stopShine();
            _loc1_++;
         }
      }
      
      private function initEvent() : void
      {
         this._compose_btn.addEventListener(MouseEvent.CLICK,this.__composeClick);
         this._composeHelp.addEventListener(MouseEvent.CLICK,this.__openHelp);
         this._buyStoneBtn.addEventListener(MouseEvent.CLICK,this.__buyStone);
         ConsortiaRateManager.instance.addEventListener(ConsortiaRateManager.CHANGE_CONSORTIA,this._consortiaLoadComplete);
      }
      
      private function userGuide() : void
      {
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUIDE_COMPOSE) && TaskManager.isAchieved(TaskManager.getQuestByID(346)))
         {
            NewHandQueue.Instance.push(new Step(Step.COMPOSE_WEAPON_TIP,this.exeWeaponTip,this.preWeaponTip,this.finWeaponTip));
            NewHandQueue.Instance.push(new Step(Step.COMPOSE_STONE_TIP,this.exeStoneTip,this.preStoneTip,this.finStoneTip));
         }
      }
      
      private function preWeaponTip() : void
      {
         NewHandContainer.Instance.showArrow(ArrowType.COM_WEAPON,0,"trainer.comWeaponArrowPos","asset.trainer.txtWeaponTip","trainer.comWeaponTipPos");
      }
      
      private function exeWeaponTip() : Boolean
      {
         return this._items[1].info;
      }
      
      private function finWeaponTip() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.COM_WEAPON);
      }
      
      private function preStoneTip() : void
      {
         NewHandContainer.Instance.showArrow(ArrowType.COM_WEAPON,45,"trainer.comStoneArrowPos","asset.trainer.txtComStoneTip","trainer.comStoneTipPos");
      }
      
      private function exeStoneTip() : Boolean
      {
         return this._items[2].info;
      }
      
      private function finStoneTip() : void
      {
         this.disposeUserGuide();
      }
      
      private function disposeUserGuide() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.COM_WEAPON);
         NewHandQueue.Instance.dispose();
      }
      
      private function __buyStone(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(ShopManager.Instance.getMoneyShopItemByTemplateID(ITEMS[0]).getItemPrice(1).moneyValue > PlayerManager.Instance.Self.Money)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         var _loc2_:ShortcutBuyFrame = ComponentFactory.Instance.creatCustomObject("store.ShortcutBuyFrame");
         _loc2_.show(ITEMS,false,LanguageMgr.GetTranslation("store.view.Compose.buyCompose"),2);
      }
      
      private function showArr() : void
      {
         this.cpsArr.visible = true;
         this._cpsShine.movie.play();
      }
      
      private function hideArr() : void
      {
         this.cpsArr.visible = false;
         this._cpsShine.movie.gotoAndStop(1);
      }
      
      public function get area() : Array
      {
         return this._items;
      }
      
      private function __composeClick(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         param1.stopImmediatePropagation();
         SoundManager.instance.play("008");
         if(this._showDontClickTip())
         {
            return;
         }
         if(this.checkTipBindType())
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.StoreIIComposeBG.use"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
            _loc2_.addEventListener(FrameEvent.RESPONSE,this._responseI);
         }
         else
         {
            this.hideArr();
            this.sendSocket();
         }
      }
      
      private function _responseV(param1:FrameEvent) : void
      {
         var _loc2_:QuickBuyFrame = null;
         SoundManager.instance.play("008");
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseV);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("core.QuickFrame");
            _loc2_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            _loc2_.itemID = EquipType.GOLD_BOX;
            LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function _responseI(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = BaseAlerFrame(param1.currentTarget);
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.sendSocket();
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function sendSocket() : void
      {
         var _loc1_:Boolean = false;
         if(PlayerManager.Instance.Self.ConsortiaID != 0 && ConsortiaRateManager.instance.rate > 0)
         {
            _loc1_ = true;
         }
         SocketManager.Instance.out.sendItemCompose(_loc1_);
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUIDE_COMPOSE))
         {
            SocketManager.Instance.out.syncWeakStep(Step.GUIDE_COMPOSE);
         }
      }
      
      private function checkTipBindType() : Boolean
      {
         if(this._items[1].itemInfo && this._items[1].itemInfo.IsBinds)
         {
            return false;
         }
         if(this._items[0].itemInfo && this._items[0].itemInfo.IsBinds)
         {
            return true;
         }
         if(this._items[2].itemInfo && this._items[2].itemInfo.IsBinds)
         {
            return true;
         }
         return false;
      }
      
      private function __itemInfoChange(param1:Event) : void
      {
         if(this.getCountRate() > 0)
         {
         }
         this.getCountRateI();
         if(this._items[1].info == null || this._items[2].info == null)
         {
            this.hideArr();
         }
         else
         {
            this.showArr();
         }
      }
      
      private function _showDontClickTip() : Boolean
      {
         if(this._items[1].info == null && this._items[2].info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.compose.dontCompose"));
            return true;
         }
         if(this._items[1].info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.compose.dontComposeI"));
            return true;
         }
         if(this._items[2].info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.compose.dontComposeII"));
            return true;
         }
         return false;
      }
      
      private function getCountRate() : Number
      {
         var _loc1_:Number = 0;
         if(this._items[1] == null || this._items[1].info == null)
         {
            return _loc1_;
         }
         if(this._items[2] != null && this._items[2].info != null)
         {
            _loc1_ = this.composeRate[this._items[2].info.Quality - 1] * 100;
         }
         if(_loc1_ > 0 && this._items[0] != null && this._items[0].info != null)
         {
            _loc1_ = (1 + this._items[0].info.Property2 / 100) * _loc1_;
         }
         _loc1_ *= 1 + 0.1 * ConsortiaRateManager.instance.rate;
         _loc1_ = Math.floor(_loc1_ * 10) / 10;
         return Number(_loc1_ > 100 ? Number(Number(100)) : Number(Number(_loc1_)));
      }
      
      private function getCountRateI() : void
      {
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         if(this._items[1] == null || this._items[1].info == null)
         {
            this._showSuccessRate.showAllNum(_loc1_,_loc2_,_loc3_,_loc4_);
            return;
         }
         if(this._items[2] != null && this._items[2].info != null)
         {
            _loc1_ = this.composeRate[this._items[2].info.Quality - 1] * 100;
         }
         if(_loc1_ > 0 && this._items[0] != null && this._items[0].info != null)
         {
            _loc2_ = this._items[0].info.Property2 / 100 * _loc1_;
         }
         _loc3_ = _loc1_ * (0.1 * ConsortiaRateManager.instance.rate);
         _loc4_ = _loc1_ + _loc2_ + _loc3_;
         _loc1_ = Math.floor(_loc1_ * 10) / 10;
         _loc2_ = Math.floor(_loc2_ * 10) / 10;
         _loc3_ = Math.floor(_loc3_ * 10) / 10;
         _loc4_ = Math.floor(_loc4_ * 10) / 10;
         _loc1_ = _loc1_ > 100 ? Number(Number(100)) : Number(Number(_loc1_));
         _loc2_ = _loc2_ > 100 ? Number(Number(100)) : Number(Number(_loc2_));
         _loc3_ = _loc3_ > 100 ? Number(Number(100)) : Number(Number(_loc3_));
         _loc4_ = _loc4_ > 100 ? Number(Number(100)) : Number(Number(_loc4_));
         this._showSuccessRate.showAllNum(_loc1_,_loc2_,_loc3_,_loc4_);
      }
      
      public function consortiaRate() : void
      {
         ConsortiaRateManager.instance.reset();
      }
      
      private function _consortiaLoadComplete(param1:Event) : void
      {
         this.__itemInfoChange(null);
      }
      
      public function show() : void
      {
         this.visible = true;
         this._consortiaLoadComplete(null);
         this.consortiaRate();
         this.updateData();
         if(WeakGuildManager.Instance.switchUserGuide)
         {
            this.userGuide();
         }
      }
      
      public function hide() : void
      {
         this.visible = false;
         this.disposeUserGuide();
      }
      
      private function __openHelp(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         var _loc2_:HelpPrompt = ComponentFactory.Instance.creat("store.composeHelp");
         var _loc3_:HelpFrame = ComponentFactory.Instance.creat("store.helpFrame");
         _loc3_.setView(_loc2_);
         _loc3_.titleText = LanguageMgr.GetTranslation("store.StoreIIComposeBG.say");
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function dispose() : void
      {
         this.disposeUserGuide();
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            this._items[_loc1_].removeEventListener(Event.CHANGE,this.__itemInfoChange);
            this._items[_loc1_].dispose();
            this._items[_loc1_] = null;
            _loc1_++;
         }
         this._items = null;
         this._compose_btn.removeEventListener(MouseEvent.CLICK,this.__composeClick);
         this._composeHelp.removeEventListener(MouseEvent.CLICK,this.__openHelp);
         ConsortiaRateManager.instance.removeEventListener(ConsortiaRateManager.CHANGE_CONSORTIA,this._consortiaLoadComplete);
         if(this._area)
         {
            this._area.dispose();
         }
         this._area = null;
         this._pointArray = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._compose_btn)
         {
            ObjectUtils.disposeObject(this._compose_btn);
         }
         this._compose_btn = null;
         if(this._composeHelp)
         {
            ObjectUtils.disposeObject(this._composeHelp);
         }
         this._composeHelp = null;
         if(this._cpsShine)
         {
            ObjectUtils.disposeObject(this._cpsShine);
         }
         this._cpsShine = null;
         if(this.cpsArr)
         {
            ObjectUtils.disposeObject(this.cpsArr);
         }
         this.cpsArr = null;
         if(this._cBuyluckyBtn)
         {
            ObjectUtils.disposeObject(this._cBuyluckyBtn);
         }
         this._cBuyluckyBtn = null;
         if(this._buyStoneBtn)
         {
            ObjectUtils.disposeObject(this._buyStoneBtn);
         }
         this._buyStoneBtn = null;
         if(this._consortiaSmith)
         {
            ObjectUtils.disposeObject(this._consortiaSmith);
         }
         this._consortiaSmith = null;
         if(this._consortiaSmith)
         {
            ObjectUtils.disposeObject(this._consortiaSmith);
         }
         this._consortiaSmith = null;
         if(this._showSuccessRate)
         {
            ObjectUtils.disposeObject(this._showSuccessRate);
         }
         this._showSuccessRate = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}

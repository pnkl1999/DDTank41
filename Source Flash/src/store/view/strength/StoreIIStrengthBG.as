package store.view.strength
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.bagStore.BagStore;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.StoneType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.common.BuyItemButton;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import store.HelpFrame;
   import store.IStoreViewBG;
   import store.ShowSuccessRate;
   import store.StoneCell;
   import store.StoreCell;
   import store.StoreDragInArea;
   import store.analyze.StrengthenLevelIIAnalyzer;
   import store.view.ConsortiaRateManager;
   import trainer.controller.NewHandQueue;
   import trainer.controller.WeakGuildManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   import vip.VipController;
   
   public class StoreIIStrengthBG extends Sprite implements IStoreViewBG
   {
       
      
      private var _area:StoreDragInArea;
      
      private var _items:Array;
      
      private var _rateList1:Dictionary;
      
      private var _rateList2:Dictionary;
      
      private var _rateList3:Dictionary;
      
      private var _rateList4:Dictionary;
      
      private var _strength_btn:BaseButton;
      
      private var _strengHelp:BaseButton;
      
      private var _bg:MutipleImage;
      
      private var _gold_txt:FilterFrameText;
      
      private var _pointArray:Vector.<Point>;
      
      private var _strthShine:MovieImage;
      
      private var _startStrthTip:MutipleImage;
      
      private var _consortiaSmith:MySmithLevel;
      
      private var _sBuyLucky:BuyItemButton;
      
      private var _sBuyHierogram:BuyItemButton;
      
      private var _sBuyStrengthStoneCell:BuyItemButton;
      
      private var _sBuyGiftBag:BuyGiftBagButton;
      
      private var _spellAlertFrame:SpellAlertFrame;
      
      private var _lastStrengthTime:int = 0;
      
      private var _showSuccessRate:ShowSuccessRate;
      
      private var rateItems:Array;
      
      public function StoreIIStrengthBG()
      {
         this.rateItems = [0.75,3,12,48,240,768];
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         var _loc7_:StoreCell = null;
         var _loc1_:int = 0;
         _loc7_ = null;
         this._items = new Array();
         this._area = new StoreDragInArea(this._items);
         addChildAt(this._area,0);
         this._bg = ComponentFactory.Instance.creatComponentByStylename("store.StrengthBG");
         addChild(this._bg);
         this._strength_btn = ComponentFactory.Instance.creatComponentByStylename("store.StrengthBtn");
         addChild(this._strength_btn);
         this._strthShine = ComponentFactory.Instance.creatComponentByStylename("store.StrengthButtonShine");
         this._strthShine.mouseEnabled = false;
         this._strthShine.mouseChildren = false;
         addChild(this._strthShine);
         this._startStrthTip = ComponentFactory.Instance.creatComponentByStylename("store.ArrowHeadTip");
         addChild(this._startStrthTip);
         this._strengHelp = ComponentFactory.Instance.creatComponentByStylename("store.StrengthNodeBtn");
         addChild(this._strengHelp);
         this.getCellsPoint();
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            if(_loc1_ == 0 || _loc1_ == 1 || _loc1_ == 2)
            {
               _loc7_ = new StrengthStone([StoneType.STRENGTH,StoneType.STRENGTH_1],_loc1_);
            }
            else if(_loc1_ == 4)
            {
               _loc7_ = new StoneCell([StoneType.LUCKY],_loc1_);
            }
            else if(_loc1_ == 3)
            {
               _loc7_ = new StoneCell([StoneType.SOULSYMBOL],_loc1_);
            }
            else if(_loc1_ == 5)
            {
               _loc7_ = new StreangthItemCell(_loc1_);
            }
            _loc7_.addEventListener(Event.CHANGE,this.__itemInfoChange);
            _loc7_.x = this._pointArray[_loc1_].x;
            _loc7_.y = this._pointArray[_loc1_].y;
            addChild(_loc7_);
            this._items.push(_loc7_);
            _loc1_++;
         }
         this._sBuyLucky = ComponentFactory.Instance.creat("store.BuyLuckyBtn");
         this._sBuyLucky.setup(EquipType.LUCKY,1,true);
         addChild(this._sBuyLucky);
         this._sBuyHierogram = ComponentFactory.Instance.creat("store.BuyHierogramBtn");
         this._sBuyHierogram.setup(EquipType.SYMBLE,1,true);
         addChild(this._sBuyHierogram);
         this._sBuyStrengthStoneCell = ComponentFactory.Instance.creat("store.BuyStoneBtn");
         this._sBuyStrengthStoneCell.setup(EquipType.STRENGTH_STONE4,1,true);
         addChild(this._sBuyStrengthStoneCell);
         this._sBuyGiftBag = ComponentFactory.Instance.creat("store.BuyGiftBagBtn");
         this._sBuyGiftBag.tipData = this.getGiftBagTipInfo();
         addChild(this._sBuyGiftBag);
         this._consortiaSmith = ComponentFactory.Instance.creatCustomObject("store.MySmithLevel");
         addChild(this._consortiaSmith);
         this.hide();
         this.hideArr();
         if(BagStore.instance.controllerInstance.Model.rateList1 == null)
         {
            this.loadStrengthenLevel();
         }
         else
         {
            this._rateList1 = BagStore.instance.controllerInstance.Model.rateList1;
            this._rateList2 = BagStore.instance.controllerInstance.Model.rateList2;
            this._rateList3 = BagStore.instance.controllerInstance.Model.rateList3;
            this._rateList4 = BagStore.instance.controllerInstance.Model.rateList4;
         }
         this._showSuccessRate = ComponentFactory.Instance.creatCustomObject("store.ShowSuccessRate");
         this._showSuccessRate.showVIPRate();
         var _loc2_:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.StrengthenStonStrip");
         var _loc3_:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.LuckSignStrip");
         var _loc4_:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.ConsortiaAddStrip");
         var _loc5_:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.VIPAddStrip");
         var _loc6_:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.AllNumStrip");
         if(PlayerManager.Instance.Self.ConsortiaID == 0)
         {
            _loc4_ = LanguageMgr.GetTranslation("tank.view.store.consortiaRateI");
         }
         if(!PlayerManager.Instance.Self.IsVIP)
         {
            _loc5_ = LanguageMgr.GetTranslation("store.StoreIIComposeBG.NoVIPAddStrip");
         }
         this._showSuccessRate.showAllTips(_loc2_,_loc3_,_loc4_,_loc6_);
         this._showSuccessRate.showVIPTip(_loc5_);
         addChild(this._showSuccessRate);
      }
      
      private function initEvent() : void
      {
         this._strength_btn.addEventListener(MouseEvent.CLICK,this.__strengthClick);
         this._strengHelp.addEventListener(MouseEvent.CLICK,this.__openHelp);
         ConsortiaRateManager.instance.addEventListener(ConsortiaRateManager.CHANGE_CONSORTIA,this._consortiaLoadComplete);
      }
      
      private function removeEvents() : void
      {
         this._strength_btn.removeEventListener(MouseEvent.CLICK,this.__strengthClick);
         this._strengHelp.removeEventListener(MouseEvent.CLICK,this.__openHelp);
         ConsortiaRateManager.instance.removeEventListener(ConsortiaRateManager.CHANGE_CONSORTIA,this._consortiaLoadComplete);
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            this._items[_loc1_].removeEventListener(Event.CHANGE,this.__itemInfoChange);
            _loc1_++;
         }
      }
      
      private function userGuide() : void
      {
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUIDE_STRENGTH) && PlayerManager.Instance.Self.Grade >= 8)
         {
            NewHandQueue.Instance.push(new Step(Step.STRENGTH_WEAPON_TIP,this.exeWeaponTip,this.preWeaponTip,this.finWeaponTip));
            NewHandQueue.Instance.push(new Step(Step.STRENGTH_STONE_TIP,this.exeStoneTip,this.preStoneTip,this.finStoneTip));
         }
      }
      
      private function preWeaponTip() : void
      {
         NewHandContainer.Instance.showArrow(ArrowType.STR_WEAPON,0,"trainer.strWeaponArrowPos","asset.trainer.txtWeaponTip","trainer.strWeaponTipPos");
      }
      
      private function exeWeaponTip() : Boolean
      {
         return this._items[5].info;
      }
      
      private function finWeaponTip() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
      }
      
      private function preStoneTip() : void
      {
         NewHandContainer.Instance.showArrow(ArrowType.STR_WEAPON,45,"trainer.strStoneArrowPos","asset.trainer.txtStoneTip","trainer.strStoneTipPos");
      }
      
      private function exeStoneTip() : Boolean
      {
         return this._items[0].info || this._items[1].info || this._items[2].info;
      }
      
      private function finStoneTip() : void
      {
         this.disposeUserGuide();
      }
      
      private function disposeUserGuide() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
         NewHandQueue.Instance.dispose();
      }
      
      private function getCellsPoint() : void
      {
         var _loc2_:Point = null;
         this._pointArray = new Vector.<Point>();
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("store.Strengthpoint" + _loc1_);
            this._pointArray.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function getGiftBagTipInfo() : GoodTipInfo
      {
         var _loc1_:ItemTemplateInfo = new ItemTemplateInfo();
         _loc1_.Name = LanguageMgr.GetTranslation("tank.view.common.BuyGiftBagButton.initliziItemTemplate.excellent");
         _loc1_.Quality = 4;
         _loc1_.TemplateID = 2;
         _loc1_.CategoryID = 11;
         _loc1_.Description = LanguageMgr.GetTranslation("tank.view.common.BuyGiftBagButton.initliziItemTemplate.info");
         var _loc2_:GoodTipInfo = new GoodTipInfo();
         _loc2_.itemInfo = _loc1_;
         _loc2_.isBalanceTip = false;
         _loc2_.typeIsSecond = false;
         return _loc2_;
      }
      
      private function loadStrengthenLevel() : void
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ItemStrengthenList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("store.view.fusion.LoadStrengthenListError");
         _loc1_.analyzer = new StrengthenLevelIIAnalyzer(this.__searchResult);
         LoaderManager.Instance.startLoad(_loc1_);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
      }
      
      private function __searchResult(param1:StrengthenLevelIIAnalyzer) : void
      {
         this._rateList1 = BagStore.instance.controllerInstance.Model.rateList1 = param1.LevelItems1;
         this._rateList2 = BagStore.instance.controllerInstance.Model.rateList2 = param1.LevelItems2;
         this._rateList3 = BagStore.instance.controllerInstance.Model.rateList3 = param1.LevelItems3;
         this._rateList4 = BagStore.instance.controllerInstance.Model.rateList4 = param1.LevelItems4;
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:String = param1.loader.loadErrorMessage;
         if(param1.loader.analyzer)
         {
            _loc2_ = param1.loader.loadErrorMessage + "\n" + param1.loader.analyzer.message;
         }
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),param1.loader.loadErrorMessage,LanguageMgr.GetTranslation("tank.view.bagII.baglocked.sure"));
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         param1.currentTarget.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      public function get area() : Array
      {
         return this._items;
      }
      
      private function isAdaptToItem(param1:InventoryItemInfo) : Boolean
      {
         if(param1.Property1 == StoneType.SOULSYMBOL || param1.Property1 == StoneType.LUCKY)
         {
            return true;
         }
         if(this._items[5].info == null)
         {
            return true;
         }
         if(this._items[5].info.RefineryLevel > 0)
         {
            if(param1.Property1 == "35")
            {
               return true;
            }
            return false;
         }
         if(param1.Property1 == "35")
         {
            return false;
         }
         return true;
      }
      
      private function isAdaptToStone(param1:InventoryItemInfo) : Boolean
      {
         if(param1.Property1 == StoneType.SOULSYMBOL || param1.Property1 == StoneType.LUCKY)
         {
            return true;
         }
         if(this._items[0].info != null && this._items[0].info.Property1 != param1.Property1)
         {
            return false;
         }
         if(this._items[1].info != null && this._items[1].info.Property1 != param1.Property1)
         {
            return false;
         }
         if(this._items[2].info != null && this._items[2].info.Property1 != param1.Property1)
         {
            return false;
         }
         return true;
      }
      
      private function itemIsAdaptToStone(param1:InventoryItemInfo) : Boolean
      {
         if(param1.RefineryLevel > 0)
         {
            if(this._items[0].info != null && this._items[0].info.Property1 != "35")
            {
               return false;
            }
            if(this._items[1].info != null && this._items[1].info.Property1 != "35")
            {
               return false;
            }
            if(this._items[2].info != null && this._items[2].info.Property1 != "35")
            {
               return false;
            }
            return true;
         }
         if(this._items[0].info != null && this._items[0].info.Property1 == "35")
         {
            return false;
         }
         if(this._items[1].info != null && this._items[1].info.Property1 == "35")
         {
            return false;
         }
         if(this._items[2].info != null && this._items[2].info.Property1 == "35")
         {
            return false;
         }
         return true;
      }
      
      public function dragDrop(param1:BagCell) : void
      {
         var _loc3_:StoreCell = null;
         var _loc4_:BaseAlerFrame = null;
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
                        if(this.isAdaptToStone(_loc2_))
                        {
                           SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,_loc3_.index,1);
                           DragManager.acceptDrag(_loc3_,DragEffect.NONE);
                           return;
                        }
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.typeUnpare"));
                     }
                  }
               }
               else if(_loc3_ is StreangthItemCell)
               {
                  if(_loc2_.getRemainDate() <= 0)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
                  }
                  else
                  {
                     if(_loc2_.StrengthenLevel >= PathManager.solveStrengthMax())
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StrengthItemCell.up"));
                        return;
                     }
                     if(param1.info.CanStrengthen)
                     {
                        if(_loc2_.StrengthenLevel == 9 && !SharedManager.Instance.isAffirm)
                        {
                           SharedManager.Instance.isAffirm = true;
                           SharedManager.Instance.save();
                           _loc4_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.game.GameViewBase.HintTitle"),LanguageMgr.GetTranslation("store.view.strength.clew"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
                           _loc4_.info.showCancel = false;
                           _loc4_.addEventListener(FrameEvent.RESPONSE,this._responseII);
                        }
                        SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,_loc3_.index,1);
                        DragManager.acceptDrag(_loc3_,DragEffect.NONE);
                        return;
                     }
                  }
               }
            }
         }
         if(EquipType.isStrengthStone(_loc2_) || _loc2_.CategoryID == 11 && _loc2_.Property1 == StoneType.SOULSYMBOL || _loc2_.CategoryID == 11 && _loc2_.Property1 == StoneType.LUCKY)
         {
            for each(_loc3_ in this._items)
            {
               if(_loc3_ is StoneCell && (_loc3_ as StoneCell).types.indexOf(_loc2_.Property1) > -1 && _loc2_.CategoryID == 11)
               {
                  if(this.isAdaptToStone(_loc2_))
                  {
                     SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,_loc3_.index,1);
                     DragManager.acceptDrag(_loc3_,DragEffect.NONE);
                     return;
                  }
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.typeUnpare"));
               }
            }
         }
      }
      
      private function _responseII(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this._responseII);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function showArr() : void
      {
         this._startStrthTip.visible = true;
         this._strthShine.movie.play();
      }
      
      private function hideArr() : void
      {
         this._startStrthTip.visible = false;
         this._strthShine.movie.gotoAndStop(1);
      }
      
      public function refreshData(param1:Dictionary) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         for(_loc2_ in param1)
         {
            _loc3_ = int(_loc2_);
            if(this._items.hasOwnProperty(_loc3_))
            {
               this._items[_loc3_].info = PlayerManager.Instance.Self.StoreBag.items[_loc3_];
            }
         }
      }
      
      public function updateData() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            this._items[_loc1_].info = PlayerManager.Instance.Self.StoreBag.items[_loc1_];
            _loc1_++;
         }
      }
      
      public function startShine(param1:int) : void
      {
         this._items[param1].startShine();
      }
      
      public function stopShine() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            this._items[_loc1_].stopShine();
            _loc1_++;
         }
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
      
      private function __strengthClick(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         var _loc3_:BaseAlerFrame = null;
         param1.stopImmediatePropagation();
         SoundManager.instance.play("008");
         if(this._showDontClickTip())
         {
            return;
         }
         if(this._items[5].info != null)
         {
            if(this._items[5].itemInfo.StrengthenLevel >= PathManager.solveStrengthMax())
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StrengthItemCell.up"));
               return;
            }
            if(this._items[5].itemInfo.StrengthenLevel == 5)
            {
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.view.strength.FiveLevelTip"),LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc2_.moveEnable = false;
               _loc2_.addEventListener(FrameEvent.RESPONSE,this.__fiveLevelResponse);
               return;
            }
            if(this._items[5].itemInfo.StrengthenLevel > 5 && this._items[3].info == null)
            {
               this._spellAlertFrame = ComponentFactory.Instance.creatComponentByStylename("store.view.strength.spellAlertFrame");
               this._spellAlertFrame.show();
               this._spellAlertFrame.addEventListener(SpellAlertFrame.CLOSE,this.__spellAlertClose);
               this._spellAlertFrame.addEventListener(SpellAlertFrame.SUBMIT,this.__spellAlertSubmit);
               return;
            }
         }
         if(this.checkTipBindType())
         {
            _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.StoreIIStrengthBG.use"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc3_.moveEnable = false;
            _loc3_.info.enableHtml = true;
            _loc3_.info.mutiline = true;
            _loc3_.addEventListener(FrameEvent.RESPONSE,this._bingResponse);
         }
         else
         {
            this.sendSocket();
         }
      }
      
      private function __spellAlertSubmit(param1:Event) : void
      {
         var _loc2_:BaseAlerFrame = null;
         this.hideSpellAlertFrame();
         if(this.checkTipBindType())
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.StoreIIStrengthBG.use"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc2_.moveEnable = false;
            _loc2_.info.enableHtml = true;
            _loc2_.info.mutiline = true;
            _loc2_.addEventListener(FrameEvent.RESPONSE,this._bingResponse);
            return;
         }
         this.sendSocket();
      }
      
      private function __spellAlertClose(param1:Event) : void
      {
         this.hideSpellAlertFrame();
      }
      
      private function hideSpellAlertFrame() : void
      {
         this._spellAlertFrame.removeEventListener(SpellAlertFrame.CLOSE,this.__spellAlertClose);
         this._spellAlertFrame.removeEventListener(SpellAlertFrame.SUBMIT,this.__spellAlertSubmit);
         this._spellAlertFrame.dispose();
         this._spellAlertFrame = null;
      }
      
      private function _responseV(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseV);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.okFastPurchaseGold();
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function okFastPurchaseGold() : void
      {
         var _loc1_:QuickBuyFrame = ComponentFactory.Instance.creatCustomObject("core.QuickFrame");
         _loc1_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         _loc1_.itemID = EquipType.GOLD_BOX;
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __fiveLevelResponse(param1:FrameEvent) : void
      {
         var _loc3_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__fiveLevelResponse);
         ObjectUtils.disposeObject(param1.target);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(this._items[5].itemInfo.StrengthenLevel >= 5 && this._items[3].info == null)
            {
               this._spellAlertFrame = ComponentFactory.Instance.creatComponentByStylename("store.view.strength.spellAlertFrame");
               this._spellAlertFrame.show();
               this._spellAlertFrame.addEventListener(SpellAlertFrame.CLOSE,this.__spellAlertClose);
               this._spellAlertFrame.addEventListener(SpellAlertFrame.SUBMIT,this.__spellAlertSubmit);
               return;
            }
            if(this.checkTipBindType())
            {
               _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.StoreIIStrengthBG.use"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc3_.moveEnable = false;
               _loc3_.info.enableHtml = true;
               _loc3_.info.mutiline = true;
               _loc3_.addEventListener(FrameEvent.RESPONSE,this._bingResponse);
            }
            else
            {
               this.sendSocket();
            }
         }
      }
      
      private function __graceResponse(param1:FrameEvent) : void
      {
         var _loc3_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__graceResponse);
         ObjectUtils.disposeObject(param1.target);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(this.checkTipBindType())
            {
               _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.StoreIIStrengthBG.use"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc3_.moveEnable = false;
               _loc3_.info.enableHtml = true;
               _loc3_.info.mutiline = true;
               _loc3_.addEventListener(FrameEvent.RESPONSE,this._bingResponse);
               return;
            }
            this.sendSocket();
         }
      }
      
      private function _bingResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this._bingResponse);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.sendSocket();
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function sendSocket() : void
      {
         if(!this.checkLevel())
         {
            return;
         }
         var _loc1_:Boolean = false;
         if(PlayerManager.Instance.Self.ConsortiaID != 0 && ConsortiaRateManager.instance.rate > 0)
         {
            _loc1_ = true;
         }
         var _loc2_:int = getTimer();
         if(_loc2_ - this._lastStrengthTime > 500)
         {
            SocketManager.Instance.out.sendItemStrength(_loc1_);
            this._lastStrengthTime = _loc2_;
            if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUIDE_STRENGTH))
            {
               SocketManager.Instance.out.syncWeakStep(Step.GUIDE_STRENGTH);
            }
         }
      }
      
      private function checkTipBindType() : Boolean
      {
         if(this._items[5].itemInfo && this._items[5].itemInfo.IsBinds)
         {
            return false;
         }
         if(this._items[0].itemInfo && this._items[0].itemInfo.IsBinds)
         {
            return true;
         }
         if(this._items[3].itemInfo && this._items[3].itemInfo.IsBinds)
         {
            return true;
         }
         if(this._items[4].itemInfo && this._items[4].itemInfo.IsBinds)
         {
            return true;
         }
         if(this._items[1].itemInfo && this._items[1].itemInfo.IsBinds)
         {
            return true;
         }
         if(this._items[2].itemInfo && this._items[2].itemInfo.IsBinds)
         {
            return true;
         }
         return false;
      }
      
      private function checkLevel() : Boolean
      {
         var _loc1_:StreangthItemCell = this._items[5] as StreangthItemCell;
         var _loc2_:InventoryItemInfo = _loc1_.info as InventoryItemInfo;
         if(_loc2_ && _loc2_.StrengthenLevel >= PathManager.solveStrengthMax())
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StrengthItemCell.up"));
            return false;
         }
         return true;
      }
      
      private function __itemInfoChange(param1:Event) : void
      {
         if(param1.currentTarget is StreangthItemCell)
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
         this.getCountRateI();
         var _loc2_:int = 0;
         if(this._items[0].info != null)
         {
            _loc2_++;
            this._items[1].stoneType = this._items[0].stoneType;
            this._items[2].stoneType = this._items[0].stoneType;
            this._items[5].stoneType = this._items[0].stoneType;
         }
         if(this._items[1].info != null)
         {
            _loc2_++;
            this._items[0].stoneType = this._items[1].stoneType;
            this._items[2].stoneType = this._items[1].stoneType;
            this._items[5].stoneType = this._items[1].stoneType;
         }
         if(this._items[2].info != null)
         {
            _loc2_++;
            this._items[0].stoneType = this._items[2].stoneType;
            this._items[1].stoneType = this._items[2].stoneType;
            this._items[5].stoneType = this._items[2].stoneType;
         }
         if(_loc2_ == 0)
         {
            this._items[0].stoneType = this._items[1].stoneType = this._items[2].stoneType = this._items[5].stoneType = "";
         }
         if(this._items[5].info == null)
         {
            this._items[0].itemType = this._items[1].itemType = this._items[2].itemType = -1;
         }
         else
         {
            this._items[0].itemType = this._items[1].itemType = this._items[2].itemType = this._items[5].info.RefineryLevel;
         }
         if(this._items[5].info == null || _loc2_ == 0 || this._items[5].itemInfo.StrengthenLevel >= 9 && this._items[3].info == null)
         {
            this.hideArr();
            return;
         }
         this.showArr();
         _loc2_ == 0;
      }
      
      private function _showDontClickTip() : Boolean
      {
         if(this._items[5].info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.strength.dontStrengthI"));
            return true;
         }
         if(this._items[0].info == null && this._items[1].info == null && this._items[2].info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.strength.dontStrengthII"));
            return true;
         }
         if(this._items[5].itemInfo.StrengthenLevel >= 9 && this._items[3].info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.strength.dontStrengthIII"));
            return true;
         }
         return false;
      }
      
      private function getCountRate() : Number
      {
         var _loc1_:Number = 0;
         if(this._items[5] == null || this._items[5].info == null || this._rateList1 == null)
         {
            return _loc1_;
         }
         if(this._items[0].info != null)
         {
            _loc1_ += this.rateItems[this._items[0].info.Level - 1];
         }
         if(this._items[1].info != null)
         {
            _loc1_ += this.rateItems[this._items[1].info.Level - 1];
         }
         if(this._items[2].info != null)
         {
            _loc1_ += this.rateItems[this._items[2].info.Level - 1];
         }
         if(this._items[4].info != null)
         {
            _loc1_ += _loc1_ * this._items[4].info.Property2 / 100;
         }
         _loc1_ = _loc1_ * 100 / this.getNeedRate();
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
         var _loc5_:Number = 0;
         if(this._items[5] == null || this._items[5].info == null || this._rateList1 == null)
         {
            this._showSuccessRate.showAllNum(_loc1_,_loc2_,_loc3_,_loc4_);
            this._showSuccessRate.showVIPNum(_loc5_);
            return;
         }
         if(this._items[0].info != null)
         {
            _loc1_ += this.rateItems[this._items[0].info.Level - 1];
         }
         if(this._items[1].info != null)
         {
            _loc1_ += this.rateItems[this._items[1].info.Level - 1];
         }
         if(this._items[2].info != null)
         {
            _loc1_ += this.rateItems[this._items[2].info.Level - 1];
         }
         if(this._items[4].info != null)
         {
            _loc2_ += _loc1_ * this._items[4].info.Property2 / 100;
         }
         _loc1_ = _loc1_ * 100 / this.getNeedRate();
         _loc2_ = _loc2_ * 100 / this.getNeedRate();
         _loc3_ = _loc1_ * (0.1 * ConsortiaRateManager.instance.rate);
         if(PlayerManager.Instance.Self.IsVIP)
         {
            _loc5_ = VipController.VIPStrengthenEx * _loc1_;
         }
         _loc4_ = _loc1_ + _loc2_ + _loc3_ + _loc5_;
         _loc1_ = Math.floor(_loc1_ * 10) / 10;
         _loc2_ = Math.floor(_loc2_ * 10) / 10;
         _loc3_ = Math.floor(_loc3_ * 10) / 10;
         _loc5_ = Math.floor(_loc5_ * 10) / 10;
         _loc4_ = Math.floor(_loc4_ * 10) / 10;
         _loc1_ = _loc1_ > 100 ? Number(Number(100)) : Number(Number(_loc1_));
         _loc2_ = _loc2_ > 100 ? Number(Number(100)) : Number(Number(_loc2_));
         _loc3_ = _loc3_ > 100 ? Number(Number(100)) : Number(Number(_loc3_));
         _loc5_ = _loc5_ > 100 ? Number(Number(100)) : Number(Number(_loc5_));
         _loc4_ = _loc4_ > 100 ? Number(Number(100)) : Number(Number(_loc4_));
         this._showSuccessRate.showAllNum(_loc1_,_loc2_,_loc3_,_loc4_);
         this._showSuccessRate.showVIPNum(_loc5_);
      }
      
      private function getNeedRate() : Number
      {
         if(this._rateList1[this._items[5].info.StrengthenLevel + 1] == null)
         {
            return 0;
         }
         var _loc1_:int = (this._items[5].info as InventoryItemInfo).CategoryID;
         switch(_loc1_)
         {
            case EquipType.ARM:
               return Number(this._rateList1[this._items[5].info.StrengthenLevel + 1]);
            case EquipType.HEAD:
               return Number(this._rateList2[this._items[5].info.StrengthenLevel + 1]);
            case EquipType.CLOTH:
               return Number(this._rateList3[this._items[5].info.StrengthenLevel + 1]);
            case EquipType.OFFHAND:
               return Number(this._rateList4[this._items[5].info.StrengthenLevel + 1]);
            default:
               return 0;
         }
      }
      
      public function consortiaRate() : void
      {
         ConsortiaRateManager.instance.reset();
      }
      
      private function _consortiaLoadComplete(param1:Event) : void
      {
         this.getCountRateI();
      }
      
      public function getStrengthItemCellInfo() : InventoryItemInfo
      {
         return (this._items[5] as StreangthItemCell).itemInfo;
      }
      
      private function __openHelp(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         var _loc2_:DisplayObject = ComponentFactory.Instance.creat("store.strengHelp");
         var _loc3_:HelpFrame = ComponentFactory.Instance.creat("store.helpFrame");
         _loc3_.setView(_loc2_);
         _loc3_.titleText = LanguageMgr.GetTranslation("store.StoreIIStrengthBG.say");
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         this.disposeUserGuide();
         if(this._area)
         {
            ObjectUtils.disposeObject(this._area);
         }
         this._area = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            this._items[_loc1_].dispose();
            _loc1_++;
         }
         this._items = null;
         this._pointArray = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._strength_btn)
         {
            ObjectUtils.disposeObject(this._strength_btn);
         }
         this._strength_btn = null;
         if(this._strthShine)
         {
            ObjectUtils.disposeObject(this._strthShine);
         }
         this._strthShine = null;
         if(this._startStrthTip)
         {
            ObjectUtils.disposeObject(this._startStrthTip);
         }
         this._startStrthTip = null;
         if(this._sBuyLucky)
         {
            ObjectUtils.disposeObject(this._sBuyLucky);
         }
         this._sBuyLucky = null;
         if(this._sBuyHierogram)
         {
            ObjectUtils.disposeObject(this._sBuyHierogram);
         }
         this._sBuyHierogram = null;
         if(this._sBuyStrengthStoneCell)
         {
            ObjectUtils.disposeObject(this._sBuyStrengthStoneCell);
         }
         this._sBuyStrengthStoneCell = null;
         if(this._sBuyGiftBag)
         {
            ObjectUtils.disposeObject(this._sBuyGiftBag);
         }
         this._sBuyGiftBag = null;
         if(this._strengHelp)
         {
            ObjectUtils.disposeObject(this._strengHelp);
         }
         this._strengHelp = null;
         if(this._showSuccessRate)
         {
            ObjectUtils.disposeObject(this._showSuccessRate);
         }
         this._showSuccessRate = null;
         if(this._consortiaSmith)
         {
            ObjectUtils.disposeObject(this._consortiaSmith);
         }
         this._consortiaSmith = null;
         if(this._gold_txt)
         {
            ObjectUtils.disposeObject(this._gold_txt);
         }
         this._gold_txt = null;
         if(this._spellAlertFrame)
         {
            this.hideSpellAlertFrame();
         }
         this._spellAlertFrame = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}

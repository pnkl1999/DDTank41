package store.view.transfer
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.Dictionary;
   import store.HelpFrame;
   import store.HelpPrompt;
   import store.IStoreViewBG;
   import store.view.ConsortiaRateManager;
   
   public class StoreIITransferBG extends Sprite implements IStoreViewBG
   {
       
      
      private var _bg:MutipleImage;
      
      private var _area:TransferDragInArea;
      
      private var _items:Vector.<TransferItemCell>;
      
      private var _transferBtnAsset:BaseButton;
      
      private var _transferHelpAsset:BaseButton;
      
      private var transShine:MovieImage;
      
      private var transArr:MutipleImage;
      
      private var _pointArray:Vector.<Point>;
      
      private var gold_txt:FilterFrameText;
      
      private var _transferBefore:Boolean = false;
      
      private var _transferAfter:Boolean = false;
      
      public function StoreIITransferBG()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         var _loc2_:TransferItemCell = null;
         var _loc1_:int = 0;
         _loc2_ = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("store.TransferBG");
         addChild(this._bg);
         this._transferBtnAsset = ComponentFactory.Instance.creatComponentByStylename("store.TransferBtn");
         addChild(this._transferBtnAsset);
         this._transferHelpAsset = ComponentFactory.Instance.creatComponentByStylename("store.StrengthNodeBtn");
         addChild(this._transferHelpAsset);
         this.transShine = ComponentFactory.Instance.creatComponentByStylename("store.StrengthButtonShine");
         this.transShine.mouseEnabled = false;
         this.transShine.mouseChildren = false;
         addChild(this.transShine);
         this.transArr = ComponentFactory.Instance.creatComponentByStylename("store.ArrowHeadTransferTip");
         addChild(this.transArr);
         this.gold_txt = ComponentFactory.Instance.creatComponentByStylename("store.TransferneedMoneyTxt");
         addChild(this.gold_txt);
         this.getCellsPoint();
         this._items = new Vector.<TransferItemCell>();
         _loc1_ = 0;
         while(_loc1_ < 2)
         {
            _loc2_ = new TransferItemCell(_loc1_);
            _loc2_.addEventListener(Event.CHANGE,this.__itemInfoChange);
            _loc2_.x = this._pointArray[_loc1_].x;
            _loc2_.y = this._pointArray[_loc1_].y;
            addChild(_loc2_);
            this._items.push(_loc2_);
            _loc1_++;
         }
         this._area = new TransferDragInArea(this._items);
         addChildAt(this._area,0);
         this.hideArr();
         this.hide();
      }
      
      private function getCellsPoint() : void
      {
         var _loc2_:Point = null;
         this._pointArray = new Vector.<Point>();
         var _loc1_:int = 0;
         while(_loc1_ < 2)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("store.Transferpoint" + _loc1_);
            this._pointArray.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function initEvent() : void
      {
         this._transferBtnAsset.addEventListener(MouseEvent.CLICK,this.__transferHandler);
         this._transferHelpAsset.addEventListener(MouseEvent.CLICK,this.__openHelpHandler);
      }
      
      private function removeEvent() : void
      {
         this._transferBtnAsset.removeEventListener(MouseEvent.CLICK,this.__transferHandler);
         this._transferHelpAsset.removeEventListener(MouseEvent.CLICK,this.__openHelpHandler);
      }
      
      public function startShine(param1:int) : void
      {
         this._items[param1].startShine();
      }
      
      public function stopShine() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 2)
         {
            this._items[_loc1_].stopShine();
            _loc1_++;
         }
      }
      
      private function showArr() : void
      {
         this.transArr.visible = true;
         this.transShine.movie.play();
      }
      
      private function hideArr() : void
      {
         this.transArr.visible = false;
         this.transShine.movie.gotoAndStop(1);
      }
      
      public function get area() : Vector.<TransferItemCell>
      {
         return this._items;
      }
      
      public function dragDrop(param1:BagCell) : void
      {
         var _loc3_:TransferItemCell = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:InventoryItemInfo = param1.info as InventoryItemInfo;
         for each(_loc3_ in this._items)
         {
            if(_loc3_.info == null)
            {
               if(this._items[0].info && this._items[0].info.CategoryID != _loc2_.CategoryID || this._items[1].info && this._items[1].info.CategoryID != _loc2_.CategoryID)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.put"));
                  return;
               }
               SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,_loc3_.index,1);
               DragManager.acceptDrag(_loc3_,DragEffect.NONE);
               return;
            }
         }
      }
      
      private function __transferHandler(param1:MouseEvent) : void
      {
         var _loc4_:BaseAlerFrame = null;
         var _loc5_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         var _loc2_:TransferItemCell = this._items[0] as TransferItemCell;
         var _loc3_:TransferItemCell = this._items[1] as TransferItemCell;
         if(this._showDontClickTip())
         {
            return;
         }
         if(_loc2_.info && _loc3_.info)
         {
            if(PlayerManager.Instance.Self.Gold < Number(this.gold_txt.text))
            {
               _loc4_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc4_.moveEnable = false;
               _loc4_.addEventListener(FrameEvent.RESPONSE,this._responseV);
               return;
            }
            this.hideArr();
            this._transferAfter = false;
            this._transferBefore = false;
            if(EquipType.isArm(_loc2_.info) || EquipType.isCloth(_loc2_.info) || EquipType.isHead(_loc2_.info) || EquipType.isArm(_loc3_.info) || EquipType.isCloth(_loc3_.info) || EquipType.isHead(_loc3_.info))
            {
               this.confirmTransferHole();
            }
            else
            {
               _loc5_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.sure"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               _loc5_.addEventListener(FrameEvent.RESPONSE,this._responseII);
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.EmptyItem"));
         }
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
      
      private function _response(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.depositAction();
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function _responseII(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = BaseAlerFrame(param1.currentTarget);
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this._responseII);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this._transferAfter = true;
            this._transferBefore = true;
            this.sendSocket();
         }
         else
         {
            this.cannel();
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function cannel() : void
      {
         this.showArr();
      }
      
      private function confirmTransferHole() : void
      {
         var _loc1_:InventoryItemInfo = this._items[0].info as InventoryItemInfo;
         var _loc2_:InventoryItemInfo = this._items[1].info as InventoryItemInfo;
         var _loc3_:int = -1;
         var _loc4_:int = -1;
         var _loc5_:int = _loc1_.Hole1 + _loc1_.Hole2 + _loc1_.Hole3 + _loc1_.Hole4 + _loc2_.Hole1 + _loc2_.Hole2 + _loc2_.Hole3 + _loc2_.Hole4;
         if(_loc5_ > 0)
         {
            _loc3_ = 1;
         }
         if(_loc1_.Hole5 >= 0 || _loc1_.Hole6 >= 0 || _loc2_.Hole5 >= 0 || _loc2_.Hole6 >= 0 || _loc1_.Hole5Exp > 0 || _loc1_.Hole6Exp > 0 || _loc2_.Hole5Exp > 0 || _loc2_.Hole6Exp > 0)
         {
            _loc4_ = 1;
         }
         var _loc6_:HoleConfirmAlert = ComponentFactory.Instance.creatCustomObject("store.view.transfer.HoleConfirmAlert",[_loc3_,_loc4_]);
         _loc6_.addEventListener(FrameEvent.RESPONSE,this.__confirmHoleResponse);
         LayerManager.Instance.addToLayer(_loc6_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __confirmHoleResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:HoleConfirmAlert = param1.currentTarget as HoleConfirmAlert;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__confirmHoleResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this._transferBefore = _loc2_.state1;
            this._transferAfter = _loc2_.state2;
            this.sendSocket();
         }
         else
         {
            this.showArr();
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      private function depositAction() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("setFlashCall");
         }
         navigateToURL(new URLRequest(PathManager.solveFillPage()),"_blank");
      }
      
      private function isComposeStrengthen(param1:BagCell) : Boolean
      {
         if(param1.itemInfo.StrengthenLevel > 0)
         {
            return true;
         }
         if(param1.itemInfo.AttackCompose > 0)
         {
            return true;
         }
         if(param1.itemInfo.DefendCompose > 0)
         {
            return true;
         }
         if(param1.itemInfo.LuckCompose > 0)
         {
            return true;
         }
         if(param1.itemInfo.AgilityCompose > 0)
         {
            return true;
         }
         return false;
      }
      
      private function sendSocket() : void
      {
         SocketManager.Instance.out.sendItemTransfer(this._transferBefore,this._transferAfter);
      }
      
      private function __itemInfoChange(param1:Event) : void
      {
         this.gold_txt.text = "0";
         var _loc2_:TransferItemCell = this._items[0];
         var _loc3_:TransferItemCell = this._items[1];
         if(_loc2_.info)
         {
            _loc2_.categoryId = -1;
            if(_loc3_.info)
            {
               _loc2_.categoryId = _loc2_.info.CategoryID;
            }
            _loc3_.categoryId = _loc2_.info.CategoryID;
         }
         else
         {
            _loc3_.categoryId = -1;
            if(_loc3_.info)
            {
               _loc2_.categoryId = _loc3_.info.CategoryID;
            }
            else
            {
               _loc2_.categoryId = -1;
            }
         }
         if(_loc2_.info)
         {
            _loc2_.Refinery = _loc3_.Refinery = _loc2_.info.RefineryLevel;
         }
         else if(_loc3_.info)
         {
            _loc2_.Refinery = _loc3_.Refinery = _loc3_.info.RefineryLevel;
         }
         else
         {
            _loc2_.Refinery = _loc3_.Refinery = -1;
         }
         if(_loc2_.info && _loc3_.info)
         {
            if(_loc2_.info.CategoryID != _loc3_.info.CategoryID)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.put"));
               return;
            }
            if(this.isComposeStrengthen(_loc2_) || this.isOpenHole(_loc2_) || this.isHasBead(_loc2_) || this.isComposeStrengthen(_loc3_) || this.isOpenHole(_loc3_) || this.isHasBead(_loc3_) || _loc2_.itemInfo.isHasLatentEnergy || _loc3_.itemInfo.isHasLatentEnergy)
            {
               this.showArr();
               this.goldMoney();
            }
            else
            {
               this.hideArr();
            }
         }
         else
         {
            this.hideArr();
         }
         if(_loc2_.info && !_loc3_.info)
         {
            ConsortiaRateManager.instance.sendTransferShowLightEvent(_loc2_.info,true);
         }
         else if(_loc3_.info && !_loc2_.info)
         {
            ConsortiaRateManager.instance.sendTransferShowLightEvent(_loc3_.info,true);
         }
         else
         {
            ConsortiaRateManager.instance.sendTransferShowLightEvent(null,false);
         }
      }
      
      private function _showDontClickTip() : Boolean
      {
         var _loc1_:TransferItemCell = this._items[0];
         var _loc2_:TransferItemCell = this._items[1];
         if(_loc1_.info == null && _loc2_.info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.NoItem"));
            return true;
         }
         if(_loc1_.info == null || _loc2_.info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.EmptyItem"));
            return true;
         }
         if(!this.isComposeStrengthen(_loc1_) && !this.isOpenHole(_loc1_) && !this.isHasBead(_loc1_) && !this.isComposeStrengthen(_loc2_) && !this.isOpenHole(_loc2_) && !this.isHasBead(_loc2_) && !_loc1_.itemInfo.isHasLatentEnergy && !_loc2_.itemInfo.isHasLatentEnergy)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.transfer.dontTransferII"));
            return true;
         }
         return false;
      }
      
      private function isHasBead(param1:BagCell) : Boolean
      {
         var _loc2_:InventoryItemInfo = param1.itemInfo;
         return _loc2_.Hole1 + _loc2_.Hole2 + _loc2_.Hole3 + _loc2_.Hole4 + _loc2_.Hole5 + _loc2_.Hole6 > 0;
      }
      
      private function isOpenHole(param1:BagCell) : Boolean
      {
         if(param1.itemInfo.Hole5Level > 0 || param1.itemInfo.Hole6Level > 0 || param1.itemInfo.Hole5Exp > 0 || param1.itemInfo.Hole6Exp > 0)
         {
            return true;
         }
         return false;
      }
      
      private function goldMoney() : void
      {
         this.gold_txt.text = "10000";
      }
      
      public function show() : void
      {
         this.initEvent();
         this.visible = true;
         this.updateData();
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
         while(_loc1_ < 2)
         {
            this._items[_loc1_].info = PlayerManager.Instance.Self.StoreBag.items[_loc1_];
            _loc1_++;
         }
      }
      
      public function hide() : void
      {
         this.removeEvent();
         this.visible = false;
      }
      
      private function __openHelpHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         var _loc2_:HelpPrompt = ComponentFactory.Instance.creat("store.transferHelp");
         var _loc3_:HelpFrame = ComponentFactory.Instance.creat("store.helpFrame");
         _loc3_.setView(_loc2_);
         _loc3_.titleText = LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.move");
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function clearTransferItemCell() : void
      {
         var _loc1_:TransferItemCell = this._items[0];
         var _loc2_:TransferItemCell = this._items[1];
         if(_loc1_.info != null)
         {
            SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,_loc1_.index,_loc1_.itemBagType,-1);
         }
         if(_loc2_.info != null)
         {
            SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,_loc2_.index,_loc2_.itemBagType,-1);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            this._items[_loc1_].removeEventListener(Event.CHANGE,this.__itemInfoChange);
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
         if(this._area)
         {
            ObjectUtils.disposeObject(this._area);
         }
         this._area = null;
         if(this._transferBtnAsset)
         {
            ObjectUtils.disposeObject(this._transferBtnAsset);
         }
         this._transferBtnAsset = null;
         if(this._transferHelpAsset)
         {
            ObjectUtils.disposeObject(this._transferHelpAsset);
         }
         this._transferHelpAsset = null;
         if(this.transShine)
         {
            ObjectUtils.disposeObject(this.transShine);
         }
         this.transShine = null;
         if(this.transArr)
         {
            ObjectUtils.disposeObject(this.transArr);
         }
         this.transArr = null;
         if(this.gold_txt)
         {
            ObjectUtils.disposeObject(this.gold_txt);
         }
         this.gold_txt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}

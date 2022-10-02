package store.fineStore.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.greensock.TweenMax;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.events.CEvent;
   import ddt.events.CellEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.HelpFrameUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import road7th.utils.MathUtils;
   import store.StoreController;
   import store.StoreDragInArea;
   import store.equipGhost.EquipGhostManager;
   import store.events.StoreDargEvent;
   import store.view.StoneCellFrame;
   import store.view.storeBag.StoreBagCell;
   import store.view.storeBag.StoreBagController;
   import store.view.storeBag.StoreBagView;
   
   public final class FineGhostView extends Sprite implements Disposeable
   {
       
      
      private var _area:StoreDragInArea;
      
      private var _items:Array;
      
      private var _luckyStoneCell:StoneCellFrame;
      
      private var _ghostStoneCell:StoneCellFrame;
      
      private var _equipmentCell:StoneCellFrame;
      
      private var _ghostBtn:SimpleBitmapButton;
      
      private var _ghostHelpBtn:BaseButton;
      
      private var _ratioTxt:FilterFrameText;
      
      private var _continuesBtn:SelectedCheckButton;
      
      private var _controller:StoreBagController;
      
      private var _view:DisplayObject;
      
      private var _moveSprite:Sprite;
      
      private var _successBit:Bitmap;
      
      private var _failBit:Bitmap;
      
      public function FineGhostView(param1:StoreController)
      {
         super();
         this._controller = new StoreBagController(param1.Model);
         this._controller.model.currentPanel = 7;
         this.initView();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.StoreBag.addEventListener("update",this.refreshData);
         PlayerManager.Instance.Self.StoreBag.addEventListener("clearStoreBag",this.updateData);
         EquipGhostManager.getInstance().addEventListener("equip_ghost_result",this.onEquipGhostResult);
         EquipGhostManager.getInstance().addEventListener("equip_ghost_ratio",this.onEquipGhostRatio);
         EquipGhostManager.getInstance().addEventListener("equip_ghost_state",this.onEquipGhostState);
         this._ghostBtn.addEventListener("click",this.equipGhost);
         addEventListener("startDarg",this.startShine);
         addEventListener("stopDarg",this.stopShine);
      }
      
      private function removeEvent() : void
      {
         var _loc1_:int = 0;
         PlayerManager.Instance.Self.StoreBag.removeEventListener("update",this.refreshData);
         PlayerManager.Instance.Self.StoreBag.removeEventListener("clearStoreBag",this.updateData);
         if(this._items)
         {
            _loc1_ = 0;
            while(_loc1_ < this._items.length)
            {
               this._items[_loc1_].dispose();
               this._items[_loc1_] = null;
               _loc1_++;
            }
         }
         this._ghostBtn.removeEventListener("click",this.equipGhost);
         EquipGhostManager.getInstance().removeEventListener("equip_ghost_result",this.onEquipGhostResult);
         EquipGhostManager.getInstance().removeEventListener("equip_ghost_ratio",this.onEquipGhostRatio);
         EquipGhostManager.getInstance().removeEventListener("equip_ghost_state",this.onEquipGhostState);
         removeEventListener("startDarg",this.startShine);
         removeEventListener("stopDarg",this.stopShine);
      }
      
      private function startShine(param1:StoreDargEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:ItemTemplateInfo = param1.sourceInfo;
         if(_loc3_ == null)
         {
            return;
         }
         var _loc4_:int = 1;
         if(_loc3_.CategoryID == 11)
         {
            if(_loc3_.Property1 == "117")
            {
               _loc4_ = 0;
            }
            else
            {
               if(_loc3_.Property1 != "118")
               {
                  return;
               }
               _loc4_ = 2;
            }
         }
         if(this._items != null && this._items.length > _loc4_)
         {
            _loc2_ = this._items[_loc4_];
            if(_loc2_)
            {
               _loc2_.startShine();
            }
         }
      }
      
      private function stopShine(param1:StoreDargEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(this._items && _loc2_ < this._items.length)
         {
            this._items[_loc2_].stopShine();
            _loc2_++;
         }
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("equipGhost.leftBg");
         PositionUtils.setPos(_loc3_,"equipGhost.leftBgPos");
         addChild(_loc3_);
         this._luckyStoneCell = ComponentFactory.Instance.creatCustomObject("equipGhost.LuckySymbolCell");
         this._luckyStoneCell.label = LanguageMgr.GetTranslation("equipGhost.luck");
         addChild(this._luckyStoneCell);
         this._ghostStoneCell = ComponentFactory.Instance.creatCustomObject("equipGhost.StrengthenStoneCell");
         this._ghostStoneCell.label = LanguageMgr.GetTranslation("equipGhost.stone");
         addChild(this._ghostStoneCell);
         this._equipmentCell = ComponentFactory.Instance.creatCustomObject("equipGhost.EquipmentCell");
         this._equipmentCell.label = LanguageMgr.GetTranslation("store.Strength.StrengthenEquipmentCellText");
         addChild(this._equipmentCell);
         this._ghostBtn = ComponentFactory.Instance.creatComponentByStylename("equipGhost.ghostButton");
         addChild(this._ghostBtn);
         this._ghostHelpBtn = HelpFrameUtils.Instance.simpleHelpButton(this,"ddtstore.HelpButton",null,LanguageMgr.GetTranslation("store.StoreIIGhost.say"),"ddtstore.HelpFrame.GhostText",404,484);
         PositionUtils.setPos(this._ghostHelpBtn,"equipGhost.helpBtnPos");
         var _loc4_:Point = null;
         this._items = [];
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            if(_loc1_ == 0)
            {
               _loc2_ = new GhostStoneCell(["117"],_loc1_);
            }
            else if(_loc1_ == 1)
            {
               _loc2_ = new GhostItemCell(_loc1_);
            }
            else if(_loc1_ == 2)
            {
               _loc2_ = new GhostStoneCell(["118"],_loc1_);
            }
            _loc4_ = ComponentFactory.Instance.creatCustomObject("equipGhost.ghostPos" + _loc1_);
            _loc2_.x = _loc4_.x;
            _loc2_.y = _loc4_.y;
            addChild(_loc2_);
            this._items.push(_loc2_);
            _loc1_++;
         }
         this._ratioTxt = ComponentFactory.Instance.creatComponentByStylename("equipGhost.successRatioTxt");
         this._ratioTxt.htmlText = LanguageMgr.GetTranslation("equipGhost.ratioLowTxt");
         addChild(this._ratioTxt);
         this._continuesBtn = ComponentFactory.Instance.creatComponentByStylename("equipGhost.continuousBtn");
         addChild(this._continuesBtn);
         this._view = this._controller.getView();
         this._view.visible = true;
         (this._view as StoreBagView).EquipList.setData(this._controller.model.canGhostEquipList);
         (this._view as StoreBagView).PropList.setData(this._controller.model.canGhostPropList);
         (this._view as StoreBagView).enableCellDoubleClick(true,this.dragDrop);
         PositionUtils.setPos(this._view,"equipGhost.rightViewPos");
         addChild(this._view);
      }
      
      public function dragDrop(param1:CellEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = false;
         var _loc6_:BagCell = param1.data as StoreBagCell;
         if(_loc6_ == null)
         {
            return;
         }
         var _loc7_:InventoryItemInfo = _loc6_.info as InventoryItemInfo;
         if(_loc7_ == null)
         {
            return;
         }
         var _loc8_:int = 0;
         var _loc9_:* = this._items;
         for each(_loc3_ in this._items)
         {
            if(_loc3_.info == _loc7_)
            {
               _loc3_.info = null;
               _loc6_.locked = false;
               return;
            }
         }
         _loc2_ = 1;
         if(_loc7_.CategoryID == 11)
         {
            if(_loc7_.Property1 == "117")
            {
               _loc2_ = 0;
            }
            else
            {
               if(_loc7_.Property1 != "118")
               {
                  return;
               }
               _loc2_ = 2;
            }
         }
         if(_loc2_ == 1)
         {
            _loc4_ = PlayerManager.Instance.Self.getGhostDataByCategoryID(_loc7_.CategoryID);
            if(_loc4_)
            {
               _loc5_ = _loc4_.level >= EquipGhostManager.getInstance().model.topLvDic[_loc7_.CategoryID];
               if(_loc5_)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("equipGhost.upLevel"));
                  return;
               }
            }
            SocketManager.Instance.out.sendMoveGoods(_loc7_.BagType,_loc7_.Place,12,_loc2_,_loc7_.Count,true);
            EquipGhostManager.getInstance().chooseEquip(_loc7_);
         }
         else
         {
            SocketManager.Instance.out.sendMoveGoods(_loc7_.BagType,_loc7_.Place,12,_loc2_,_loc7_.Count,true);
            if(_loc2_ == 0)
            {
               EquipGhostManager.getInstance().chooseLuckyMaterial(_loc7_);
            }
            else
            {
               EquipGhostManager.getInstance().chooseStoneMaterial(_loc7_);
            }
         }
      }
      
      public function refreshData(param1:BagEvent) : void
      {
         var _loc2_:* = 0;
         var _loc3_:Dictionary = param1.changedSlots;
         var _loc4_:int = 0;
         var _loc5_:* = _loc3_;
         for(_loc2_ in _loc3_)
         {
            if(_loc2_ < this._items.length)
            {
               this._items[_loc2_].info = PlayerManager.Instance.Self.StoreBag.items[_loc2_];
               if(_loc2_ == 0)
               {
                  EquipGhostManager.getInstance().chooseLuckyMaterial(this._items[_loc2_].info);
               }
               else if(_loc2_ == 2)
               {
                  EquipGhostManager.getInstance().chooseStoneMaterial(this._items[_loc2_].info);
               }
            }
         }
      }
      
      public function updateData(param1:CEvent = null) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < 3)
         {
            this._items[_loc2_].info = PlayerManager.Instance.Self.StoreBag.items[_loc2_];
            _loc2_++;
         }
         this._ratioTxt.htmlText = LanguageMgr.GetTranslation("equipGhost.ratioLowTxt");
      }
      
      private function equipGhost(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this.checkMaterial())
         {
            EquipGhostManager.getInstance().requestEquipGhost();
         }
      }
      
      private function checkMaterial() : Boolean
      {
         var _loc1_:Boolean = true;
         if(this._items[1].info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("equipGhost.material1"));
            _loc1_ = false;
         }
         else if(this._items[2].info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("equipGhost.material2"));
            _loc1_ = false;
         }
         return _loc1_;
      }
      
      public function show() : void
      {
         this.visible = true;
         this.updateData();
      }
      
      public function dispose() : void
      {
         TweenMax.killTweensOf(this._moveSprite);
         SoundManager.instance.resumeMusic();
         SoundManager.instance.stop("063");
         SoundManager.instance.stop("064");
         this.removeEvent();
         EquipGhostManager.getInstance().clearEquip();
         EquipGhostManager.getInstance().chooseStoneMaterial(null);
         EquipGhostManager.getInstance().chooseLuckyMaterial(null);
         this._items = null;
         if(this._area)
         {
            this._area.dispose();
         }
         this._area = null;
         if(this._luckyStoneCell)
         {
            ObjectUtils.disposeObject(this._luckyStoneCell);
         }
         this._luckyStoneCell = null;
         if(this._ghostStoneCell)
         {
            ObjectUtils.disposeObject(this._ghostStoneCell);
         }
         this._ghostStoneCell = null;
         if(this._ghostBtn)
         {
            ObjectUtils.disposeObject(this._ghostBtn);
         }
         this._ghostBtn = null;
         if(this._ghostHelpBtn)
         {
            ObjectUtils.disposeObject(this._ghostHelpBtn);
         }
         this._ghostHelpBtn = null;
         if(this._equipmentCell)
         {
            ObjectUtils.disposeObject(this._equipmentCell);
         }
         this._equipmentCell = null;
         (this._view as StoreBagView).enableCellDoubleClick(false,this.dragDrop);
         if(this._view)
         {
            ObjectUtils.disposeObject(this._view);
         }
         this._view = null;
         if(this._ratioTxt)
         {
            ObjectUtils.disposeObject(this._ratioTxt);
         }
         this._ratioTxt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function onEquipGhostResult(param1:CEvent) : void
      {
         var _loc2_:Boolean = param1.data;
         if(!_loc2_)
         {
            this.showResultEffect(false);
         }
         else
         {
            this.showResultEffect();
         }
      }
      
      private function showResultEffect(param1:Boolean = true) : void
      {
         this._ghostBtn.enable = true;
         if(!this._moveSprite)
         {
            this._moveSprite = new Sprite();
            this._moveSprite.mouseEnabled = false;
            this._moveSprite.mouseChildren = false;
            addChild(this._moveSprite);
         }
         if(param1)
         {
            this._successBit = this._successBit || ComponentFactory.Instance.creatBitmap("store.StoreIISuccessBitAsset");
            this._successBit.visible = true;
            if(this._failBit)
            {
               this._failBit.visible = false;
            }
            this._moveSprite.addChild(this._successBit);
            SoundManager.instance.pauseMusic();
            SoundManager.instance.play("063",false,false);
         }
         else
         {
            this._failBit = this._failBit || ComponentFactory.Instance.creatBitmap("store.StoreIIFailBitAsset");
            this._failBit.visible = true;
            if(this._successBit)
            {
               this._successBit.visible = false;
            }
            this._moveSprite.addChild(this._failBit);
            SoundManager.instance.pauseMusic();
            SoundManager.instance.play("064",false,false);
         }
         TweenMax.killTweensOf(this._moveSprite);
         this._moveSprite.y = 170;
         this._moveSprite.alpha = 1;
         TweenMax.to(this._moveSprite,0.4,{
            "delay":1.4,
            "y":54,
            "alpha":0,
            "onComplete":this.continueGhost,
            "onCompleteParams":[param1]
         });
      }
      
      private function continueGhost(param1:Boolean) : void
      {
         SoundManager.instance.resumeMusic();
         SoundManager.instance.stop("063");
         SoundManager.instance.stop("064");
         var _loc2_:Boolean = this._items && this._items.length > 2 && this._items[2].info != null;
         if(!param1 && this._continuesBtn.selected && _loc2_)
         {
            EquipGhostManager.getInstance().requestEquipGhost();
         }
      }
      
      private function onEquipGhostRatio(param1:CEvent) : void
      {
         var _loc2_:Number = MathUtils.getValueInRange(Number(param1.data),1,99);
         if(_loc2_ < 5)
         {
            this._ratioTxt.htmlText = LanguageMgr.GetTranslation("equipGhost.ratioLowTxt");
         }
         else
         {
            this._ratioTxt.htmlText = LanguageMgr.GetTranslation("equipGhost.ratioTxt",_loc2_);
         }
      }
      
      private function onEquipGhostState(param1:CEvent) : void
      {
         var _loc2_:Boolean = param1.data as Boolean;
         if(this._ghostBtn)
         {
            this._ghostBtn.enable = _loc2_;
         }
      }
   }
}

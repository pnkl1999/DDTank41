package petsBag.view.item
{
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.ShineObject;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.analyze.PetconfigAnalyzer;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import farm.viewx.FarmFieldBlock;
   import flash.events.MouseEvent;
   import petsBag.controller.PetBagController;
   import petsBag.view.PetFoodNumberSelectFrame;
   
   public class FeedItem extends BaseCell
   {
       
      
      protected var _tbxCount:FilterFrameText;
      
      private var _shiner:ShineObject;
      
      public function FeedItem()
      {
         _showLoading = false;
         _bg = ComponentFactory.Instance.creatBitmap("assets.petsBag.petFeedPnlBg");
         this.initView();
         super(_bg,null,false);
      }
      
      private function initView() : void
      {
         this._tbxCount = ComponentFactory.Instance.creatComponentByStylename("BagCellCountText");
         this._tbxCount.mouseEnabled = false;
         addChild(this._tbxCount);
         this._shiner = new ShineObject(ComponentFactory.Instance.creat("asset.petBagSystem.cellShine"));
         addChild(this._shiner);
         this._shiner.mouseEnabled = false;
         this._shiner.mouseChildren = false;
      }
      
      public function startShine() : void
      {
         this._shiner.shine();
      }
      
      public function stopShine() : void
      {
         this._shiner.stopShine();
      }
      
      public function updateCount() : void
      {
         if(this._tbxCount)
         {
            if(_info && this.itemInfo && this.itemInfo.MaxCount > 1)
            {
               this._tbxCount.text = String(this.itemInfo.Count);
               this._tbxCount.visible = true;
               addChild(this._tbxCount);
            }
            else
            {
               this._tbxCount.visible = false;
            }
         }
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         PlayerManager.Instance.Self.StoreBag.addEventListener(BagEvent.UPDATE,this.__updateStoreBag);
      }
      
      private function __updateStoreBag(param1:BagEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         for(_loc2_ in param1.changedSlots)
         {
            _loc3_ = int(_loc2_);
            if(_loc3_ == 0)
            {
               this.info = PlayerManager.Instance.Self.StoreBag.items[0];
            }
         }
      }
      
      override protected function onMouseClick(param1:MouseEvent) : void
      {
         if(_info && allowDrag)
         {
            SoundManager.instance.play("008");
            dragStart();
         }
      }
      
      override protected function removeEvent() : void
      {
         PlayerManager.Instance.Self.StoreBag.removeEventListener(BagEvent.UPDATE,this.__updateStoreBag);
         super.removeEvent();
      }
      
      public function get itemInfo() : InventoryItemInfo
      {
         return _info as InventoryItemInfo;
      }
      
      override public function set info(param1:ItemTemplateInfo) : void
      {
         super.info = param1;
         this.updateCount();
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         var _loc3_:PetFoodNumberSelectFrame = null;
         var _loc4_:int = 0;
         if(!this.mouseEnabled)
         {
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(_loc2_ && _loc2_.CategoryID == EquipType.FOOD)
         {
            if(EquipType.isPetSpeciallFood(_loc2_))
            {
               if(info)
               {
                  SocketManager.Instance.out.sendClearStoreBag();
               }
               param1.action = DragEffect.NONE;
               SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,-1,1);
            }
            else
            {
               _loc3_ = ComponentFactory.Instance.creatComponentByStylename("petsBag.PetFoodNumberSelectFrame");
               _loc3_.foodInfo = _loc2_;
               _loc3_.petInfo = PetBagController.instance().petModel.currentPetInfo;
               _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onFoodAmountResponse);
               _loc4_ = this.needMaxFood(PetBagController.instance().petModel.currentPetInfo.Hunger,int(_loc2_.Property1));
               if(PetBagController.instance().petModel.currentPetInfo.Level == 65 || PetBagController.instance().petModel.currentPetInfo.Level == PlayerManager.Instance.Self.Grade)
               {
                  _loc3_.show(_loc4_);
               }
               else
               {
                  _loc3_.show(_loc2_.Count);
               }
            }
            param1.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
         }
         else
         {
            param1.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.current"));
         }
      }
      
      private function needMaxFood(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = PetconfigAnalyzer.PetCofnig.MaxHunger - param1;
         return int(int(Math.ceil(_loc4_ / Number(param2))));
      }
      
      protected function __onFoodAmountResponse(param1:FrameEvent) : void
      {
         var _loc2_:PetFoodNumberSelectFrame = null;
         var _loc3_:InventoryItemInfo = null;
         SoundManager.instance.play("008");
         _loc2_ = PetFoodNumberSelectFrame(param1.currentTarget);
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
               _loc2_.dispose();
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               _loc3_ = _loc2_.foodInfo;
               if(info)
               {
                  SocketManager.Instance.out.sendClearStoreBag();
               }
               SocketManager.Instance.out.sendMoveGoods(_loc3_.BagType,_loc3_.Place,BagInfo.STOREBAG,0,_loc2_.amount,true);
               _loc2_.dispose();
         }
      }
      
      override public function dragStop(param1:DragEffect) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new CellEvent(CellEvent.DRAGSTOP,null,true));
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(param1.action == DragEffect.MOVE && param1.target == null)
         {
            if(_loc2_ && _loc2_.BagType == 11)
            {
               param1.action = DragEffect.NONE;
               super.dragStop(param1);
            }
            else if(_loc2_ && _loc2_.BagType == 12)
            {
               locked = false;
            }
            else
            {
               locked = false;
            }
         }
         else if(param1.action == DragEffect.SPLIT && param1.target == null)
         {
            locked = false;
         }
         else if(param1.target is FarmFieldBlock)
         {
            locked = false;
         }
         else
         {
            super.dragStop(param1);
         }
      }
      
      override public function dispose() : void
      {
         if(this._tbxCount)
         {
            ObjectUtils.disposeObject(this._tbxCount);
            this._tbxCount = null;
         }
         if(this._shiner)
         {
            ObjectUtils.disposeObject(this._shiner);
            this._shiner = null;
         }
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
      }
   }
}

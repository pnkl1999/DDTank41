package store.view.storeBag
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.greensock.TweenMax;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.display.Sprite;
   import store.StrengthDataManager;
   import store.events.StoreDargEvent;
   
   public class StoreBagCell extends BagCell
   {
       
      
      private var _light:Boolean;
      
      public function StoreBagCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:Sprite = null)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            return;
         }
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(!this.checkBagType(_loc2_))
         {
            return;
         }
         if(StrengthDataManager.instance.autoFusion)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.fusion.donMoveGoods"));
            param1.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
            return;
         }
         SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,bagType,this.getPlace(_loc2_),1);
         param1.action = DragEffect.NONE;
         DragManager.acceptDrag(this);
      }
      
      override public function dragStart() : void
      {
         if(_info && !locked && stage)
         {
            if(DragManager.startDrag(this,_info,createDragImg(),stage.mouseX,stage.mouseY,DragEffect.MOVE,true,false,true))
            {
               locked = true;
               dispatchEvent(new StoreDargEvent(this.info,StoreDargEvent.START_DARG,true));
            }
         }
      }
      
      override public function dragStop(param1:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            param1.action = DragEffect.NONE;
            super.dragStop(param1);
            BaglockedManager.Instance.show();
            dispatchEvent(new StoreDargEvent(this.info,StoreDargEvent.STOP_DARG,true));
            return;
         }
         if(param1.action == DragEffect.MOVE && param1.target == null)
         {
            locked = false;
            sellItem();
         }
         else if(param1.action == DragEffect.SPLIT && param1.target == null)
         {
            locked = false;
         }
         else
         {
            super.dragStop(param1);
         }
         dispatchEvent(new StoreDargEvent(this.info,StoreDargEvent.STOP_DARG,true));
      }
      
      private function getPlace(param1:InventoryItemInfo) : int
      {
         return -1;
      }
      
      private function checkBagType(param1:InventoryItemInfo) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if(param1.BagType == bagType)
         {
            return false;
         }
         if(param1.CategoryID == 10 || param1.CategoryID == 11 || param1.CategoryID == 12 || param1.CategoryID == 20)
         {
            if(bagType == BagInfo.EQUIPBAG)
            {
               return false;
            }
            return true;
         }
         if(bagType == BagInfo.EQUIPBAG)
         {
            return true;
         }
         return false;
      }
      
      public function set light(param1:Boolean) : void
      {
         if(this._light == param1)
         {
            return;
         }
         this._light = param1;
         if(param1)
         {
            this.showEffect();
         }
         else
         {
            this.hideEffect();
         }
      }
      
      private function showEffect() : void
      {
         TweenMax.to(this,0.5,{
            "repeat":-1,
            "yoyo":true,
            "glowFilter":{
               "color":16777011,
               "alpha":1,
               "blurX":8,
               "blurY":8,
               "strength":3,
               "inner":true
            }
         });
      }
      
      private function hideEffect() : void
      {
         TweenMax.killChildTweensOf(this.parent,false);
         this.filters = null;
      }
      
      override public function dispose() : void
      {
         TweenMax.killChildTweensOf(this.parent,false);
         this.filters = null;
         super.dispose();
      }
   }
}

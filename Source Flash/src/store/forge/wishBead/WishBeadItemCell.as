package store.forge.wishBead
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   
   public class WishBeadItemCell extends BagCell
   {
       
      
      public function WishBeadItemCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:DisplayObject = null, param5:Boolean = true)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(_tbxCount)
         {
            ObjectUtils.disposeObject(_tbxCount);
         }
         _tbxCount = ComponentFactory.Instance.creat("wishBeadMainView.itemCell.countTxt");
         _tbxCount.mouseEnabled = false;
         addChild(_tbxCount);
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.enableDoubleClick(this);
         WishBeadManager.instance.addEventListener(WishBeadManager.ITEM_MOVE,this.itemMoveHandler);
         WishBeadManager.instance.addEventListener(WishBeadManager.ITEM_MOVE2,this.itemMoveHandler2);
      }
      
      private function itemMoveHandler(param1:WishBeadEvent) : void
      {
         var _loc2_:WishBeadEvent = null;
         if(info == param1.info)
         {
            return;
         }
         if(info)
         {
            _loc2_ = new WishBeadEvent(WishBeadManager.ITEM_MOVE2);
            _loc2_.info = info as InventoryItemInfo;
            _loc2_.moveType = 3;
            WishBeadManager.instance.dispatchEvent(_loc2_);
         }
         info = param1.info;
      }
      
      private function itemMoveHandler2(param1:WishBeadEvent) : void
      {
         if(info != param1.info || param1.moveType != 2)
         {
            return;
         }
         info = null;
      }
      
      protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         if(!info)
         {
            return;
         }
         SoundManager.instance.play("008");
         var _loc2_:WishBeadEvent = new WishBeadEvent(WishBeadManager.ITEM_MOVE2);
         _loc2_.info = info as InventoryItemInfo;
         _loc2_.moveType = 2;
         WishBeadManager.instance.dispatchEvent(_loc2_);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.disableDoubleClick(this);
         WishBeadManager.instance.removeEventListener(WishBeadManager.ITEM_MOVE,this.itemMoveHandler);
         WishBeadManager.instance.removeEventListener(WishBeadManager.ITEM_MOVE2,this.itemMoveHandler2);
      }
      
      protected function __clickHandler(param1:InteractiveEvent) : void
      {
         SoundManager.instance.play("008");
         dragStart();
      }
      
      public function clearInfo() : void
      {
         var _loc1_:WishBeadEvent = null;
         if(info)
         {
            _loc1_ = new WishBeadEvent(WishBeadManager.ITEM_MOVE2);
            _loc1_.info = info as InventoryItemInfo;
            _loc1_.moveType = 2;
            WishBeadManager.instance.dispatchEvent(_loc1_);
         }
      }
   }
}

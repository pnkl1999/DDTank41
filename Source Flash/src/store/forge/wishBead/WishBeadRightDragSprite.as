package store.forge.wishBead
{
   import bagAndInfo.cell.DragEffect;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import flash.display.Sprite;
   
   public class WishBeadRightDragSprite extends Sprite implements IAcceptDrag
   {
       
      
      public function WishBeadRightDragSprite()
      {
         super();
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         var _loc3_:String = null;
         DragManager.acceptDrag(this,DragEffect.NONE);
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(_loc2_.BagType == BagInfo.EQUIPBAG)
         {
            _loc3_ = WishBeadManager.EQUIP_MOVE2;
         }
         else
         {
            _loc3_ = WishBeadManager.ITEM_MOVE2;
         }
         var _loc4_:WishBeadEvent = new WishBeadEvent(_loc3_);
         _loc4_.info = _loc2_;
         _loc4_.moveType = 2;
         WishBeadManager.instance.dispatchEvent(_loc4_);
      }
   }
}

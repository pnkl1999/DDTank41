package latentEnergy
{
   import bagAndInfo.cell.DragEffect;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import flash.display.Sprite;
   
   public class LatentEnergyRightDragSprite extends Sprite implements IAcceptDrag
   {
       
      
      public function LatentEnergyRightDragSprite()
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
            _loc3_ = LatentEnergyManager.EQUIP_MOVE2;
         }
         else
         {
            _loc3_ = LatentEnergyManager.ITEM_MOVE2;
         }
         var _loc4_:LatentEnergyEvent = new LatentEnergyEvent(_loc3_);
         _loc4_.info = _loc2_;
         _loc4_.moveType = 2;
         LatentEnergyManager.instance.dispatchEvent(_loc4_);
      }
   }
}

package latentEnergy
{
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   
   public class LatentEnergyLeftDragSprite extends Sprite implements IAcceptDrag
   {
       
      
      public function LatentEnergyLeftDragSprite()
      {
         super();
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         var _loc3_:String = null;
         DragManager.acceptDrag(this,DragEffect.NONE);
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(_loc2_.BagType == BagInfo.EQUIPBAG)
         {
            _loc3_ = LatentEnergyManager.EQUIP_MOVE;
         }
         else
         {
            _loc3_ = LatentEnergyManager.ITEM_MOVE;
         }
         var _loc4_:LatentEnergyEvent = new LatentEnergyEvent(_loc3_);
         _loc4_.info = _loc2_;
         _loc4_.moveType = 1;
         LatentEnergyManager.instance.dispatchEvent(_loc4_);
      }
   }
}

package store.fineStore.view.pageBringUp
{
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   import latentEnergy.LatentEnergyEvent;
   import latentEnergy.LatentEnergyManager;
   import store.FineBringUpController;
   
   public class FineBringUpLeftDragSprite extends Sprite implements IAcceptDrag
   {
       
      
      public function FineBringUpLeftDragSprite()
      {
         super();
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         var _loc2_:String = null;
         DragManager.acceptDrag(this,DragEffect.NONE);
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc3_:InventoryItemInfo = param1.data as InventoryItemInfo;
         _loc2_ = LatentEnergyManager.EQUIP_MOVE;
         var _loc4_:LatentEnergyEvent = new LatentEnergyEvent(_loc2_);
         _loc4_.info = _loc3_;
         _loc4_.moveType = 1;
         FineBringUpController.getInstance().dispatchEvent(_loc4_);
      }
   }
}

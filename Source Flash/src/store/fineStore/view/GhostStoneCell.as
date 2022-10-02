package store.fineStore.view
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.InteractiveEvent;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import store.StoneCell;
   import store.equipGhost.EquipGhostManager;
   
   public class GhostStoneCell extends StoneCell
   {
       
      
      public function GhostStoneCell(param1:Array, param2:int)
      {
         super(param1,param2);
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(_loc2_.BagType == 12 && info != null)
         {
            return;
         }
         if(_loc2_ && param1.action != "split")
         {
            param1.action = "none";
            if(_types.indexOf(_loc2_.Property1) == -1)
            {
               return;
            }
            if(_loc2_.CategoryID == 11)
            {
               if(_loc2_.Property1 == "117")
               {
                  EquipGhostManager.getInstance().chooseLuckyMaterial(_loc2_);
               }
               else if(_loc2_.Property1 == "118")
               {
                  EquipGhostManager.getInstance().chooseStoneMaterial(_loc2_);
               }
               SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,12,index,_loc2_.Count,true);
               DragManager.acceptDrag(this);
            }
         }
      }
      
      override protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         if(!DoubleClickEnabled)
         {
            return;
         }
         if(info == null)
         {
            return;
         }
         if((param1.currentTarget as BagCell).info != null)
         {
            SocketManager.Instance.out.sendMoveGoods(12,index,itemBagType,-1);
            if(info.Property1 == "117")
            {
               EquipGhostManager.getInstance().chooseLuckyMaterial(null);
            }
            else if(info.Property1 == "118")
            {
               EquipGhostManager.getInstance().chooseStoneMaterial(null);
            }
            if(!mouseSilenced)
            {
               SoundManager.instance.play("008");
            }
         }
      }
   }
}

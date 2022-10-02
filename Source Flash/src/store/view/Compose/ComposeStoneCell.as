package store.view.Compose
{
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import store.StoneCell;
   
   public class ComposeStoneCell extends StoneCell
   {
       
      
      public function ComposeStoneCell(param1:Array, param2:int)
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
         if(_loc2_.BagType == BagInfo.STOREBAG && info != null)
         {
            return;
         }
         if(_loc2_ && param1.action != DragEffect.SPLIT)
         {
            param1.action = DragEffect.NONE;
            if(_loc2_.CategoryID == 11 && _types.indexOf(_loc2_.Property1) > -1 && _loc2_.getRemainDate() > 0)
            {
               SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,index,_loc2_.Count,true);
               param1.action = DragEffect.NONE;
               DragManager.acceptDrag(this);
            }
         }
      }
   }
}

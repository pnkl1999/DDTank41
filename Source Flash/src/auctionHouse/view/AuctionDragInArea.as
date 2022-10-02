package auctionHouse.view
{
   import bagAndInfo.cell.DragEffect;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import flash.display.Sprite;
   
   public class AuctionDragInArea extends Sprite implements IAcceptDrag
   {
       
      
      private var _cells:Vector.<AuctionCellView>;
      
      public function AuctionDragInArea(param1:Vector.<AuctionCellView>)
      {
         super();
         this._cells = param1;
         graphics.beginFill(0,0);
         graphics.drawRect(-100,-10,1000,370);
         graphics.endFill();
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(_loc2_ && param1.action != DragEffect.SPLIT)
         {
            param1.action = DragEffect.NONE;
            if(_loc2_.getRemainDate() <= 0)
            {
               MessageTipManager.getInstance().show(_loc2_.getRemainDate().toString());
               DragManager.acceptDrag(this);
            }
            else if(param1.target == null)
            {
               DragManager.acceptDrag(this);
            }
         }
      }
   }
}
